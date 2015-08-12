package Bio::SRAXml;
use strict;
our $VERSION = '0.01';
1;
use Exporter 'import';    # gives you Exporter's import() method directly
our @EXPORT_OK = qw(write_analysis_xml);

use Bio::SRAXml::Analysis;
use Bio::SRAXml::AnalysisSet;
use Bio::SRAXml::Attribute;
use Bio::SRAXml::EntityRef;
use Bio::SRAXml::EntrezLink;
use Bio::SRAXml::File;
use Bio::SRAXml::NameType;
use Bio::SRAXml::QualifiedNameType;
use Bio::SRAXml::UrlLink;
use Bio::SRAXml::XrefLink;
use Bio::SRAXml::SimpleAnalysisType;

sub write_analysis_xml {
    my ( $analysis_set, $filehandle ) = @_;

    my $writer = XML::Writer->new(
        OUTPUT      => $filehandle,
        DATA_INDENT => 4,
        CHECK_PRINT => 1,
        DATA_MODE   => 1
    );
    
    $analysis_set->write_to_xml($writer);
    
    $writer->end();
}

1;
