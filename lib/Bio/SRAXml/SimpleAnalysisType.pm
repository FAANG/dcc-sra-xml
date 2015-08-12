package Bio::SRAXml::SimpleAnalysisType;

use namespace::autoclean;
use Moose;
use Moose::Util::TypeConstraints;
with 'Bio::SRAXml::Roles::AnalysisType';

#TODO add support for the more complex REFERENCE_ALIGNMENT, SEQUENCE_VARIATION and SEQUENCE_ASSEMBLY types

enum 'Bio::SRAXml::SimpleAnalysisType::SimpleAnalysisTypeEnum',
  [
    qw( sequence_annotation reference_sequence sample_phenotype processed_reads )
  ];

has 'type' => ( is => 'rw', isa => 'Bio::SRAXml::SimpleAnalysisType::SimpleAnalysisTypeEnum' );

sub write_to_xml {
    my ( $self, $write_to_xml ) = @_;

    $write_to_xml->emptyTag( uc( $self->type() ) );
}

__PACKAGE__->meta->make_immutable;
1;
