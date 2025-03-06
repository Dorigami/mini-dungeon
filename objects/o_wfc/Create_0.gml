/// @description handle wave function collapse

function wfc() {
	var i;
  // Make a (shallow) copy of grid &
  // Remove any collapsed cells from the copy
  var _gridCopy = array_filter(wfc_cells, function(a){return !a.collapsed});

  // We're done if all cells are collapsed!
  if (array_length(gridCopy) == 0) {
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
  for (i = 1; i < array_length(_gridCopy); i++) {
    if (array_length(gridCopy[i].options) > _len) {
      stopIndex = i;
      break;
    }
  }
  if (stopIndex > 0) array_copy(_gridCopy,0,_gridCopy,0,stopIndex+1);

  // Randomly select one of the lowest entropy cells to collapse
  var _cell = gridCopy[max(0,irandom(_len-1))];
  _cell.collapsed = true;

  // Choose one option randomly from the cell's options
  var _pick = _cell.options[irandom(max(0,array_length(cell.options)-1))];
  
  // If there are no possible tiles that fit there!
  if (_pick == undefined) {
	show_debug_message("ran into a conflict");
    exit;
  }
  
  // Set the file tile
  _cell.options = [_pick];

  // Propagate entropy reduction to neighbors
  reduceEntropy(wfc_cells, _cell, 0);
}

tmap_sprite = Terrain;
tmap = layer_tilemap_get_id(layer_get_id("wfc_tiles_0"));
tmap_ts = tileset_get_info(tilemap_get_tileset(tmap));
tmap_width = tilemap_get_width(tmap);
tmap_height = tilemap_get_height(tmap);
tmap_tile_count = tmap_width*tmap_height;
tmap_tile_width = tilemap_get_tile_width(tmap);
tmap_tile_height = tilemap_get_tile_height(tmap);
show_debug_message("tilemap = {0}",tmap);
var i,j;
show_debug_message("height={0} | width={1} | count={2}",tmap_height,tmap_width,tmap_tile_count);
// set tiles randomly
for(j=0;j<tmap_height;j++){
for(i=0;i<tmap_width;i++){
	tilemap_set(tmap,irandom(tmap_ts.tile_count-1),i,j);
}}

if(!variable_instance_exists(id,"wfc_cells")){
	wfc_cells = array_create(tmap_tile_count);
}
if(!variable_instance_exists(id,"wfc_tiles")){
	wfc_tiles = [];
}
wfc_max_depth = 5;
// add constructors for the tiles and cells
InitCellWFC();
InitTileWFC();

wfc_setup();

/* source code
// Source image
let sourceImage;
// Tiles extracted from the source image
let tiles;
// Number of cells along one dimension of the grid
let DIM = 40;
// Maximum depth for recursive checking of cells
let maxDepth = 5;
// Grid of cells for the Wave Function Collapse algorithm
let grid = [];

function preload() {
  sourceImage = loadImage("images/city.png");
}

function setup() {
  createCanvas(400, 400);

  // Extract tiles and calculate their adjacencies
  let w = width / DIM;
  tiles = extractTiles(sourceImage);
  for (let tile of tiles) {
    tile.calculateNeighbors(tiles);
  }

  // Initialize the grid with cells
  let count = 0;
  for (let j = 0; j < DIM; j++) {
    for (let i = 0; i < DIM; i++) {
      grid.push(new Cell(tiles, i * w, j * w, w, count));
      count++;
    }
  }

  // Perform initial wave function collapse step
  wfc();
}

function draw() {
  background(0);
  
  // Width of each cell on the grid
  let w = width / DIM;

  // Show the grid
  for (let i = 0; i < grid.length; i++) {
    grid[i].show();
    // Reset all cells to "unchecked"
    grid[i].checked = false;
  }

  // Run Wave Function Collapse!
  wfc();
}


// The Wave Function Collapse algorithm
function wfc() {

  // Make a (shallow) copy of grid
  let gridCopy = grid.slice();

  // Remove any collapsed cells from the copy
  gridCopy = gridCopy.filter((a) => !a.collapsed);

  // We're done if all cells are collapsed!
  if (gridCopy.length == 0) {
    noLoop();
    return;
  }

  // Sort cells by "entropy"
  // (simplified formula of number of possible options left)
  gridCopy.sort((a, b) => {
    return a.options.length - b.options.length;
  });

  // Identify all cells with the lowest entropy
  let len = gridCopy[0].options.length;
  let stopIndex = 0;
  for (let i = 1; i < gridCopy.length; i++) {
    if (gridCopy[i].options.length > len) {
      stopIndex = i;
      break;
    }
  }
  if (stopIndex > 0) gridCopy.splice(stopIndex);

  // Randomly select one of the lowest entropy cells to collapse
  const cell = random(gridCopy);
  cell.collapsed = true;

  // Choose one option randomly from the cell's options
  const pick = random(cell.options);
  
  // If there are no possible tiles that fit there!
  if (pick == undefined) {
    console.log("ran into a conflict");
    noLoop();
    return;
  }
  
  // Set the file tile
  cell.options = [pick];

  // Propagate entropy reduction to neighbors
  reduceEntropy(grid, cell, 0);
}

function reduceEntropy(grid, cell, depth) {
  // Stop propagation if max depth is reached
  if (depth > maxDepth) return;
  
  // Or if cell is already checked
  if (cell.checked) return;
  
  // Set the cell to be checked
  cell.checked = true;

  
  // Find the cell  
  let index = cell.index;
  let i = floor(index % DIM);
  let j = floor(index / DIM);

  // Update neighboring cells based on adjacency rules

  // RIGHT
  if (i + 1 < DIM) {
    let rightCell = grid[i + 1 + j * DIM];
    let checked = checkOptions(cell, rightCell, TRIGHT);
    if (checked) {
      reduceEntropy(grid, rightCell, depth + 1);
    }
  }

  // LEFT
  if (i - 1 >= 0) {
    let leftCell = grid[i - 1 + j * DIM];
    let checked = checkOptions(cell, leftCell, TLEFT);
    if (checked) {
      reduceEntropy(grid, leftCell, depth + 1);
    }
  }

  // DOWN
  if (j + 1 < DIM) {
    let downCell = grid[i + (j + 1) * DIM];
    let checked = checkOptions(cell, downCell, TDOWN);
    if (checked) {
      reduceEntropy(grid, downCell, depth + 1);
    }
  }

  // UP
  if (j - 1 >= 0) {
    let upCell = grid[i + (j - 1) * DIM];
    let checked = checkOptions(cell, upCell, TUP);
    if (checked) {
      reduceEntropy(grid, upCell, depth + 1);
    }
  }
}

function checkOptions(cell, neighbor, direction) {
  // If it's a valid non-collapsed neighbord
  if (neighbor && !neighbor.collapsed) {
    // Collect valid options based on the current cell's adjacency rules
    let validOptions = [];
    for (let option of cell.options) {
      validOptions = validOptions.concat(tiles[option].neighbors[direction]);
    }

    // Filter the neighbor's options to retain only those that are valid
    neighbor.options = neighbor.options.filter((elt) =>
      validOptions.includes(elt)
    );

    // Return true if the options were successfully reduced
    return true;
  } else {
    // Return false if the neighbor is already collapsed or invalid
    return false;
  }
}
////////  THE CELL  ///////////
class Cell {
  constructor(value) {
    // Initialize the cell as not collapsed
    this.collapsed = false;
    // Is an array passed in?
    if (value instanceof Array) {
      // Set options to the provided array
      this.options = value;
    } else {
      // Fill array with all the options
      this.options = [];
      for (let i = 0; i < value; i++) {
        this.options[i] = i;
      }
    }
  }
}
//////////  THE TILE  ////////////
// Reverse a string
function reverseString(s) {
  let arr = s.split('');
  arr = arr.reverse();
  return arr.join('');
}

// Compare if one edge matches the reverse of another
function compareEdge(a, b) {
  return a == reverseString(b);
}

// Class for each tile
class Tile {
  constructor(img, edges, i) {
    this.img = img;
    this.edges = edges;
    this.up = [];
    this.right = [];
    this.down = [];
    this.left = [];

    if (i !== undefined) {
      this.index = i;
    }
  }

  // Analyze and find matching edges with other tiles
  analyze(tiles) {
    for (let i = 0; i < tiles.length; i++) {
      let tile = tiles[i];

      // Skip if both tiles are tile 5
      if (tile.index == 5 && this.index == 5) continue;

      // Check if the current tile's bottom edge matches this tile's top edge
      if (compareEdge(tile.edges[2], this.edges[0])) {
        this.up.push(i);
      }
      // Check if the current tile's left edge matches this tile's right edge
      if (compareEdge(tile.edges[3], this.edges[1])) {
        this.right.push(i);
      }
      // Check if the current tile's top edge matches this tile's bottom edge
      if (compareEdge(tile.edges[0], this.edges[2])) {
        this.down.push(i);
      }
      // Check if the current tile's right edge matches this tile's left edge
      if (compareEdge(tile.edges[1], this.edges[3])) {
        this.left.push(i);
      }
    }
  }

  // Rotate the tile image and edges
  rotate(num) {
    const w = this.img.width;
    const h = this.img.height;
    const newImg = createGraphics(w, h);
    newImg.imageMode(CENTER);
    newImg.translate(w / 2, h / 2);
    newImg.rotate(HALF_PI * num);
    newImg.image(this.img, 0, 0);

    const newEdges = [];
    const len = this.edges.length;
    for (let i = 0; i < len; i++) {
      newEdges[i] = this.edges[(i - num + len) % len];
    }
    return new Tile(newImg, newEdges, this.index);
  }
}
*/