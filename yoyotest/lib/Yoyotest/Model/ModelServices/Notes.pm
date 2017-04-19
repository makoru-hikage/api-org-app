package Yoyotest::Model::ModelServices::Notes;

use strict;
use warnings;

use parent 'Yoyotest::Model::ModelService';
use parent 'Yoyotest::Model::ModelServices::OwnedByUserTrait';

sub get_valid_columns {
	return ('username', 'title', 'content');
}

sub write_note {
	my $self = shift;

	unless ($self->{error_code}) {
		$self->{input_data}->{user_id} = $self->{user}->id;
		$self->{output_data} = $self
			->{repository}
			->create('Note', $self->{input_data});
	}

	return $self;
}

1;