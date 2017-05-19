var login_modal_object = new Modal(document.getElementById('login-modal') , 
	{  keyboard: true });

function login(){
	var $username = Bliss('#username').value;
	var $password = Bliss('#pass').value;

	Bliss.fetch('/api/login', {
		"method": "POST",
		"data": JSON.stringify({
					"username": $username,
					"password": $password,
				}),
		"headers": {
		    "Content-type": "application/x-www-form-urlencoded"
		}
	}).then(()=>window.location.replace("/"), ()=>show_modal());
}

function initialize_modal (){
	var $login_modal = Bliss('#login-modal');

	
}

function show_modal(){
	login_modal_object.show();
}

function hide_modal(){
	login_modal_object.hide();
}