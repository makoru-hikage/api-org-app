
/* Ajax for notes*/
function load_notes_list_data(){
	var promise = $.fetch('/api/notes', {
		"method": "GET",
		"data": null,
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	}).then((xhr)=>load_notes(JSON.parse(xhr.response).data), ()=>alert('aw'));
}

/* Ajax for todos*/
function load_todos_list_data(){
	var promise = $.fetch('/api/todos', {
		"method": "GET",
		"data": null,
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	}).then((xhr)=>load_todos(JSON.parse(xhr.response).data), ()=>alert('aw'));
}

function update_notes_list_data($id, $input_data){
	var promise = $.fetch('/notes/' + $id, {
		"method": "PUT",
		"data": { "input_data": $input_data }
	}).then((result)=>load_notes( result.data ));
}

function create_list_data($input_data){
	var promise = $.fetch('/notes', {
		"method": "POST",
		"data": { "input_data": $input_data }
	}).then();
}

function delete_list_data($id){
	var promise = $.fetch('/notes' + $id, {
		"method": "DELETE",
	}).then();
}



/* Conversions */
function convert_to_todo(){

}

function convert_to_note(){

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
					<label class="list-item-title note_title">
						
					</label>
					<span class="list-item-sub note_text"></span> 
				</div>
				<div class="col-md-3 is-done-box"><div>
			</li>`
	};

	var list = new List('sidebar-panel', options);
	list.add(list_data);

}

function load_todos(list_data){
	
	$('#sidebar-list-items').innerHTML = '';
	
	var options = {
	  valueNames: [
	  	{ data: ['note_id'] },
	  	"task",
		"due_time",
		"task_started",
		"creation_time",
		"username",
		"note_title",
		{ name:"is_done", attr: "value"}
	  ],
	  item: `<li class="sidebar-list-item">
				<div class="col-md-9">
					<span class="list-item-time timestamp creation_time"></span>
					<span class="list-item-sub due_time"></span> 
					<label class="list-item-title task">
					</label>
					
				</div>
				<div class="col-md-3 is-done-box"><input class="is_done" type="checkbox" name="is_done" ><div>
			</li>`,
		indexAsync : true
	};

	var list = new List('sidebar-panel', options);

	list.add(list_data);

	$$('.sidebar-list-item .is-done-box .is_done').forEach( (item) => {
		if (item.value > 0){ item.checked = "true"; }
	});
}

function add_item(){

}

function remove_item(){

}

function update_item(){

}

/* GUI events */
function switch_to_todos(){

}

function edit_note_window(){

}

function new_note_window(){

}

function load_done_checkbox(e){
	var is_done = e.target.value > 0;
	if (is_done){
		e.target.checked = true;
	}
}

