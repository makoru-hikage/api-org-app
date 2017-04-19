package Yoyotest;

use Dancer2;
use Yoyotest::Model;

use Dancer2::Plugin::Auth::Extensible::Provider::Database ('authenticate_user');
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Passphrase;
use Dancer2::Plugin::Ajax;
use Yoyotest::Model::Repository;
use Yoyotest::Model::ModelServices::Todos;
use Yoyotest::Model::ModelServices::Notes;
use Data::Dumper;

our $VERSION = '0.1';

#Load the database connection
my $schema = schema;

sub get_logged_user {
	my $logged_username = session ('user');

	if ($logged_username){
		return 0;
	}

	my $user_model = $schema->resultset('User');
	my $user = $user_model->search({ username => $logged_username })->first;
	return $user;
}

get '/' => sub {

	#If no one is logged in, redirect to login page
	#redirect '/login' unless session('user');
	#Load the template
    template index => { 'title' => 'yoyotest' };

};

post '/login' => sub {

	#Get all the params from HTTP request
	my $username  = param 'username';
	my $password  = param 'password';

	#Extract requested resource if there is, else it's just login
	my $redir_url = param 'redirect_url' || '/login';

	#Find and load the user's data from database by username 
	my $user_model = $schema->resultset('User');
	my $user = $user_model->search({ username => $username })->first;
	my $username_from_db = $user->username;
	my $password_from_db = $user->password;

	#Hash the input password match against the one in DB
	my $access_granted = passphrase($password)->matches($password_from_db);
	
	$access_granted or redirect $redir_url;

	session user => $username_from_db;
	redirect $redir_url;
};

ajax '/notes' => sub {
	#Determine the logged user
	my $logged_username = session ('user');
	my $user_model = $schema->resultset('User');
	my $user = $user_model->search({ username => $logged_username })->first;

	#Specifies what columns shall be used in query
	#Also specifies how the records shall be sorted
	my $attributes = {
		order_by => { -desc => 'created_at' },
		columns => [
			'title',
			'content',
			'created_at',
		],
	}; 

	#Run the query
	my $notes = $user->search_related('notes', { is_deleted => 0}, %{ $attributes });

	$notes or send_error("We have no notes", 404);

    return @{ $notes };
};

get '/todos' => sub {
	#Determine the logged user
	my $logged_username = session ('user');
	my $repository = $Yoyotest::Model::Repository->new ($schema, 'User');
	my $todo_maker = $Yoyotest::Model::ModelServices::Todos->new ($repository);

	
	my @todos = $todo_maker->set_user($logged_username)->get_todos->get_output_data;
	my $test = $repository->first('username', 'cmoran');

	return {data => Dumper $test };
};

true;
