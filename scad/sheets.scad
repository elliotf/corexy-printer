include <config.scad>;
include <positions.scad>;
use <util.scad>;
use <lib/boxcutter/main.scad>;

module top_sheet() {
  module body() {
    box_side([top_sheet_width,top_sheet_depth],[1,2,1,2]);
  }

  module holes() {
    translate([-top_sheet_x,-top_sheet_y]) {
      cube([top_sheet_opening_width,top_sheet_opening_depth,sheet_thickness+1],center=true);

      /*
      // make top front open
      translate([0,-top_sheet_depth/2,0])
        cube([top_sheet_opening_width,top_sheet_depth,sheet_thickness+1],center=true);
      */

      for(side=[left,right]) {
        for(end=[front,rear]) {
          translate([z_rod_x*side,0,0]) {
            hole(z_rod_diam,sheet_thickness+1,sheet_hole_resolution);
          }

          translate([y_rod_x*side,(y_rod_len/2-y_clamp_len/2)*end,0]) {
            for(side=[left,right]) {
              translate([screw_pad_hole_spacing/2*side,0,0])
                hole(sheet_screw_diam,sheet_thickness+1,sheet_hole_resolution);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module front_sheet() {
  module body() {
    box_side([front_sheet_width,front_sheet_height],[2,2,2,2]);
  }

  module holes() {
    translate([0,motor_side/4,0])
      cube([top_sheet_opening_width,front_sheet_height-motor_side*2,sheet_thickness+1],center=true);

    /*
    // make top front open
    opening_width_bottom = top_sheet_opening_width-motor_side;
    bottom_height = front_sheet_height+z_axis_z;

    hull() {
      translate([0,front_sheet_height/2+sheet_thickness,0])
        cube([top_sheet_opening_width,sheet_thickness*2,sheet_thickness+1],center=true);

      translate([0,-front_sheet_height/2+bottom_height+sheet_thickness/2,0])
        cube([opening_width_bottom,sheet_thickness,sheet_thickness+1],center=true);
      //cube([top_sheet_opening_width,front_sheet_height-motor_side*1.5,sheet_thickness+1],center=true);
    }
    */
  }

  difference() {
    body();
    holes();
  }
}

module side_sheet() {
  module body() {
    box_side([side_sheet_depth,side_sheet_height],[1,1,2,1]);
  }

  module holes() {
    cube([side_sheet_depth-motor_side*2,side_sheet_height-motor_side*2,sheet_thickness+1],center=true);
  }

  difference() {
    body();
    holes();
  }
}

module rear_sheet() {
  module body() {
    box_side([rear_sheet_width,rear_sheet_height],[2,2,2,2]);
  }

  module holes() {
    translate([0,rear_sheet_height/2+sheet_thickness,0]) {
      for(side=[left,right]) {
        // motor
        translate([xy_motor_x*side,xy_motor_z,0]) {
          for(x=[-1,1]) {
            for(y=[-1,1]) {
              translate([motor_hole_spacing/2*x,motor_hole_spacing/2*y,0])
                hole(motor_screw_diam,sheet_thickness+1,sheet_hole_resolution);
            }
          }

          hole(motor_hole_spacing*.8,sheet_thickness+1,sheet_hole_resolution);
        }

        // pulley idler
        translate([xy_pulley_idler_x*side,xy_pulley_idler_z,0]) {
          hole(xy_pulley_idler_hole,sheet_thickness+1,sheet_hole_resolution);

          for(x=[-1,1]) {
            translate([screw_pad_hole_spacing/2*x,-motor_hole_spacing/2,0])
              hole(sheet_screw_diam,sheet_thickness+1,sheet_hole_resolution);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module bottom_sheet() {
  module body() {
    box_side([bottom_sheet_width,bottom_sheet_depth],[1,1,1,1]);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module box_sides() {
  translate([top_sheet_x,top_sheet_y,top_sheet_z]) top_sheet();

  /*
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

  */
}

box_sides();
