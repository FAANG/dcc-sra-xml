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
        center_name   => 'RITA',
        broker_name   => 'SUE',
        accession     => 'A1',
        analysis_type => 'sample_phenotype',
        title         => 'A title',
        description   => 'The description',
        study_refs    => {
            refname      => 'my_study_alias',
            refcenter    => 'FRED',
            accession    => 'A1',
            primary_id   => { name => 'A1' },
            secondary_id => { name => 'A-A1' },
            external_id  => { namespace => 'SUE', name => 'EXT-A-A1',label => 'extlabel' },
            uuid         => { name      => '348923usdfgk0934-234oij' },
            submitter_id => { namespace => 'BOB', name => 'SGVP' }
        },
        files => [
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

is_xml( $actual, $expected, "Analysis with identifiers" );
done_testing();

__DATA__
<ANALYSIS_SET>
    <ANALYSIS alias="foo_alias" center_name="RITA" broker_name="SUE" accession="A1">
        <TITLE>A title</TITLE>
        <DESCRIPTION>The description</DESCRIPTION>
        <STUDY_REF refname="my_study_alias" accession="A1" refcenter="FRED">
          <IDENTIFIERS>
             <PRIMARY_ID>A1</PRIMARY_ID>
             <SECONDARY_ID>A-A1</SECONDARY_ID>
             <EXTERNAL_ID namespace="SUE" label="extlabel">EXT-A-A1</EXTERNAL_ID>
             <SUBMITTER_ID namespace="BOB">SGVP</SUBMITTER_ID>
             <UUID>348923usdfgk0934-234oij</UUID>
          </IDENTIFIERS>
        </STUDY_REF>
        <ANALYSIS_TYPE>
            <SAMPLE_PHENOTYPE />
        </ANALYSIS_TYPE>
        <FILES>
            <FILE filename="afile.bam" filetype="bam" checksum_method="MD5" checksum="abcdefg" />
        </FILES>
    </ANALYSIS>
</ANALYSIS_SET>
