package Yoyotest::Model::Repository;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {};
	my $schema_connection = shift;
	my $entity_name = shift;
	
	$self->{entity} = $schema_connection->resultset($entity_name);

	bless ($self, $class);
	return $self;
}

sub first {
	my $self = shift;
	my $unique_column = shift;
	my $value = shift;
	my $columns = shift;

	my $entity = $self
		->{entity}
		->search ({ $unique_column => $value })
		->first;

}

sub get {
	my $self = shift;
	my $search_filters = shift;
	my $attributes = shift;

	return $self
		->{entity}
		->search($search_filters, $attributes);
}

sub create {
	my $self = shift;
	my $input_data = shift;

	my $entity = $self
		->{entity}
		->create($input_data)
		->first;

	return $input_data;
}

sub update {
	my $self = shift;
	my $unique_column = shift;
	my $value = shift;
	my $input_data = shift;

	#Return nothing if such row does not exist 
	$self->first($unique_column, $value)
	->update($input_data) or return undef;

	#Prepare something for the response body
	#The updated fields and the values are included
	#The identifying column is also included 
	$input_data->{ $unique_column } = $value;
	return $input_data;

}

sub delete {
	my $self = shift;
	my $unique_column = shift;
	my $value = shift;

	my $entity = $self->update(  
		$unique_column, 
		$value, 
		{ is_deleted => 1 }
	);

	return $entity ? 'It is now deleted.' : 'It does not exist';
}

1;