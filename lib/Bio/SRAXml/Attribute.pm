package Bio::SRAXml::Attribute;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::ToXMLwithTagName';

has 'tag'   => ( is => 'rw', isa => 'Str' );
has 'value' => ( is => 'rw', isa => 'Str' );
has 'units' => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $xml_writer, $tag_name ) = @_;

    $xml_writer->startTag($tag_name);

    $xml_writer->dataElement( 'TAG',   $self->tag() );
    $xml_writer->dataElement( 'VALUE', $self->value() )
      if ( defined $self->value() );
    $xml_writer->dataElement( 'UNITS', $self->units() )
      if ( defined $self->units() );

    $xml_writer->endTag($tag_name);

}

__PACKAGE__->meta->make_immutable;
1;
