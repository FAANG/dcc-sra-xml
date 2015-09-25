package TestHelper;

use strict;
use warnings;
use autodie;
use Carp;
use MooseX::Params::Validate;

sub file_to_str {
  my ($fh,$fn)   = validated_list(
      \@_,
      fh       => { isa => 'FileHandle', optional => 1 },
      filename => { isa => 'Str',        optional => 1 }
  );

  if (($fh && $fn) || (!$fh && !$fn)){
    croak "Specify fh or filename";
  }

  if ($fn){
    open($fh,'<',$fn);
  }

  local $/ = undef;
  my $a = <$fh>;
  
  if ($fn){
    close($fh);
  }

  return $a;
}

1;
