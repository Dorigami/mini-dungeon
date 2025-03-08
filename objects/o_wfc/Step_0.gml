/// @description 

if(keyboard_check_pressed(ord("I"))){
	if(time_source_get_state(wfc_time_source) != time_source_state_active) wfc(id); 
}
if(keyboard_check_pressed(ord("O"))){
	wfc_start_over();
}
if(keyboard_check_pressed(ord("P"))){
	switch(time_source_get_state(wfc_time_source)){
		case time_source_state_initial:
			time_source_start(wfc_time_source);
			break;
		case time_source_state_active:
			time_source_pause(wfc_time_source);
			break;
		case time_source_state_paused:
			time_source_resume(wfc_time_source);
			break;
		case time_source_state_stopped:
			//time_source_start(wfc_time_source);
			break;
	}
}

if(keyboard_check_pressed(vk_space)){
	var _s = {
		wfc_cells: wfc_cells,
		wfc_tiles: wfc_tiles
	}
	instance_create_depth(x,y,depth,o_wfc,_s);
	instance_destroy();
}
