package Yoyotest::Model::ModelServices::Todos;

use strict;
use warnings;
use diagnostics;

use parent 'Yoyotest::Model::ModelService';
use parent 'Yoyotest::Model::ModelServices::OwnedByUserTrait';

use Yoyotest::Model::ModelServices::Notes;

# COMBOS:
# 
# Create a new todo: 
# 	new($repository)
# 	->set_input_data($input_data)
# 	->set_user($username) #NOTE_1
# 	->write_note
# 	->create_todo
# 	->get_output_data;
# 	
# NOTE_1: optional if $username is already in $input_data
# 
# Convert a note into todo: 
# 	new($repository)
# 	->set_input_data($input_data)
# 	->set_user($username) #NOTE_1
# 	->set_note($id_value)
# 	->create_todo
# 	->get_output_data;
# 	
# NOTE_1: optional if $username is already in $input_data
# 	
# Get specific notes
#	 new($repository)
#	  ->set_search_filter($search_filter)
#	  ->set_user($username) #NOTE_1
#	  ->get_notes
#	  ->get_output_data;
#
# NOTE_1: Not needed when accessing own notes
# 
# Update a note
# 	new($repository)
#	  ->set_input_data($input_data)
#	  ->set_user($username)
#	  ->edit_note($id_value)
#	  ->get_output_data;

my $entity_name = 'Todo';

my $valid_input_columns = [
	'users.username', 
	'notes.title', 
	'notes.content', 
	'todos.target_datetime'
];

sub set_note {
	my $self = shift;
	my $note_id = shift;

	#If there is no argument for note_id, 
	#get the one included in input_data
	$note_id =  $self->{input_data}->{note_id} unless $note_id; 
	
	#Set the error code should the note not exist
	$self->{note} = $self->{repository}->first('id', $note_id);
	$self->{error_code} = 404 unless $self->{note};
	
	return $self;
}

sub write_note {
	my $self = shift;
	$self->{repo}->change_entity('Todo');

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
	$self->{repo}->change_entity('Todo');
	my $note_and_user_exists = exists $self->{user} and exists $self->{note};

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
	$self->{repo}->change_entity('Todo');

	$self->{search_filter}->{ 'note.user_id' } = $self->{user}->id;

	my $attributes = {
		'select' => [
			'task', 
			'target_datetime', 
			'is_done',
			'created_at',
			'notes.title',
			'notes.content',
			'notes.created_at',
			'users.username',
		],
		'as' => [
			'task', 
			'due_time', 
			'is_done',
			'task_started',
			'note_title',
			'note_content',
			'creation_time',
			'username',
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