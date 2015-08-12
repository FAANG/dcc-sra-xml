package Bio::SRAXml::Roles::ToXML;
use strict;
use Moose::Role;
use Carp;
requires 'write_to_xml';

before 'write_to_xml' => sub {
    my ( $self, $xml_writer, ) = @_;

    if ( !$xml_writer || !$xml_writer->isa('XML::Writer') ) {
        confess("first argument to write_to_xml should be an XML::Writer object");
    }
};

1;
