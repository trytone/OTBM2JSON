/*
 * Example script of using the otbm2json library
 * Changes all tiles on a map to chessboard pattern in global coordinates
 */

var fs = require('fs');

const otbm2json = require("../lib/otbm2json");

// Read the map data using the otbm2json library
const mapData = otbm2json.read("../map.otbm");

// Go over all nodes
mapData.data.nodes.forEach(function(a) {
	
  a.features.forEach(function(b) {
	 
	// Save z coordinate
	var tileAreaX = b.x;
	var tileAreaY = b.y;
	
	var cordZ = b.z;
		
    // Skip anything that is not a tile area
    if(b.type !== otbm2json.HEADERS.OTBM_TILE_AREA) return; 
	
    // For each tile area; go over all actual tiles
    b.tiles.forEach(function(c) {
		
      // Skip anything that is not a tile (e.g. house tiles)
      if(c.type !== otbm2json.HEADERS.OTBM_TILE) return;
	  
	  // Save x and y coordinates
	  var cordX = tileAreaX + c.x;
	  var cordY = tileAreaY + c.y;
	  	
      if(c.tileid && c.tileid !== 0){
	
		  fs.appendFileSync("../output/tiles.csv", cordX + ";" + cordY + ";" + cordZ + ";" + c.tileid + "\n", function (err) {});
		  		  
		  if(c.items){
			
			  c.items.forEach(function(d) {
				  // Save ITEM into CSV
				  fs.appendFileSync("../output/items.csv", cordX + ";" + cordY + ";" + cordZ + ";" + d.id + "\n", function (err) {});
			  });
		  }
	  } else {
		   c.items.forEach(function(d) {
			   
			   if(d.type == otbm2json.HEADERS.OTBM_ITEM){

				   // Save ITEM into CSV
				   fs.appendFileSync("../output/items.csv", cordX + ";" + cordY + ";" + cordZ + ";" + d.id + "\n", function (err) {});
			   }
	
		   });
	  }
	  
    });
		
  });

});
