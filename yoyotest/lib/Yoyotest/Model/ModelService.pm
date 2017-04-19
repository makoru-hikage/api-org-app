package Yoyotest::Model::ModelService;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {};
	my $repository = shift;
	
	$self->{repository} = $repository;
	$self->{errors} = undef;

	bless ($self, $class);
	return $self;
}

sub set_input_data{
	my $self = shift;
	my $input_data = shift;

	#Enforces the developer to set the proper columns
	return $self unless $self->valid_columns();

	#Filter out unnecessary key pairs
	$self->{input_data} = $input_data->{ $self->valid_columns() };

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

sub set_exception_message {
	my $self = shift;
	my $code = shift;
	my $message = shift;

	$self->{error}->{code} = $code;
	$self->{error}->{message} = $message;
	return $self;
}

sub get_output_data {
	my $self = shift;

	return $self->{output_data};
}

1;