
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

package Bio::SRAXml::Roles::Identifier;
use strict;
use Moose::Role;

=head1 Description
  
  Role to mixin common identifier type attributes (using com:IdentifierType)
  
=cut

has 'primary_id' => ( is => 'rw', isa => 'Bio::SRAXml::NameType', coerce => 1 );
has 'secondary_id' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::NameTypeArrayRef',
    default => sub { [] },
    coerce  => 1,
    handles => {
        add_secondary_id  => 'push',
        has_secondary_ids => 'count',
        all_secondary_ids => 'elements',
    }
);

has 'external_id' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::QualifiedNameTypeArrayRef',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_external_id  => 'push',
        has_external_ids => 'count',
        all_external_ids => 'elements'
    }
);
has 'submitter_id' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::QualifiedNameTypeArrayRef',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_submitter_id  => 'push',
        has_submitter_ids => 'count',
        all_submitter_ids => 'elements'
    }
);
has 'uuid' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::NameTypeArrayRef',
    default => sub { [] },
    coerce  => 1,
    handles => {
        add_uuid  => 'push',
        has_uuids => 'count',
        all_uuids => 'elements'
    }
);

sub write_identifiers_xml {
    my ( $self, $xml_writer ) = @_;

    if (   $self->primary_id()
        || $self->has_secondary_ids()
        || $self->has_external_ids()
        || $self->has_submitter_ids()
        || $self->has_uuids() )
    {
        $xml_writer->startTag('IDENTIFIERS');

        if ( $self->primary_id() ) {
            $self->primary_id()->write_to_xml( $xml_writer, 'PRIMARY_ID' );
        }
        for ( $self->all_secondary_ids() ) {
            $_->write_to_xml( $xml_writer, 'SECONDARY_ID' );
        }
        for ( $self->all_external_ids() ) {
            $_->write_to_xml( $xml_writer, 'EXTERNAL_ID' );
        }
        for ( $self->all_submitter_ids() ) {
            $_->write_to_xml( $xml_writer, 'SUBMITTER_ID' );
        }
        for ( $self->all_uuids() ) {
            $_->write_to_xml( $xml_writer, 'UUID' );
        }
        $xml_writer->endTag('IDENTIFIERS');
    }
}

1;
