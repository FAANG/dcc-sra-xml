#!/usr/bin/env perl
use strict;

#use Test::More;
use FindBin qw($Bin);

use lib "$Bin/../lib";
use Bio::SRAXml::Types;

use Bio::SRAXml::AnalysisType::ReferenceAlignment;
use Bio::SRAXml::AnalysisType::SequenceAssembly;
use Bio::SRAXml::AnalysisType::SequenceVariation;
use Bio::SRAXml::AnalysisType::SimpleAnalysisType;

use Data::Dumper;

my $sat =
  Bio::SRAXml::AnalysisType::SimpleAnalysisType->new(
    type => 'sample_phenotype' );

print Dumper($sat);
my $sa = Bio::SRAXml::AnalysisType::SequenceAssembly->new(
    name           => 'foo',
    partial        => 0,
    coverage       => 'one hundred',
    program        => 'cortex',
    platform       => 'linux',
    min_gap_length => 7000,
    mol_type       => 'genomic RNA'
);
print Dumper($sa);

my $sv = Bio::SRAXml::AnalysisType::SequenceVariation->new(
    assembly => {
        description => 'this is a non-std assembly',
        url_link    => {
            label => 'url_label',
            url   => 'http://url.thing.whatsit',
        }
    },
    sequences => [
        { refname => 'chr1', label => '1', accession => 'ABCD1' },
        { refname => 'chr2', label => '2', accession => 'EFGH2' }
    ],
    program    => 'gatk',
    platform   => 'linux',
    imputation => 0,
    experiment_type => ['Curation','transcriptomics'],
);

print Dumper($sv);


my $ra = Bio::SRAXml::AnalysisType::ReferenceAlignment->new(
    assembly => {
        description => 'this is a non-std assembly',
        url_link    => {
            label => 'url_label',
            url   => 'http://url.thing.whatsit',
        }
    },
    sequences => [
        { refname => 'chr1', label => '1', accession => 'ABCD1' },
        { refname => 'chr2', label => '2', accession => 'EFGH2' }
    ],
);
print Dumper($ra);
