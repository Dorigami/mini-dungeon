function getTilesetEdges(_tileset){
	// colors
	var _c_light = global.i_engine.color_light
	var _c_dark = global.i_engine.color_dark
	var _c_accent = global.i_engine.color_accent
	// this will take any sprite, and replace {c_black} with the {_color} parameter
	var _w = ceil(sqrt(3)*_hex_size);
	var _h = _hex_size*2;
	var _ox = _w div 2;
	var _oy = _h div 2;
	var _surface_w = _columns*_w + ((_rows>1)*_w div 2) + _hsep*_columns;
	var _surface_h = _h + ((_rows-1)*0.75*_h) + _vsep*_rows;
	var _surface = surface_create(_surface_w,_surface_h) ;
	var _new_sprite = -1;
	var i, j, _x, _y;
	
	// prep surface
	surface_set_target(_surface);
	draw_clear_alpha(c_black, 0);
	draw_set_color(c_white);
	draw_set_alpha(1.0);

	shader_set(sh_player_color);
	var _handle = global.i_engine.player_color_uni;
	var _color = global.i_engine.color_light;
	shader_set_uniform_f(_handle, color_get_red(_color)*1.0/255, color_get_green(_color)*1.0/255, color_get_blue(_color)*1.0/255);
	// draw each row
	for(i=0;i<_rows;i++){
		_y = (_vsep div 2) + (_h div 2) + (_h*0.75 + _vsep)*i;
		for(j=0;j<_columns;j++){
			_x = (_hsep div 2) + (_w div 2) + ((i%2)*(_w div 2)) + (_w+_hsep)*j;
			draw_sprite(_hex0,2,_x,_y);
			draw_sprite(_hex1,2,_x,_y);
		}
	}
	shader_reset();

	_new_sprite = sprite_create_from_surface(_surface, 0, 0, _surface_w, _surface_h, false, false, 0, 0);

	// cleanup
	surface_reset_target();
	surface_free(_surface);
	return _new_sprite;
}
