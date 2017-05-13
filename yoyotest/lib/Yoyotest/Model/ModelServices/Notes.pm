package Yoyotest::Model::ModelServices::Notes;

use strict;
use warnings;

use parent 'Yoyotest::Model::ModelService';
use parent 'Yoyotest::Model::ModelServices::OwnedByUserTrait';

# COMBOS:
# 
# Create a new note: 
# 	new($schema)
# 	->set_input_data($input_data)
# 	->set_user($username) #NOTE_1
# 	->write_note
# 	->get_output_data;
# 	
# NOTE_1: optional if $username is already in $input_data
# 	
# Get specific notes
#	 new($schema)
#	  ->set_search_filter($search_filter)
#	  ->set_user($username) #NOTE_1
#	  ->get_notes
#	  ->get_output_data;
#
# NOTE_1: Not needed when accessing own notes
# 
# Update a note
# 	new($schema)
#	  ->set_input_data($input_data)
#	  ->set_user($username)
#	  ->edit_note($id_value)
#	  ->get_output_data;
#	  

sub get_entity_name {
	return 'Note';
}

sub get_valid_input_columns {
	return [
		'title', 
		'content',
	];
}

sub write_note {
	my $self = shift;
	$self->{repository} = $self->{repository}->change_entity('Note');

	$self->{input_data}->{user_id} = $self->{user}->id;

	$self->{output_data} = $self
		->{repository}
		->create($self->{input_data});

	return $self;
}

sub edit_note {
	my $self = shift;
	my $id_value = shift;
	$self->{repository} = $self->{repository}->change_entity('Note');

	$self->{output_data} = $self
		->{repository}
		->update('id', $id_value, $self->{input_data});

	return $self;
}

sub get_notes(){
	my $self = shift;
	$self->{repository}->change_entity('Note');

	my $select_columns = [
		'id',
		'title',
		'content',
		'created_at',
		'user.username',
		'user.first_name',
		'user.last_name',
	];

	my $attributes = {
		select => $select_columns,
		as => [
			'id',
			'note_title',
			'note_text',
			'creation_time',
			'owner',
			'first_name',
			'last_name',
		],
		join => ['user', 'todo'],
		'order_by' => { -desc => 'created_at' },
	};

	#Assure that only non-deleted items are fetched
	$self->{search_filter}->{'me.is_deleted'} = 0;

	#Who owns the notes?
	$self->{search_filter}->{'user_id'} = $self->{user}->id;

	#We only want Notes without Todos
	$self->{search_filter}->{'todo.id'} = undef;


		$self->{output_data} = $self
			->{repository}
			->get($self->{search_filter}, $attributes);

	return $self;
}

sub delete_note {
	my $self = shift;
	my $unique_column = shift;
	my $id_value = shift;

	$self->{output_data} = $self->{repository}
		->soft_delete($unique_column, $id_value);

	return $self;
}


sub convert_note_to_todo {
	my $self = shift;
	my $id_value = shift;
	my $task = shift;
	my $target_datetime = shift;

	#Just to check for 404
	my $note = $self->{repository}->first('id', $id_value);
	return 0 unless $note;

	my $todo_data = {
		task => $task,
		target_datetime => $target_datetime,
		note_id => $id_value,
		is_deleted => 0,
	};

	my $todo = $note->search_related_rs('todo')
		->update_or_create($todo_data, { key => 'note_id_UNIQUE'});

	$self->{output_data} = $todo ? "Successfully converted" : 0;

	return $self;
}

1;