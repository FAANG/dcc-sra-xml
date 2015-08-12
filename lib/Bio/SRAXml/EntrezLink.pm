package Bio::SRAXml::EntrezLink;

use namespace::autoclean;
use Moose;

with 'Bio::SRAXml::Roles::Link', 'Bio::SRAXml::Roles::ToXML';

has 'db'    => ( is => 'rw', isa => 'Str' );
has 'id'    => ( is => 'rw', isa => 'Int' );
has 'query' => ( is => 'rw', isa => 'Str' );
has 'label' => ( is => 'rw', isa => 'Maybe[Str]' );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("ENTREZ_LINK");

    $xml_writer->dataElement( "DB",    $self->db() );
    $xml_writer->dataElement( "ID",    $self->id() );
    $xml_writer->dataElement( "QUERY", $self->query() );
    $xml_writer->dataElement( "LABEL", $self->label() ) if ( $self->label() );

    $xml_writer->endTag("ENTREZ_LINK");

}

__PACKAGE__->meta->make_immutable;
1;
