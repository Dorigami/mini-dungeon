/// @description handle wave function collapse

// get tilemap
tmap = layer_tilemap_get_id(layer_get_id("wfc_tiles_0"));
// resize tilemap to fit the room
tilemap_set_width(tmap, ceil(room_width / tilemap_get_tile_width(tmap)));
tilemap_set_height(tmap, ceil(room_height / tilemap_get_tile_height(tmap)));
// get tilemap data
tmap_ts = tileset_get_info(tilemap_get_tileset(tmap));
tmap_width = tilemap_get_width(tmap);
tmap_height = tilemap_get_height(tmap);
tmap_tile_count = tmap_width*tmap_height;
tmap_tile_width = tilemap_get_tile_width(tmap);
tmap_tile_height = tilemap_get_tile_height(tmap);
// get the name of the sprite used in the current tileset
var _name = tileset_get_name(tilemap_get_tileset(tmap))
tmap_source_sprite = asset_get_index(string_replace(_name,"ts_","s_"));
tmap_tile_weights = wfc_get_tile_weights(tmap_source_sprite, tmap_ts.tile_count);

var i,j;
if(!variable_instance_exists(id,"wfc_cells")){
	wfc_cells = array_create(tmap_tile_count);
}
if(!variable_instance_exists(id,"wfc_tiles")){
	wfc_tiles = [];
}
//tilemap_set_mask()
// the validOptions array is needed for the 'checkOptions function'
// due to scope issues, this cannot be a local var
validOptions = [];
loop_interval = floor(FRAME_RATE*0.05);
wfc_max_depth = 8;
wfc_complete = false;
wfc_time_source = time_source_create(time_source_game, 0.002, time_source_units_seconds, wfc,[id],-1);
wfc_recent_tile = -1;
// add constructors for the tiles and cells
InitCellWFC();
InitTileWFC();

wfc_setup();
