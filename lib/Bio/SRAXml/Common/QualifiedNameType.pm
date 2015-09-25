
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
package Bio::SRAXml::Common::QualifiedNameType;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

extends 'Bio::SRAXml::Common::NameType';
=head1 Description
  
  Class for representing a single identifier with a namespace (see QualifiedNameType in SRA.common.xsd)
  
=cut

has 'namespace' => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $xml_writer, $tag_name ) = @_;

    my %attrs;

    $attrs{namespace} = $self->namespace();

    if ( defined $self->label() ) {
        $attrs{label} = $self->label();
    }

    $xml_writer->dataElement( $tag_name, $self->name(), %attrs );
}

__PACKAGE__->meta->make_immutable;
1;
