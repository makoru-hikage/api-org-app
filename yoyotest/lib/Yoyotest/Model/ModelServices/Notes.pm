package Yoyotest::Model::ModelServices::Notes;

use strict;
use warnings;

use parent 'Yoyotest::Model::ModelService';

sub get_valid_columns {
	return ('username', 'title', 'content');
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

sub write_note {
	my $self = shift;

	unless ($self->{error}) {
		$self->{input_data}->{user_id} = $self->{user}->id;
		$self->{output_data} = $self
			->{repository}
			->create('Note', $self->{input_data});
	}

	return $self;
}

1;