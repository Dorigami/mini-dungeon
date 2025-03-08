// Reverse a string

function reverseString(s) {
	var _str="";
	var _ind = string_length(s);
	repeat(_ind){ _str += string_char_at(s,_ind--) }
	return _str;
}

// Compare if one edge matches the reverse of another
function compareEdge(a, b) {
  return a == reverseString(b);
}

function InitCellWFC(){
	CellWFC = function(_options, _col, _row, _index) constructor{
		creator = noone;
		with(o_wfc) other.creator = id;
		// Initialize the cell as not collapsed
		collapsed = false;
		checked = false;
		index = _index;
		col = _col;
		row = _row;
		// Is an array passed in?
		if (is_array(_options)) {
			// Set options to the provided array
			options = _options;
		} else {
			// Fill array with all the options (tile indexes)
			options = [];
			for(var i=0; i<array_length(creator.wfc_tiles); i++) { options[i] = creator.wfc_tiles[i].index }
		}
	}
}

function InitTileWFC(){
	TileWFC = function(_index, _sprite, _edges) constructor{
		creator = noone;
		with(o_wfc) other.creator = id;
	    edges = _edges;
		neighbors = [[],[],[],[]];
	    index = _index;
		// Analyze and find matching edges with other tiles
		static analyze = function(tiles) {
			if(index == 0) return;
			for (var i = 0; i < array_length(tiles); i++) {
				var _tile = tiles[i];
				var _inspect_index = 23;
				// Check if the current tile's bottom edge matches this tile's top edge
			//--//if(index == _inspect_index) show_debug_message("comparing {4} to {0}: match={3}\n{4}-N={1}\n{0}-S={2}",i, edges[NORTH], _tile.edges[SOUTH], compareEdge(_tile.edges[SOUTH], edges[NORTH]), _inspect_index);
				if (compareEdge(_tile.edges[SOUTH], edges[NORTH])) {
				array_push(neighbors[NORTH], _tile.index);
				}
				// Check if the current tile's left edge matches this tile's right edge
			//--//if(index == _inspect_index) show_debug_message("comparing {4} to {0}: match={3}\n{4}-E={1}\n{0}-W={2}",i, edges[EAST], _tile.edges[WEST], compareEdge(_tile.edges[WEST], edges[EAST]), _inspect_index);
				if (compareEdge(_tile.edges[WEST], edges[EAST])) {
				array_push(neighbors[EAST], _tile.index);
				}
				// Check if the current tile's top edge matches this tile's bottom edge
			//--//if(index == _inspect_index) show_debug_message("comparing {4} to {0}: match={3}\n{4}-S={1}\n{0}-N={2}",i, edges[SOUTH], _tile.edges[NORTH], compareEdge(_tile.edges[NORTH], edges[SOUTH]), _inspect_index);
				if (compareEdge(_tile.edges[NORTH], edges[SOUTH])) {
				array_push(neighbors[SOUTH], _tile.index);
				}
				// Check if the current tile's right edge matches this tile's left edge
			//--//if(index == _inspect_index) show_debug_message("comparing {4} to {0}: match={3}\n{4}-W={1}\n{0}-E={2}",i, edges[WEST], _tile.edges[EAST], compareEdge(_tile.edges[EAST], edges[WEST]), _inspect_index);
				if (compareEdge(_tile.edges[EAST], edges[WEST])) {
				array_push(neighbors[WEST], _tile.index);
				}
			}
			/*
			show_debug_message("neighbors for tile {0}: {1} | [E, W, N, S]", index, neighbors);
			if(index == _inspect_index){
				show_debug_message("neighbors for tile {0} E: {1}", index, neighbors[EAST]);
				show_debug_message("neighbors for tile {0} W: {1}", index, neighbors[WEST]);
				show_debug_message("neighbors for tile {0} N: {1}", index, neighbors[NORTH]);
				show_debug_message("neighbors for tile {0} S: {1}", index, neighbors[SOUTH]);
			}
			*/
		}
	}
}

function wfc(_id) {
	with(_id){
		// Make a (shallow) copy of grid &
		// Remove any collapsed cells from the copy
		var _gridCopy = array_filter(wfc_cells, function(a, ind){ return !a.collapsed});
		//show_debug_message("count of non-collapsed cells: {0}", array_length(_gridCopy));
		// We're done if all cells are collapsed!
		if (array_length(_gridCopy) == 0) {
			time_source_stop(wfc_time_source);
			wfc_recent_tile = -1;
			wfc_complete = true;
			exit;
		}
		// uncheck the cells
		for(var i=0;i<array_length(_gridCopy);i++){
			_gridCopy[i].checked = false;
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
		//show_debug_message("min entropy: {0} | stopIndex: {1}", _len, stopIndex);
		// Randomly select one of the lowest entropy cells to collapse
		var _cell = _gridCopy[max(0,irandom(stopIndex-1))];
		_cell.collapsed = true;

		if(array_length(_cell.options) == 0){wfc_start_over(); time_source_start(wfc_time_source) exit;}
		// Choose one option randomly from the cell's options
		var _rand_ind = irandom(max(0,array_length(_cell.options)-1));
		var _pick = _cell.options[_rand_ind];
	//--//show_debug_message("cell[{0},{1}] = opt:{2} | pick:{3}", _cell.col, _cell.row, _cell.options, _pick);
		// If there are no possible tiles that fit there!
		if (_pick == undefined) {
			wfc_complete = true;
			wfc_recent_tile = -1;
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
		
		// set bbox for recent tile
		wfc_recent_tile = [
			_cell.col*tmap_tile_width,
			_cell.row*tmap_tile_height,
			_cell.col*tmap_tile_width + tmap_tile_width,
			_cell.row*tmap_tile_height + tmap_tile_height
		];
	}
}

function wfc_setup() {
	// Extract tiles and calculate their adjacencies
	var i, j, _w = tmap_width, _h = tmap_height;
	var _count = 0;
	// encode edge pixel colors to use as edges for the wfc algorithm
	// the edges array contains the edge codes for each edge for each tile
	var _tile_edges = getTilesetEdges(tmap_source_sprite, tmap_ts);
	//show_debug_message("tile edges:\n{0}",_tile_edges);
	// add a dummy tile to fill index 0
	array_push(wfc_tiles, new TileWFC(0, -1, [[""],[""],[""],[""]]));
	for(i = 1; i < 1 + array_length(_tile_edges); i++) {// index 0 is always empty, so skip it
		// get the image
		var _sprite = -1;
		// create the tile
		array_push(wfc_tiles, new TileWFC(i, _sprite, _tile_edges[i-1]));
	}
	// determine the valid neighbors for each tile
	for (i=0;i<array_length(wfc_tiles);i++) {
		wfc_tiles[i].analyze(wfc_tiles);
	}

	// Initialize cells of the tilemap
	_count = 0;
	for(j = 0; j < _h; j++) {
	for(i = 0; i < _w; i++) {
		if(!is_instanceof(wfc_cells[_count], CellWFC)){
			wfc_cells[_count] = new CellWFC(0, i, j, _count);
		}
		_count++;
	}}

	// Perform initial wave function collapse step
	wfc(id);
	time_source_start(wfc_time_source);
}
function wfc_start_over(){
	show_debug_message("--- starting over ---")
	var i, j, _w = tmap_width, _h = tmap_height;
	var _count = 0;
	for(j = 0; j < _h; j++) {
	for(i = 0; i < _w; i++) {
		if(is_instanceof(wfc_cells[_count], CellWFC)){ delete wfc_cells[_count]; }
		wfc_cells[_count] = new CellWFC(0, i, j, _count);
		_count++;
		tilemap_set(tmap, 0, i, j);
	}}
	time_source_reset(wfc_time_source);
}
function reduceEntropy(_grid, _cell, _depth) {
  var _dim = tmap_width; 
  var _checked;
  var _rightCell,_leftCell,_upCell,_downCell;
  // Stop propagation if max depth is reached
  if (_depth > wfc_max_depth) return;
  
  // Or if cell is already checked
  if (_cell.checked) return;
  
  // Set the cell to be checked
  _cell.checked = true;

  // Update neighboring cells based on adjacency rules
  if (_cell.col + 1 < _dim) { // RIGHT
    _rightCell = _grid[_cell.col + 1 + _cell.row * _dim];
    _checked = checkOptions(_cell, _rightCell, EAST);
    if (_checked) { reduceEntropy(_grid, _rightCell, _depth + 1) }
  }

  if (_cell.col - 1 >= 0) { // LEFT
    _leftCell = _grid[_cell.col - 1 + _cell.row * _dim];
    _checked = checkOptions(_cell, _leftCell, WEST);
    if (_checked) { reduceEntropy(_grid, _leftCell, _depth + 1) }
  }
  
  if (_cell.row + 1 < _dim) { // DOWN
    _downCell = _grid[_cell.col + (_cell.row + 1) * _dim];
    _checked = checkOptions(_cell, _downCell, SOUTH);
    if (_checked) { reduceEntropy(_grid, _downCell, _depth + 1) }
  }

  if (_cell.row - 1 >= 0) { // UP
    _upCell = _grid[_cell.col + (_cell.row - 1) * _dim];
    _checked = checkOptions(_cell, _upCell, NORTH);
    if (_checked) { reduceEntropy(_grid, _upCell, _depth + 1) }
  }
}

function checkOptions(_cell, _neighbor, _direction) {
	//show_debug_message("cell's options: {0}", _cell.options);
	// If it's a valid non-collapsed neighbor
	if (_neighbor && !_neighbor.collapsed) {
		// Collect valid options based on the current cell's adjacency rules
		validOptions = [];
		for(var i=0;i<array_length(_cell.options);i++){
			var _option = _cell.options[i];
			validOptions = array_concat(validOptions, wfc_tiles[_option].neighbors[_direction]);
			//show_debug_message("tile's neighbors for index {0}: {1}",_option, wfc_tiles[_option].neighbors[_direction]);
		}
		//show_debug_message("validOptions at [{0},{1}] due {3}: {2}",_cell.col,_cell.row,validOptions, _direction == NORTH ? "NORTH" : (_direction == SOUTH ? "SOUTH" : (_direction == EAST ? "EAST" : "WEST")));
		// Filter the neighbor's options to retain only those that are valid
		_neighbor.options = array_filter(
			_neighbor.options,
			function(elem){
				return array_contains(validOptions,elem);
			}
		);
		// Return true if the options were successfully reduced
		return true;
	} else {
		// Return false if the neighbor is already collapsed or invalid
		return false;
	}
}
