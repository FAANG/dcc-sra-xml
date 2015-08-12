package Bio::SRAXml::File;

use namespace::autoclean;
use Moose;

with 'Bio::SRAXml::Roles::ToXML';

use Moose::Util::TypeConstraints;

enum 'FileTypeEnum', [
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
]
;

has 'filename'             => ( is => 'rw', isa => 'Str' );
has 'filetype'             => ( is => 'rw', isa => 'FileTypeEnum' );
has 'checksum'             => ( is => 'rw', isa => 'Str' );
has 'unencrypted_checksum' => ( is => 'rw', isa => 'Undef|Str' );
has 'checksum_method' => ( is => 'rw', isa => 'Str', default => 'MD5' );
has 'checklist'       => ( is => 'rw', isa => 'Undef|Str' );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    my %attrs = (
        filename        => $self->filename(),
        filetype        => $self->filetype(),
        checksum        => $self->checksum(),
        checksum_method => $self->checksum_method(),
    );

    $attrs{unencrypted_checksum} = $self->unencrypted_checksum()
      if ( defined $self->unencrypted_checksum() );
    $attrs{checklist} = $self->checklist() if ( defined $self->checklist() );

    $xml_writer->emptyTag( 'FILE', %attrs );
}

__PACKAGE__->meta->make_immutable;
1;
