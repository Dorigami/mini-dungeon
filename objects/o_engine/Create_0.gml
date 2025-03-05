/// @description initialize game

// Command is a struct returned by the inputHandler script to register inputs
Command = function(_type="", _value=undefined, _x=0, _y=0) constructor{
    type = _type;
    value = _value;
    x = _x;
    y = _y;
}

// OS system info
os = os_get_info();
os_keys  = ds_map_keys_to_array(os);
os_vals = ds_map_values_to_array(os);
show_debug_message("-- OS --");
for(var i=0; i<array_length(os_keys);i++){ show_debug_message("{2} - [{0}, {1}]",os_keys[i], os_vals[i], i) }
os_is_html5 = os == -1;
os_is_android = !is_undefined(os[? "android_tv"]);
os_is_windows = (!os_is_html5 && !os_is_android);
ds_map_destroy(os);
show_debug_message("---\nwindows: {0}\nandroid: {1}\nhtml5: {2}\n---", os_is_windows, os_is_android, os_is_html5);
	
init_display_flag = false;

// other global variables
global.i_engine = id;
global.i_camera = instance_create_depth(0, 0, LOWERDEPTH, o_camera);
global.game_state = GameStates.PLAY;
global.game_state_previous = global.game_state;
global.mouse_focus = noone;

menu_stack = ds_stack_create();
settings = settings_load_from_config();

// create the particles
ParticleSystemsInit();

// misc setup
randomize();
game_set_speed(FRAME_RATE, gamespeed_fps);
InitializeDisplay(1, true);

room_goto(ROOM_START);
