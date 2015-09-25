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
        alias         => 'foo_alias',
        center        => 'foo_center',
        analysis_date => {
            year   => 2011,
            month  => 12,
            day    => 13,
            hour   => 7,
            minute => 8,
            second => 9,
        },
        analysis_type => 'sample_phenotype',
        title         => 'A title',
        description   => 'The description',
        study_refs    => { refname => 'my_study_alias', },
        sample_refs   => {
            refname => 'my_sample_alias',
            label   => 'bob',
        },
        attributes => [
            { tag => 'attr1', value => 'val1' },
            { tag => 'attr2', value => 'val2' },
            { tag => 'attr3', value => '4', units => 'kg' },
        ],
        links => [
            {
                url   => 'http://something.com',
                label => 'url link'
            },
            {
                db => 'foo',
                entrez_id => 7,
                label     => 'entrez link',
            },
            {
                db           => 'foo',
                entrez_query => 'bar',
                label => 'entrez link',
            },
            {
                db    => 'canute',
                id    => 107,
                label => 'xref link',
            }
        ],
        experiment_refs => { refname => 'my_experiment_alias' },
        run_refs => [ { refname => 'run1' }, { refname => 'run2' } ],
        files    => [
            {
                filename => 'afile.bam',
                filetype => 'bam',
                checksum => 'abcdefg'
            },
        ],

    }
);

my ( $fh, $filename ) = tempfile();

write_xml_file( analysis_set => $analysis_set, filename => $filename );

my $actual   = TestHelper::file_to_str( filename => $filename );
my $expected = TestHelper::file_to_str( fh       => \*DATA );

is_xml( $actual, $expected, "Analysis with simple analysis type" );
done_testing();

__DATA__
<ANALYSIS_SET>
    <ANALYSIS analysis_date="2011-12-13T07:08:09.0Z" alias="foo_alias">
        <TITLE>A title</TITLE>
        <DESCRIPTION>The description</DESCRIPTION>
        <STUDY_REF refname="my_study_alias"></STUDY_REF>
        <SAMPLE_REF refname="my_sample_alias"></SAMPLE_REF>
        <EXPERIMENT_REF refname="my_experiment_alias"></EXPERIMENT_REF>
        <RUN_REF refname="run1"></RUN_REF>
        <RUN_REF refname="run2"></RUN_REF>
        <ANALYSIS_TYPE>
            <SAMPLE_PHENOTYPE />
        </ANALYSIS_TYPE>
        <FILES>
            <FILE filename="afile.bam" filetype="bam" checksum_method="MD5" checksum="abcdefg" />
        </FILES>
        <ANALYSIS_LINKS>
            <ANALYSIS_LINK>
                <URL_LINK>
                    <LABEL>url link</LABEL>
                    <URL>http://something.com</URL>
                </URL_LINK>
            </ANALYSIS_LINK>
            <ANALYSIS_LINK>
                <ENTREZ_LINK>
                    <DB>foo</DB>
                    <ID>7</ID>
                    <LABEL>entrez link</LABEL>
                </ENTREZ_LINK>
            </ANALYSIS_LINK>
            <ANALYSIS_LINK>
                <ENTREZ_LINK>
                    <DB>foo</DB>
                    <QUERY>bar</QUERY>
                    <LABEL>entrez link</LABEL>
                </ENTREZ_LINK>
            </ANALYSIS_LINK>
            <ANALYSIS_LINK>
                <XREF_LINK>
                    <DB>canute</DB>
                    <ID>107</ID>
                    <LABEL>xref link</LABEL>
                </XREF_LINK>
            </ANALYSIS_LINK>
        </ANALYSIS_LINKS>
        <ANALYSIS_ATTRIBUTES>
            <ANALYSIS_ATTRIBUTE>
                <TAG>attr1</TAG>
                <VALUE>val1</VALUE>
            </ANALYSIS_ATTRIBUTE>
            <ANALYSIS_ATTRIBUTE>
                <TAG>attr2</TAG>
                <VALUE>val2</VALUE>
            </ANALYSIS_ATTRIBUTE>
            <ANALYSIS_ATTRIBUTE>
                <TAG>attr3</TAG>
                <VALUE>4</VALUE>
                <UNITS>kg</UNITS>
            </ANALYSIS_ATTRIBUTE>
        </ANALYSIS_ATTRIBUTES>
    </ANALYSIS>
</ANALYSIS_SET>
