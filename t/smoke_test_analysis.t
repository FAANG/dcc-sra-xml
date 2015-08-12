#!/usr/bin/env perl
use strict;
use Test::More;
use FindBin qw($Bin);
use File::Temp qw/ tempfile /;
use lib "$Bin/../lib";

use Bio::SRAXml qw(write_analysis_xml);
use XML::Writer;

my $analysis_set = Bio::SRAXml::AnalysisSet->new();

$analysis_set->add_analysis(
    {
        alias         => 'foo_alias',
        center        => 'foo_center',
        analysis_date => {
            year   => 2011,
            month  => 11,
            day    => 18,
            hour   => 10,
            minute => 10,
            second => 10,
        },
        analysis_type => 'sample_phenotype',
        title         => 'A title',
        description   => 'The description',
        study_refs    => { refname => 'my_study_alias', },
        sample_refs   => {
            refname => 'my_sample_alias',
            label   => 'bob',
        },
        attributes => {
            attr1 => 'val1',
            attr2 => 'val2',
            attr3 => [ 4, 'kg' ],
        },
        links => [
            {
                url   => 'http://something.com',
                label => 'url link'
            },
            {
                db    => 'foo',
                query => 'bar',
                id    => 7,
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

write_analysis_xml($analysis_set,$fh);

close($fh);
open( $fh, '<', $filename );

my ( $expected, $actual );
{
    local $/ = undef;
    $actual   = <$fh>;
    $expected = <DATA>;
}
close $fh;

is($actual,$expected,"AnalysisSet XML output smoke test");
done_testing();

__DATA__
<ANALYSIS_SET>
    <ANALYSIS analysis_date="2011-10-18T10:10:10.0Z" alias="foo_alias">
        <TITLE>A title</TITLE>
        <DESCRIPTION>The description</DESCRIPTION>
        <STUDY_REF refname="my_study_alias"></STUDY_REF>
        <SAMPLE_REF refname="my_sample_alias"></SAMPLE_REF>
        <EXPERIMENT_REF refname="my_experiment_alias"></EXPERIMENT_REF>
        <RUN_REF refname="run1"></RUN_REF>
        <RUN_REF refname="run2"></RUN_REF>
        <ANALYSIS_LINKS>
            <URL_LINK>
                <LABEL>url link</LABEL>
                <URL>http://something.com</URL>
            </URL_LINK>
            <ENTREZ_TAG>
                <DB>foo</DB>
                <ID>7</ID>
                <QUERY>bar</QUERY>
                <LABEL>entrez link</LABEL>
            </ENTREZ_TAG>
            <XREF_LINK>
                <DB>canute</DB>
                <ID>107</ID>
                <LABEL>xref link</LABEL>
            </XREF_LINK>
        </ANALYSIS_LINKS>
        <ANALYSIS_ATTRIBUTES>
            <ANALYSIS_ATTRIBUTE>
                <TAG>attr2</TAG>
                <VALUE>val2</VALUE>
            </ANALYSIS_ATTRIBUTE>
            <ANALYSIS_ATTRIBUTE>
                <TAG>attr1</TAG>
                <VALUE>val1</VALUE>
            </ANALYSIS_ATTRIBUTE>
            <ANALYSIS_ATTRIBUTE>
                <TAG>attr3</TAG>
                <VALUE>4</VALUE>
                <UNITS>kg</UNITS>
            </ANALYSIS_ATTRIBUTE>
        </ANALYSIS_ATTRIBUTES>
        <ANALYSIS_TYPE>
            <SAMPLE_PHENOTYPE />
        </ANALYSIS_TYPE>
        <FILES>
            <FILE checksum="abcdefg" filetype="bam" filename="afile.bam" checksum_method="MD5" />
        </FILES>
    </ANALYSIS>
</ANALYSIS_SET>
