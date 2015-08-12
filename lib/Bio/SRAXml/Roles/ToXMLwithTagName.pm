package Bio::SRAXml::Roles::ToXMLwithTagName;

use Moose::Role;
use Carp;
requires 'write_to_xml';

before 'write_to_xml' => sub {
    my ( $self, $xml_writer, $tag_name ) = @_;

    if ( !$xml_writer || !$xml_writer->isa('XML::Writer') ) {
        confess("first argument to write_to_xml should be an XML::Writer object");
    }
    
    if (! defined $tag_name) {
      confess("second argument to write_to_xml should be a tag name ")
    }
};

1;
