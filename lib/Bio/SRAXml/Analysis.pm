package Bio::SRAXml::Analysis;
use strict;
use namespace::autoclean;
use Moose;

use MooseX::Types::DateTime qw( DateTime );
use Bio::SRAXml::EntityRef;
use Bio::SRAXml::File;
use Bio::SRAXml::UrlLink;
use Bio::SRAXml::EntrezLink;
use Bio::SRAXml::XrefLink;
use Bio::SRAXml::Attribute;
use Bio::SRAXml::AnalysisType::ReferenceAlignment;
use Bio::SRAXml::AnalysisType::SequenceAssembly;
use Bio::SRAXml::AnalysisType::SequenceVariation;
use Bio::SRAXml::AnalysisType::SimpleAnalysisType;

use Bio::SRAXml::Types ':all';

with 'Bio::SRAXml::Roles::Identifier', 'Bio::SRAXml::Roles::NameGroup',
  'Bio::SRAXml::Roles::ToXML';

has 'title'           => ( is => 'rw', isa => 'Str' );
has 'description'     => ( is => 'rw', isa => 'Str' );
has 'analysis_center' => ( is => 'rw', isa => 'Str' );
has 'analysis_date'   => ( is => 'rw', isa => 'DateTime', coerce => 1 );
has 'analysis_type'   => ( is => 'rw', isa => 'Bio::SRAXml::Roles::AnalysisType', required => 1, coerce => 1);

has 'study_refs' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::EntityRefArrayRef',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_study_ref    => 'push',
        all_study_refs   => 'elements',
        count_study_refs => 'count',
    }
);
has 'sample_refs' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::EntityRefArrayRef',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_sample_ref    => 'push',
        all_sample_refs   => 'elements',
        count_sample_refs => 'count',
    }
);
has 'experiment_refs' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::EntityRefArrayRef',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_experiment_ref    => 'push',
        all_experiment_refs   => 'elements',
        count_experiment_refs => 'count',
    }
);
has 'run_refs' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::EntityRefArrayRef',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_run_ref    => 'push',
        all_run_refs   => 'elements',
        count_run_refs => 'count',
    }
);
has 'analysis_ref' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::EntityRefArrayRef',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_analysis_ref    => 'push',
        all_analysis_refs   => 'elements',
        count_analysis_refs => 'count',
    }
);
has 'links' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::Roles::LinkArrayRef',
    default => sub { [] },
    handles => {
        add_link    => 'push',
        all_links   => 'elements',
        count_links => 'count',
        has_links   => 'count',
    },
    coerce => 1,
);
has 'attributes' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::AttributeArrayRef',
    default => sub { [] },
    handles => {
        add_attribute    => 'push',
        all_attributes   => 'elements',
        count_attributes => 'count',
        has_attributes   => 'count',
    },
    coerce => 1,
);
has 'files' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::FileArrayRef',
    default => sub { [] },
    coerce  => 1,
    handles => {
        add_file    => 'push',
        all_files   => 'elements',
        count_files => 'count',
        has_files   => 'count',
    }
);

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    my %analysis_attrs = $self->name_group_as_hash();

    if ( defined $self->analysis_center() ) {
        $analysis_attrs{analysis_center} = $self->analysis_center();
    }
    if ( defined $self->analysis_date() ) {
        my $date_time     = $self->analysis_date();
        my $cldr_format   = 'YYYY-MM-dd\'T\'HH:mm:ss.S\'Z\'';
        my $date_time_str = $date_time->format_cldr($cldr_format);
        $analysis_attrs{analysis_date} = $date_time_str;
    }

    $xml_writer->startTag( "ANALYSIS", %analysis_attrs );

    $self->write_identifiers_xml();
    $xml_writer->dataElement( 'TITLE', $self->title() );

    if ( $self->description() ) {
        $xml_writer->dataElement( 'DESCRIPTION', $self->description() );
    }

    for ( $self->all_study_refs() ) {
        $_->write_to_xml( $xml_writer, 'STUDY_REF' );
    }
    for ( $self->all_sample_refs() ) {
        $_->write_to_xml( $xml_writer, 'SAMPLE_REF' );
    }
    for ( $self->all_experiment_refs() ) {
        $_->write_to_xml( $xml_writer, 'EXPERIMENT_REF' );
    }
    for ( $self->all_run_refs() ) {
        $_->write_to_xml( $xml_writer, 'RUN_REF' );
    }
    for ( $self->all_analysis_refs() ) {
        $_->write_to_xml( $xml_writer, 'ANALYSIS_REF' );
    }

    if ( $self->count_links() ) {
        $xml_writer->startTag("ANALYSIS_LINKS");
        for ( $self->all_links ) {
            $_->write_to_xml($xml_writer);
        }
        $xml_writer->endTag("ANALYSIS_LINKS");
    }

    if ( $self->has_attributes() ) {
        $xml_writer->startTag("ANALYSIS_ATTRIBUTES");
        for ( $self->all_attributes ) {
            $_->write_to_xml( $xml_writer, 'ANALYSIS_ATTRIBUTE' );
        }
        $xml_writer->endTag("ANALYSIS_ATTRIBUTES");
    }

    $self->analysis_type()->write_to_xml($xml_writer);

    if ( $self->has_files() ) {
        $xml_writer->startTag("FILES");
        for ( $self->all_files ) {
            $_->write_to_xml($xml_writer);
        }
        $xml_writer->endTag("FILES");
    }

    $xml_writer->endTag("ANALYSIS");
}

__PACKAGE__->meta->make_immutable;
1;
