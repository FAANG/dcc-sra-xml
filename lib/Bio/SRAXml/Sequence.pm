
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
package Bio::SRAXml::Sequence;

use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::ToXML';

=head1 Description
  
  Class for representing a reference sequence.
  
=cut

has [ 'refname', 'label' ] => ( is => 'rw', isa => 'Str' );
has 'accession' => ( is => 'rw', isa => 'Str', required => 1 );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    my %attr = ( accession => $self->accession );

    $attr{refname} = $self->refname if ( $self->refname );
    $attr{label}   = $self->label   if ( $self->label );

    $xml_writer->emptyTag( "SEQUENCE", %attr );
}

__PACKAGE__->meta->make_immutable;
1;
