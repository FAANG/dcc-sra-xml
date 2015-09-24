package Bio::SRAXml::ReferenceAssemblyType;

use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;
use Bio::SRAXml::UrlLink;

with 'Bio::SRAXml::Roles::ToXML';

has 'refname'   => ( is => 'rw', isa => 'Str' );
has 'accession' => ( is => 'rw', isa => 'Str' );

has 'description' => ( is => 'rw', isa => 'Str' );
has 'url_link' => ( is => 'rw', isa => 'Bio::SRAXml::UrlLink', coerce => 1 );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    if ( $self->accession ) {
        my %attr = ( accession => $self->accession );
        $attr{refname} = $self->refname if ( $self->refname );
        $xml_writer->emptyTag( "STANDARD", %attr );
    }
    elsif ( $self->url_link ) {
        $xml_writer->startTag("CUSTOM");
        $xml_writer->dataTag( "DESCRIPTION", $self->description )
          if ( $self->description );
        $xml_writer->url_link->write_to_xml($xml_writer);
        $xml_writer->endTag("CUSTOM");
    }

}

__PACKAGE__->meta->make_immutable;
1;
