/// @description handle wave function collapse

tmap = layer_tilemap_get_id(layer_get_id("wfc_tiles_0"));
tmap_ts = tileset_get_info(tilemap_get_tileset(tmap));
tmap_width = tilemap_get_width(tmap);
tmap_height = tilemap_get_height(tmap);
tmap_tile_count = tmap_width*tmap_height;
tmap_tile_width = tilemap_get_tile_width(tmap);
tmap_tile_height = tilemap_get_tile_height(tmap);
// get the name of the sprite used in the current tileset
var _name = tileset_get_name(tilemap_get_tileset(tmap))
tmap_source_sprite = asset_get_index(string_replace(_name,"ts_","s_"));

var i,j;
show_debug_message("height={0} | width={1} | count={2}",tmap_height,tmap_width,tmap_tile_count);

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
wfc_max_depth = 4;
wfc_complete = false;
wfc_time_source = time_source_create(time_source_game, 0.002, time_source_units_seconds, wfc,[id],-1);
wfc_recent_tile = -1;
// add constructors for the tiles and cells
InitCellWFC();
InitTileWFC();

wfc_setup();
