package Bio::SRAXml::Roles::AnalysisType;

use Moose::Role;

with 'Bio::SRAXml::Roles::ToXML';

before 'write_to_xml' => sub {
  my ($self,$xml_writer) = @_;
  
  $xml_writer->startTag('ANALYSIS_TYPE');  
};
after 'write_to_xml' => sub {
  my ($self,$xml_writer) = @_;
  
  $xml_writer->endTag('ANALYSIS_TYPE');  
};
1;