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

