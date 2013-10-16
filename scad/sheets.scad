include <main.scad>;
use <lib/boxcutter/main.scad>;

module top_sheet() {
  module body() {
    box_side([top_sheet_width,top_sheet_depth],[2,2,2,2]);
  }

  module holes() {
    translate([-top_sheet_x,-top_sheet_y]) {
      cube([top_sheet_opening_width,top_sheet_opening_depth,sheet_thickness+1],center=true);
      translate([0,-top_sheet_depth/2,0])
        cube([top_sheet_opening_width,top_sheet_depth,sheet_thickness+1],center=true);

      for(side=[left,right]) {
        // y ends
        translate([y_rod_x*side,y_rod_len/2*front,-sheet_thickness/2])
          mirror([side+1,0,0])
            y_end_front_screw_holes(1-side);

        translate([y_rod_x*side,y_rod_len/2*rear,-sheet_thickness/2])
          mirror([side+1,0,0])
            y_end_rear_screw_holes();
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
    box_side([front_sheet_width,front_sheet_height],[1,2,2,2]);
  }

  module holes() {
    opening_width_bottom = top_sheet_opening_width-motor_side;
    bottom_height = front_sheet_height+z_axis_z;

    hull() {
      translate([0,front_sheet_height/2+sheet_thickness/2,0])
        cube([top_sheet_opening_width,sheet_thickness+1,sheet_thickness+1],center=true);
      translate([0,-front_sheet_height/2+bottom_height+sheet_thickness/2,0])
        cube([opening_width_bottom,sheet_thickness,sheet_thickness+1],center=true);
      //cube([top_sheet_opening_width,front_sheet_height-motor_side*1.5,sheet_thickness+1],center=true);
    }
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
    box_side([rear_sheet_width,rear_sheet_height],[1,2,2,2]);
  }

  module holes() {
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
