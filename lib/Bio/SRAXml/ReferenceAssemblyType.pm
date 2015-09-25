
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
package Bio::SRAXml::ReferenceAssemblyType;

use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;
use Bio::SRAXml::UrlLink;

with 'Bio::SRAXml::Roles::ToXML';

has 'refname'   => ( is => 'rw', isa => 'Str' );
has 'accession' => ( is => 'rw', isa => 'Str' );

has 'description' => ( is => 'rw', isa => 'Str' );
has 'url_link' => ( is => 'rw', isa => 'Bio::SRAXml::UrlLink', coerce => 1 );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    if ( $self->accession ) {
        my %attr = ( accession => $self->accession );
        $attr{refname} = $self->refname if ( $self->refname );
        $xml_writer->emptyTag( "STANDARD", %attr );
    }
    elsif ( $self->url_link ) {
        $xml_writer->startTag("CUSTOM");
        $xml_writer->dataTag( "DESCRIPTION", $self->description )
          if ( $self->description );
        $xml_writer->url_link->write_to_xml($xml_writer);
        $xml_writer->endTag("CUSTOM");
    }

}

__PACKAGE__->meta->make_immutable;
1;
