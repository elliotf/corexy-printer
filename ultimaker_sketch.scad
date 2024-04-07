include <config.scad>;
include <positions.scad>;
include <boxcutter.scad>;
use <util.scad>;
use <belt_retainer.scad>;

sheet_thickness      = 5;
belt_width           = 6;
dimensions           = 200;
side_len             = dimensions+motor_side;
spacer               = 1;
motor_pos_y          = side_len/2*front;
belt_idler_diam      = 10;
belt_idler_thickness = 8;
belt_idler_spacer    = 0.5;
belt_idler_dist      = belt_idler_thickness+belt_idler_spacer;
motor_pos_z          = -belt_idler_dist*1.5-sheet_thickness;
belt_pos_x           = side_len/2+z_pulley_diam - belt_thickness/2;
motor_pos_x          = belt_pos_x + belt_thickness/2 + z_pulley_diam/2;

z_motor_pos_x = 0;

xy_carriage_width = 12 + 2;
xy_rod_diam   = 8;
xy_rod_length = dimensions+xy_carriage_width+sheet_thickness*2+3;
rod_dist      = dimensions;
belt_pulley_teeth = 20;
belt_pulley_pitch = 2;
belt_pulley_diam  = (belt_pulley_teeth*belt_pulley_pitch)/2/pi;
xy_sheet_pos      = xy_rod_length/2 - sheet_thickness/2;
xy_motor_pos          = xy_sheet_pos+sheet_thickness/2;
xy_motor_pos_from_end = rod_dist/2-motor_side/2;
xy_motor_rod_dist_z   = -motor_hole_spacing/2-bearing_623_diam-belt_pulley_diam;

module assembly() {
  z_motor_pos_y = -motor_pos_y;
  z_motor_pos_z = -dimensions;

  sheet_sides = xy_sheet_pos*2+sheet_thickness;

  colors = ["orange", 0, "lightblue"];

  for(side=[front,rear]) {
  }

  for(side=[left,right]) {
    translate([xy_sheet_pos,0,0]) {
      % cube([sheet_thickness,sheet_sides,motor_side*4],center=true);
    }
  }

  axis();
}

assembly();

module axis() {
  for(side=[left,right]) {
    translate([side*rod_dist/2,0,0]) {
      rotate([90,0,0]) {
        hole(xy_rod_diam, xy_rod_length, resolution);
      }
    }
  }

  translate([xy_motor_pos,xy_motor_pos_from_end,xy_motor_rod_dist_z]) {
    rotate([0,-90,0]) {
      motor();
    }
  }
}

module belt_top_sheet() {
  total_width   = motor_pos_x*2+motor_side;
  total_depth   = side_len+motor_side;
  opening_width = total_width-motor_side*2;
  opening_depth = total_depth-motor_side;

  difference() {
    cube([total_width,total_depth,sheet_thickness],center=true);
    translate([0,-total_depth/2,0]) {
      cube([opening_width,opening_depth*2,sheet_thickness+1],center=true);
    }
  }
}

module belt_path(side) {
  rear_belt_pos_y      = side_len/2+belt_idler_diam;//+(1-side)*(belt_thickness*2);
  rear_idler_pos_y     = rear_belt_pos_y-belt_idler_diam/2-belt_thickness/2;
  belt_idler_z_spacing = 0; //belt_idler_dist;
  y_idler_pos_x        = belt_pos_x - belt_idler_diam/2 - belt_thickness/2;
  y_idler_pos_y        = 0; //belt_thickness/2+belt_idler_diam/2;
  far_rear_idler_pos_y = rear_belt_pos_y + belt_idler_diam/2;
  far_rear_idler_pos_y = rear_idler_pos_y;
  far_rear_belt_pos_y  = far_rear_idler_pos_y + belt_idler_diam/2 + belt_thickness/2;

  // x carriage to motor y idler
  hull() {
    translate([0,front*y_idler_pos_y+belt_idler_diam/2+belt_thickness/2,0]) {
      translate([belt_pos_x-belt_idler_diam/2,0,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
      translate([2,0,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
    }
  }

  // y carriage to motor
  translate([y_idler_pos_x,front*y_idler_pos_y,0]) {
    hole(belt_idler_diam, belt_idler_thickness, resolution);
  }
  translate([belt_pos_x,0,0]) {
    hull() {
      translate([0,motor_pos_y,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
      translate([0,front*y_idler_pos_y,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
    }
  }
  // motor pulley
  translate([belt_pos_x+belt_thickness/2+belt_idler_diam/2,motor_pos_y,0]) {
    hole(z_pulley_diam, belt_idler_thickness, resolution);
  }
  // motor to rear
  hull() {
    translate([z_pulley_diam/2+belt_thickness/2,0,0]) {
      translate([belt_pos_x+z_pulley_diam/2,motor_pos_y,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
      translate([motor_pos_x,far_rear_idler_pos_y,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
    }
  }

  translate([motor_pos_x,far_rear_idler_pos_y,0]) {
    hole(belt_idler_diam, belt_idler_thickness, resolution);
  }

  // across the rear
  hull() {
    translate([0,0,0]) {
      translate([motor_pos_x,far_rear_belt_pos_y,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
      translate([-y_idler_pos_x,rear_belt_pos_y,-belt_idler_z_spacing]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
    }
  }

  // far side rear idler
  translate([-belt_pos_x+belt_thickness/2+belt_idler_diam/2,rear_idler_pos_y,-belt_idler_z_spacing]) {
    hole(belt_idler_diam, belt_idler_thickness, resolution);
  }

  // far side rear to y carriage
  translate([-belt_pos_x,0,-belt_idler_z_spacing]) {
    hull() {
      translate([0,rear_idler_pos_y,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
      translate([0,y_idler_pos_y,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
    }
  }

  // y idler to x carriage
  translate([-y_idler_pos_x,rear*y_idler_pos_y,0]) {
    hole(belt_idler_diam, belt_idler_thickness, resolution);
  }

  // far side to x carriage
  hull() {
    translate([0,rear*y_idler_pos_y-belt_idler_diam/2-belt_thickness/2,0]) {
      translate([-belt_pos_x+belt_idler_diam/2,0,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
      translate([-2,0,0]) {
        cube([belt_thickness,belt_thickness,belt_width],center=true);
      }
    }
  }
}

module motor() {
  difference() {
    translate([0,0,-motor_side/2]) cube([motor_side,motor_side,motor_side],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }

  translate([0,0,motor_shaft_len/2]) cylinder(r=motor_shaft_diam/2,h=motor_shaft_len,center=true);
}

module motor_sheet_holes() {
  accurate_circle(z_motor_shoulder_diam,resolution);

  for(x=[left,right]) {
    for(y=[top,bottom]) {
      translate([nema17_hole_spacing/2*x,nema17_hole_spacing/2*y]) {
        accurate_circle(nema17_screw_diam,resolution);
      }

      rotate([0,0,45]) {
        translate([nema14_hole_spacing/2*x,nema14_hole_spacing/2*y]) {
          accurate_circle(nema14_screw_diam,resolution);
        }
      }
    }
  }
}
