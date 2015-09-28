#!/usr/bin/env perl
use strict;
use Test::More;
use FindBin qw($Bin);
use File::Temp qw/ tempfile /;
use lib ("$Bin/../lib","$Bin/lib");

use TestHelper;
use Bio::SRAXml qw(write_xml_file);
use Test::XML;

my $analysis_set = Bio::SRAXml::Analysis::AnalysisSet->new();

$analysis_set->add_analysis(
    {
        alias => 'bar_alias',
        analysis_type => {
            'sequence_assembly' => {
                name     => 'Pony assembly 102',
                partial  => 0,
                coverage => '180',
                program  => 'cortex',
                platform => 'Amstrad CPC'
            }
        },
        title       => 'My little contigs',
        description => 'Cortex assembly',
        study_refs  => { refname => 'my_excellent_study', },
        sample_refs => [
            { refname => 'my_first_sample', },
            { refname => 'my_second_sample', }
        ],
        files => [
            {
                filename => 'pony.dna.gz',
                filetype => 'contig_fasta',
                checksum => '32baacdb4c66da820f780cf028792ccf'
            },
        ],
    }
);

my ( $fh, $filename ) = tempfile();

write_xml_file( root_entity => $analysis_set, filename => $filename );

my $actual   = TestHelper::file_to_str( filename => $filename );
my $expected = TestHelper::file_to_str( fh       => \*DATA );

is_xml( $actual, $expected, "Analysis with sequence assembly type" );
done_testing();

__DATA__
<ANALYSIS_SET>
    <ANALYSIS alias="bar_alias">
        <TITLE>My little contigs</TITLE>
        <DESCRIPTION>Cortex assembly</DESCRIPTION>
        <STUDY_REF refname="my_excellent_study"></STUDY_REF>
        <SAMPLE_REF refname="my_first_sample"></SAMPLE_REF>
        <SAMPLE_REF refname="my_second_sample"></SAMPLE_REF>
        <ANALYSIS_TYPE>
            <SEQUENCE_ASSEMBLY>
                <NAME>Pony assembly 102</NAME>
                <PARTIAL>false</PARTIAL>
                <COVERAGE>180</COVERAGE>
                <PROGRAM>cortex</PROGRAM>
                <PLATFORM>Amstrad CPC</PLATFORM>
            </SEQUENCE_ASSEMBLY>
        </ANALYSIS_TYPE>
        <FILES>
            <FILE filename="pony.dna.gz" filetype="contig_fasta" checksum_method="MD5" checksum="32baacdb4c66da820f780cf028792ccf" />
        </FILES>
    </ANALYSIS>
</ANALYSIS_SET>
