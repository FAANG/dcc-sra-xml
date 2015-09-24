package Bio::SRAXml::AnalysisType::SimpleAnalysisType;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::AnalysisType';

has 'type' => ( is => 'rw', isa => 'Bio::SRAXml::SimpleAnalysisTypeEnum', required => 1 );

sub write_to_xml {
    my ( $self, $write_to_xml ) = @_;

    $write_to_xml->emptyTag( uc( $self->type() ) );
}

__PACKAGE__->meta->make_immutable;
1;
