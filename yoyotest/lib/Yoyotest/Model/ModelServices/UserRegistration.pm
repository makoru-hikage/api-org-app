package Yoyotest::Model::ModelServices:UserRegistration;

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

1;