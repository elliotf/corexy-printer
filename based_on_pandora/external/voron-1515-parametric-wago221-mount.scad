include <BOSL2/std.scad>
include <BOSL2/screws.scad>

module wago_1515(blocks=[3,3,3]) {
  extrusion_side = 15;
  leave_room_for_plate_thickness = 3.3; // ~1/8" plus room
  screw_pos_z = extrusion_side/2-leave_room_for_plate_thickness; // 

  // Voron 1515 extrusion parametric Wago 221 mount
  // Based on the parametric Wago 221 mount by
  // Joo Chung, modified to match the Fusion 360 designed
  // part provided in the STL archive.
  //
  // https://www.thingiverse.com/thing:2075219
  //
  // Modified by MrRVK for 1515 extrusions.

  // ////////////////////////////////////////////////
  // vector of blocks. each element specifies the number of conductors for that block
  // EDIT THIS
  // blocks = [2,2];
  //blocks = [3, 3, 3]; // a set of 5 conductor, 3 conductor, 2 conductor blocks
  // blocks = [2,2,2,2,2]; // a single 5 conductor blocks 
  // blocks = [5, 3, 2]; // a set of 5 conductor, 3 conductor, 2 conductor blocks
  // blocks = [5, 5, 5]; // a set of three 5 conductor blocks
  // blocks = [2]; // a single 2 conductor block
  // blocks = [3]; // a single 3 conductor block

  // ////////////////////////////////////////////////
  // EDIT THIS: Set width and length of the tab. (tab is basically a square)
  tabwidth = 10;

  // ////////////////////////////////////////////////
  // Block dimensions in mm -- DO NOT EDIT
  conwidth = 5.6; // width of a single conductor
  // DO NOT EDIT
  border = 1.75; // block transparent plastic border
  // DO NOT EDIT
  blockdepth = 18.25;
  // DO NOT EDIT
  fudge = 0.2;

  // ////////////////////////////////////////////////
  // OpenSCAD special variables -- DO NOT EDIT
  $fa = 1;
  // DO NOT EDIT
  $fs = 0.4;

  // ////////////////////////////////////////////////
  // Functions
  function bw(x) = conwidth*x+border+fudge; // block width
  function mw(i, n) = ( i==0 ? bw(blocks[i]) + 2 + mw(i+1, n) : (i < n ? bw(blocks[i]) + 2 + mw(i+1, n) : 0)); // mount width (index, max index)

  total_length = mw(0,len(blocks)) + 2*tabwidth+2;
  total_depth = blockdepth + 2 + 2;

  module original(blocks) {
    translate([50,blockdepth+2+2+15/2,screw_pos_z]) {
      rotate([0,90,0]) {
        % difference() {
          cube([15,15,100],center=true);
          translate([0,-15/2,0]) {
            cube([3,3*2,200],center=true);
          }
        }
      }

      translate([0,-30-5,-15/2+3/2]) {
        % cube([200,30,3],center=true);
      }
    }

    // ////////////////////////////////////////////////
    // Modules
    module tab() {
        difference() {
            union() {
                back(blockdepth+4) right(4) cuboid([10,2,10],anchor=BOTTOM+BACK+LEFT);
                back(blockdepth+4) right(6) cuboid([10,4,2],anchor=BOTTOM+BACK+LEFT);
                back(blockdepth+4) cuboid([tabwidth,4,10],anchor=BOTTOM+BACK+LEFT,rounding=3,teardrop=true,except=[FRONT,BACK]);
            }
            down(0.1) back(blockdepth+4) cuboid([tabwidth+7,2,10],anchor=BOTTOM+FRONT+LEFT,chamfer=-0.6,edges=[BOTTOM]);
            up(screw_pos_z) right(tabwidth/2) back(blockdepth+2) screw_hole("M3,8",head="button",orient=FORWARD);
            down(0.1) right(tabwidth/2) back(blockdepth+1) cuboid([3,4,14],anchor=BOTTOM+BACK,chamfer=-0.6,edges=[BOTTOM]);
            up(screw_pos_z) right(tabwidth/2) back(blockdepth+1) cyl(d=6,h=7, orient=FORWARD,anchor=BOTTOM);
        }
    }

    module shoulder (depth) {
        difference () {
            union () {
                cuboid([2, blockdepth, 3.25], anchor=LEFT+BOTTOM+FRONT, chamfer=0.5,edges=[BOTTOM+LEFT]);
                translate([0,0,3.25]) cube([2.25, blockdepth, 2], false);
            }
            translate([0,0,2]) cube([2.25,2,3.25], false);
            translate([2,blockdepth-4,2]) cube([0.25,4,3.25], false);
        }
    }


    module backshoulder (height) {
        difference() {
            union() {  
                translate([0, 2, 0]) cuboid([2, 1.25, 10.15], anchor=LEFT+BOTTOM+FRONT, chamfer=0.5,edges=[BOTTOM]);
                cuboid([2.25, 2, 10.15], anchor=LEFT+BOTTOM+FRONT, chamfer=0.5,edges=[BOTTOM]);
            }
            translate([0,0,10.15-2]) cube([2.25,3.25,2]);
            translate([2,0,2]) cube([1.25,3.25,3.25]);
        }
    }



    // WAGO 221 block
    module block (nconn) {
        blockwidth = bw(nconn);

        // base
        translate([2,2,0]) cube([blockwidth, blockdepth, 2], false);
        
        // back headboard
        translate([0,blockdepth+2,0]) cuboid([blockwidth+4, 2, 10], anchor=LEFT+BOTTOM+FRONT, chamfer=0.5, edges=[BOTTOM+BACK,BOTTOM+RIGHT,BOTTOM+LEFT]);
        
        // front lip
        translate([0,0,0]) cuboid([blockwidth+4, 2, 2.5], anchor=LEFT+BOTTOM+FRONT, chamfer=0.5, edges=[BOTTOM+FRONT,BOTTOM+RIGHT,BOTTOM+LEFT]);

        // left shoulder and right shoulders
        translate([0,2,0]) shoulder();
        translate([blockwidth+4,2,0]) mirror([1,0,0]) shoulder(); 
        
        // back left and shoulder
        translate([0, blockdepth-1.25, 0]) backshoulder(); 
        translate([blockwidth+4, blockdepth -1.25, 0]) mirror([1,0,0]) backshoulder();
        
    }

    // ////////////////////////////////////////////////
    // MAIN BODY

    mountwidth=mw(0, len(blocks));
    // create array of blocks
    for (i=[0:len(blocks)-1]) {
        offset = (i==0) ? tabwidth : tabwidth + mw(0, i);
        translate([offset, 0, 0]) block(blocks[i]);
    }
    tab();
    translate([mountwidth+7+tabwidth+tabwidth/2,0,0]) mirror([1,0,0]) tab ();
  }

  // position the blocks so that their origin the middle of the mount and centered on the extrusion
  translate([-total_length/2,-total_depth,-screw_pos_z]) {
    original(blocks);
  }
}

// EDIT THIS
// blocks = [2,2];
//blocks = [3, 3, 3]; // a set of 5 conductor, 3 conductor, 2 conductor blocks
// blocks = [2,2,2,2,2]; // a single 5 conductor blocks 
// blocks = [5, 3, 2]; // a set of 5 conductor, 3 conductor, 2 conductor blocks
// blocks = [5, 5, 5]; // a set of three 5 conductor blocks
// blocks = [2]; // a single 2 conductor block
// blocks = [3]; // a single 3 conductor block
//wago_1515(blocks);
