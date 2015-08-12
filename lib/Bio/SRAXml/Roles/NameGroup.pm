package Bio::SRAXml::Roles::NameGroup;

use Moose::Role;

has 'alias'       => ( is => 'rw', isa => 'Maybe[Str]' );
has 'center_name' => ( is => 'rw', isa => 'Maybe[Str]' );
has 'broker_name' => ( is => 'rw', isa => 'Maybe[Str]' );
has 'accession'   => ( is => 'rw', isa => 'Maybe[Str]' );

sub name_group_as_hash {
  my ($self) = @_;
  
  my %h;
  
  if (defined $self->alias()){
    $h{alias} = $self->alias();
  }
  
  if (defined $self->center_name()) {
    $h{center_name} = $self->center_name();
  }
  
  if (defined $self->broker_name()){
    $h{broker_name} = $self->broker_name();
  }
  
  if (defined $self->accession()){
    $h{accession} = $self->accession();
  }
  
  return %h;
}

1;
