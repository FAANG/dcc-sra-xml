
=head1 LICENSE
   Copyright 2015 EMBL - European Bioinformatics Institute
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
     http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
=cut
package Bio::SRAXml;

=head1 NAME

Bio::SRAXml - Perlish construction of SRA XML

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Bio::SRAXml qw(write_xml_file);

    my $analysis_set = Bio::SRAXml::Analysis::AnalysisSet->new();

    $analysis_set->add_analysis({
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
    });

    write_xml_file($analysis_set,'/path/to/file');

=head1 Description

    Write SRA XML using native perl data structures. Scalars/HashRefs/ArrayRefs
    are coerced into the appropriate data type. Calling write_xml_file writes
    the xml file and validates the file against the schema. 

    Your script can 'use' this module to get all the functionality of the API.

=head1 Caveats

  This version of the API only supports creating analysis objects.
 
  Validation is limited to comparing the document to the document schema, 
   ensuring that documents syntactically valid. 
  The archives perform additional checks on the content of submissions
   that go beyond the scope of this API. 
=cut

use strict;
use warnings;
use Exporter 'import';
use Carp;

use XML::Writer;
use XML::LibXML;
use MooseX::Params::Validate;

use Bio::SRAXml::Types;
use Bio::SRAXml::Analysis::Analysis;
use Bio::SRAXml::Analysis::AnalysisSet;
use Bio::SRAXml::Common::Attribute;
use Bio::SRAXml::Common::EntityRef;
use Bio::SRAXml::Common::EntrezIdLink;
use Bio::SRAXml::Common::EntrezQueryLink;
use Bio::SRAXml::Analysis::AnalysisFile;
use Bio::SRAXml::Common::NameType;
use Bio::SRAXml::Common::QualifiedNameType;
use Bio::SRAXml::Common::ReferenceAssemblyType;
use Bio::SRAXml::Common::ReferenceSequenceType;
use Bio::SRAXml::Common::Sequence;
use Bio::SRAXml::Analysis::SimpleAnalysisType;
use Bio::SRAXml::Common::UrlLink;
use Bio::SRAXml::Common::XrefLink;

use Bio::SRAXml::Analysis::ReferenceAlignment;
use Bio::SRAXml::Analysis::SequenceAssembly;
use Bio::SRAXml::Analysis::SequenceVariation;
use Bio::SRAXml::Analysis::SimpleAnalysisType;

our @EXPORT_OK = qw(write_xml_file);

=head2 Bio::SRAXml::SCHEMA_LOCATION

  Package variable set to the schema URL http://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/ENA.root.xsd
  It is unlikely you will want to change this variable in isolation 
   - the API is designed against this version of the schema
=cut

our $SCHEMA_LOCATION = 'http://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/ENA.root.xsd';

=head2 write_xml_file

  Output XML for the object to the named file, and
    validate that file against the schema.

  Schema errors will cause the code to die.
=cut

sub write_xml_file {
    my ( $analysis_set, $filename ) = validated_list(
        \@_,
        analysis_set => { isa => 'Bio::SRAXml::Roles::WriteableEntity' },
        filename     => { isa => 'Str' }
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

    validate_against_schema( filename => $filename );
}

sub validate_against_schema {
    my ($filename) = validated_list( \@_, filename => { isa => 'Str' }, );

    my $xmlschema = XML::LibXML::Schema->new( location => $SCHEMA_LOCATION );

    my $doc = XML::LibXML->new->parse_file($filename);

    eval { $xmlschema->validate($doc); };
    croak "XML Document is not valid: " . $@
      if $@;
}

1;
