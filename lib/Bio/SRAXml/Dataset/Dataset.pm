
=head1 LICENSE
   Copyright 2015 EMBL - European Bioinformatics Institute
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
     http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
=cut

package Bio::SRAXml::Dataset::Dataset;
use strict;
use namespace::autoclean;
use Moose;

use MooseX::Types::DateTime qw( DateTime );
use Bio::SRAXml::Common::EntityRef;

use Bio::SRAXml::Common::UrlLink;
use Bio::SRAXml::Common::EntrezIdLink;
use Bio::SRAXml::Common::EntrezQueryLink;
use Bio::SRAXml::Common::XrefLink;
use Bio::SRAXml::Common::Attribute;

use Bio::SRAXml::Types;

=head1 Description
  
  Class for representing Dataset elements 
  
=cut

with 'Bio::SRAXml::Roles::Identifier', 'Bio::SRAXml::Roles::NameGroup',
  'Bio::SRAXml::Roles::ToXML';

has 'title' => ( is => 'rw', isa => 'Str', required => 1, );
has 'description' => ( is => 'rw', isa => 'Str', );
has 'dataset_type' =>
  ( is => 'rw', isa => 'Bio::SRAXml::DatasetTypeEnum', required => 1 );

has 'run_refs' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::Common::EntityRefArrayRef',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_run_ref    => 'push',
        all_run_refs   => 'elements',
        count_run_refs => 'count',
    }
);

has 'analysis_refs' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::Common::EntityRefArrayRef',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_analysis_ref    => 'push',
        all_analysis_refs   => 'elements',
        count_analysis_refs => 'count',
    }
);

has 'policy_ref' => (
    is       => 'rw',
    isa      => 'Bio::SRAXml::Common::EntityRef',
    coerce   => 1,
    required => 1,
);

has 'links' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::Roles::LinkArrayRef',
    default => sub { [] },
    handles => {
        add_link    => 'push',
        all_links   => 'elements',
        count_links => 'count',
        has_links   => 'count',
    },
    coerce => 1,
);

has 'attributes' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::Common::AttributeArrayRef',
    default => sub { [] },
    handles => {
        add_attribute    => 'push',
        all_attributes   => 'elements',
        count_attributes => 'count',
        has_attributes   => 'count',
    },
    coerce => 1,
);

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    my %analysis_attrs = $self->name_group_as_hash();

    $xml_writer->startTag( "DATASET", %analysis_attrs );

    $self->write_identifiers_xml();
    $xml_writer->dataElement( 'TITLE', $self->title() );

    if ( $self->description() ) {
        $xml_writer->dataElement( 'DESCRIPTION', $self->description() );
    }

    $xml_writer->dataElement( 'DATASET_TYPE', $self->dataset_type() );

    for ( $self->all_run_refs() ) {
        $_->write_to_xml( $xml_writer, 'RUN_REF' );
    }

    for ( $self->all_analysis_refs() ) {
        $_->write_to_xml( $xml_writer, 'ANALYSIS_REF' );
    }

    $self->policy_ref->write_to_xml( $xml_writer, 'POLICY_REF' );

    if ( $self->count_links() ) {
        $xml_writer->startTag("DATASET_LINKS");
        for ( $self->all_links ) {
            $xml_writer->startTag("DATASET_LINK");
            $_->write_to_xml($xml_writer);
            $xml_writer->endTag("DATASET_LINK");
        }
        $xml_writer->endTag("DATASET_LINKS");
    }

    if ( $self->has_attributes() ) {
        $xml_writer->startTag("DATASET_ATTRIBUTES");
        for ( $self->all_attributes ) {
            $_->write_to_xml( $xml_writer, 'DATASET_ATTRIBUTE' );
        }
        $xml_writer->endTag("DATASET_ATTRIBUTES");
    }

    $xml_writer->endTag("DATASET");
}

__PACKAGE__->meta->make_immutable;
1;
