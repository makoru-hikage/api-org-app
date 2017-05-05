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
# 	new($schema)
# 	->set_input_data($input_data)
# 	->set_note($id_value)
# 	->create_todo
# 	->get_output_data;
# 	
# Get specific notes
#	 new($schema)
#	  ->set_search_filter($search_filter)
#	  ->set_user($username) #NOTE_1
#	  ->get_todos
#	  ->get_output_data;
#
# NOTE_1: Not needed when accessing own todos
# 
# Update a todo
# 	new($schema)
# 	  ->set_search_filter($search_filter)
#	  ->set_input_data($input_data)
#	  ->edit_note($id_value)
#	  ->get_output_data;
#	  
# Convert todo into a note 
# 	new($schema)
#	  ->set_search_filter($search_filter)
#	  ->convert_into_note()
#	  ->get_output_data;  


my $valid_input_columns = [
	'users.username', 
	'notes.title', 
	'notes.content', 
	'todos.target_datetime'
];

sub get_entity_name {
	return 'Todo';
}

sub set_note {
	my $self = shift;
	my $note_id = shift;

	#If there is no argument for note_id, 
	#get the one included in input_data
	$note_id =  $self->{input_data}->{note_id} unless $note_id; 
	
	#Set the error code should the note not exist
	$self->{note} = $self->{repository}->first('id', $note_id);
	
	return $self;
}

sub write_note {
	my $self = shift;
	$self->{repository}->change_entity('Note');

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
	$self->{repository}->change_entity('Todo');
	my $note_and_user_exists = exists $self->{user} and exists $self->{note};

	if ( $note_and_user_exists ) {
		$self->{input_data}->{user_id} = $self->{user}->{id};
		$self->{input_data}->{note_id} = $self->{note}->{id};

		$self->{output_data} = $self
			->{repository}
			->create('Todo', $self->{input_data});
	}

	return $self;
}

sub get_todos {
	my $self = shift;
	$self->{repository}->change_entity('Todo');

	my $attributes = {
		'select' => [
			'id',
			'task', 
			'target_datetime', 
			'is_done',
			'created_at',
			'note.title',
			'note.content',
			'note.created_at',
			'user.username',
		],
		'as' => [
			'id',
			'task', 
			'due_time', 
			'is_done',
			'task_started',
			'note_title',
			'note_content',
			'creation_time',
			'username',
		],
		'order_by' => { -desc => 'me.created_at' },
		'join' => { 'note' => 'user' }
	};

	$self->{search_filter}->{'note.user_id'} = $self->{user}->id;

	my $todos = $self->{repository}->get($self->{search_filter}, $attributes);

	$self->{output_data} = $todos;
	return $self;
}

sub convert_into_note {

}

1;