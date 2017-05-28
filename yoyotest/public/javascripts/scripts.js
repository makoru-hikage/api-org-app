window.onload = (e) => load_notes_list_data();
var sidebar_list;
var notepad_data_buffer = {
	"note_title": "",
	"note_text": "",
	"task": "",
	"target_datetime": "",
	"is_done": 0
};


/* Functions for loading entries*/
function load_notes_list_data(){
	var promise = $.fetch('/api/notes', {
		"method": "GET",
		"data": null,
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	}).then((xhr) => { 
		$('title').innerHTML = "Ｎ Ｏ Ｔ Ｅ Ｓ";
		$('#view-title').innerHTML = "Ｎ Ｏ Ｔ Ｅ Ｓ"; 
		$('#note-title').dataset.entity = 'note';
		return xhr; 
	}, ()=>alert('Failed to fetch data'))
	.then((xhr) => { 
		note_fill_notepad(JSON.parse(xhr.response).data[0]); 
		return xhr; 
	}, ()=>alert('Failed to fill notepad'))
	.then((xhr)=>{ 
		fill_buffer(JSON.parse(xhr.response).data[0]); 
		return xhr; 
	}, ()=>alert('Failed to load buffer'))
	.then((xhr)=>load_notes(JSON.parse(xhr.response).data), ()=>alert('Notes failed to load'));
}


function load_todos_list_data(){
	var promise = $.fetch('/api/todos', {
		"method": "GET",
		"data": null,
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	}).then((xhr) => { 
		$('title').innerHTML = "Ｔ Ｏ Ｄ Ｏ Ｓ";
		$('#view-title').innerHTML = "Ｔ Ｏ Ｄ Ｏ Ｓ"; 
		$('#note-title').dataset.entity = 'todo';
		return xhr; 
	}, ()=>alert('Failed to fetch data'))
	.then((xhr) => { 
		todo_fill_notepad(JSON.parse(xhr.response).data[0]); 
		return xhr; 
	}, ()=>alert('Failed to fill notepad'))
	.then((xhr)=>{ 
		fill_buffer(JSON.parse(xhr.response).data[0]); 
		return xhr; 
	}, ()=>alert('Failed to load buffer'))
	.then((xhr)=>load_todos(JSON.parse(xhr.response).data), ()=>alert('Todos failed to load'));
}

function refresh_list(){

	var mode = $('#note-title').dataset.entity;
	var id = $('#note-title').dataset.id;

	var promise = $.fetch('/api/'+ mode +'s', {
		"method": "GET",
		"data": null,
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	}).then((xhr)=>load_notes(JSON.parse(xhr.response).data), ()=>alert('Notes failed to load'));
}

/* Functions for filling the notepad */
function pick_one_note(e){
	var list_item_id = e.target.closest('li').dataset.id;

	load_one_note(list_item_id);
}

function load_one_note(id){

	var promise = $.fetch('/api/notes/'+id, {
		"method": "GET",
		"data": null,
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	})
	.then((xhr)=>{ note_fill_notepad(JSON.parse(xhr.response).data); return xhr; }, ()=>alert('Failed to load note'))
	.then((xhr)=>{ fill_buffer(JSON.parse(xhr.response).data); return xhr; }, ()=>alert('Failed to load buffer'));
}

function pick_one_todo(e){
	var list_item_id = e.target.closest('li').dataset.note_id;

	load_one_todo(list_item_id);
}

function load_one_todo(id){

	var promise = $.fetch('/api/todos/'+id, {
		"method": "GET",
		"data": null,
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	})
	.then((xhr)=>{ todo_fill_notepad(JSON.parse(xhr.response).data); return xhr; }, ()=>alert('Failed to load todo'))
	.then((xhr)=>{ fill_buffer(JSON.parse(xhr.response).data); return xhr; }, ()=>alert('Failed to load buffer'));
}

function delete_note(){
	var delete_confirmed = confirm("Are you sure?");
	var note_id = $('#note-title').dataset.id;
	var entity = $('#note-title').dataset.entity;
	var list_index = entity == 'todo' ? 'note_id' : 'id';
	var what_to_load = entity === 'note' ? load_notes_list_data : load_todos_list_data;

	if (delete_confirmed){
		var promise = $.fetch('/api/'+entity+'s/' + note_id, {
			"method": "DELETE",
		}).then((xhr)=>sidebar_list.remove(list_index, note_id), ()=>alert('Failed to be deleted'))
		.then((xhr)=>what_to_load(), ()=>alert('Failed to be deleted'));
	}
}

/* GUI Item list functions */
function load_notes(list_data){
	$('#sidebar-list-items').innerHTML = '';

	var options = {
	  valueNames: [
	  	{ data: ['id'] },
	  	'note_title',
		'creation_time'
	  ],
	  item: `<li class="sidebar-list-item">
				<div class="col-md-9">
					<span class="list-item-time timestamp creation_time"></span>
					<label class="list-item-title note_title" onclick="pick_one_note(event)">
						
					</label>
					<span class="list-item-sub note_text"></span> 
				</div>
				<div class="col-md-3 is-done-box"><div>
			</li>`
	};

	sidebar_list = new List('sidebar-panel', options);
	sidebar_list.add(list_data);

}

function load_todos(list_data){
	
	$('#sidebar-list-items').innerHTML = '';
	
	var options = {
	  valueNames: [
	  	{ data: ['note_id'] },
	  	"task",
		"target_datetime",
		"task_started",
		"creation_time",
		"username",
		"note_title",
		{ name:"is_done", attr: "value"}
	  ],
	  item: `<li class="sidebar-list-item">
				<div class="col-md-9">
					<span class="list-item-time creation_time"></span>
					<label class="list-item-title task" onclick="pick_one_todo(event)">
					</label>
					<span class="list-item-sub target_datetime"></span> 
					
				</div>
				<div class="col-md-3 is-done-box"><input class="is_done" type="checkbox" name="is_done" onchange="toggle_done(event)"><div>
			</li>`,
		indexAsync : true
	};

	sidebar_list = new List('sidebar-panel', options);

	sidebar_list.add(list_data);

	$$('.sidebar-list-item .is-done-box .is_done').forEach( (item) => {
		if (item.value > 0){ item.checked = "true"; }
	});
}


/* Note event functions */
function note_fill_notepad(list_item){
	$('#task-field').style.display = 'none';
	$('#d_d').style.display = 'none';
	$('#textarea-content').style.height = "83%";

	var title_bar = list_item.note_title + " (" + list_item.creation_time +")";
	$('#note-title').innerHTML = title_bar;
	$('#note-title').dataset.id = list_item.id;
	$('#note-title').dataset.entity = 'note';

	$('#note-title-field').value = list_item.note_title;
	$('#textarea-content').value = list_item.note_text  || '';
}

function todo_fill_notepad(list_item){
	notepad_mode('todo');
	
	var title_bar = list_item.note_title + " (" + list_item.creation_time +")";
	$('#note-title').innerHTML = title_bar;
	$('#note-title').dataset.id = list_item.note_id;
	$('#note-title').dataset.entity = 'todo';

	$('#note-title-field').value = list_item.note_title;
	$('#textarea-content').value = list_item.note_text || '';
	$('#todo-target-field').value = list_item.target_datetime || '';
	$('#todo-task-field').value = list_item.task;
	if (list_item.is_done) {
		$('#todo-is-done-field').setAttribute('checked', 'true');
	} else {
		$('#todo-is-done-field').removeAttribute('checked');
	}
}

function reset_notepad(){

	notepad_data_buffer = {
		"note_title": "",
		"note_text": "",
		"task": "",
		"target_datetime": "",
		"is_done": 0
	}

	var title_bar = '';
	$('#note-title').innerHTML = '';
	$('#note-title').dataset.id = '0';

	$('#note-title-field').value = '';
	$('#textarea-content').value = '';
	$('#todo-target-field').value = '';
	$('#todo-task-field').value = '';
	$('#todo-is-done-field').removeAttribute('checked');

	var mode = $('#note-title').dataset.entity;
	notepad_mode (mode);
}

function notepad_mode (mode) {
	switch (mode) {
		case 'todo':
			$('#task-field').style.display = 'block';
			$('#d_d').style.display = 'block';
			$('#textarea-content').style.height = "74%";
			break;
		default:
			$('#task-field').style.display = 'none';
			$('#d_d').style.display = 'none';
			$('#textarea-content').style.height = "83%";
	}
}

function check_changes (){
	var data_buffer = notepad_data_buffer;

	var columns = [
		"note_title",
		"note_content",
		"task",
		"target_datetime",
		"is_done"
	];

	var notepad_data = {
		"note_title": $('#note-title-field').value,
		"note_text": $('#textarea-content').value,
		"task": $('#todo-task-field').value,
		"target_datetime": $('#todo-target-field').value,
		"is_done": $('#todo-is-done-field').checked ? 1 : 0
	};

	var input_data = {};

	for(var column in data_buffer) {
        if (notepad_data[column] != data_buffer[column] && data_buffer[column] !== undefined) {
        	input_data[column] = notepad_data[column];
        }
    }

	return input_data;
}

function fill_buffer(item_data){

	for(var column in notepad_data_buffer) {
		if (item_data[column] === null ) { item_data[column] = ""; }
		notepad_data_buffer[column] = item_data[column];
        
    }
}

function save_data (event) {
	var id = $('#note-title').dataset.id;
	var mode = $('#note-title').dataset.entity;

	var method = id > 0 ? 'PUT' : 'POST';
	var identifier = mode == 'note' ? 'id' : 'note_id';
	var input_data = check_changes();

	if (Object.keys(input_data).length === 0 && input_data.constructor === Object) {
		return 0;
	}

	var prepared_data = {
		"title": input_data.note_title,
		"content": input_data.note_text,
		"task": input_data.task,
		"target_datetime": input_data.target_datetime,
		"is_done": input_data.is_done
	};

	if (mode === 'note') {
		for(var column in prepared_data) {
			if (! ["content", "title"].includes(column)) {
				delete prepared_data[column];
			}
    	}
	}

	prepared_data = { "input_data": prepared_data };

	var action;
	var what_to_load = mode === 'note' ? load_notes_list_data : load_todos_list_data;

	switch (method) {
		case 'POST':
			action =  (xhr) => what_to_load();
			alert("File created");
			break;
		case 'PUT':
			action =  (xhr) => {
				if (mode === 'note'){
					load_one_note(id);
				} else {
					load_one_todo(id);
				}
				refresh_list();
			};
			alert("File updated");
			break;
		default:
			alert("Action can\'t be done. Wrong METHOD");
			return 0;
	}

	var url_path = id > 0 ? '/api/'+ mode +'s/'+id : '/api/'+ mode +'s';

	var promise = $.fetch(url_path, {
		"method": method,
		"data": JSON.stringify(prepared_data),
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	}).then(action, ()=>alert('Action can\'t be done.'));
}

function toggle_done (e){
	var is_done = e.target.checked ? 1 : 0;
	var method = is_done > 0 ? 'POST' : 'DELETE';
	var message = is_done > 0 ? 'It\'s marked as done' : 'It\'s marked as un-done';
	var id = e.target.closest('li').dataset.note_id;

	var promise = $.fetch('/api/todos/'+id+'/done', {
		"method": method,
		"data": null,
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	}).then((xhr)=>alert(message), ()=>alert('Request failed'));
}

