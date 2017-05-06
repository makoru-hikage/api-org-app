

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

	send_as JSON => $notes, 
		{ content_type => 'application/json; charset=UTF-8' };
};

1;