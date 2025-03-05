/// @description 
function Update(){
	depth = ENTITYDEPTH - 0.3*y;
	// update position relative to the gui layer
	if(visible){
		gui_x = position[1] - camera_get_view_x(view_camera[0]);
		gui_y = position[2] - camera_get_view_y(view_camera[0]);
	}
	
	// animate
	var _idle_lim = 0.6;
	var _move_lim = 0.8;
	var _spd = vect_len(velocity);
	var _dir = vect_direction(velocity);
    var _theta = 5; // this value will determine a deadzone where the sprite cannot flip their scaling
	if(spr_idle != -1)
	{
        if(_spd <= _idle_lim)
        {
            if(sprite_index != spr_idle) 
            {
                sprite_index = spr_idle;
                image_index = 0;
                image_speed = 1;
            }
		} else if(_spd > _move_lim){
            if(sprite_index != spr_move) 
            {
                sprite_index = spr_move;
                image_index = 0;
                image_speed = 1;
            }
        }
	}
	x = position[1];
	y = position[2];
}

// movement & position variables
hex = vect2(0,0);
hex_prev = hex;
hex_path_list = ds_list_create();
position = vect2(xstart,ystart);
velocity = vect2(0,0);
xTo = position[1];
yTo = position[2]; 
z = 0;

//animation
spr_idle = variable_instance_exists(id, "spr_idle") ? spr_idle : -1;
spr_move = -1;
spr_attack = -1;
spr_death = -1;

// data bars that display over-head
gui_x = 0;
gui_y = 0;
