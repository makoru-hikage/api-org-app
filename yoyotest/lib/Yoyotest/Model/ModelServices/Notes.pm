package Yoyotest::Model::ModelServices::Notes;

use strict;
use warnings;

use parent 'Yoyotest::Model::ModelService';
use parent 'Yoyotest::Model::ModelServices::OwnedByUserTrait';

# COMBOS:
# 
# Create a new note: 
# 	new($repository)
# 	->set_input_data($input_data)
# 	->set_user($username) #NOTE_1
# 	->write_note
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
#	  

sub get_entity_name {
	return 'Note';
}


my $select_columns = [
	'id',
	'title',
	'content',
	'created_at',
	'user.username',
	'user.first_name',
	'user.last_name',
];


my $valid_input_columns = [
	'username', 
	'title', 
	'content',
];

sub write_note {
	my $self = shift;
	$self->{repository}->change_entity('Note');

	$self->{input_data}->{user_id} = $self->{user}->id;

	$self->{output_data} = $self
		->{repository}
		->create($self->{input_data});

	return $self;
}

sub edit_note {
	my $self = shift;
	my $id_value = shift;
	$self->{repository}->change_entity('Note');

	$self->{input_data}->{user_id} = $self->{user}->id;

	$self->{output_data} = $self
		->{repository}
		->update('id', $id_value, $self->{input_data});

	return $self;
}

sub get_notes(){
	my $self = shift;
	$self->{repository}->change_entity('Note');

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

1;