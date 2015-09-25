
=head1 LICENSE
   Copyright 2015 EMBL - European Bioinformatics Institute
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
     http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
=cut
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

