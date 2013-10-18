include <main.scad>;
use <lib/boxcutter/main.scad>;

module top_sheet() {
  module body() {
    box_side([top_sheet_width,top_sheet_depth],[1,2,1,2]);
  }

  module holes() {
    translate([-top_sheet_x,-top_sheet_y]) {
      cube([top_sheet_opening_width,top_sheet_opening_depth,sheet_thickness+1],center=true);

      /*
      translate([0,-top_sheet_depth/2,0])
        cube([top_sheet_opening_width,top_sheet_depth,sheet_thickness+1],center=true);
      */

      for(side=[left,right]) {
        for(end=[front,rear]) {
          translate([y_rod_x*side,(y_rod_len/2-y_clamp_len/2)*end,0]) {
            for(side=[left,right]) {
              translate([screw_pad_hole_spacing/2*side,0,0]) hole(sheet_screw_diam,sheet_thickness+1,12);
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
                cylinder(r=motor_screw_diam/2,h=sheet_thickness+1,center=true);
            }
          }

          cylinder(r=motor_hole_spacing*.4,h=sheet_thickness+1,center=true);
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
