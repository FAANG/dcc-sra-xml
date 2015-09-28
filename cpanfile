requires "Moose",  ">= 2.1200";
requires "namespace::autoclean", ">= 0.26";
requires "MooseX::Types::DateTime", ">= 0.10";
requires "MooseX::Types::URI", ">=0.08";
requires "MooseX::Params::Validate", ">=0.18";
requires "XML::Writer", ">=0.625";
requires "XML::LibXML", ">=2.0122";

on 'test' => sub {
	requires "autodie", ">=2.29";
	requires "Test::More", ">=1.00";
	requires "Test::XML", ">=0.08";
	requires "Test::Exception", ">=0.40";
};
