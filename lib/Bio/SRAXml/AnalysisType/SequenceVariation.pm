
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
package Bio::SRAXml::AnalysisType::SequenceVariation;

use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::AnalysisType';
extends 'Bio::SRAXml::ReferenceSequenceType';

has 'experiment_type' => (
    traits => ['Array'],
    is     => 'rw',
    isa    => 'Bio::SRAXml::SequenceVariationExperimentTypeEnumArrayRef',
    coerce => 1,
    default => sub { [] },
    handles => {
        add_experiment_type    => 'push',
        all_experiment_types   => 'elements',
        count_experiment_types => 'count',
    },
);
has [ 'program', 'platform' ] => ( is => 'rw', isa => 'Str' );
has 'imputation' => ( is => 'rw', isa => 'Bool' );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("SEQUENCE_VARIATION");
    $self->SUPER::write_to_xml($xml_writer);

    for my $et ( $self->all_experiment_types ) {
        $xml_writer->dataElement( "EXPERIMENT_TYPE", $et );
    }

    $xml_writer->dataElement( "PROGRAM",  $self->program )  if ( $self->program );
    $xml_writer->dataElement( "PLATFORM", $self->platform ) if ( $self->platform );
    if ( defined $self->imputation ) {
        my $is_imputation = $self->imputation ? 'true' : 'false';
        $xml_writer->dataElement( "IMPUTATION", $is_imputation );
    }

    $xml_writer->endTag("SEQUENCE_VARIATION");
}

__PACKAGE__->meta->make_immutable;
1;

