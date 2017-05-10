package Yoyotest::Validators::TodoValidator;

use Validation::Class;
use Yoyotest::Model::Repository;
use Yoyotest;

field 'title' => {
	required => 1,
	max_length => 50,
	messages => {
		required => 'There must be a title!',
		max_length => 'The number of characters is too much, shorten it'
	} 
};

field 'task' => {
	required => 1,
	max_length => 50,
	messages => {
		required => 'There must be a Task!',
		max_length => 'The number of characters is too much, shorten it'
	}
};

1;