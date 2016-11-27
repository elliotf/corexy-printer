include <config.scad>;
include <positions.scad>;
include <boxcutter.scad>;
include <main.scad>;
use <util.scad>;
use <belt_retainer.scad>;

build_volume_side = 200;

xy_gt2_pulley_teeth = 20;
xy_gt2_pulley_diam  = 18;
xy_bearing_diam     = 12;
xy_rod_spacing_z    = xy_gt2_pulley_diam/2 + xy_bearing_diam/2 + wall_thickness*2;
x_rod_pos_y         = build_volume_side/2 + xy_rod_spacing_z*2;
y_rod_pos_x         = build_volume_side/2 + xy_rod_spacing_z*2;

x_rod_length        = x_rod_pos_y*2 + xy_rod_spacing_z + rod_diam + sheet_thickness*2;
y_rod_length        = y_rod_pos_x*2 + xy_rod_spacing_z + rod_diam + sheet_thickness*2;
x_rod_pos_z         = xy_rod_spacing_z/2;
y_rod_pos_z         = -xy_rod_spacing_z/2;

module side_sheet() {
  bottom_material  = 30;
  hotend_clearance = -1*(hotend_z-hotend_len/2-top_of_sheet);

  module body() {
    box_side([side_sheet_depth,side_sheet_height],[0,3,4,3]);
  }

  module holes() {
    translate([0,-sheet_pos_z+top_sheet_pos_z]) {
      box_holes_for_side(side_sheet_depth,4);
    }

    rounded_diam     = 10;
    main_hole_depth  = side_sheet_depth       - motor_side*2.5;
    main_hole_height = height_below_top_sheet - motor_side*2.5;

    hull() {
      translate([0,-side_sheet_height/2+height_below_top_sheet/2]) {
        for(x=[left,right]) {
          for(y=[front,rear]) {
            translate([(main_hole_depth/2-rounded_diam)*x,(main_hole_height/2-rounded_diam)*y]) {
              accurate_circle(rounded_diam,resolution);
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

module effector() {
  bearing_diam      = z_bearing_diam;
  bearing_body_diam = bearing_diam + wall_thickness*4;
  rod_offset = 15;

  module body() {
    hull() {
      translate([0,-rod_offset,0]) {
        translate([rod_offset,0,-xy_rod_spacing_z/2]) {
          rotate([90,0,0]) {
            hole(bearing_body_diam,50,resolution);
          }
        }
        cube([bearing_body_diam,50,bearing_body_diam/2],center=true);
      }
    }
    hull() {
      translate([-rod_offset,0,0]) {
        translate([0,rod_offset,xy_rod_spacing_z/2]) {
          rotate([0,90,0]) {
            hole(bearing_body_diam,50,resolution);
          }
        }
        cube([50,bearing_body_diam,bearing_body_diam/2],center=true);
      }
    }
  }

  module holes() {
    translate([rod_offset,0,-xy_rod_spacing_z/2]) {
      rotate([90,0,0]) {
        hole(bearing_diam,150,resolution);
      }
    }
    translate([0,rod_offset,xy_rod_spacing_z/2]) {
      rotate([0,90,0]) {
        hole(bearing_diam,150,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

effector();

module assembly() {

  for(side=[left,right]) {
    translate([side_sheet_pos_x*side,0,0]) {
      rotate([0,0,90]) {
        rotate([90,0,0]) {
          linear_extrude(height=sheet_thickness,center=true) {
            //side_sheet();
          }
        }
      }
    }
  }

  for(side=[left,right]) {
    translate([y_rod_pos_x*side,0,y_rod_pos_z]) {
      rotate([90,0,0]) {
        % hole(rod_diam, y_rod_length, resolution);
      }
    }
    translate([0,x_rod_pos_y*side,x_rod_pos_z]) {
      rotate([0,90,0]) {
        % hole(rod_diam, x_rod_length, resolution);
      }
    }
  }

  translate([x_rod_length/2,x_rod_pos_y-motor_side/2,x_rod_pos_z+xy_rod_spacing_z]) {
    rotate([0,-90,0]) {
      % motor();
    }
  }
  translate([x_rod_pos_y-motor_side/2,y_rod_length/2,y_rod_pos_z-xy_rod_spacing_z]) {
    rotate([90,0,0]) {
      % motor();
    }
  }

  translate([0,0,-xy_rod_spacing_z*3]) {
    color("red") % cube([build_volume_side,build_volume_side,1],center=true);
  }
}

assembly();
