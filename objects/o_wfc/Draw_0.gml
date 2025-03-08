/// @description 

draw_set_color(c_fuchsia);
draw_set_alpha(1);
draw_rectangle(0, 0, room_width, room_height, true);
// highlight the most recent tile change
if(wfc_recent_tile != -1){
	draw_rectangle(wfc_recent_tile[0],wfc_recent_tile[1],wfc_recent_tile[2],wfc_recent_tile[3],true);
}
