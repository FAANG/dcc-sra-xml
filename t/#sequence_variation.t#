#!/usr/bin/env perl
use strict;
use Test::More;
use FindBin qw($Bin);
use File::Temp qw/ tempfile /;
use lib ( "$Bin/../lib", "$Bin/lib" );

use TestHelper;
use Bio::SRAXml qw(write_xml_file);
use Test::XML;

my $analysis_set = Bio::SRAXml::Analysis::AnalysisSet->new();

$analysis_set->add_analysis(
    {
        alias         => 'bar_alias',
        analysis_type => {
            'sequence_variation' => {
                experiment_type => 'Whole genome sequencing',
                program         => 'MyVariantCaller',
                platform        => 'Illumina SuperWhizzy Sequencing Machine',

                assembly => {
                    refname   => 'GRCh37',
                    accession => 'GCA_000001405.1',
                },
                sequences => [
                    { accession => 'CM000663.1', label => '1' },
                    { accession => 'CM000672.1', label => '10' },
                    { accession => 'CM000673.1', label => '11' },
                    { accession => 'CM000674.1', label => '12' },
                    { accession => 'CM000675.1', label => '13' },
                    { accession => 'CM000676.1', label => '14' },
                    { accession => 'CM000677.1', label => '15' },
                    { accession => 'CM000678.1', label => '16' },
                    { accession => 'CM000679.1', label => '17' },
                    { accession => 'CM000680.1', label => '18' },
                    { accession => 'CM000681.1', label => '19' },
                    { accession => 'CM000664.1', label => '2' },
                    { accession => 'CM000682.1', label => '20' },
                    { accession => 'CM000683.1', label => '21' },
                    { accession => 'CM000684.1', label => '22' },
                    { accession => 'CM000665.1', label => '3' },
                    { accession => 'CM000666.1', label => '4' },
                    { accession => 'CM000667.1', label => '5' },
                    { accession => 'CM000668.1', label => '6' },
                    { accession => 'CM000669.1', label => '7' },
                    { accession => 'CM000670.1', label => '8' },
                    { accession => 'CM000671.1', label => '9' },
                    { accession => 'J01415.2',   label => 'MT' },
                    { accession => 'CM000685.1', label => 'X' },
                    { accession => 'CM000686.1', label => 'Y' },
                ]
            }
        },
        title       => 'My little VCF',
        description => 'Genotype calls',
        study_refs  => { refname => 'my_excellent_study', },
        sample_refs => [
            { refname => 'my_first_sample', },
        ],
        files => [
            {
                filename => 'genotypes.vcf',
                filetype => 'vcf',
                checksum => '32baacdb4c66da820f780cf028792ccf'
            },
        ],
    }
);
my ( $fh, $filename ) = tempfile();

write_xml_file( root_entity => $analysis_set, filename => $filename );

my $actual   = TestHelper::file_to_str( filename => $filename );
my $expected = TestHelper::file_to_str( fh       => \*DATA );

is_xml( $actual, $expected, "Analysis with sequence analysis type" );
done_testing();

__DATA__
<ANALYSIS_SET>
    <ANALYSIS alias="bar_alias">
        <TITLE>My little VCF</TITLE>
        <DESCRIPTION>Genotype calls</DESCRIPTION>
        <STUDY_REF refname="my_excellent_study"></STUDY_REF>
        <SAMPLE_REF refname="my_first_sample"></SAMPLE_REF>
        <ANALYSIS_TYPE>
            <SEQUENCE_VARIATION>
                <ASSEMBLY>
                    <STANDARD refname="GRCh37" accession="GCA_000001405.1" />
                </ASSEMBLY>
                <SEQUENCE accession="CM000663.1" label="1" />
                <SEQUENCE accession="CM000672.1" label="10" />
                <SEQUENCE accession="CM000673.1" label="11" />
                <SEQUENCE accession="CM000674.1" label="12" />
                <SEQUENCE accession="CM000675.1" label="13" />
                <SEQUENCE accession="CM000676.1" label="14" />
                <SEQUENCE accession="CM000677.1" label="15" />
                <SEQUENCE accession="CM000678.1" label="16" />
                <SEQUENCE accession="CM000679.1" label="17" />
                <SEQUENCE accession="CM000680.1" label="18" />
                <SEQUENCE accession="CM000681.1" label="19" />
                <SEQUENCE accession="CM000664.1" label="2" />
                <SEQUENCE accession="CM000682.1" label="20" />
                <SEQUENCE accession="CM000683.1" label="21" />
                <SEQUENCE accession="CM000684.1" label="22" />
                <SEQUENCE accession="CM000665.1" label="3" />
                <SEQUENCE accession="CM000666.1" label="4" />
                <SEQUENCE accession="CM000667.1" label="5" />
                <SEQUENCE accession="CM000668.1" label="6" />
                <SEQUENCE accession="CM000669.1" label="7" />
                <SEQUENCE accession="CM000670.1" label="8" />
                <SEQUENCE accession="CM000671.1" label="9" />
                <SEQUENCE accession="J01415.2" label="MT" />
                <SEQUENCE accession="CM000685.1" label="X" />
                <SEQUENCE accession="CM000686.1" label="Y" />
                <EXPERIMENT_TYPE>Whole genome sequencing</EXPERIMENT_TYPE>
                <PROGRAM>MyVariantCaller</PROGRAM>
                <PLATFORM>Illumina SuperWhizzy Sequencing Machine</PLATFORM>
            </SEQUENCE_VARIATION>
        </ANALYSIS_TYPE>
        <FILES>
            <FILE filename="genotypes.vcf" filetype="vcf" checksum_method="MD5" checksum="32baacdb4c66da820f780cf028792ccf" />
        </FILES>
    </ANALYSIS>
</ANALYSIS_SET>
