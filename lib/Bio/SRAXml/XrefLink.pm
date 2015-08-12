package Bio::SRAXml::XrefLink;

use namespace::autoclean;
use Moose;

with 'Bio::SRAXml::Roles::Link';

has 'db'    => ( is => 'rw', isa => 'Str' );
has 'id'    => ( is => 'rw', isa => 'Int' );
has 'label' => ( is => 'rw', isa => 'Maybe[Str]' );

sub write_to_xml {
    my ( $self, $write_to_xml ) = @_;

    $write_to_xml->startTag("XREF_LINK");

    $write_to_xml->dataElement( "DB",    $self->db() );
    $write_to_xml->dataElement( "ID",    $self->id() );
    $write_to_xml->dataElement( "LABEL", $self->label() )
      if ( defined $self->label() );

    $write_to_xml->endTag("XREF_LINK");

}

__PACKAGE__->meta->make_immutable;
1;
