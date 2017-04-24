package Yoyotest;

use Dancer2;
use Yoyotest::Model;

use Dancer2::Plugin::Auth::Extensible::Provider::Database ('authenticate_user');
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Passphrase;
use DBIx::Class::ResultClass::HashRefInflator;
use Dancer2::Plugin::REST;

use Yoyotest::Model::ModelServices::Todos;
use Yoyotest::Model::ModelServices::Notes;
use Data::Dumper;

our $VERSION = '0.1';

#Load the database connection
my $schema = schema;



get '/' => sub {

	#Load the template
    template index => { title => 'yoyotest' };

};

hook init_error => sub {
    my $error = shift;
    status $error->status;
    
    send_as JSON => { 
    	message => $error->message,
    	status => $error->status,
    }, { content_type => 'application/json; charset=UTF-8' };
};

post '/login' => sub {

	send_as JSON => { message => "Still logged in"} if session('user');

	#Get all the params from HTTP request
	my $username  = param 'username';
	my $password  = param 'password';

	#Find and load the user's data from database by username 
	my $user_model = $schema->resultset('User');
	my $user = $user_model->search({ username => $username })->first;
	my $username_from_db = $user->username;
	my $password_from_db = $user->password;

	#Hash the input password match against the one in DB
	my $access_granted = passphrase($password)->matches($password_from_db);
	
	send_error("Unauthorized! Wrong username and/or password", 401) unless $access_granted;

	session user => $username_from_db;
	send_as JSON => { message => "You are now logged in as ". session('user')},
		{ content_type => 'application/json; charset=UTF-8' };

};

any '/logout' => sub {

	session user => undef;
	send_as JSON => { message => "You are now logged out."},
		{ content_type => 'application/json; charset=UTF-8' };

};

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



get '/test/:id' => sub {
	my $id = route_parameters->{id};
	my $input_data = from_json(request->body)->{input_data};
	my $search_filter = from_json(request->body)->{search_filter};

	my $data = {
		id => $id,
		input => $input_data,
		filter => $search_filter,
	};

	send_as JSON => $data , { content_type => 'application/json; charset=UTF-8' };
};

get '/hash_pass/:pass' => sub {
	my $passwd = param 'pass';
	send_as JSON => {
			passwd => passphrase( $passwd )->generate->rfc2307} , 
			{ content_type => 'application/json; charset=UTF-8' };
};

true;
