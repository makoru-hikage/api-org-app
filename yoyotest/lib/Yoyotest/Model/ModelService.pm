package Yoyotest::Model::ModelService;

use strict;
use warnings;

use Yoyotest::Model::Repository;


sub get_input_columns {
	return undef;
}

sub get_entity_name {
	return undef;
}

sub new {
	my $class = shift;
	my $self = {};
	my $schema = shift;
	
	bless ($self, $class);
	$self->{repository} = Yoyotest::Model::Repository->new($schema, $self->get_entity_name);
	$self->{error_code} = 0;

	return $self;
}

sub set_input_data{
	my $self = shift;
	my $input_data = shift;

	#Enforces the developer to set the proper columns
	return $self unless $self->valid_columns();

	#Filter out unnecessary key pairs
	$self->{input_data} = $input_data->{ $self->get_input_columns() };

	return $self;
}

sub set_search_filter {
	my $self = shift;
	my $search_filter = shift;

	$self->{search_filter} = $search_filter;
	return $self;
}

sub get_search_filter {
	my $self = shift;
	return $self->{search_filter};
}

sub get_output_data {
	my $self = shift;

	$self->{output_data} = $self->{error_code} if $self->{error_code};
	return $self->{output_data};
}

1;