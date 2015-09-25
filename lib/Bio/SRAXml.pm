package Bio::SRAXml;
use strict;
our $VERSION = '0.01';
1;
use Exporter 'import';
our @EXPORT_OK = qw(write_analysis_xml_file);

use Carp;

use XML::Writer;
use XML::LibXML;
use MooseX::Params::Validate;

use Bio::SRAXml::Types;
use Bio::SRAXml::Analysis;
use Bio::SRAXml::AnalysisSet;
use Bio::SRAXml::Attribute;
use Bio::SRAXml::EntityRef;
use Bio::SRAXml::EntrezLink;
use Bio::SRAXml::File;
use Bio::SRAXml::NameType;
use Bio::SRAXml::QualifiedNameType;
use Bio::SRAXml::ReferenceAssemblyType;
use Bio::SRAXml::ReferenceSequenceType;
use Bio::SRAXml::Sequence;
use Bio::SRAXml::AnalysisType::SimpleAnalysisType;
use Bio::SRAXml::UrlLink;
use Bio::SRAXml::XrefLink;

use Bio::SRAXml::AnalysisType::ReferenceAlignment;
use Bio::SRAXml::AnalysisType::SequenceAssembly;
use Bio::SRAXml::AnalysisType::SequenceVariation;
use Bio::SRAXml::AnalysisType::SimpleAnalysisType;

my %SCHEMA_LOCATIONS = (
    analysis => 'http://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.analysis.xsd',
    common   => 'http://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.common.xsd',
);

sub write_analysis_xml_file {
    my ( $analysis_set, $filename ) = validated_list(
        \@_,
        analysis_set => { isa => 'Bio::SRAXml::AnalysisSet' },
        filename => { isa => 'Str' }
    );

    my $output = IO::File->new( '>' . $filename );

    my $writer = XML::Writer->new(
        OUTPUT      => $output,
        DATA_INDENT => 4,
        CHECK_PRINT => 1,
        DATA_MODE   => 1
    );

    $analysis_set->write_to_xml($writer);

    $writer->end();
    $output->close();

    validate_against_schema( schema => 'analysis', filename => $filename );
}

sub validate_against_schema {
    my ( $schema, $filename ) = validated_list(
        \@_,
        schema   => { isa => 'Str' },
        filename => { isa => 'Str' },
    );

    if ( !$SCHEMA_LOCATIONS{$schema} ) {
        confess "$schema is not a known schema";
    }
    my $xmlschema =
      XML::LibXML::Schema->new( location => $SCHEMA_LOCATIONS{$schema} );

    my $doc = XML::LibXML->new->parse_file($filename);

    eval { $xmlschema->validate($doc); };
    carp "XML Document is not valid: " . $@
      if $@;
}

1;
