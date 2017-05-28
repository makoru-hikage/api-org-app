package Yoyotest::Model::ModelServices::Todos;

use strict;
use warnings;
use diagnostics;

use parent 'Yoyotest::Model::ModelService';
use parent 'Yoyotest::Model::ModelServices::OwnedByUserTrait';
use Dancer2;

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


sub get_valid_input_columns {
	return [
		'title', 
		'content',
		'task',
		'target_datetime'
	];
}

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

	$self->{repository} = $self->{repository}->change_entity('Note');
	$self->{input_data}->{user_id} = $self->{user}->id;

	my $input_data = { 
		user_id => $self->{input_data}->{user_id}, 
		title => $self->{input_data}->{title}, 
		content => $self->{input_data}->{content}
	};

	$self->{note} = $self
		->{repository}
		->create($input_data);

	return $self;
}

sub create_todo {
	my $self = shift;

	$self->{repository} = $self->{repository}->change_entity('Todo');
	my $note_exists = exists $self->{note};

	my $input_data = {  
		task => $self->{input_data}->{task}, 
		target_datetime => $self->{input_data}->{target_datetime}
	};

	if ( $note_exists ) {
		$input_data->{note_id} = $self->{note}->id;

		my %output_data = $self
			->{repository}
			->create($input_data)->get_columns;

		$self->{output_data} = \%output_data;
	
	}

	return $self;
}

sub get_todos {
	my $self = shift;
	$self->{repository}->change_entity('Todo');

	my $attributes = {
		'select' => [
			'note_id',
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
			'note_id',
			'task', 
			'target_datetime', 
			'is_done',
			'task_started',
			'note_title',
			'note_text',
			'creation_time',
			'username',
		],
		'order_by' => { -desc => 'me.created_at' },
		'join' => { 'note' => 'user' }
	};

	#Who owns the todos?
	$self->{search_filter}->{'note.user_id'} = $self->{user}->id;

	#We do not want deleted rows
	$self->{search_filter}->{'me.is_deleted'} = 0;
	$self->{search_filter}->{'note.is_deleted'} = 0;

	my $todos = $self->{repository}->get($self->{search_filter}, $attributes);

	$self->{output_data} = $todos;
	return $self;
}

sub edit_todo {
	my $self = shift;
	my $id_value = shift;

	$self->{repository} = $self->{repository}->change_entity('Todo');

	my $todo_data = {  
		task => $self->{input_data}->{task}, 
		target_datetime => $self->{input_data}->{target_datetime},
		is_done => $self->{input_data}->{is_done}
	};

	my $note_data = {  
		title => $self->{input_data}->{title}, 
		content => $self->{input_data}->{content}
	};

	foreach my $item (keys %$todo_data) {
		delete $todo_data->{$item} unless (defined $todo_data->{$item});
	}

	foreach my $item (keys %$note_data) {
		delete $note_data->{$item} unless (defined $note_data->{$item});
	}



	my $todo = $self
		->{repository}
		->update('note_id', $id_value, $todo_data)
		->note
		->update($note_data);

		$self->{output_data} = $self->{input_data};

	return $self;
}

sub delete_todo {
	my $self = shift;
	my $unique_column = shift;
	my $id_value = shift;

	$self->{output_data} = $self->{repository}
		->soft_delete($unique_column, $id_value);

	return $self;
}

sub convert_todo_to_note {
	my $self = shift;
	my $id_value = shift;

	$self->{repository} = $self->{repository}->change_entity('Todo');

	my $todo = $self->{repository}->soft_delete('note_id', $id_value);

	$self->{output_data} = $todo ? "Successfully converted" : 0;

	return $self;
}

sub toggle_done {
	my $self = shift;
	my $id_value = shift;
	my $is_done = shift;

	$self->{repository} = $self->{repository}->change_entity('Todo');

	my $todo = $self->{repository}->update('note_id', $id_value, { is_done => $is_done});

	$self->{output_data} = $todo ? "Successfully converted" : 0;

	return $self;
}

1;