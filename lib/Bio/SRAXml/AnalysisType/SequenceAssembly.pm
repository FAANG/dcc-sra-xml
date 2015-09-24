package Bio::SRAXml::AnalysisType::SequenceAssembly;

use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::AnalysisType';

has [ 'name', 'coverage', 'program', 'platform', 'mol_type' ] =>
  ( is => 'rw', isa => 'Str' );
has 'partial'        => ( is => 'rw', isa => 'Bool' );
has 'min_gap_length' => ( is => 'rw', isa => 'Int' );
has 'mol_type'       => (
    is  => 'rw',
    isa => 'Bio::SRAXml::SequenceAssemblyMolTypeEnum'
);

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("SEQUENCE_ASSEMBLY");

    $xml_writer->dataTag( "NAME", $self->name ) if ( $self->name );
    $xml_writer->dataTag( "PARTIAL", $self->partial ? 'true' : 'false' )
      if ( defined $self->partial );

    $xml_writer->dataTag( "COVERAGE", $self->coverage ) if ( $self->coverage );
    $xml_writer->dataTag( "PROGRAM",  $self->program )  if ( $self->program );
    $xml_writer->dataTag( "PLATFORM", $self->platform ) if ( $self->platform );
    $xml_writer->dataTag( "MIN_GAP_LENGTH", $self->min_gap_length )
      if ( $self->min_gap_length );
    $xml_writer->dataTag( "MOL_TYPE", $self->mol_type ) if ( $self->mol_type );

    $xml_writer->endTag("SEQUENCE_ASSEMBLY");

}

__PACKAGE__->meta->make_immutable;
1;
