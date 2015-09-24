package Bio::SRAXml::AnalysisSet;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;
use Bio::SRAXml::Analysis;

with 'Bio::SRAXml::Roles::ToXML';

has 'analysis' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::AnalysisArrayRef',
    default => sub { [] },
    coerce  => 1,
    handles => {
        add_analysis   => 'push',
        all_analysis   => 'elements',
        count_analysis => 'count',
    }
);

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("ANALYSIS_SET");

    for ( $self->all_analysis ) {
        $_->write_to_xml($xml_writer);
    }

    $xml_writer->endTag("ANALYSIS_SET");
}

__PACKAGE__->meta->make_immutable;
1;
