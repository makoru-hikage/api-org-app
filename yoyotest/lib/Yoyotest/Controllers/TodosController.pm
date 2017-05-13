use Yoyotest::Model::Repository;
use Yoyotest::MenuService;
use Yoyotest::Validators::TodoValidator;

get '/api/todos' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $search_filter = from_json(request->body)->{search_filter} if from_json(request->body);

	my $todos = Yoyotest::Model::ModelServices::Todos
		->new($schema)
		->set_search_filter($search_filter)
		->set_user($username)
		->get_todos
		->get_output_data;

	send_as JSON => $todos, 
		{ content_type => 'application/json; charset=UTF-8' };
};

post '/api/todos' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $request_body = from_json(request->body);
	$response_body->{input_data}->{username} = $username;

	my $todos = sub {
		my ($schema, $input_data) = @_;

		Yoyotest::Model::ModelServices::Todos
			->new($schema)
			->set_input_data($input_data)
			->set_user($username)
			->write_note
			->create_todo
			->get_output_data;
	};

	my $response_body = Yoyotest::MenuService
		->new($schema)
		->set_model_service_sub($todos)
		->set_model_service_data($request_body)
		->set_validator(Yoyotest::Validators::TodoValidator)
		->check_uniqueness('Note','title')
		->execute;

	status $response_body->{code};

	push_response_header content_type => 'application/json; charset=UTF-8';
	send_as JSON => $response_body;
};

put '/api/todos/:id' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	$id_value = route_parameters->{id};

	my $request_body = from_json(request->body);
	$response_body->{input_data}->{username} = $username;

	my $todos = sub {
		my ($schema, $input_data) = @_;

		Yoyotest::Model::ModelServices::Todos
			->new($schema)
			->set_input_data($input_data)
			->edit_todo($id_value)
			->get_output_data;
	};

	my $response_body = Yoyotest::MenuService
		->new($schema)
		->set_model_service_sub($todos)
		->set_model_service_data($request_body)
		->set_validator(Yoyotest::Validators::TodoValidator)
		->check_uniqueness('Note','title')
		->execute;

	status $response_body->{code};

	push_response_header content_type => 'application/json; charset=UTF-8';
	send_as JSON => $response_body;
};

del '/api/todos/:id' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	$id_value = route_parameters->{id};

	my $is_deleted = Yoyotest::Model::ModelServices::Notes
		->new($schema)
		->delete_note('id', $id_value)
		->get_output_data;

	send_error("It does not exist", 404) unless $is_deleted;
	status 200;

	push_response_header content_type => 'application/json; charset=UTF-8';
	send_as JSON => { message => $is_deleted, code => 200 };
};

any ['put', 'post'] => '/api/todos/:id/convert' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	$id_value = route_parameters->{id};

	my $is_converted = Yoyotest::Model::ModelServices::Todos
		->new($schema)
		->convert_todo_to_note($id_value)
		->get_output_data;

	send_error("It does not exist", 404) unless $is_converted;
	status 200;

	push_response_header content_type => 'application/json; charset=UTF-8';
	send_as JSON => { message => $is_converted, code => 200 };
};

any ['put', 'post', 'del'] => '/api/todos/:id/done' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $mark = undef;
	my $message = "error";

	if (request->method eq 'POST' || request->method eq 'PUT') {
		$mark = 1;
		$message = "It is marked as done";
	} else {
		$mark = 0;
		$message = "It is marked as not done";
	} 

	$id_value = route_parameters->{id};

	my $is_converted = Yoyotest::Model::ModelServices::Todos
		->new($schema)
		->toggle_done($id_value, $mark)
		->get_output_data;

	send_error("It does not exist", 404) unless $is_converted;
	status 200;

	push_response_header content_type => 'application/json; charset=UTF-8';
	send_as JSON => { message => $message, code => 200 };
};

1;