/// @description set up camera

function resize(){
	var _zoom = global.i_engine.zoom;
	var _vp = room_get_viewport(room,0);
	show_debug_message("--resizing camera--")
	show_debug_message("FROM: viewport: [{0},{1}] | camera: [{2},{3}] | halfDim: [{4},{5}]",	
			_vp[3],
			_vp[4],
			camera_get_view_width(view_camera[0]),
			camera_get_view_height(view_camera[0]),
			viewWidthHalf,viewHeightHalf);
			
	// update camera sizing
	cam = view_camera[0];
	viewWidthHalf = camera_get_view_width(cam) div 2;
	viewHeightHalf = camera_get_view_height(cam) div 2;
	
	show_debug_message("TO  : viewport: [{0},{1}] | camera: [{2},{3}] | halfDim: [{4},{5}]",
			_vp[3],
			_vp[4],
			camera_get_view_width(view_camera[0]),
			camera_get_view_height(view_camera[0]),
			viewWidthHalf,viewHeightHalf);
	show_debug_message("-------------------");
}

follow = noone;
cam = view_camera[0];
viewWidthHalf = camera_get_view_width(cam) div 2;
viewHeightHalf = camera_get_view_height(cam) div 2;

spd = 6;
spdFast = 12;

xTo = x;
yTo = y;
pan_rate = 0.15;
zoom_rate = 0.15;

shakeLength = 0;
shakeMagnitude = 0;
shakeRemain = 0;

