package Bio::SRAXml::Roles::ToXMLwithTagName;
use strict;
use Moose::Role;
use Carp;
use MooseX::Params::Validate;

requires 'write_to_xml';

before 'write_to_xml' => sub {
    my ($self) = shift;
    my ( $xml_writer, $tag_name ) =
      pos_validated_list( \@_, { isa => 'XML::Writer' }, { isa => 'Str' } );
};

1;
