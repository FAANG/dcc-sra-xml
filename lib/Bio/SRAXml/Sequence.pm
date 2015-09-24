package Bio::SRAXml::Sequence;

use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::ToXML';

has [ 'refname', 'label' ] => ( is => 'rw', isa => 'Undef|Str' );
has 'accession' => ( is => 'rw', isa => 'Str', required => 1 );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    my %attr = ( accession => $self->accession );

    $attr{refname} = $self->refname if ( $self->refname );
    $attr{label}   = $self->label   if ( $self->label );

    $xml_writer->emptyTag( "SEQUENCE", %attr );
}

__PACKAGE__->meta->make_immutable;
1;
