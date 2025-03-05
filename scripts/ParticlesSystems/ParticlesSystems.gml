function ParticleSystemsInit(){
	/*
	ptsys_confetti = 0;
	ConfettiInit();
	ptsys_win_puff = 0;
	WinPuffInit();
	*/
}
function ConfettiInit(){
	with(global.i_engine)
	{
		if(!part_system_exists(ptsys_confetti)) ptsys_confetti = part_system_create();
		
		part_system_depth(ptsys_confetti,UPPERDEPTH);
		pt_confetti = part_type_create();
		part_type_scale(pt_confetti,0.05,0.015);
		part_type_shape(pt_confetti, pt_shape_square);
		part_type_size(pt_confetti,2,4,0,0);
		part_type_color3(pt_confetti,color_light,color_dark,color_accent);
		part_type_life(pt_confetti,220,300);
		part_type_alpha3(pt_confetti,1,0.9,0.0);
		part_type_gravity(pt_confetti, 0.4, 270);
	    part_type_direction(pt_confetti, -45, 225, 0, 60);
		part_type_orientation(pt_confetti,0,0,0,30,false);
	    part_type_speed(pt_confetti, 20, 40, -0.8, 0);
	}
}
function ConfettiCreate(_x,_y,_direction,_sep=1,_horizontal_spread=1,_vertical_spread=1,_pt_count=1){
	with(global.i_engine){
		var _col_len = array_length(color_player)-1;
		if(!is_undefined(_direction)){
			part_type_direction(pt_confetti, _direction-45, _direction+45, 0, 30);
		}
		repeat(_pt_count){
			var _col = color_player[irandom(_col_len)];
			part_type_color2(pt_confetti,_col,color_light);
			part_particles_create(
				ptsys_confetti, 
				_x+_sep*random_range(-_horizontal_spread,_horizontal_spread), 
				_y+_sep*random_range(-_vertical_spread,_vertical_spread), 
				pt_confetti,
				1);
		}
	}
}
function WinPuffInit(){
	with(global.i_engine)
	{
		if(!part_system_exists(ptsys_win_puff)) ptsys_win_puff = part_system_create();
		
		part_system_depth(ptsys_win_puff,UPPERDEPTH-100);
		pt_win_puff = part_type_create();
		part_type_scale(pt_win_puff,0.05,0.05);
		part_type_shape(pt_win_puff, pt_shape_square);
		part_type_size(pt_win_puff,4,4,0,0);
		part_type_life(pt_win_puff,(FRAME_RATE)*0.6,(FRAME_RATE)*0.6);
		part_type_alpha3(pt_win_puff,1,0.9,0.0);
		part_type_orientation(pt_win_puff,0,0,0,50,false);
	    part_type_speed(pt_win_puff, 20, 20, -1.6, 0);
	}
}
function WinPuffCreate(_x,_y,_color,_speed=20){
	with(global.i_engine){
		var _col_len = array_length(color_player)-1;
		var _pt_count = 10;
		var _ang, _ang_inc = 360 div _pt_count;
		part_type_color1(pt_win_puff,_color);
		part_type_speed(pt_win_puff,_speed,_speed,0,0);
		for(var i=0;i<_pt_count;i++){
			_ang = _ang_inc*i;
			part_type_direction(pt_win_puff, _ang, _ang, 0, 0);
			part_particles_create(ptsys_win_puff, _x, _y, pt_win_puff, 1);
		}
	}
}