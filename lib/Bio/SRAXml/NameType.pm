package Bio::SRAXml::NameType;

use namespace::autoclean;
use Moose;

with 'Bio::SRAXml::Roles::ToXMLwithTagName';

has 'label' => ( is => 'rw', isa => 'Maybe[Str]' );
has 'name'  => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $xml_writer, $tag_name ) = @_;

    my %attrs;

    if ( defined $self->label() ) {
        $attrs{label} = $self->label();
    }

    $xml_writer->dataElement( $tag_name, $self->name(), %attrs );
}

__PACKAGE__->meta->make_immutable;
1;
