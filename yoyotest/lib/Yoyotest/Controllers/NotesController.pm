use Yoyotest::Model::Repository;
use Yoyotest::MenuService;
use Yoyotest::Validators::NoteValidator;

sub notes_getter { 

	return sub { 
		my $get_only_one = shift;

		my $username = session('user');
		send_error("Please login first.", 401) unless $username;

		my $id = route_parameters->{id} if $get_only_one;

		my $search_filter = from_json(request->body) ?
			from_json(request->body)->{search_filter} :
			undef;
	
		$search_filter->{'me.id'} = $id;

		if (!$id) {
			delete $search_filter->{'me.id'};
		} 

		my $notes = Yoyotest::Model::ModelServices::Notes
			->new($schema)
		 	->set_search_filter($search_filter)
		 	->set_user($username)
		 	->get_notes
		 	->get_output_data;

		$notes = $id ? $notes->{data}[0] : $notes->{data};

		send_error("No data available", 404) unless $notes;

		send_as JSON => { data => $notes }, 
			{ content_type => 'application/json; charset=UTF-8' };
	};
};

get '/api/notes' => notes_getter();
get '/api/notes/:id' => notes_getter(1);

post '/api/notes' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $request_body = from_json(request->body);
	$response_body->{input_data}->{username} = $username;

	my $notes = sub {
		my ($schema, $input_data) = @_;

		Yoyotest::Model::ModelServices::Notes
			->new($schema)
			->set_input_data($input_data)
			->set_user($username)
			->write_note
			->get_output_data;
	};

	my $response_body = Yoyotest::MenuService
		->new($schema)
		->set_model_service_sub($notes)
		->set_model_service_data($request_body)
		->set_validator(Yoyotest::Validators::NoteValidator)
		->check_uniqueness('Note','title')	
		->execute;

	status $response_body->{code};

	push_response_header content_type => 'application/json; charset=UTF-8';
	send_as JSON => $response_body;
};

put '/api/notes/:id' => sub {
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	$id_value = route_parameters->{id};

	my $request_body = from_json(request->body);

	my $notes = sub {
		my ($schema, $input_data) = @_;

		Yoyotest::Model::ModelServices::Notes
			->new($schema)
			->set_input_data($input_data)
			->edit_note($id_value)
			->get_output_data;
	};

	my $response_body = Yoyotest::MenuService
		->new($schema)
		->set_model_service_sub($notes)
		->set_model_service_data($request_body)
		->set_validator(Yoyotest::Validators::NoteValidator)	
		->check_uniqueness('Note','title')	
		->execute;

	status $response_body->{code};

	push_response_header content_type => 'application/json; charset=UTF-8';
	send_as JSON => $response_body;
};

del '/api/notes/:id' => sub { 
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

any ['put', 'post'] => '/api/notes/:id/convert' => sub {
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	$id_value = route_parameters->{id};

	my $request_body = from_json(request->body);

	my $notes = sub {
		my ($schema, $input_data) = @_;

		Yoyotest::Model::ModelServices::Notes
			->new($schema)
			->convert_note_to_todo($id_value, $input_data->{task}, $input_data->{target_datetime})
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