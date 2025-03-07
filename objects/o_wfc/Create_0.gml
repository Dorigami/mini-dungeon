/// @description handle wave function collapse

function wfc(_id) {
	with(_id){
		// Make a (shallow) copy of grid &
		// Remove any collapsed cells from the copy
		var _gridCopy = array_filter(wfc_cells, function(a, ind){ return !a.collapsed});
		show_debug_message("count of non-collapsed cells: {0}", array_length(_gridCopy));
		// We're done if all cells are collapsed!
		if (array_length(_gridCopy) == 0) {
			time_source_stop(wfc_time_source);
			wfc_complete = true;
			exit;
		}

		// Sort cells by "entropy"
		// (simplified formula of number of possible options left)
		array_sort(_gridCopy,function(a,b){
			return array_length(a.options) - array_length(b.options)}
		);

		// Identify all cells with the lowest entropy
		var _len = array_length(_gridCopy[0].options);
		var stopIndex = 0;
		for (var i = 1; i < array_length(_gridCopy); i++) {
			if (array_length(_gridCopy[i].options) > _len) {
			    stopIndex = i;
			    break;
			}
		}
		if (stopIndex > 0) array_copy(_gridCopy,0,_gridCopy,0,stopIndex);
		show_debug_message("min entropy: {0} | stopIndex: {1}", _len, stopIndex);
		// Randomly select one of the lowest entropy cells to collapse
		var _cell = _gridCopy[max(0,irandom(stopIndex-1))];
		_cell.collapsed = true;

		if(array_length(_cell.options) == 0){wfc_start_over(); exit;}
		// Choose one option randomly from the cell's options
		show_debug_message("cell = {0}",_cell);
		var _rand_ind = irandom(max(0,array_length(_cell.options)-1));
		var _pick = _cell.options[_rand_ind];
  
		// If there are no possible tiles that fit there!
		if (_pick == undefined) {
			wfc_complete = true;
			time_source_stop(wfc_time_source);
			show_debug_message("ran into a conflict");
			exit;
		}
  
		// Set the file tile
		_cell.options = [_pick];

		// set the tile for the room's tile layer
		tilemap_set(tmap, _pick, _cell.col, _cell.row);
	
		// Propagate entropy reduction to neighbors
		reduceEntropy(wfc_cells, _cell, 0);
	}
}

tmap_source_sprite = s_small_tiles;
tmap = layer_tilemap_get_id(layer_get_id("wfc_tiles_0"));
tmap_ts = tileset_get_info(tilemap_get_tileset(tmap));
tmap_width = tilemap_get_width(tmap);
tmap_height = tilemap_get_height(tmap);
tmap_tile_count = tmap_width*tmap_height;
tmap_tile_width = tilemap_get_tile_width(tmap);
tmap_tile_height = tilemap_get_tile_height(tmap);
show_debug_message("tilemap = {0}",tmap);

// the validOptions array is needed for the 'checkOptions function'
// due to scope issues, this cannot be a local var
validOptions = [];
loop_interval = floor(FRAME_RATE*0.05);

var i,j;
show_debug_message("height={0} | width={1} | count={2}",tmap_height,tmap_width,tmap_tile_count);
/*
// set tiles randomly
for(j=0;j<tmap_height;j++){
for(i=0;i<tmap_width;i++){
	tilemap_set(tmap,irandom(tmap_ts.tile_count-1),i,j);
}}
*/
if(!variable_instance_exists(id,"wfc_cells")){
	wfc_cells = array_create(tmap_tile_count);
}
if(!variable_instance_exists(id,"wfc_tiles")){
	wfc_tiles = [];
}
wfc_max_depth = 3;
wfc_complete = false;
wfc_time_source = time_source_create(time_source_game, 0.01, time_source_units_seconds, wfc,[id],-1);
// add constructors for the tiles and cells
InitCellWFC();
InitTileWFC();

wfc_setup();
