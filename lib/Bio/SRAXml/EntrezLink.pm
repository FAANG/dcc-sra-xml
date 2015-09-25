package Bio::SRAXml::EntrezLink;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::Link', 'Bio::SRAXml::Roles::ToXML';

has 'db' => ( is => 'rw', isa => 'Str', required => 1 );
has 'id'    => ( is => 'rw', isa => 'Int' );    #TODO change to positive int
has 'query' => ( is => 'rw', isa => 'Str' );    #TODO ID or query
has 'label' => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("ENTREZ_LINK");

    $xml_writer->dataElement( "DB", $self->db() );
    if ( $self->id ) {
        $xml_writer->dataElement( "ID", $self->id() );
    }
    elsif ( $self->query ) {
        $xml_writer->dataElement( "QUERY", $self->query() );
    }

    $xml_writer->dataElement( "LABEL", $self->label() ) if ( $self->label() );

    $xml_writer->endTag("ENTREZ_LINK");

}

__PACKAGE__->meta->make_immutable;
1;
