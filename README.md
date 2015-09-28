#SRA XML
[![Build Status](https://travis-ci.org/FAANG/sra_xml.svg)](https://travis-ci.org/FAANG/sra_xml) [![Coverage Status](https://coveralls.io/repos/FAANG/sra_xml/badge.svg?branch=master&service=github)](https://coveralls.io/github/FAANG/sra_xml?branch=master)

A library for building SRA XML.

##Scope

Smooth the process of writing SRA XML, producing documents that comply with the XML schema. We make no attempt to validate the content of the documents produced. The initial focus of the library is writing analysis XML.

##Example

```perl

use Bio::SRAXml qw(write_xml_file);

my $analysis_set = Bio::SRAXml::Analysis::AnalysisSet->new();

$analysis_set->add_analysis(
    {
        alias         => 'foo_alias',  # a unique name for this analysis
        analysis_date => { # when was this analysis performed?
            year   => 2011,
            month  => 12,
            day    => 13,
            hour   => 7,
            minute => 8,
            second => 9,
        },
        analysis_type => 'sample_phenotype', # what is the type of the analysis? see documentation below on more complex analysis types
        title         => 'A title',
        description   => 'The description',
        # references can be made to studies, samples, experiments, runs and analyses
        study_refs    => { refname => 'my_study_alias', }, 
        sample_refs   => {
            refname => 'my_sample_alias',
            label   => 'bob',
        },
        experiment_refs => { refname => 'my_experiment_alias' },
        run_refs => [ { refname => 'run1' }, { refname => 'run2' } ],
        #attributes are tags/values/units describing the analysis
        attributes => [
            { tag => 'attr1', value => 'val1' },
            { tag => 'attr2', value => 'val2' },
            { tag => 'attr3', value => '4', units => 'kg' },
        ],
        #links can be made as URLs, entrez queries or IDs, or XRef links
        links => [
            {
                url   => 'http://something.com',
                label => 'url link'
            },
            {
                db    => 'foo',
                id    => 7,
                label => 'entrez link',
            },
            {
                db    => 'canute',
                id    => 107,
                label => 'xref link',
            }
        ],
       #files have names, types and checksums
        files    => [
            {
                filename => 'afile.bam',
                filetype => 'bam',
                checksum => 'abcdefg'
            },
        ],
    }
);

write_xml_file($analysis_set,'/path/to/file');
```

##Analysis types

Each alignment type has different requirements

###Reference alignment

A reference alignment must specify which assembly was used, and which sequences it refers to. Assemblies can either be standard (refname and accession) or custom (description and url_link).

```perl
$analysis_set->add_analysis(
    {
        alias         => 'bar_alias',
        analysis_type => {
            'reference_alignment' => {
                assembly => {
                    description =>
'A custom assembly created with my beautiful assembly pipeline',
                    url_link => {
                        url   => 'ftp://url.for.assembly.fa.gz',
                        label => 'my custom assembly'
                    },
                },
                sequences => [
                    { accession => 'CM000663.1', label => '1' },
                    { accession => 'CM000672.1', label => '10' },
                    { accession => 'CM000673.1', label => '11' },
                    ...
                ]
            }
        },
        ...
    }
);
```


###Sequence assembly

```perl
$analysis_set->add_analysis(
    {
        alias => 'bar_alias',
        analysis_type => {
            'sequence_assembly' => {
                name     => 'Pony assembly 102',
                partial  => 0,
                coverage => '180',
                program  => 'cortex',
                platform => 'linux'
            }
        },
        ...
      }
);
```

###Sequence variation

Similar to reference alignment, sequence variation requires an assembly and sequences, plus some additional attributes.

```perl
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
                    ..
                    ].
        },
        ...
      }
);
```

###Other types

The following types can be specified with a simple string:

 * sequence_annotation
 * reference_sequence
 * sample_phenotype
 * processed_reads
 
 e.g. 

```perl
$analysis_set->add_analysis(
    {
        alias         => 'bar_alias',
        analysis_type => 'reference_sequence',
        ...
      }
);


##Contributing

We would welcome contributions that extend the SRA objects covered by this library. Please organise code to support one xsd file in one directory, e.g.

* http://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.common.xsd is in `lib/Bio/SRAXml/Common`
* http://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/SRA.analysis.xsd is in `lib/Bio/SRAXml/Analysis`

The roles in `lib/Bio/SRAXml/Roles` are used for two purposes

 * tag classes (e.g. Bio::SRAXml::Roles::Link to label the Entrez, URL and XRef link classes)
 * for use as mixins for common attributes, e.g. NameGroup 
to either tag classes as supporting some functionality, or as mixins to provide   

The library makes heavy use of moose type coercions, so that you users can input data without knowing the entire class hierachy. This should be continued as the llibrary grows. See Bio::SRAXml::Types for examples.
