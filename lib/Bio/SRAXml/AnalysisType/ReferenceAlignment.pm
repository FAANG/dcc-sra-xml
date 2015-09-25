
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
package Bio::SRAXml::AnalysisType::ReferenceAlignment;

use strict;
use Moose;
use namespace::autoclean;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::AnalysisType';

extends 'Bio::SRAXml::ReferenceSequenceType';

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->start_tag("REFERENCE_ALIGNMENT");
    $self->SUPER::write_to_xml($xml_writer);
    $xml_writer->end_tag("REFERENCE_ALIGNMENT");
}

__PACKAGE__->meta->make_immutable;
1;

