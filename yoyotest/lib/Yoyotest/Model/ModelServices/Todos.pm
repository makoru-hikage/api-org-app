package Yoyotest::Model::ModelServices::Todos;

use strict;
use warnings;
use diagnostics;

use parent 'Yoyotest::Model::ModelService';

use Yoyotest::Model::ModelServices::Notes;

sub get_valid_columns {
	return ('username', 'title', 'content', 'target_datetime');
}

sub set_user {
	my $self = shift;
	my $username = shift;

	#If there is no argument for username, 
	#get the one included in input_data
	$username =  $self->{input_data}->{username} unless $username;
	
	if ($username) {
		#Get one row from database
		$self->{user} = $self->{input_data}->{repository}->first('User', 'username', $username);

		#If user does not exist...
		unless ($self->{user}){
			$self->set_exception_message(404, "User does not exist");
		}
	} else {
		#Error shall be raised if there's no username provided
		$self->set_exception_message(400, "Provide a username please") unless $username;
	}
	
	return $self;
}

sub create_note {
	my $self = shift;
	if ($self->{user}) {
		my $note_maker = Yoyotest::Model::ModelServices::Notes->new( $self->{repository} );

		$self->{note} = $note_maker
			->set_input_data($self->{input_data})
			->set_user($self->{user})
			->write_note
			->get_output_data;
	}

	return $self;
}

sub create_todo {
	my $self = shift;

	unless ($self->{errors}) {
	
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

	$self->{search_filter}->{ 'note.user_id' } = 1;

	my $attributes = {
	
		order_by => { -desc => 'note.created_at' },
		prefetch => { 'note' => 'user' }
	};

	my $todos = $self->{repository}->first('username', 'cmoran');
	#get('Todo', $self->{search_filter}, $attributes);

	$self->set_exception_message(404, "No Todos found") unless $todos;

	$self->{output_data} = $todos;

	return $self;
}

1;