package Yoyotest::Model::ModelServices::OwnedByUserTrait;

use warnings;
use strict;

#Used on a Yoyotest::Model::ModelService wherein
#a user is required
sub set_user {
	my $self = shift;
	my $username = shift;
	$self->{repository} = $self->{repository}->change_entity('User');

	#If there is no argument for username, 
	#get the one included in input_data
	$username =  $self->{input_data}->{username} unless $username; 

	#Set the error code should the user not exist
	$self->{user} = $self->{repository}->first('username', $username);
	
	return $self;
}

1;