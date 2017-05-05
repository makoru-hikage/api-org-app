
/* Ajax for notes*/
function load_list_data($search_filters){
	var promise = $.fetch('/notes', {
		"method": "GET",
		"data": { "search_filters": $search_filters }
	}).then();
}
function update_list_data($id, $input_data){
	var promise = $.fetch('/notes/' + $id, {
		"method": "PUT",
		"data": { "input_data": $input_data }
	}).then();
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

/* User authentication*/
function user_login(){

}

function user_logout(){

}

/* GUI Item list functions */
function load_notes($items){
	var options = {
	  valueNames: [
	  	{ data: ['id'] },
	  	'note_title',
		'note_text',
		'creation_time'
	  ],
	  item: `<li class="sidebar-list-item">
				<div class="col-md-12 list-item-info">
					<span class="list-item-sub timestamp creation_time">I'm the timestamp</span>
					<span class="list-item-title note_title"></span> 
					<span class="list-item-sub">I'm the sub</span> 
				</div>	
			</li>`
	};

	var $list = new List(list_sidebar, options);

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
