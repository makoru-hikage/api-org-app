use Yoyotest::Model::Repository;

get '/notes' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $search_filter = from_json(request->body)->{search_filter} if from_json(request->body);

	my $notes = Yoyotest::Model::ModelServices::Notes
		->new($schema)
	 	->set_search_filter($search_filter)
	 	->set_user($username)
	 	->get_notes
	 	->get_output_data;

	send_error("No data available", 404) unless $notes->{data}[0];

	send_as JSON => $notes, 
		{ content_type => 'application/json; charset=UTF-8' };
};

get '/notes/:id' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $search_filter = from_json(request->body)->{search_filter} if from_json(request->body);
	$search_filter->{'me.id'} = route_parameters->{id};

	my $notes = Yoyotest::Model::ModelServices::Notes
		->new($schema)
	 	->set_search_filter($search_filter)
	 	->set_user($username)
	 	->get_notes
	 	->get_output_data;

	send_error("No data available", 404) unless $notes->{data}[0];

	send_as JSON => $notes->{data}[0], 
		{ content_type => 'application/json; charset=UTF-8' };
};

post '/notes' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $input_data = from_json(request->body)->{input_data};

	#Titles must be unique
	$it_already_exists = Yoyotest::Model::Repository
		->new($schema, 'Note')
		->check_uniqueness('title', $input_data->{title});

	send_error("Title already exists", 422) if $it_already_exists;

	my $notes = Yoyotest::Model::ModelServices::Notes
			->new($schema)
			->set_input_data($input_data)
			->set_user($username)
			->write_note
			->get_output_data;

	send_as JSON => $input_data, 
		{ content_type => 'application/json; charset=UTF-8' };
};

put '/notes/:id' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $input_data = from_json(request->body)->{input_data};
	$input_data->{'me.id'} = route_parameters->{id};

	my $notes = Yoyotest::Model::ModelServices::Notes
			->new($schema)
			->set_input_data($input_data)
			->set_user($username)
			->edit_note($id_value)
			->get_output_data;

	send_as JSON => $notes, 
		{ content_type => 'application/json; charset=UTF-8' };.
};

del '/notes/:id' => sub { 
	my $username = session('user');
	send_error("Please login first.", 401) unless $username;

	my $input_data = from_json(request->body)->{input_data} if from_json(request->body);
	$input_data->{'me.id'} = route_parameters->{id};

	my $notes = Yoyotest::Model::ModelServices::Notes
			->new($schema)
			->set_input_data($input_data)
			->set_user($username) #NOTE_1
			->write_note
			->get_output_data;

	send_as JSON => $notes->{data}[0], 
		{ content_type => 'application/json; charset=UTF-8' };
};

1;