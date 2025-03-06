/// @description 

if(keyboard_check_pressed(vk_space)){
	var _s = {
		wfc_cells: wfc_cells,
		wfc_tiles: wfc_tiles
	}
	instance_create_depth(x,y,depth,o_wfc,_s);
	instance_destroy();
}
