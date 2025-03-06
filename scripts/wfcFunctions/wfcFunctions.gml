// Reverse a string

function reverseString(s) {
  var _str="",arr = string_split(s,"");
  arr = array_reverse(arr);
  for(var i=0;i<array_length(arr);i++){ _str += arr[i] }
  return _str;
}

// Compare if one edge matches the reverse of another
function compareEdge(a, b) {
  return a == reverseString(b);
}

function InitCellWFC(){
	CellWFC = function(_options, _col, _row, _index) constructor{
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
			for(var i=0; i<array_length(wfc_tiles); i++) { options[i] = i }
		}
	}
}

function InitTileWFC(){
	TileWFC = function(_index, _sprite, _edges) constructor{
	    edges = _edges;
	    up = [];
	    right = [];
	    down = [];
	    left = [];
	    index = _index;
		// Analyze and find matching edges with other tiles
		static analyze = function(tiles) {
			for (var i = 0; i < array_length(tiles); i++) {
				var _tile = tiles[i];
				// Skip if both tiles are tile 5
				if (_tile.index == 5 && index == 5) continue;
				// Check if the current tile's bottom edge matches this tile's top edge
				if (compareEdge(_tile.edges[SOUTH], edges[NORTH])) {
				array_push(up,i);
				}
				// Check if the current tile's left edge matches this tile's right edge
				if (compareEdge(_tile.edges[WEST], edges[EAST])) {
				array_push(right,i);
				}
				// Check if the current tile's top edge matches this tile's bottom edge
				if (compareEdge(_tile.edges[NORTH], edges[SOUTH])) {
				array_push(down,i);
				}
				// Check if the current tile's right edge matches this tile's left edge
				if (compareEdge(_tile.edges[EAST], edges[WEST])) {
				array_push(left,i);
				}
			}
		}
		static calculateNeighbors = function(_tiles){
			
		}
	}
}
function wfc_setup() {
	// Extract tiles and calculate their adjacencies
	var i, j, _w = tmap_width, _h = tmap_height;
	var _count = 0;
	// encode edge pixel colors to use as edges for the wfc algorithm
	// the edges array contains the edge codes for each edge for each tile
	var _tile_edges = getTilesetEdges(tmap_ts);
	show_debug_message("tileset tile = {0}", tmap_ts.tile_count);
	for(i = 0; i < array_length(_tile_edges); i++) {// index 0 is always empty, so skip it
		// get the image
		var _sprite = -1;
		// create the tile
		array_push(wfc_tiles, new TileWFC(i, _sprite, _tile_edges[i]));
	}
	// determine the valid neighbors for each tile
	for (i=0;i<array_length(wfc_tiles);i++) {
		wfc_tiles[i].calculateNeighbors(wfc_tiles);
	}

	// Initialize cells of the tilemap
	_count = 0;
	for(j = 0; j < _h; j++) {
	for(i = 0; i < _w; i++) {
		if(!is_instanceof(wfc_cells[_count], CellWFC)){
			wfc_cells[_count] = new CellWFC(wfc_tiles, i, j, _count);
		}
		_count++;
	}}

	// Perform initial wave function collapse step
	wfc();
}

function reduceEntropy(_grid, _cell, _depth) {
  var _dim = tmap_width; 
  var i,j,_ind,_checked;
  var _rightCell,_leftCell,_upCell,_downCell;
  // Stop propagation if max depth is reached
  if (_depth > wfc_max_depth) return;
  
  // Or if cell is already checked
  if (_cell.checked) return;
  
  // Set the cell to be checked
  _cell.checked = true;

  
  // Find the cell  
  _ind = _cell.index;
  i = floor(_ind % _dim);
  j = floor(_ind / _dim);

  // Update neighboring cells based on adjacency rules

  // RIGHT
  if (i + 1 < _dim) {
    _rightCell = _grid[i + 1 + j * _dim];
    _checked = checkOptions(_cell, _rightCell, EAST);
    if (_checked) { reduceEntropy(_grid, _rightCell, _depth + 1) }
  }

  // LEFT
  if (i - 1 >= 0) {
    _leftCell = _grid[i - 1 + j * _dim];
    _checked = checkOptions(_cell, _leftCell, WEST);
    if (_checked) { reduceEntropy(_grid, _leftCell, _depth + 1) }
  }

  // DOWN
  if (j + 1 < _dim) {
    _downCell = _grid[i + (j + 1) * _dim];
    _checked = checkOptions(_cell, _downCell, SOUTH);
    if (_checked) { reduceEntropy(_grid, _downCell, _depth + 1) }
  }

  // UP
  if (j - 1 >= 0) {
    _upCell = _grid[i + (j - 1) * _dim];
    _checked = checkOptions(_cell, _upCell, NORTH);
    if (_checked) { reduceEntropy(_grid, _upCell, _depth + 1) }
  }
}

function checkOptions(_cell, _neighbor, _direction) {
  // If it's a valid non-collapsed neighbor
  if (_neighbor && !_neighbor.collapsed) {
    // Collect valid options based on the current cell's adjacency rules
    var _validOptions = [];
	for(var i=0;i<array_length(_cell.options);i++){
		var _option = _cell.options[i];
		_validOptions = array_concat(_validOptions, wfc_tiles[_option].neighbors[_direction]);
	}

    // Filter the neighbor's options to retain only those that are valid
	_neighbor.options = array_filter(
		_neighbor.options,
		function(elem,ind,_validOptions){
			return array_contains_ext(_validOptions,elem,true);
		}
	);
    // Return true if the options were successfully reduced
    return true;
  } else {
    // Return false if the neighbor is already collapsed or invalid
    return false;
  }
}
