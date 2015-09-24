package Bio::SRAXml::EntityRef;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

with 'Bio::SRAXml::Roles::Identifier', 'Bio::SRAXml::Roles::RefNameGroup',
  'Bio::SRAXml::Roles::ToXMLwithTagName';

sub write_to_xml {
    my ( $self, $xml_writer, $tag_name ) = @_;

    my %attr_hash = $self->refname_group_as_hash();

    $xml_writer->startTag( $tag_name, %attr_hash );
    $self->write_identifiers_xml($xml_writer);
    $xml_writer->endTag($tag_name);

}

__PACKAGE__->meta->make_immutable;
1;
