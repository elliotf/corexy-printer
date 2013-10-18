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

  color("grey", .5) for(side=[-1,1]) {
    // x rods
    translate([0,(side*x_rod_spacing/2),x_rod_z]) rotate([0,90,0]) rotate([0,0,22.5])
      cylinder(r=da8*rod_diam+0.05,h=x_rod_len,center=true,$fn=8);
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
  translate([y_rod_x*side,y_rod_len/2*front,y_rod_z]) mirror([side+1,0,0]) rotate([90,0,0]) y_end_front(1-side);
  translate([y_rod_x*side,y_rod_len/2*rear,y_rod_z]) mirror([side+1,0,0]) y_end_rear(side);

  // y rods
  % translate([side*y_rod_x,0,y_rod_z]) rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=da8*rod_diam,h=y_rod_len,center=true,$fn=8);
}

// shift one line's bearings up or down to avoid rubbing?
color("red",0.5) idlers(-1);
color("red",0.5) mirror([1,0,0]) line(-1);
color("green",0.5) mirror([1,0,0]) idlers(1);
color("green",0.5) line(1);

module box_sides() {
  translate([top_sheet_x,top_sheet_y,top_sheet_z]) top_sheet();

  translate([front_sheet_x,front_sheet_y,front_sheet_z])
    rotate([90,0,0])
      front_sheet();

  translate([rear_sheet_x,rear_sheet_y,rear_sheet_z])
    rotate([90,0,0])
      rear_sheet();

  for(side=[left,right]) {
    translate([side_sheet_x*side,side_sheet_y,side_sheet_z])
      rotate([0,0,90]) rotate([90,0,0])
        side_sheet();
  }

  translate([bottom_sheet_x,bottom_sheet_y,bottom_sheet_z])
    bottom_sheet();
}

//color("Khaki", 0.5) box_sides();
color("Khaki") box_sides();

% translate([0,0,bed_zero+build_z/2]) cube([build_x,build_y,build_z],center=true);

// power supply
/*
translate([0,xy_motor_y,-sheet_thickness-spacer-psu_length/2]) rotate([90,0,0])
  % cube([psu_width,psu_length,psu_height],center=true);
  */
