package Bio::SRAXml::Roles::RefNameGroup;
use strict;
use Moose::Role;

has 'refname'   => ( is => 'rw', isa => 'Maybe[Str]' );
has 'ref_center'   => ( is => 'rw', isa => 'Maybe[Str]' );
has 'accession'   => ( is => 'rw', isa => 'Maybe[Str]' );

sub refname_group_as_hash {
  my ($self) = @_;
  
  my %h;
  
  if (defined $self->refname()){
    $h{refname} = $self->refname();
  }
  
  if (defined $self->ref_center()) {
    $h{ref_center} = $self->ref_center();
  }
  
  if (defined $self->accession()){
    $h{accession} = $self->accession();
  }
  
  return %h;
}

1;
