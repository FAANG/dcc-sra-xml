package Bio::SRAXml::Roles;





1;

=head
#coercions for Analysis
coerce Bio::SRAXml::Analysis,
  from 'HashRef',
  via { Bio::SRAXml::Analysis->new( %{$_} ) };

coerce ArrayRefOfAnalysis, from 'ArrayRef[HashRef]', via {
    [ map { Bio::SRAXml::Analysis->new( %{$_} ) } @$_ ];
};

coerce ArrayRefOfAnalysis, from 'HashRef',
  via { [ Bio::SRAXml::Analysis->new( %{$_} ) ] };

coerce 'ArrayRefOfAnalysis', from 'Bio::SRAXml::Analysis' => via { [$_] };
=cut
