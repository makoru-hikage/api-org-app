package Yoyotest::Model::ModelService;

use strict;
use warnings;

use Yoyotest::Model::Repository;

sub get_entity_name {
	return undef;
}

sub get_valid_input_columns {
	return undef;
}

sub new {
	my $class = shift;
	my $self = {};
	my $schema = shift;
	
	bless ($self, $class);
	$self->{repository} = Yoyotest::Model::Repository->new($schema, $self->get_entity_name);

	return $self;
}

sub set_input_data{
	my $self = shift;
	my $input_data = shift;

	my $valid_input_columns = $self->get_valid_input_columns();

	#Enforces the developer to set the proper columns
	return $self unless $valid_input_columns;

	my @valid_input_columns = grep { exists $input_data->{$_} } @$valid_input_columns;
	my %filtered_input;
	@filtered_input{@valid_input_columns} = @$input_data{@valid_input_columns};

	#Filter out unnecessary key pairs
	$self->{input_data} = \%filtered_input;

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