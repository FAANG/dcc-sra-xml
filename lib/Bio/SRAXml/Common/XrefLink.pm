
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
package Bio::SRAXml::Common::XrefLink;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::Link';

=head1 Description
  
  Class for representing a cross reference. Use should follow the 
  INSDC controlled vocabulary of permitted cross references.

  See http://www.insdc.org/db_xref.html for details.
  
=cut

has 'db'    => ( is => 'rw', isa => 'Str' );
has 'id'    => ( is => 'rw', isa => 'Str' );
has 'label' => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $write_to_xml ) = @_;

    $write_to_xml->startTag("XREF_LINK");

    $write_to_xml->dataElement( "DB",    $self->db() );
    $write_to_xml->dataElement( "ID",    $self->id() );
    $write_to_xml->dataElement( "LABEL", $self->label() )
      if ( defined $self->label() );

    $write_to_xml->endTag("XREF_LINK");

}

__PACKAGE__->meta->make_immutable;
1;
