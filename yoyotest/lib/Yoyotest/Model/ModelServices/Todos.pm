package Yoyotest::Model::ModelServices::Todos;

use strict;
use warnings;
use diagnostics;

use parent 'Yoyotest::Model::ModelService';
use parent 'Yoyotest::Model::ModelServices::OwnedByUserTrait';

use Yoyotest::Model::ModelServices::Notes;

sub get_valid_columns {
	return ('username', 'title', 'content', 'target_datetime');
}

sub set_note {
	my $self = shift;
	my $username = shift;

	#If there is no argument for username, 
	#get the one included in input_data
	$note_id =  $self->{input_data}->{note_id} unless $note_id; 
	
	#Set the error code should the user not exist
	$self->{note} = $self->{repository}->first('note_id', $note_id);
	$self->{error_code} = 404 unless $self->{note};
	
	return $self;
}

sub create_note {
	my $self = shift;

	if ($self->{user}) {
		my $note_maker = Yoyotest::Model::ModelServices::Notes->new( $self->{repository} );

		$self->{note} = $note_maker
			->set_input_data($self->{input_data})
			->set_user($self->{user}->username)
			->write_note
			->get_output_data;
	}

	return $self;
}

sub create_todo {
	my $self = shift;
	my $note_and_user_exists = $self->{user} or $self->{note};

	unless ( $self->{error_code} or not $note_and_user_exists ) {
		$self->{input_data}->{user_id} = $self->{user}->{id};
		$self->{input_data}->{note_id} = $self->{note}->{id};

		$self->{output_data} = $self
			->{repository}
			->create('Todo', $self->{input_data});
	}

	$self->{output_data} = $self->{error_code};
	return $self;
}

sub get_todos {
	my $self = shift;

	$self->{search_filter}->{ 'note.user_id' } = $self->{user}->{id};

	my $attributes = {
		'select' => [
			'todos.task', 
			{ 'due_date' => 'TIME(todos.target_datetime)' }, 
			'todos.is_done',
			'todos.created_at'
		],
		'+select' => [
			'notes.title',
			'notes.content',
			'notes.title',
			'notes.created_at',
			'users.username',
		],
		'order_by' => { -desc => 'note.created_at' },
		'join' => { 'notes' => 'users' }
	};

	my $todos = $self->{repository}->get('Todo', $self->{search_filter}, $attributes);

	$self->{error_code} = 404 unless $todos;

	$self->{output_data} = $todos;
	return $self;
}

1;