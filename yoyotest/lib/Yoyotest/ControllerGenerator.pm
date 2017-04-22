package Yoyotest::ControllerGenerator;

use warnings;
use strict;

use Dancer2;
use Yoyotest::Model::Repository;


sub new {
	my $class = shift;
	my $self = {};
	my $schema_connection = shift;
	my $entity_name = shift;
	my $model_service_name = shift;
	
	$self->{schema} = $schema_connection;
	$self->{entity_name} = $entity_name;
	$self->{model_service_name} = $model_service_name;

	$self->initiate_repository if $self->{schema} and $self->{entity_name};
	$self->initiate_model_service if $model_service_name and $self->{repo};

	bless ($self, $class);
	return $self;
}

sub initiate_repository {
	my $self = shift;
	my $repo = Yoyotest::Model::Repository->new($self->{schema}, $self->{entity_name});
	$self->{repo} = $repo;

	return $self;
}

sub initiate_model_service {
	my $self = shift;

	my $repo = $self->{repo};

	my $model_service = $self->{model_service_name}->new($repo);
	$self->{model_service} = $model_service;

	return $self;
}

sub repository_create {
	my $self = shift;
	my $creation_method = shift; #this is an anonymous sub
	my $repo = $self->{repo};

	return sub {
		my $input_data = from_json(request->body)->{input_data};

		$create_success = $self->{repository}->create($input_data);
		send_error ("Unsuccessful", 422) unless $create_success; 
		send_as JSON => $create_success, 
			{ content_type => 'application/json; charset=UTF-8' };
	};
}

sub repository_update {
	my $self = shift;
	my $unique_column = shift;
	my $repo = $self->{repo};

	return sub {
		my $value = param 'id';
		my $input_data = from_json(request->body)->{input_data};

		$update_success = $repo->update($unique_column, $value, $input_data);
		send_error ("Not found", 404) unless $update_success; 
		send_as JSON => $update_success, 
			{ content_type => 'application/json; charset=UTF-8' };
	};
}

sub repository_get {
	my $self = shift;
	my $attributes = shift;

	return sub {
		my $search_filters= from_json(request->body)->{search_filter};
		
		$data = $repo->get($search_filters, $attributes);
		send_error ("Not found", 404) unless $data; 
		send_as JSON => $data, { content_type => 'application/json; charset=UTF-8' };
	};
}

sub repository_delete {
	my $self = shift;
	my $unique_column = shift;	 
	my $repo = $self->{repo};

	return sub {
		my $value = param 'id'; 

		$entity = $repo->delete($unique_column, $value);
		send_error ("It does not exist", 404) unless $entity;
		send_as JSON => $entity, 
			{ content_type => 'application/json; charset=UTF-8' };
	};
}

sub repository_first {
	my $self = shift;
	my $unique_column = shift;	  
	my $repo = $self->{repo};

	return sub {
		my $value = param 'id';

		$entity = $repo->first($unique_column, $value);
		send_error ("It does not exist", 404) unless $entity;
		send_as JSON => $entity, 
			{ content_type => 'application/json; charset=UTF-8' };
	};
}


