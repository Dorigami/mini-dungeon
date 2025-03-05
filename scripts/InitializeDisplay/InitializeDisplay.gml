function InitializeDisplay(_zoom=1, _lock_width=true){
	// dynamic resolution
	var i, d; 
	with(o_engine){
		var _display_asp = display_get_width()/display_get_height();
		var _asp = settings.resolution[1]/settings.resolution[2]; //settings.resolution[1] / settings.resolution[2];
		show_debug_message("Initialize Display: [{0}x{1}] asp ratio = {2}", settings.resolution[1], settings.resolution[2], _asp);
		if(_lock_width){
			idealWidth = min(display_get_width(),settings[$ "resolution"][1]); // RESOLUTION_W;
			idealHeight = round(idealWidth / _asp);
		} else {
			idealHeight = min(display_get_height(),settings[$ "resolution"][2]); // RESOLUTION_H;
			idealWidth = round(idealHeight*_asp);
		}

		// perfect pixel scaling
		if(display_get_width() mod idealWidth != 0)
		{
			d = round(display_get_width() / idealWidth);
			idealWidth = display_get_width() / d;
		}
		if(display_get_height() mod idealHeight != 0)
		{
			d = round(display_get_height() / idealHeight);
			idealHeight = display_get_height() / d;
		}

		//check for odd numbers
		if(idealWidth & 1) idealWidth++;
		if(idealHeight & 1) idealHeight++;

		//do the zoom
		zoom = _zoom; // 1, 2, or 3
		zoomMax = floor(display_get_width() / idealWidth);
		zoom = min(zoom, zoomMax);
		view_zoom = 1;
	
		// enable & set views of each room
		for(i=0; i<=100; i++)
		{
			if(!room_exists(i)) break;
			show_debug_message(room_get_name(i)+" has been initialized")
			if(i == 30){show_message("update display initialize, there are too many rooms")}
			room_set_view_enabled(i, true);
			room_set_viewport(i,0,true,0,0,idealWidth, idealHeight);
		}
		// set timer to center window
		if(!init_display_flag){
			alarm[0] = 2;
		}

		surface_resize(application_surface, idealWidth, idealHeight);
		display_set_gui_size(idealWidth, idealHeight);
		window_set_size(idealWidth*zoom, idealHeight*zoom);
	}
}