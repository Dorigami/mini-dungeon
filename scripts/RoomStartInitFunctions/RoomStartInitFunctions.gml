function room_start_init_playspace(){

}
function room_start_init_camera(_pos=[]){
	with(global.i_camera){
		var _vp = room_get_viewport(room, 0);
		
		resize();
		
		// set position if a vect2 was passed as a parameter
		if(array_length(_pos)==3){
			xTo = _pos[1];
			yTo = _pos[2];
			x = xTo;
			y = yTo;
		}
	}
}
