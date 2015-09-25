
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

=head1 Description
  
  A library for moose types and coercions used in this project. 
  
=cut

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

class_type 'Bio::SRAXml::Analysis::Analysis';
class_type 'Bio::SRAXml::Analysis::AnalysisSet';
class_type 'Bio::SRAXml::Analysis::ReferenceAlignment';
class_type 'Bio::SRAXml::Analysis::SequenceAssembly';
class_type 'Bio::SRAXml::Analysis::SequenceVariation';
class_type 'Bio::SRAXml::Analysis::SimpleAnalysisType';
class_type 'Bio::SRAXml::Common::Attribute';
class_type 'Bio::SRAXml::Common::EntityRef';
class_type 'Bio::SRAXml::Common::EntrezLink';
class_type 'Bio::SRAXml::Analysis::AnalysisFile';
class_type 'Bio::SRAXml::Common::NameType';
class_type 'Bio::SRAXml::Common::QualifiedNameType';
class_type 'Bio::SRAXml::Common::ReferenceAssemblyType';
class_type 'Bio::SRAXml::Common::ReferenceSequenceType';
class_type 'Bio::SRAXml::Common::Sequence';
class_type 'Bio::SRAXml::Common::UrlLink';
class_type 'Bio::SRAXml::Common::XrefLink';

coerce 'Bio::SRAXml::Analysis::Analysis' => from 'HashRef' =>
  via { Bio::SRAXml::Analysis::Analysis->new($_); };
coerce 'Bio::SRAXml::Analysis::AnalysisSet' => from 'HashRef' =>
  via { Bio::SRAXml::Analysis::AnalysisSet->new($_); };
coerce 'Bio::SRAXml::Analysis::ReferenceAlignment' => from 'HashRef' =>
  via { Bio::SRAXml::Analysis::ReferenceAlignment->new($_); };
coerce 'Bio::SRAXml::Analysis::SequenceAssembly' => from 'HashRef' =>
  via { Bio::SRAXml::Analysis::SequenceAssembly->new($_); };
coerce 'Bio::SRAXml::Analysis::SequenceVariation' => from 'HashRef' =>
  via { Bio::SRAXml::Analysis::SequenceVariation->new($_); };
coerce 'Bio::SRAXml::Analysis::SimpleAnalysisType' => from 'HashRef' =>
  via { Bio::SRAXml::Analysis::SimpleAnalysisType->new($_); };
coerce 'Bio::SRAXml::Common::Attribute' => from 'HashRef' =>
  via { Bio::SRAXml::Common::Attribute->new($_); };
coerce 'Bio::SRAXml::Common::EntityRef' => from 'HashRef' =>
  via { Bio::SRAXml::Common::EntityRef->new($_); };
coerce 'Bio::SRAXml::Common::EntrezLink' => from 'HashRef' =>
  via { Bio::SRAXml::Common::EntrezLink->new($_); };
coerce 'Bio::SRAXml::Analysis::AnalysisFile' => from 'HashRef' =>
  via { Bio::SRAXml::Analysis::AnalysisFile->new($_); };
coerce 'Bio::SRAXml::Common::NameType' => from 'HashRef' =>
  via { Bio::SRAXml::Common::NameType->new($_); };
coerce 'Bio::SRAXml::Common::QualifiedNameType' => from 'HashRef' =>
  via { Bio::SRAXml::Common::QualifiedNameType->new($_); };
coerce 'Bio::SRAXml::Common::ReferenceAssemblyType' => from 'HashRef' =>
  via { Bio::SRAXml::Common::ReferenceAssemblyType->new($_); };
coerce 'Bio::SRAXml::Common::ReferenceSequenceType' => from 'HashRef' =>
  via { Bio::SRAXml::Common::ReferenceSequenceType->new($_); };
coerce 'Bio::SRAXml::Common::Sequence' => from 'HashRef' =>
  via { Bio::SRAXml::Common::Sequence->new($_); };
coerce 'Bio::SRAXml::Common::UrlLink' => from 'HashRef' =>
  via { Bio::SRAXml::Common::UrlLink->new($_); };
coerce 'Bio::SRAXml::Common::XrefLink' => from 'HashRef' =>
  via { Bio::SRAXml::Common::XrefLink->new($_); };

role_type 'Bio::SRAXml::Roles::AnalysisType';
role_type 'Bio::SRAXml::Roles::Link';
role_type 'Bio::SRAXml::Roles::WriteableEntity';

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

subtype 'Bio::SRAXml::Common::EntityRefArrayRef' => as
  'ArrayRef[Bio::SRAXml::Common::EntityRef]';

coerce 'Bio::SRAXml::Common::EntityRefArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Common::EntityRef->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Common::EntityRef' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Common::EntityRef->new($_) ];
  };

subtype 'Bio::SRAXml::Common::EntityRefArrayRef' => as
  'ArrayRef[Bio::SRAXml::Common::EntityRef]';

coerce 'Bio::SRAXml::Common::EntityRefArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Common::EntityRef->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Common::EntityRef' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Common::EntityRef->new($_) ];
  };

subtype 'Bio::SRAXml::Common::NameTypeArrayRef' => as 'ArrayRef[Bio::SRAXml::Common::NameType]';

coerce 'Bio::SRAXml::Common::NameTypeArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Common::NameType->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Common::NameType' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Common::NameType->new($_) ];
  };

subtype 'Bio::SRAXml::Common::QualifiedNameTypeArrayRef' => as
  'ArrayRef[Bio::SRAXml::Common::QualifiedNameType]';

coerce 'Bio::SRAXml::Common::QualifiedNameTypeArrayRef' => from 'ArrayRef[HashRef]' =>
  via {
    [ map { Bio::SRAXml::Common::QualifiedNameType->new($_) } @$_ ];
  },
  from 'Bio::SRAXml::Common::QualifiedNameType' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Common::QualifiedNameType->new($_) ];
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

subtype 'Bio::SRAXml::Analysis::AnalysisFileArrayRef' => as 'ArrayRef[Bio::SRAXml::Analysis::AnalysisFile]';

coerce 'Bio::SRAXml::Analysis::AnalysisFileArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Analysis::AnalysisFile->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Analysis::AnalysisFile' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Analysis::AnalysisFile->new($_) ];
  };

subtype 'Bio::SRAXml::AnalysisArrayRef' => as 'ArrayRef[Bio::SRAXml::Analysis::Analysis]';

coerce 'Bio::SRAXml::AnalysisArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Analysis::Analysis->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Analysis' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Analysis::Analysis->new($_) ];
  };

subtype 'Bio::SRAXml::SequenceArrayRef' => as 'ArrayRef[Bio::SRAXml::Common::Sequence]';

coerce 'Bio::SRAXml::SequenceArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Common::Sequence->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Common::Sequence' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Common::Sequence->new($_) ];
  };

subtype 'Bio::SRAXml::Common::AttributeArrayRef' => as
  'ArrayRef[Bio::SRAXml::Common::Attribute]';

coerce 'Bio::SRAXml::Common::AttributeArrayRef' => from 'ArrayRef[HashRef]' => via {
    [ map { Bio::SRAXml::Common::Attribute->new($_) } @$_ ];
},
  from 'Bio::SRAXml::Common::Attribute' => via {
    [$_];
  },
  from 'HashRef' => via {
    [ Bio::SRAXml::Common::Attribute->new($_) ];
  },
  ;

# link coercion
sub _link_from_hashref {
    my ($hr) = @_;

    if ( exists $hr->{url} ) {
        return Bio::SRAXml::Common::UrlLink->new(%$_);
    }
    if ( exists $hr->{query} ) {
        return Bio::SRAXml::Common::EntrezLink->new(%$_);
    }
    return Bio::SRAXml::Common::XrefLink->new(%$_);
}

coerce 'Bio::SRAXml::Roles::AnalysisType' => from 'Str' => via {
    Bio::SRAXml::Analysis::SimpleAnalysisType->new( type => $_ );
};
coerce 'Bio::SRAXml::Roles::AnalysisType' => from 'HashRef' => via {
    my $at   = $_;
    my @keys = keys %$at;
    confess("AnalysisType coercion should have a single key")
      if ( scalar(@keys) != 1 );

    my $k = pop @keys;
    my $v = $at->{$k};

    if ( $k eq 'reference_alignment' ) {
        return Bio::SRAXml::Analysis::ReferenceAlignment->new(%$v);
    }
    elsif ( $k eq 'sequence_assembly' ) {
        return Bio::SRAXml::Analysis::SequenceAssembly->new(%$v);
    }
    elsif ( $k eq 'sequence_variation' ) {
        return Bio::SRAXml::Analysis::SequenceVariation->new(%$v);
    }
    else {
        confess(
"$k is not a known Bio::SRAXml::AnalysisType suitable for coercion from hash"
        );
    }
};

1;
