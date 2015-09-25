
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
package Bio::SRAXml::EntityRef;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::Identifier', 'Bio::SRAXml::Roles::RefNameGroup',
  'Bio::SRAXml::Roles::ToXMLwithTagName';

sub write_to_xml {
    my ( $self, $xml_writer, $tag_name ) = @_;

    my %attr_hash = $self->refname_group_as_hash();

    $xml_writer->startTag( $tag_name, %attr_hash );
    $self->write_identifiers_xml($xml_writer);
    $xml_writer->endTag($tag_name);

}

__PACKAGE__->meta->make_immutable;
1;
