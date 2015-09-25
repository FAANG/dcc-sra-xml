
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
package Bio::SRAXml::EntrezLink;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

=head1 Description
  
  Class for modelling links to Entrez. db is required, 
  as is either id or query (mutually exclusive). 
  
=cut

with 'Bio::SRAXml::Roles::Link', 'Bio::SRAXml::Roles::ToXML';

has 'db' => ( is => 'rw', isa => 'Str', required => 1 );
has 'id'    => ( is => 'rw', isa => 'Int' );    #TODO change to positive int
has 'query' => ( is => 'rw', isa => 'Str' );    #TODO ID or query
has 'label' => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("ENTREZ_LINK");

    $xml_writer->dataElement( "DB", $self->db() );
    if ( $self->id ) {
        $xml_writer->dataElement( "ID", $self->id() );
    }
    elsif ( $self->query ) {
        $xml_writer->dataElement( "QUERY", $self->query() );
    }

    $xml_writer->dataElement( "LABEL", $self->label() ) if ( $self->label() );

    $xml_writer->endTag("ENTREZ_LINK");

}

__PACKAGE__->meta->make_immutable;
1;
