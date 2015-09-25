
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

package Bio::SRAXml::Common::ReferenceAssemblyCustomType;

use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;
use Bio::SRAXml::Common::UrlLink;

with 'Bio::SRAXml::Roles::ReferenceAssembly';

=head1 Description
  
  Class for representing a custom reference assembly.
  
=cut

with 'Bio::SRAXml::Roles::ToXML';

has 'description' => ( is => 'rw', isa => 'Str' );
has 'url_link' => (
    is       => 'rw',
    isa      => 'Bio::SRAXml::Common::UrlLink',
    required => 1,
    coerce   => 1
);

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("CUSTOM");
    $xml_writer->dataElement( "DESCRIPTION", $self->description )
      if ( $self->description );
    $self->url_link->write_to_xml($xml_writer);
    $xml_writer->endTag("CUSTOM");

}

__PACKAGE__->meta->make_immutable;
1;
