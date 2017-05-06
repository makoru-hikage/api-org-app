package Yoyotest;

use Dancer2;

use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Passphrase;
use DBIx::Class::ResultClass::HashRefInflator;
use Yoyotest::Model::ModelServices::Todos;
use Yoyotest::Model::ModelServices::Notes;

our $VERSION = '0.1';

#Load the database connection
our $schema = schema;

require Yoyotest::Controllers::NotesController;
require Yoyotest::Controllers::TodosController;

get '/' => sub {

	#Load the template
    template index => { title => 'yoyotest' };

};

#What happens after send_error is invoked.
# hook init_error => sub {
#     my $error = shift;
#     status $error->status;
    
#     send_as JSON => { 
#     	message => $error->message,
#     	status => $error->status,
#     }, { content_type => 'application/json; charset=UTF-8' };
# };

#A simple login using cookie sessions. See config.yml
any ['put', 'post'] => '/login' => sub {

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

#You see that right, any, any method.
any '/logout' => sub {

	session user => undef;
	send_as JSON => { message => "You are now logged out."},
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
