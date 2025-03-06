function getTilesetEdges(_tileset){
	var _ts_width = _tileset.width;
	var _ts_height = _tileset.height;
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

	// prep surface
	surface_set_target(_surface);
	draw_clear_alpha(c_black, 0);
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	draw_sprite(tmap_source_sprite,0,0,0);

	// go through each tile to read the colors at the edges, skip index 0 which is always empty
	for(k=1;k<_tile_count;k++){
		_col = k % _col_max;
		_row = k div _col_max;
		_ox = _col*(_tile_w + 2*_tile_hsep);
		_oy = _row*(_tile_h + 2*_tile_vsep);
		// loop through every pixel along each edge of the tile, codify the colors
		for(j = 0; j < 4; j++) {
			_str = "";
			_edge = array_create(4);
			switch(j){
				case EAST: 
					for(i = 0; i < _tile_h; i++) {
						_str += draw_getpixel(_ox+_tile_w,_oy+i) == c_white ? "1" : "0";
					}
					break;
				case NORTH: 
					for(i = 0; i < _tile_w; i++) {
						_str += draw_getpixel(_ox+i,_oy) == c_white ? "1" : "0";
					}
					break;
				case WEST: 
					for(i = 0; i < _tile_h; i++) {
						_str += draw_getpixel(_ox,_oy+i) == c_white ? "1" : "0";
					}
					break;
				case SOUTH: 
					for(i = 0; i < _tile_w; i++) {
						_str += draw_getpixel(_ox+i,_oy+_tile_h) == c_white ? "1" : "0";
					}
					break;
			}
			// add the edge code to this tile's array
			_edge[j] = _str;
		}
		show_debug_message("tile#{0} edges = {1}",k,_edge);
		// add the completed edge array to the array of edges
		array_push(_edges, _edge);
	}

	// cleanup
	surface_reset_target();
	surface_free(_surface);
	return _edges;
}
