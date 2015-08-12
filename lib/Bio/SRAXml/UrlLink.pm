package Bio::SRAXml::UrlLink;

use namespace::autoclean;
use Moose;

with 'Bio::SRAXml::Roles::Link', 'Bio::SRAXml::Roles::ToXML';

has 'label' => ( is => 'rw', isa => 'Str' );
has 'url'   => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("URL_LINK");

    $xml_writer->dataElement( "LABEL", $self->label() );
    $xml_writer->dataElement( "URL",   $self->url() );

    $xml_writer->endTag("URL_LINK");
}

__PACKAGE__->meta->make_immutable;
1;
