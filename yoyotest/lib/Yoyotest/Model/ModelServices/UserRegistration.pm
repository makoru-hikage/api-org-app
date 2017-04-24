package Yoyotest::Model::ModelServices:Users;

use strict;
use warnings;

use parent 'Yoyotest::Model::ModelService';

my $entity_name = 'User';

sub get_valid_columns {
	return ('username', 'email', 'first_name', 'last_name');
}

sub register_user {
	my $self = shift;

	$user = $self->{repository}->create($self->{input_data});
	$self->{error_code} = 404 unless $user
	$self->{output_data} = $user ? "User created!" : $self->{error_code};
	return $self;
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