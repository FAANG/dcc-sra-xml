package Bio::SRAXml::File;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::ToXML';

has 'filename'             => ( is => 'rw', isa => 'Str' );
has 'filetype'             => ( is => 'rw', isa => 'FileTypeEnum' );
has 'checksum'             => ( is => 'rw', isa => 'Str' );
has 'unencrypted_checksum' => ( is => 'rw', isa => 'Str' );
has 'checksum_method' => ( is => 'rw', isa => 'Str', default => 'MD5' );
has 'checklist'       => ( is => 'rw', isa => 'Str' );

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
