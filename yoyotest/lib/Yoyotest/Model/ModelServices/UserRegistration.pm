package Yoyotest::Model::ModelServices:Users;

use strict;
use warnings;

use parent 'Yoyotest::Model::ModelService';

sub get_valid_columns {
	return ('username', 'email', 'first_name', 'last_name');
}

sub register_user {
	my $self = shift;
	$self->{output_data} = $self->{repository}->create('User', $self->{input_data};
}

#"Statically" call this, no args required
sub get_logged_user {
	my $logged_username = session ('user');

	if ($logged_username){
		return 0;
	}

	my $user_model = $schema->resultset('User');
	my $user = $user_model->search({ username => $logged_username })->first;
	return $user;
}

1;