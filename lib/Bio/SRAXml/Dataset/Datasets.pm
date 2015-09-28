
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
package Bio::SRAXml::Dataset::Datasets;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;
use Bio::SRAXml::Dataset::Dataset;

=head1 Description
  
  Container element for datasets elements
  
=cut

with 'Bio::SRAXml::Roles::ToXML','Bio::SRAXml::Roles::WriteableEntity';

has 'datasets' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'Bio::SRAXml::DatasetArrayRef',
    default => sub { [] },
    coerce  => 1,
    handles => {
        add_dataset   => 'push',
        all_datasets   => 'elements',
        count_datasets => 'count',
    }
);

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    $xml_writer->startTag("DATASETS");

    for ( $self->all_datasets ) {
        $_->write_to_xml($xml_writer);
    }

    $xml_writer->endTag("DATASETS");
}

__PACKAGE__->meta->make_immutable;
1;
