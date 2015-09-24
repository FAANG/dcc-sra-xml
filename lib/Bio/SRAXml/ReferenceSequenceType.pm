package Bio::SRAXml::ReferenceSequenceType;

use strict;
use Moose;
use namespace::autoclean;
use Bio::SRAXml::Types;
use Bio::SRAXml::ReferenceAssemblyType;
use Bio::SRAXml::Sequence;

with 'Bio::SRAXml::Roles::ToXML';

has 'assembly' => (
    is       => 'rw',
    isa      => 'Bio::SRAXml::ReferenceAssemblyType',
    required => 1,
    coerce   => 1
);

has 'sequences' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::SequenceArrayRef',
    default => sub { [] },
    coerce  => 1,
    handles => {
        add_sequence    => 'push',
        all_sequences   => 'elements',
        count_sequences => 'count',
    }
);

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("ASSEMBLY");
    $self->assembly->write_to_xml($xml_writer);
    $xml_writer->endTag("ASSEMBLY");

    for my $seq ( $self->all_sequences ) {
        $seq->write_to_xml($xml_writer);
    }

}

__PACKAGE__->meta->make_immutable;
1;

