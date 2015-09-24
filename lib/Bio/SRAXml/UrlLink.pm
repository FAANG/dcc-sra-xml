package Bio::SRAXml::UrlLink;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;
use MooseX::Types::URI qw(Uri);
with 'Bio::SRAXml::Roles::Link', 'Bio::SRAXml::Roles::ToXML';

has 'label' => ( is => 'rw', isa => 'Str' );
has 'url' => ( is => 'rw', isa => Uri, coerce => 1 );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("URL_LINK");

    $xml_writer->dataElement( "LABEL", $self->label() );
    $xml_writer->dataElement( "URL",   $self->url()->as_string )
      if ( $self->url() );

    $xml_writer->endTag("URL_LINK");
}

__PACKAGE__->meta->make_immutable;
1;
