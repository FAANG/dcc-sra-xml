#!/usr/bin/env perl
use strict;
use FindBin qw($Bin);
use lib ( "$Bin/../lib", "$Bin/lib" );

use Bio::SRAXml;
use Test::More;
use Test::Exception;

my $test_dir = "$Bin/xml_files";

throws_ok {
    Bio::SRAXml::validate_against_schema(
        filename => "$test_dir/non_existent_file.xml" );
}
qr/No such file or directory/, 'Validator rejects non-existent file';

lives_ok {
    Bio::SRAXml::validate_against_schema(
        filename => "$test_dir/ERZ000001.xml" );
}
'Validator accepts file from ENA';

throws_ok {
    Bio::SRAXml::validate_against_schema(
        filename => "$test_dir/not_actually.xml" );
}
qr/Start tag expected/, 'Validator rejects non-xml file';

throws_ok {
    Bio::SRAXml::validate_against_schema(
        filename => "$test_dir/slightly_broken.xml" );
}
qr/Schemas validity error : Element 'BROKEN_TITLE_ELEMENT'/,
  'Validator rejects xml file with element not in schema';

done_testing();
