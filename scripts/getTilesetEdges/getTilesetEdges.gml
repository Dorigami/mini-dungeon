function getTilesetEdges(_source_sprite, _tileset){
	var _ts_width = sprite_get_width(_source_sprite);//_tileset.width;
	var _ts_height = sprite_get_height(_source_sprite);//_tileset.height;
	var _tile_w = _tileset.tile_width;
	var _tile_h = _tileset.tile_height;
	var _tile_hsep = _tileset.tile_horizontal_separator;
	var _tile_vsep = _tileset.tile_vertical_separator;
	var _tile_count = _tileset.tile_count;
	var _col_max = _ts_width div _tile_w;
	var _row_max = _ts_height div _tile_h;
	var _surface = surface_create(_ts_width,_ts_height) ;
	var _edge, _edges = [];
	var i, j, k, _x, _y, _ox, _oy, _col, _row, _str;
	var _alpha, _alpha_count=0;
	// prep surface
	surface_set_target(_surface);
	draw_clear_alpha(c_black, 0);
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	draw_sprite(_source_sprite,0,0,0);
	show_debug_message("tile:[{0},{1}] | cells:[{2},{3}]",_tile_w,_tile_h,_col_max,_row_max)
	// go through each tile to read the colors at the edges, skip index 0 which is always empty
	for(k=1;k<_tile_count;k++){
		_col = k % _col_max;
		_row = k div _col_max;
		_ox = _col*(_tile_w);
		_oy = _row*(_tile_h);
		// check the tile's alpha channel to determine if its empty or not
		// get alpha channel from the 32-bit color value representing the pixel
		// top-left
		_alpha = (surface_getpixel_ext(_surface,_ox,_oy) >> 24) & 255;
		_alpha_count += (_alpha == 0);
		// bottom-left
		_alpha = (surface_getpixel_ext(_surface,_ox,_oy+_tile_h-1) >> 24) & 255;
		_alpha_count += (_alpha == 0);
		// top-right
		_alpha = (surface_getpixel_ext(_surface,_ox+_tile_w-1,_oy) >> 24) & 255;
		_alpha_count += (_alpha == 0);
		// bottom-right
		_alpha = (surface_getpixel_ext(_surface,_ox+_tile_w-1,_oy+_tile_h-1) >> 24) & 255;
		_alpha_count += (_alpha == 0);
		// center
		_alpha = (surface_getpixel_ext(_surface,_ox+(_tile_w div 2),_oy+(_tile_h div 2)) >> 24) & 255;
		_alpha_count += (_alpha == 0);
		// final decision
		if(_alpha_count == 5){
			// give dummy edge if the tile is determined to be invalid
			show_debug_message("Tile {0} is not populated!", k);
			_edge = k;
		} else {
			// loop through every pixel along each edge of the tile, codify the colors
			_edge = array_create(4);
			for(j = 0; j < 4; j++) {
				_str = "";
				switch(j){
					case EAST: 
						for(i = 0; i < _tile_h; i++) {
							_str += (surface_getpixel(_surface,_ox+_tile_w-1,_oy+i) == c_white ? "1" : "0");
						}
						break;
					case NORTH: 
						for(i = 0; i < _tile_w; i++) {
							_str += surface_getpixel(_surface,_ox+i,_oy) == c_white ? "1" : "0";
						}
						break;
					case WEST: 
						for(i = 0; i < _tile_h; i++) {
							_str += surface_getpixel(_surface,_ox,_oy+_tile_h-1-i) == c_white ? "1" : "0";
						}
						break;
					case SOUTH: 
						for(i = 0; i < _tile_w; i++) {
							_str += surface_getpixel(_surface,_ox+_tile_w-1-i,_oy+_tile_h-1) == c_white ? "1" : "0";
						}
						break;
				}
				// add the edge code to this tile's array
				_edge[j] = _str;
			}
			// add the tile index to the edge array
			_edge[4] = k;
		}

		show_debug_message("tile#{0} [{2}, {3}] edges = {1} | [E, W, N, S]",k,_edge,_ox,_oy);
		// add the completed edge array to the array of edges
		array_push(_edges, _edge);
	}
	surface_save(_surface,working_directory+"tileset.png")
	// cleanup
	surface_reset_target();
	surface_free(_surface);
	return _edges;
}
