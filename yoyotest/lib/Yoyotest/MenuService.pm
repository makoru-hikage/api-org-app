package Yoyotest::MenuService;

use Yoyotest::Model::Repository;

# The method chain:
# 
# Yoyotest::MenuService
# 	->new($schema)
# 	->set_validator($validator_class)
# 	->set_model_service_sub($model_service_sub)
# 	->set_model_service_data($model_service_data)
# 	->execute;
	
sub new {
	my $class = shift;
	my $self = {};

	$self->{schema} = shift;
	
	#HTTP Status Code
	$self->{code} = 0;

	#If nothing happened...
	$self->{message} = "There seems to be a problem."; 

	#The response body
	$self->{output_data} = {};

	#The input data for POST or PUT operations
	$self->{input_data} = {};

	#Other data than input data
	#It should be a list of arguments
	$self->{model_service_sub} = [];

	#Namespace of the class used for validation.
	$self->{validator} = {};

	bless ($self, $class);
	return $self;
}

# The anonymous sub which calls a method-chaining
# ModelService, such sub requires a schema object
# as the first parameter
sub set_model_service_sub {
	my $self = shift;
	$self->{model_service_sub} = shift;

	return $self;
}


sub set_model_service_data {
	my $self = shift;
	$self->{model_service_data} = shift;

	$self->{input_data} = $self->{model_service_data}->{input_data};
	$self->{search_filter} = $self->{model_service_data}->{search_filter};

	return $self;
}

sub set_validator {
	my $self = shift;
	$self->{validator} = shift;

	return $self;
}

sub validate {
	my $self = shift;

	$validator = $self->{validator};
	$input_data = $self->{input_data};

	#If there is no validator... do not validate.
	if ($validator) {
		$validator = $validator->new($input_data);

		unless ($validator->validate) {
	        # handle the failures
	        $self->{message} = $validator->errors_to_string;
	        $self->{code} = 422;
	    }
	}
	
    return $self;
}

sub check_uniqueness {
	my $self = shift;
	my $entity_name = shift;
	my $column = shift;

	#The data to be checked
	my $tested_param = $self->{input_data}->{$column};

	my $it_is_unique = Yoyotest::Model::Repository
		->new($self->{schema}, $entity_name)
		->check_uniqueness($column, $tested_param);

	unless ($it_is_unique) {
        # handle the failures
        $self->{message} = "\"$tested_param\" is already taken.";
        $self->{code} = 422;
    }

	return $self;
}

sub prepare_response {
	my $self = shift;

	return {
		code => $self->{code},
		message => $self->{message},
		data => $self->{output_data},
		input_data => $self->{input_data},
	};
}

sub process_model_service {
	my $self = shift;
	my $run_model_service = $self->{model_service_sub};

	#If $self->{code} has value, the validation have failed
	return $self if $self->{code};

	my $schema = $self->{schema};
	my $input_data = $self->{input_data};
	my $search_filter = $self->{search_filter};

	# $run_model_service must be refering to an anonymous
	# subroutine that accepts three arguments: 
	# $schema, $input_data and $search_filter. 
	# 
	# The latter two are hash references.
	$self->{output_data} = $run_model_service->($schema, $input_data, $search_filter);

	unless ($self->{output_data}) {
		$self->{code} = 404;
		$self->{message} = 'Content not found.';
		return $self;
	}

	$self->{code} = 200;
	$self->{message} = "Success!";
	return $self;
}

sub execute {
	my $self = shift;

	return $self
		->validate()
		->process_model_service()
		->prepare_response();
}

1;
