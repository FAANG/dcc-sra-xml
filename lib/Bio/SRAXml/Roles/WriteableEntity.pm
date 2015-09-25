
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
package Bio::SRAXml::Roles::WriteableEntity;
use strict;
use Moose::Role;

with 'Bio::SRAXml::Roles::ToXML';

=head1 Description
  
  Role to tag classes as being suitable RootType objects to write a complete
  document. These are listed in the root schema file
  (http://ftp.sra.ebi.ac.uk/meta/xsd/sra_1_5/ENA.root.xsd)
  
=cut

1;