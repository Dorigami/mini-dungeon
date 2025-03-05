/// @description set up camera

function set_screen_partitions(){
	// get cam data
	var _vhw = viewWidthHalf;
	var _vhh = viewHeightHalf;
	var _x = -_vhw;
	var _y = -_vhh;
	// get playspace data
	var _playspace_hw = (global.playspace[2] - global.playspace[0]) div 2;
	var _playspace_hh = (global.playspace[3] - global.playspace[1]) div 2;
	var _top = -_vhh;
	var _bottom = _vhh;
	
	// set partition variables
	pt_clock = [0,0,0,0];
	pt_ui_buttons = [0,0,0,0];
	pt_turn_order = [0,0,0,0];
	pt_instructions = [0,0,0,0];
	pt_board = [0,0,0,0];
	if(global.i_engine.is_portrait){
		// calculate the partitions
		pt_clock[0] = -_vhw;
		pt_clock[1] = _top;
		pt_clock[2] = 0;
		pt_clock[3] = _top + clamp(floor((_vhh*2)*0.06),40,300);
		pt_ui_buttons[0] =  0;
		pt_ui_buttons[1] =_top;
		pt_ui_buttons[2] = _vhw;
		pt_ui_buttons[3] = _top + floor(clamp((_vhh*2)*0.06,40,300));
		pt_turn_order[0] = -_vhw;
		pt_turn_order[1] = pt_clock[3]+1;
		pt_turn_order[2] = 0;
		pt_turn_order[3] = pt_turn_order[1] + floor(clamp((_vhh*2)*0.24,0,300));
		pt_instructions[0] = 0;
		pt_instructions[1] = pt_ui_buttons[3]+1;
		pt_instructions[2] = _vhw;
		pt_instructions[3] = pt_instructions[1] + floor(clamp((_vhh*2)*0.24,0,300));
		pt_board[0] = -_vhw;
		pt_board[1] = pt_turn_order[3]+1;
		pt_board[2] = _vhw;
		pt_board[3] = _vhh;
	} else {
		// calculate the partitions
		pt_clock[0] = -_vhw;
		pt_clock[1] = _top;
		pt_clock[2] = -_playspace_hw;
		pt_clock[3] = _top + clamp((_vhh*2)*0.1,0,300);
		pt_ui_buttons[0] =  _playspace_hw;
		pt_ui_buttons[1] =_top;
		pt_ui_buttons[2] = _vhw;
		pt_ui_buttons[3] = _top + clamp((_vhh*2)*0.1,0,300);
		pt_turn_order[0] = -_vhw;
		pt_turn_order[1] = pt_clock[3]+1;
		pt_turn_order[2] = pt_clock[2];
		pt_turn_order[3] = _bottom;
		pt_instructions[0] = pt_ui_buttons[0];
		pt_instructions[1] = pt_ui_buttons[3]+1;
		pt_instructions[2] = _vhw;
		pt_instructions[3] = _bottom;
		pt_board[0] = pt_turn_order[2]+1;
		pt_board[1] = pt_ui_buttons[1];
		pt_board[2] = pt_ui_buttons[0]-1;
		pt_board[3] = pt_instructions[3];
	}
}

cam = view_camera[0];
bbox = [0,0,0,0];
follow = noone;
viewWidthHalf = 0.5*camera_get_view_width(cam);
viewHeightHalf = 0.5*camera_get_view_height(cam);

spd = 6;
spdFast = 12;

xTo = x;
yTo = y;
pan_rate = 0.15;
zoom_rate = 0.15;

shakeLength = 0;
shakeMagnitude = 0;
shakeRemain = 0;

cam_bounds = [0,0,0,0];
