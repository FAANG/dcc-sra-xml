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
        $xml_writer->dataTag( "EXPERIMENT_TYPE", $et );
    }

    $xml_writer->dataTag( "PROGRAM",  $self->program )  if ( $self->program );
    $xml_writer->dataTag( "PLATFORM", $self->platform ) if ( $self->platform );
    if ( defined $self->imputation ) {
        my $is_imputation = $self->imputation ? 'true' : 'false';
        $xml_writer->dataTag( "IMPUTATION", $is_imputation );
    }

    $xml_writer->endTag("SEQUENCE_VARIATION");
}

__PACKAGE__->meta->make_immutable;
1;

