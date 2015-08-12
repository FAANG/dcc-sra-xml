package Bio::SRAXml::QualifiedNameType;

use namespace::autoclean;
use Moose;

extends 'Bio::SRAXml::NameType';


has 'namespace' => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $xml_writer, $tag_name ) = @_;

    my %attrs;

    $attrs{namespace} = $self->namespace();

    if ( defined $self->label() ) {
        $attrs{label} = $self->label();
    }

    $xml_writer->dataElement( $tag_name, $self->name(), %attrs );
}

__PACKAGE__->meta->make_immutable;
1;
