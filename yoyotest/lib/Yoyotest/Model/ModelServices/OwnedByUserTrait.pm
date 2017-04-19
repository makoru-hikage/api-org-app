package Yoyotest::Model::ModelServices::OwnedByUserTrait;

use warnings;
use strict;

#Used on a Yoyotest::Model::ModelService wherein
#a user is required
sub set_user {
	my $self = shift;
	my $username = shift;

	#If there is no argument for username, 
	#get the one included in input_data
	$username =  $self->{input_data}->{username} unless $username; 
	
	#Set the error code should the user not exist
	$self->{user} = $self->{repository}->first('username', $username);
	$self->{error_code} = 404 unless $self->{user};
	
	return $self;
}

1;