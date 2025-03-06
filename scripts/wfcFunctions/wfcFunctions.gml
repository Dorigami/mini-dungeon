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
	CellWFC = function(_options, _col, _row) constructor{
		// Initialize the cell as not collapsed
		collapsed = false;
		checked = false;
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
				if (compareEdge(_tile.edges[2], edges[0])) {
				array_push(up,i);
				}
				// Check if the current tile's left edge matches this tile's right edge
				if (compareEdge(_tile.edges[3], edges[1])) {
				array_push(right,i);
				}
				// Check if the current tile's top edge matches this tile's bottom edge
				if (compareEdge(_tile.edges[0], edges[2])) {
				array_push(down,i);
				}
				// Check if the current tile's right edge matches this tile's left edge
				if (compareEdge(_tile.edges[1], edges[3])) {
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
  for(j = 0; j < _h; j++) {
  for(i = 0; i < _w; i++) {
	  // get the image
	  var _sprite = -1;
	  // encode edge pixel colors to use as edges for the wfc algorithm
	  var _edges = [];
	  // create the tile
      array_push(wfc_tiles, new TileWFC(i, _sprite, _edges));
      _count++;
  }}
  tiles = extractTiles(sourceImage);
  for (i=0;i<array_length(wfc_tiles);i++) {
	  wfc_tiles[i].calculateNeighbors(wfc_tiles)
  }

  // Initialize cells of the tilemap
  _count = 0;
  for(j = 0; j < _h; j++) {
  for(i = 0; i < _w; i++) {
      array_push(wfc_cells, new CellWFC(wfc_tiles, i, j));
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
    _checked = checkOptions(_cell, _rightCell, TRIGHT);
    if (_checked) { reduceEntropy(_grid, _rightCell, _depth + 1) }
  }

  // LEFT
  if (i - 1 >= 0) {
    _leftCell = _grid[i - 1 + j * _dim];
    _checked = checkOptions(_cell, _leftCell, TLEFT);
    if (_checked) { reduceEntropy(_grid, _leftCell, _depth + 1) }
  }

  // DOWN
  if (j + 1 < _dim) {
    _downCell = _grid[i + (j + 1) * _dim];
    _checked = checkOptions(_cell, _downCell, TDOWN);
    if (_checked) { reduceEntropy(_grid, _downCell, _depth + 1) }
  }

  // UP
  if (j - 1 >= 0) {
    _upCell = _grid[i + (j - 1) * _dim];
    _checked = checkOptions(_cell, _upCell, TUP);
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
		_validOptions = array_concat(_validOptions,tiles[_option].neighbors[_direction]);
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
