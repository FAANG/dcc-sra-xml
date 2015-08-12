package Bio::SRAXml::AnalysisSet;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Analysis;

with 'Bio::SRAXml::Roles::ToXML';

use Moose::Util::TypeConstraints;
subtype 'Bio::SRAXml::AnalysisSet::ArrayRefOfAnalysis' => as 'ArrayRef[Bio::SRAXml::Analysis]';

#coercions for Analysis
coerce 'Bio::SRAXml::AnalysisSet::ArrayRefOfAnalysis' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Analysis->new( %{$_} ) } @$_ ];
};

coerce 'Bio::SRAXml::AnalysisSet::ArrayRefOfAnalysis' => from 'HashRef' =>
  via { [ Bio::SRAXml::Analysis->new( %{$_} ) ] };

coerce 'Bio::SRAXml::AnalysisSet::ArrayRefOfAnalysis' => from 'Bio::SRAXml::Analysis' => via { [$_] };
no Moose::Util::TypeConstraints;

has 'analysis' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::AnalysisSet::ArrayRefOfAnalysis',
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
