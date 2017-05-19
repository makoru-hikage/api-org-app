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

	my $user = session('user');
	redirect '/login' unless $user;

	#Load the template
    template 'index', { 
    	title => 'Notes', 
    	page_js => "scripts.js",
    	page_css => "style.css"
    };

};

get '/login' => sub {

	redirect '/' if session('user');

	#Load the template
    template 'login', { 
    	title => 'Login',
    	page_js => 'login.js',
    	page_css => 'login.css' 
    };

};

#What happens after send_error is invoked.
hook init_error => sub {
    my $error = shift;

    status $error->status;
    
    send_as JSON => { 
    	message => $error->message,
    	status => $error->status,
    }, { content_type => 'application/json; charset=UTF-8' };
};

#A simple login using cookie sessions. See config.yml
any ['put', 'post'] => '/api/login' => sub {

	send_as JSON => { message => "Still logged in"} if session('user');

	#Get all the params from HTTP request
	my $username  = from_json(request->body)->{username};
	my $password  = from_json(request->body)->{password};

	my $there_is_input = $username && $password;
	send_error("Please fill the username and password", 400) unless $there_is_input;

	#Find and load the user's data from database by username 
	my $user_model = $schema->resultset('User');
	my $user = $user_model->search({ username => $username })->first;
	my $username_from_db = $user->username;
	my $password_from_db = $user->password;

	#Hash the input password match against the one in DB
	my $access_granted = passphrase($password)->matches($password_from_db);
	send_error("Unauthorized! Wrong username and/or password", 401) unless $access_granted;

	session user => $username_from_db;
	send_as JSON => { message => "You are now logged in as ". $username_from_db	},
		{ content_type => 'application/json; charset=UTF-8' };

};

#You see that right, any, any method.
any '/api/logout' => sub {

	session user => undef;
	send_as JSON => { message => "You are now logged out."},
		{ content_type => 'application/json; charset=UTF-8' };

};

any '/logout' => sub {
	session user => undef;
	redirect '/login';
};

true;
