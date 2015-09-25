
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
package Bio::SRAXml::Common::Attribute;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

=head1 Description
  
  Class to model the common AttributeType. Tag name is required to specify if 
  it is to be serialized as SAMPLE_ATTRIBUTE or STUDY_ATTRIBUTE...(etc).
  
=cut

with 'Bio::SRAXml::Roles::ToXMLwithTagName';

has 'tag'   => ( is => 'rw', isa => 'Str' );
has 'value' => ( is => 'rw', isa => 'Str' );
has 'units' => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $xml_writer, $tag_name ) = @_;

    $xml_writer->startTag($tag_name);

    $xml_writer->dataElement( 'TAG',   $self->tag() );
    $xml_writer->dataElement( 'VALUE', $self->value() )
      if ( defined $self->value() );
    $xml_writer->dataElement( 'UNITS', $self->units() )
      if ( defined $self->units() );

    $xml_writer->endTag($tag_name);

}

__PACKAGE__->meta->make_immutable;
1;
