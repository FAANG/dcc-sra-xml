
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
package Bio::SRAXml::Types;

use strict;
use warnings;
use Carp;
use Moose::Util::TypeConstraints;

#enums
enum 'Bio::SRAXml::SimpleAnalysisTypeEnum' => [
    qw( sequence_annotation reference_sequence sample_phenotype processed_reads )
];

enum 'Bio::SRAXml::SequenceAssemblyMolTypeEnum' =>
  [ 'genomic DNA', 'genomic RNA', 'viral cRNA' ];

my $exp_type_enum_constraint =
  enum 'Bio::SRAXml::SequenceVariationExperimentTypeEnum' => [
    'Whole genome sequencing',
    'Exome sequencing',
    'Genotyping by array',
    'transcriptomics',
    'Curation',
  ];

subtype 'Bio::SRAXml::SequenceVariationExperimentTypeEnumArrayRef' => as
  'ArrayRef[Bio::SRAXml::SequenceVariationExperimentTypeEnum]';

coerce 'Bio::SRAXml::SequenceVariationExperimentTypeEnumArrayRef' => from
  'Str'                                                           => via sub {
    $exp_type_enum_constraint->assert_valid($_);
    [$_];
  };

enum FileTypeEnum => [
    qw(
      tab
      bam
      bai
      cram
      vcf
      vcf_aggregate
      tabix
      wig
      bed
      gff
      fasta
      fastq
      contig_fasta
      contig_flatfile
      scaffold_fasta
      scaffold_flatfile
      scaffold_agp
      chromosome_fasta
      chromosome_flatfile
      chromosome_agp
      chromosome_list
      unlocalised_contig_list
      unlocalised_scaffold_list
      sample_list
      readme_file
      phenotype_file
      other
      )
];

class_type 'Bio::SRAXml::Analysis';
class_type 'Bio::SRAXml::AnalysisSet';
class_type 'Bio::SRAXml::AnalysisType::ReferenceAlignment';
class_type 'Bio::SRAXml::AnalysisType::SequenceAssembly';
class_type 'Bio::SRAXml::AnalysisType::SequenceVariation';
class_type 'Bio::SRAXml::AnalysisType::SimpleAnalysisType';
class_type 'Bio::SRAXml::Attribute';
class_type 'Bio::SRAXml::EntityRef';
class_type 'Bio::SRAXml::EntrezLink';
class_type 'Bio::SRAXml::File';
class_type 'Bio::SRAXml::NameType';
class_type 'Bio::SRAXml::QualifiedNameType';
class_type 'Bio::SRAXml::ReferenceAssemblyType';
class_type 'Bio::SRAXml::ReferenceSequenceType';
class_type 'Bio::SRAXml::Sequence';
class_type 'Bio::SRAXml::UrlLink';
class_type 'Bio::SRAXml::XrefLink';

coerce 'Bio::SRAXml::Analysis' => from 'HashRef' =>
  via { Bio::SRAXml::Analysis->new($_); };
coerce 'Bio::SRAXml::AnalysisSet' => from 'HashRef' =>
  via { Bio::SRAXml::AnalysisSet->new($_); };
coerce 'Bio::SRAXml::AnalysisType::ReferenceAlignment' => from 'HashRef' =>
  via { Bio::SRAXml::AnalysisType::ReferenceAlignment->new($_); };
coerce 'Bio::SRAXml::AnalysisType::SequenceAssembly' => from 'HashRef' =>
  via { Bio::SRAXml::AnalysisType::SequenceAssembly->new($_); };
coerce 'Bio::SRAXml::AnalysisType::SequenceVariation' => from 'HashRef' =>
  via { Bio::SRAXml::AnalysisType::SequenceVariation->new($_); };
coerce 'Bio::SRAXml::AnalysisType::SimpleAnalysisType' => from 'HashRef' =>
  via { Bio::SRAXml::AnalysisType::SimpleAnalysisType->new($_); };
coerce 'Bio::SRAXml::Attribute' => from 'HashRef' =>
  via { Bio::SRAXml::Attribute->new($_); };
coerce 'Bio::SRAXml::EntityRef' => from 'HashRef' =>
  via { Bio::SRAXml::EntityRef->new($_); };
coerce 'Bio::SRAXml::EntrezLink' => from 'HashRef' =>
  via { Bio::SRAXml::EntrezLink->new($_); };
coerce 'Bio::SRAXml::File' => from 'HashRef' =>
  via { Bio::SRAXml::File->new($_); };
coerce 'Bio::SRAXml::NameType' => from 'HashRef' =>
  via { Bio::SRAXml::NameType->new($_); };
coerce 'Bio::SRAXml::QualifiedNameType' => from 'HashRef' =>
  via { Bio::SRAXml::QualifiedNameType->new($_); };
coerce 'Bio::SRAXml::ReferenceAssemblyType' => from 'HashRef' =>
  via { Bio::SRAXml::ReferenceAssemblyType->new($_); };
coerce 'Bio::SRAXml::ReferenceSequenceType' => from 'HashRef' =>
  via { Bio::SRAXml::ReferenceSequenceType->new($_); };
coerce 'Bio::SRAXml::Sequence' => from 'HashRef' =>
  via { Bio::SRAXml::Sequence->new($_); };
coerce 'Bio::SRAXml::UrlLink' => from 'HashRef' =>
  via { Bio::SRAXml::UrlLink->new($_); };
coerce 'Bio::SRAXml::XrefLink' => from 'HashRef' =>
  via { Bio::SRAXml::XrefLink->new($_); };

role_type 'Bio::SRAXml::Roles::AnalysisType';
role_type 'Bio::SRAXml::Roles::Link';

subtype 'Bio::SRAXml::Roles::LinkArrayRef' => as
  'ArrayRef[Bio::SRAXml::Roles::Link]';

coerce 'Bio::SRAXml::Roles::Link' => from 'HashRef' =>
  via { _link_from_hashref($_) };
coerce 'Bio::SRAXml::Roles::LinkArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { _link_from_hashref($_) } @$_ ];
};
coerce 'Bio::SRAXml::Roles::LinkArrayRef' => from 'HashRef' =>
  via { [ _link_from_hashref($_) ] };
coerce 'Bio::SRAXml::Roles::LinkArrayRef' => from
  'Bio::SRAXml::Roles::LinkArrayRef' => via { [$_] };

subtype 'Bio::SRAXml::EntityRefArrayRef' => as
  'ArrayRef[Bio::SRAXml::EntityRef]';

coerce 'Bio::SRAXml::EntityRefArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::EntityRef->new($_) } @$_ ];
},
  from 'Bio::SRAXml::EntityRef' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::EntityRef->new($_) ];
  };

subtype 'Bio::SRAXml::EntityRefArrayRef' => as
  'ArrayRef[Bio::SRAXml::EntityRef]';

coerce 'Bio::SRAXml::EntityRefArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::EntityRef->new($_) } @$_ ];
},
  from 'Bio::SRAXml::EntityRef' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::EntityRef->new($_) ];
  };

subtype 'Bio::SRAXml::NameTypeArrayRef' => as 'ArrayRef[Bio::SRAXml::NameType]';

coerce 'Bio::SRAXml::NameTypeArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::NameType->new($_) } @$_ ];
},
  from 'Bio::SRAXml::NameType' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::NameType->new($_) ];
  };

subtype 'Bio::SRAXml::QualifiedNameTypeArrayRef' => as
  'ArrayRef[Bio::SRAXml::QualifiedNameType]';

coerce 'Bio::SRAXml::QualifiedNameTypeArrayRef' => from 'ArrayRef[HashRef]' =>
  via {
    [ map { Bio::SRAXml::QualifiedNameType->new($_) } @$_ ];
  },
  from 'Bio::SRAXml::QualifiedNameType' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::QualifiedNameType->new($_) ];
  };

subtype 'Bio::SRAXml::AnalysisArrayRef' => as 'ArrayRef[Bio::SRAXml::Analysis]';

coerce 'Bio::SRAXml::AnalysisArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Analysis->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Analysis' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Analysis->new($_) ];
  };

subtype 'Bio::SRAXml::FileArrayRef' => as 'ArrayRef[Bio::SRAXml::File]';

coerce 'Bio::SRAXml::FileArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::File->new($_) } @$_ ];
},
  from 'Bio::SRAXml::File' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::File->new($_) ];
  };

subtype 'Bio::SRAXml::AnalysisArrayRef' => as 'ArrayRef[Bio::SRAXml::Analysis]';

coerce 'Bio::SRAXml::AnalysisArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Analysis->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Analysis' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Analysis->new($_) ];
  };

subtype 'Bio::SRAXml::SequenceArrayRef' => as 'ArrayRef[Bio::SRAXml::Sequence]';

coerce 'Bio::SRAXml::SequenceArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Sequence->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Sequence' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Sequence->new($_) ];
  };

subtype 'Bio::SRAXml::AttributeArrayRef' => as
  'ArrayRef[Bio::SRAXml::Attribute]';

coerce 'Bio::SRAXml::AttributeArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Attribute->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Attribute' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Attribute->new($_) ];
  },
  ;

# link coercion
sub _link_from_hashref {
    my ($hr) = @_;

    if ( exists $hr->{url} ) {
        return Bio::SRAXml::UrlLink->new(%$_);
    }
    if ( exists $hr->{query} ) {
        return Bio::SRAXml::EntrezLink->new(%$_);
    }
    return Bio::SRAXml::XrefLink->new(%$_);
}

coerce 'Bio::SRAXml::Roles::AnalysisType' => from 'Str' => via {
    Bio::SRAXml::AnalysisType::SimpleAnalysisType->new( type => $_ );
};
coerce 'Bio::SRAXml::Roles::AnalysisType' => from 'HashRef' => via {
    my $at   = $_;
    my @keys = keys %$at;
    confess("AnalysisType coercion should have a single key")
      if ( scalar(@keys) != 1 );

    my $k = pop @keys;
    my $v = $at->{$k};

    if ( $k eq 'reference_alignment' ) {
        return Bio::SRAXml::AnalysisType::ReferenceAlignment->new(%$v);
    }
    elsif ( $k eq 'sequence_assembly' ) {
        return Bio::SRAXml::AnalysisType::SequenceAssembly->new(%$v);
    }
    elsif ( $k eq 'sequence_variation' ) {
        return Bio::SRAXml::AnalysisType::SequenceVariation->new(%$v);
    }
    else {
        confess(
"$k is not a known Bio::SRAXml::AnalysisType suitable for coercion from hash"
        );
    }
};

1;
