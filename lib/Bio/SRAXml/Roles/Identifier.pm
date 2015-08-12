package Bio::SRAXml::Roles::Identifier;

use Moose::Role;

has 'primary_id' => ( is => 'rw', isa => 'Maybe[Bio::SRAXml::NameType]' );

has 'secondary_id' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef[Bio::SRAXml::NameType]',
    default => sub { [] },
    handles =>
      { has_secondary_ids => 'count', all_secondary_ids => 'elements', }
);

has 'external_id' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef[Bio::SRAXml::QualifiedNameType]',
    default => sub { [] },
    handles => { has_external_ids => 'count', all_external_ids => 'elements' }
);
has 'submitter_id' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef[Bio::SRAXml::QualifiedNameType]',
    default => sub { [] },
    handles => { has_submitter_ids => 'count', all_submitter_ids => 'elements' }
);
has 'uuid' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef[Bio::SRAXml::NameType]',
    default => sub { [] },
    handles => {
        has_uuids => 'count',
        all_uuids => 'elements'
    }
);

sub write_identifiers_xml {
    my ( $self, $xml_writer ) = @_;

    if (   $self->primary_id()
        || $self->has_secondary_ids()
        || $self->has_external_ids()
        || $self->has_submitter_ids()
        || $self->has_uuids() )
    {
        $xml_writer->startTag('IDENTIFIERS');

        if ( $self->primary_id() ) {
            $xml_writer->dataElement( 'PRIMARY_ID', $self->primary_id() );
        }
        for ( $self->all_secondary_ids() ) {
            $_->write_to_xml('SECONDARY_ID');
        }
        for ( $self->all_external_ids() ) {
            $_->write_to_xml('EXTERNAL_ID');
        }
        for ( $self->all_submitter_ids() ) {
            $_->write_to_xml('SUBMITTER_ID');
        }
        for ( $self->all_uuids() ) {
            $_->write_to_xml('UUID');
        }
        $xml_writer->endTag('IDENTIFIERS');
    }
}

1;
