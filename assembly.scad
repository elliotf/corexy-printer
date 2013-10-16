// 13.25 outer
// 12.25 mid
// 11.25 inner

include <main.scad>;
include <sheet_plates.scad>;
include <scad/z_axis.scad>;
use <inc/jhead.scad>;

translate([0,0,0]) y_end_front_screw_holes();

module old_z_carriage() {
  carriage_height = bearing_len*2+min_material_thickness*3;
  carriage_height = lm10uu_bearing_len*2+min_material_thickness*3;
  carriage_width  = bearing_diam*2;
  carriage_depth  = bearing_diam+min_material_thickness*2;

  x_support_len = build_x + carriage_width*2;
  x_support_len = z_motor_x*2-bearing_diam;
  x_support_y = carriage_depth/2+sheet_thickness/2;

  y_support_x = z_rod_x - carriage_width - sheet_thickness/2;
  y_support_len = heatbed_depth + sheet_min_width;

  xy_support_height = 50;
  xy_support_z = -sheet_thickness/2-xy_support_height/2;

  support_slot_height = xy_support_height/4;
  support_slots = [xy_support_height/2-xy_support_height/8,-xy_support_height/4+xy_support_height/8];

  module z_carriage_bearing_holder() {
    module body() {
      translate([carriage_width/2,0,0])
        cube([carriage_width,carriage_depth,carriage_height],center=true);
    }

    module holes() {
      // zip ties
      bearing_offset_z = carriage_height/2-bearing_len/2-min_material_thickness;
      for(side=[-1,1]) {
        translate([0,0,bearing_offset_z*side]) rotate([90,0,0]) {
          bearing_zip_tie();
        }
      }

      // bearing shaft
      cylinder(r=bearing_diam/2,h=carriage_height+1,center=true);
    }

    module bearing_supports() {
      for(side=[top,bottom]) {
        for(z=[carriage_height/2-min_material_thickness/2,carriage_height/2-min_material_thickness*1.5-bearing_len]) {
          translate([bearing_diam/2,0,z*side]) cube([min_material_thickness,bearing_diam,min_material_thickness],center=true);
        }
      }
    }

    translate([0,0,-carriage_height/2]) {
      difference() {
        body();
        holes();
      }
      bearing_supports();
    }
  }

  for(side=[left,right]) {
    // x support
    % translate([0,x_support_y*side,xy_support_z]) {
      difference() {
        cube([x_support_len,sheet_thickness,xy_support_height],center=true);

        for(side=[left,right]) {
          for(z=support_slots) {
            translate([(x_support_len/2+bearing_diam/2)*side,0,z]) {
              cube([(carriage_width+sheet_thickness+0.05)*2,sheet_thickness+1,support_slot_height+0.05],center=true);
            }
          }
        }
      }
    }

    // y support
    % translate([y_support_x*side,0,xy_support_z]) {
      difference() {
        cube([sheet_thickness,y_support_len,xy_support_height],center=true);

        for(side=[left,right]) {
          for(z=support_slots) {
            translate([0,x_support_y*side,z*-1]) {
              cube([sheet_thickness+1,sheet_thickness+0.05,support_slot_height+0.05],center=true);
            }
          }
        }
      }
    }

    // main sheet
    % cube([heatbed_width+5,y_support_len,sheet_thickness],center=true);

    // motor
    //color("blue",.5) translate([z_motor_x*side,(carriage_depth/2+sheet_thickness+z_motor_side/2)*side,0]) nema14();

    translate([0,0,0]) {
    }

    /*
    */

    translate([z_motor_x*side,0,-sheet_thickness/2]) mirror([side+1,0,0]) {
      z_carriage_bearing_holder();
    }
  }
}

/*
for(side=[left,right]) {
  //color("blue", .5) translate([z_motor_x*side,z_motor_y*side,z_motor_z]) motor();
  color("blue",.6) translate([z_motor_x*side,0,0]) {
    translate([0,z_motor_y*side,z_motor_z]) motor();
    //translate([0,z_motor_y*side,z_motor_z]) motor();
    translate([0,0,z_rod_z])
      cylinder(r=rod_diam/2,h=z_rod_len,center=true);
  }
}
*/

//color("Turquoise") translate([0,0,z_carriage_z]) z_carriage();

translate([0,build_y*.0,0]) {
  // x carriage
  translate([build_x*-.0,0,x_rod_z]) {
    x_carriage();
    //% translate([0,0,-x_rod_z+hotend_len/2]) cylinder(r=hotend_diam/2,h=hotend_len,center=true);
    //% translate([0,0,-x_rod_z+hotend_len/2]) rotate([180,0,0]) hotend_jhead();
    translate([0,0,-x_rod_z+hotend_len/2+4.6+4.7]) rotate([180,0,0]) hotend_jhead();
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

// y end front
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
