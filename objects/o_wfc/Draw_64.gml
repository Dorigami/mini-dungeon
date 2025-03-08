/// @description 

var _state = time_source_get_state(wfc_time_source);

draw_set_alpha(1);
draw_set_color(c_white);
draw_text(5,5,"wfc_playing: " + (_state == 0 ? "inital" : (_state == 1 ? "active" : (_state == 2 ? "paused" : "stopped"))));

draw_text(5,20,"controls:\ni - [next frame]\no - [restart]\np - [toggle play]");

