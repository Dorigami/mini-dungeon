/// @description 
with(global.i_engine){
	var _menu = ds_stack_top(menu_stack);
	if(_menu == other.id){
		show_debug_message("menu destroy: {0} [{1}]", _menu, (is_undefined(_menu) || !instance_exists(_menu)) ?"null": object_get_name(_menu.object_index));
		// remove from stack
		ds_stack_pop(global.i_engine.menu_stack);
		// set alarm in the next menu to delay accepting input
		var _next_menu = ds_stack_top(global.i_engine.menu_stack);
		if(!is_undefined(_next_menu) && instance_exists(_next_menu)){ _next_menu.alarm[0] = 2; }
		// update the engine's draw depth
		var _inst = ds_stack_top(menu_stack);
		if(ds_stack_size(menu_stack) > 0 && !is_undefined(_inst) && instance_exists(_inst)){
				depth = _inst.depth+3;
		} else {
			depth = LOWERDEPTH;
		}
		image_alpha = 1;
	}
}

