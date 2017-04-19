package Yoyotest;

use Dancer2;
use Yoyotest::Model;

use Dancer2::Plugin::Auth::Extensible::Provider::Database ('authenticate_user');
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Passphrase;
use Dancer2::Plugin::Ajax;
use Dancer2::Plugin::REST;
use Yoyotest::Model::Repository;
use Yoyotest::Model::ModelServices::Todos;
use Yoyotest::Model::ModelServices::Notes;
use Data::Dumper;

our $VERSION = '0.1';

#Load the database connection
my $schema = schema;



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
	
	$access_granted or send_error("Unauthorized", 401);

	session user => $username_from_db;

};

#user creation requires username and password
resource 'users' =>
    'get'    => sub { 
    	 my $repository = Yoyotest::Model::Repository->new($schema, 'User');
    },
    'create' => sub { 
    	my $repository = Yoyotest::Model::Repository->new($schema, 'User');
		my $user_maker = Yoyotest::Model::ModelServices::Users->new ($repository);

		$user_maker->set_input_data( params )->register_user->get_output_data;
    },
    'delete' => sub { 
    	my $repository = Yoyotest::Model::Repository->new($schema, 'User');
    	my $deleted = $repository->delete('id', params->{id});
    	$deleted or send_error("Entity not found", 404); 
    },
    'update' => sub { 
    	my $repository = Yoyotest::Model::Repository->new($schema, 'User');	      
    };

#todo creation requires username, task, note_id, target_date, target_time
resource 'todos' => 
    'get'    => sub { 
	    #Determine the logged user
		my $logged_username = session ('user');
		my $repository = Yoyotest::Model::Repository->new($schema, 'Todo');
		my $todo_maker = Yoyotest::Model::ModelServices::Todos->new($repository);

		
		my $todos = $todo_maker->set_user($logged_username)->get_todos->get_output_data;
		my $test = $repository->first('username', 'cmoran');

		return {data => ref $todos->all };  
    },
    'create' => sub { 
    	# create a new user with params->{user} 
    },
    'delete' => sub { 
    	my $repository = Yoyotest::Model::Repository->new($schema, 'Todo');
    	my $deleted = $repository->delete('id', params->{id});
    	$deleted or send_error("Entity not found", 404);  
    },
    'update' => sub { 
    	# update user with params->{user}       
    };

#todo creation requires username, title, content
resource 'notes' =>
    'get'    => sub { 
    	# return user where id = params->{id}   
    },
    'create' => sub { 
    	# create a new user with params->{user} 
    },
    'delete' => sub { 
    	my $repository = Yoyotest::Model::Repository->new($schema, 'Todo');
    	my $deleted = $repository->delete('id', params->{id});
    	$deleted or send_error("Entity not found", 404);    
    },
    'update' => sub { 
    	# update user with params->{user}       
    };

true;
