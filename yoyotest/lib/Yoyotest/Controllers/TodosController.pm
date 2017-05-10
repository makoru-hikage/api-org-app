use Yoyotest::Model::Repository;
use Yoyotest::MenuService;
use Yoyotest::Validators::TodoValidator;

get '/todos' => sub { 
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

post '/todos' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $request_body = from_json(request->body);
	$response_body->{input_data}->{username} = $username;

	my $notes = sub {
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
		->set_model_service_sub($notes)
		->set_model_service_data($request_body)
		->set_validator(Yoyotest::Validators::TodoValidator)
		->check_uniqueness('Note','title')
		->execute;

	status $response_body->{code};

	push_response_header content_type => 'application/json; charset=UTF-8';
	send_as JSON => $response_body;
};

put '/todos/:id' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	$id_value = route_parameters->{id};

	my $request_body = from_json(request->body);
	$response_body->{input_data}->{username} = $username;
	$response_body->{search_filter}->{id} = $id_value;

	my $notes = sub {
		my ($schema, $input_data) = @_;

		Yoyotest::Model::ModelServices::Todos
			->new($schema)
			->set_input_data($input_data)
			->set_user($username)
			->edit_todo($id_value)
			->get_output_data;
	};

	my $response_body = Yoyotest::MenuService
		->new($schema)
		->set_model_service_sub($notes)
		->set_model_service_data($request_body)
		->set_validator(Yoyotest::Validators::TodoValidator)
		->check_uniqueness('Note','title')
		->execute;

	status $response_body->{code};

	push_response_header content_type => 'application/json; charset=UTF-8';
	send_as JSON => $response_body;
};

1;