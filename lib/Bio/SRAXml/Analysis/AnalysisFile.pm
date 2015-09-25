
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

package Bio::SRAXml::Analysis::AnalysisFile;
use strict;
use namespace::autoclean;
use Moose;
use Bio::SRAXml::Types;

=head1 Description
  
  Class for files in a submission.
  
=cut

with 'Bio::SRAXml::Roles::ToXML';

has 'filename' => ( is => 'rw', isa => 'Str',          required => 1 );
has 'filetype' => ( is => 'rw', isa => 'FileTypeEnum', required => 1 );
has 'checksum' => ( is => 'rw', isa => 'Str',          required => 1 );
has 'unencrypted_checksum' => ( is => 'rw', isa => 'Str' );
has 'checksum_method' =>
  ( is => 'rw', isa => 'Str', default => 'MD5', required => 1 );
has 'checklist' => ( is => 'rw', isa => 'Str' );

sub write_to_xml {
    my ( $self, $xml_writer ) = @_;

    my @attrs = (
        filename        => $self->filename(),
        filetype        => $self->filetype(),
        checksum_method => $self->checksum_method(),
        checksum        => $self->checksum(),
    );

    push @attrs, ( unencrypted_checksum => $self->unencrypted_checksum() )
      if ( defined $self->unencrypted_checksum() );

    push @attrs, ( checklist => $self->checklist() )
      if ( defined $self->checklist() );

    $xml_writer->emptyTag( 'FILE', @attrs );
}

__PACKAGE__->meta->make_immutable;
1;
