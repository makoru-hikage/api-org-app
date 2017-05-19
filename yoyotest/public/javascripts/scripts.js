
/* Ajax for notes*/
function load_list_data(search_filters){
	var promise = Bliss.fetch('/api/notes', {
		"method": "GET",
		"data": null,
		"headers": {
		    "Content-type": "application/json",
		    "X-requested-with": " XMLHttpRequest"
		}
	}).then((result)=>load_notes( result.data ));
}
function update_notes_list_data($id, $input_data){
	var promise = Bliss.fetch('/notes/' + $id, {
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
	var options = {
	  valueNames: [
	  	{ data: ['id'] },
	  	'note_title',
		'note_text',
		'creation_time'
	  ],
	  item: `<li class="sidebar-list-item">
				<div class="col-md-9">
					<span class="list-item-time timestamp creation_time"></span>
					<label class="list-item-title note_title">
						
					</label>
					<span class="list-item-sub note_text"></span> 
				</div>
				<div class="col-md-3 is-done-box"><input type="checkbox" class="is-done"><div>
			</li>`
	};

	var list = new List('sidebar-panel', options);
	list.add(list_data);


}

function load_todos(){

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
