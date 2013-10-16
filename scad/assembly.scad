// bearing groove spacing for LM6UU
// 13.25 outer
// 12.25 mid
// 11.25 inner

include <main.scad>;
include <sheets.scad>;
include <z_axis.scad>;
use <inc/jhead.scad>;

// xy gantry
translate([0,build_y*.0,0]) {
  // x carriage
  translate([build_x*-.0,0,x_rod_z]) {
    x_carriage();
  }

  // X rods
  color("grey", .5) for(side=[-1,1]) {
    translate([0,(side*x_rod_spacing/2),x_rod_z]) rotate([0,90,0]) rotate([0,0,22.5]) cylinder(r=da8*rod_diam+0.05,h=x_rod_len,center=true,$fn=8);
  }

  // y carriage
  for(side=[left,right]) {
    translate([y_rod_x*side,0,y_rod_z]) mirror([side+1,0,0]) {
      y_carriage(1-side);

      for(end=[front,rear]) {
        % translate([0,y_carriage_bearing_y*end,0]) bearing();
      }
    }
  }
}

// y ends
for(side=[left,right]) {
  translate([y_rod_x*side,y_rod_len/2*front,y_rod_z]) mirror([side+1,0,0]) y_end_front(1-side);
  translate([y_rod_x*side,y_rod_len/2*rear,y_rod_z]) mirror([side+1,0,0]) y_end_rear(1-side);
}

// shift one line's bearings up or down to avoid rubbing?
color("red",0.5) idlers();
color("red",0.5) line();
color("green",0.5) mirror([1,0,0]) idlers();
color("green",0.5) mirror([1,0,0]) line();

// top plate
module plates() {
  top_plate_width = y_rod_x*2+sheet_min_width;
  top_plate_depth = y_rod_len+sheet_min_width+motor_side;

  echo("top plate width/depth: ", top_plate_width, "/", top_plate_depth);

  build_top = x_rod_z-(hotend_len-10);
  echo("BUILD TOP: ", build_top);

  side_depth = top_plate_depth;
  side_height = build_z+sheet_min_width*2;
  side_height = side_panel_height;
  front_back_width = y_rod_x*2-sheet_thickness;

  side_z = -side_height/2-sheet_thickness;

  top_plate();

  // front plate
  front_opening_width  = x_rod_len-x_carriage_width;
  front_opening_width  = build_x+x_carriage_width/2;
  front_opening_height = build_z+motor_len/2;
  translate([0,(y_rod_len/2-y_end_screw_hole_y)*front,side_z]) {
    difference() {
      cube([front_back_width,sheet_thickness,side_height],center=true);
      //cube([front_back_width-sheet_min_width*2,sheet_thickness+1,side_height-sheet_min_width*2],center=true);
      //translate([0,0,-side_z]) cube([front_opening_width,sheet_thickness+1,front_opening_height*2],center=true);
      hull() {
        translate([0,0,side_height/2])
          cube([front_opening_width,sheet_thickness+1,1],center=true);
        translate([0,0,-front_opening_height/4])
          cube([build_x*.8,sheet_thickness+1,1],center=true);
      }
    }
  }

  // rear plate
  translate([0,(y_rod_len/2-y_end_screw_hole_y)*rear,side_z]) {
    cube([front_back_width,sheet_thickness,side_height],center=true);
  }

  // side plates
  for(side=[left,right]) {
    translate([side_sheet_x*side,top_sheet_y,side_z]) {
      difference() {
        cube([sheet_thickness,side_depth,side_height],center=true);

        translate([0,-motor_side/4,0])
          cube([sheet_thickness+1,y_rod_len-y_end_screw_hole_y*2-sheet_min_width,build_z],center=true);
      }
    }
  }
}

color("Khaki", 0.5) plates();

//# translate([0,0,x_rod_z-build_z/2-40])
% translate([0,0,bed_zero+build_z/2]) cube([build_x,build_y,build_z],center=true);
//color("red") translate([0,0,bed_zero-heatbed_thickness/2]) heatbed();

// rods
color("grey", .5) {
  // Y
  for(side=[-1,1]) {
    translate([side*y_rod_x,0,y_rod_z]) rotate([90,0,0]) rotate([0,0,22.5])
      cylinder(r=da8*rod_diam,h=y_rod_len,center=true,$fn=8);
  }
}

// power supply
/*
translate([0,xy_motor_y,-sheet_thickness-spacer-psu_length/2]) rotate([90,0,0])
  % cube([psu_width,psu_length,psu_height],center=true);
  */
