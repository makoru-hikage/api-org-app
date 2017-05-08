package Yoyotest::Validators::NoteValidator;

use Validation::Class;
use Yoyotest::Model::Repository;
use Yoyotest;

directive 'unique' => ;

field 'title' => {
	required => 1,
	max_length => 50,
	validation => sub {

		my ($self, $proto, $field, $param) = @_;

		if (defined $field->{unique} && defined $param) {

	        my $already_exists = Yoyotest::Model::Repository
				->new(Yoyotest::schema, 'Note')
				->check_uniqueness('title', $param);

			my $valid = $already_exists ? 0 : 1;

			return $valid;
	    }
	},
	messages => {
		required => 'There must be a title!',
		max_length => 'The number of characters is too much, shorten it',
		validation => 'Title is already made, do another',
	} 
};

1;
