#!/usr/bin/env perl
use strict;
use Test::More;
use FindBin qw($Bin);
use File::Temp qw/ tempfile /;
use lib ( "$Bin/../lib", "$Bin/lib" );

use TestHelper;
use Bio::SRAXml qw(write_xml_file);
use Test::XML;

my $datasets = Bio::SRAXml::Dataset::Datasets->new();

$datasets->add_dataset(
    {
        alias        => 'foo_alias',
        dataset_type => 'Genotyping by array',
        title        => 'A title',
        description  => 'The description',
        policy_ref   => { refname => 'my_policy_alias', },

        run_refs =>
          [ { refname => 'run_alias1', }, { refname => 'run_alias2', } ],
        analysis_refs => [
            { refname => 'analysis_alias1', },
            { refname => 'analysis_alias2', }
        ],
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
                db        => 'foo',
                entrez_id => 7,
                label     => 'entrez link',
            },
            {
                db           => 'foo',
                entrez_query => 'bar',
                label        => 'entrez link',
            },
            {
                db    => 'canute',
                id    => 107,
                label => 'xref link',
            }
        ],
    }
);

my ( $fh, $filename ) = tempfile();

write_xml_file( root_entity => $datasets, filename => $filename );

my $actual   = TestHelper::file_to_str( filename => $filename );
my $expected = TestHelper::file_to_str( fh       => \*DATA );

is_xml( $actual, $expected, "Dataset" );
done_testing();

__DATA__
<DATASETS>
    <DATASET alias="foo_alias">
        <TITLE>A title</TITLE>
        <DESCRIPTION>The description</DESCRIPTION>
        <RUN_REF refname="run_alias1"></RUN_REF>
        <RUN_REF refname="run_alias2"></RUN_REF>
        <ANALYSIS_REF refname="analysis_alias1"></ANALYSIS_REF>
        <ANALYSIS_REF refname="analysis_alias2"></ANALYSIS_REF>
        <POLICY_REF refname="my_policy_alias"></POLICY_REF>
        <DATASET_TYPE>Genotyping by array</DATASET_TYPE>
        <DATASET_LINKS>
            <DATASET_LINK>
                <URL_LINK>
                    <LABEL>url link</LABEL>
                    <URL>http://something.com</URL>
                </URL_LINK>
            </DATASET_LINK>
            <DATASET_LINK>
                <ENTREZ_LINK>
                    <DB>foo</DB>
                    <ID>7</ID>
                    <LABEL>entrez link</LABEL>
                </ENTREZ_LINK>
            </DATASET_LINK>
            <DATASET_LINK>
                <ENTREZ_LINK>
                    <DB>foo</DB>
                    <QUERY>bar</QUERY>
                    <LABEL>entrez link</LABEL>
                </ENTREZ_LINK>
            </DATASET_LINK>
            <DATASET_LINK>
                <XREF_LINK>
                    <DB>canute</DB>
                    <ID>107</ID>
                    <LABEL>xref link</LABEL>
                </XREF_LINK>
            </DATASET_LINK>
        </DATASET_LINKS>
        <DATASET_ATTRIBUTES>
            <DATASET_ATTRIBUTE>
                <TAG>attr1</TAG>
                <VALUE>val1</VALUE>
            </DATASET_ATTRIBUTE>
            <DATASET_ATTRIBUTE>
                <TAG>attr2</TAG>
                <VALUE>val2</VALUE>
            </DATASET_ATTRIBUTE>
            <DATASET_ATTRIBUTE>
                <TAG>attr3</TAG>
                <VALUE>4</VALUE>
                <UNITS>kg</UNITS>
            </DATASET_ATTRIBUTE>
        </DATASET_ATTRIBUTES>
    </DATASET>
</DATASETS>
