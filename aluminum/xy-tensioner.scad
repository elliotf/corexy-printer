include <BOSL/threading.scad>;
include <NopSCADlib/lib.scad>;
include <lumpyscad/lib.scad>;
include <./config.scad>;
use <./main.scad>;
use <./xy-gantry.scad>;

xy_tensioner_screw_diam = 17;

xy_tensioner_screw_height = xy_tensioner_screw_hole_height-0.3;
xy_tensioner_nut_diam = xy_tensioner_screw_diam+3*2;

xy_tensioner_nut_height = 15;

xy_tensioner_screw_length = xy_tensioner_nut_height+xy_tensioner_wall_width+xy_tensioner_wall_gap+xy_motor_adjust_range+1;

xy_tensioner_screw_thread_pitch = 2.25;
xy_tensioner_screw_thread_depth = xy_tensioner_screw_thread_pitch*0.45;
xy_tensioner_screw_thread_angle = 38;
xy_tensioner_screw_thread_tolerance = 0.5;

bevel_height = 0.4;

module xy_tensioner_nut(resolution) {
  rim_height = 2.25;
  base_diam = xy_tensioner_nut_diam-1;

  module rim_profile() {
    hull() {
      translate([0,rim_height/2,0]) {
        translate([1,0,0]) {
          square([2,rim_height],center=true);
        }
        translate([xy_tensioner_nut_diam/2+rounded_diam/4,0,0]) {
          accurate_circle(rim_height,8);
        }
      }
    }
  }

  module body() {
    module position_corners() {
      sides = 6;
      angle = 360/sides;
      for(i=[0:sides]) {
        rotate([0,0,i*angle]) {
          translate([0,xy_tensioner_nut_diam/2,0]) {
            children();
          }
        }
      }
    }
    rotate_extrude($fn=resolution*2) {
      rim_profile();
    }
    hull() {
      position_corners() {
        translate([0,-rounded_diam/2,0]) {
          translate([0,0,xy_tensioner_nut_height-rounded_diam/2]) {
            sphere(r=rounded_diam/2,$fn=resolution/2);
          }
          translate([0,0,rim_height]) {
            cylinder(r=rounded_diam/2,h=rounded_diam/2,$fn=resolution/2);
          }
        }
      }
    }
    position_corners() {
      translate([0,-rounded_diam/2,rim_height]) {
        rotate_extrude($fn=resolution/2) {
          translate([rounded_diam/2,0,0]) {
            round_corner_filler_profile(rounded_diam/2, resolution/2);
          }
        }
      }
    }
  }

  module holes() {
    trapezoidal_threaded_rod(internal = true, thread_depth = xy_tensioner_screw_thread_depth, slop = xy_tensioner_screw_thread_tolerance, d=xy_tensioner_screw_diam, l=xy_tensioner_screw_length+10, pitch=xy_tensioner_screw_thread_pitch, thread_angle=xy_tensioner_screw_thread_angle, $fn=resolution);
  }

  difference() {
    body();
    holes();
  }
}

module xy_tensioner_body(res=resolution) {
  m3_loose_diam = 3.2;

  trim_rear_y_by = ab_pod_room_for_belts-xy_motor_space_behind;
  trim_front_y_by = 0.3;
  trim_end_for_belt_idler_by = 0.2;
  post_depth = xy_motor_side-xy_motor_hole_spacing;

  post_diam = (xy_motor_side/2-xy_motor_hole_spacing/2-trim_rear_y_by)*2;

  pos_x = -trim_end_for_belt_idler_by/2;
  width = xy_motor_side-trim_end_for_belt_idler_by;

  // maybe make this hole smaller to make it easier to thread belts?
  // we can't make it too small, because the belt starts to foul on the tensioner body
  belt_and_pulley_hole_diam = xy_motor_hole_spacing-9;
  echo("belt_and_pulley_hole_diam: ", belt_and_pulley_hole_diam);

  module thread() {
    intersection() {
      cube([100,100,xy_tensioner_screw_height],center=true);
      rotate([0,-90,0]) {
        trapezoidal_threaded_rod(d=xy_tensioner_screw_diam, thread_depth=xy_tensioner_screw_thread_depth, l=xy_tensioner_screw_length, pitch=xy_tensioner_screw_thread_pitch, thread_angle=xy_tensioner_screw_thread_angle, $fn=res, bevel1=true);
      }
    }
  }

  module belt_opening_cutter() {
    module body() {
      translate([pos_x+width/2,0,0]) {
        cube([width,belt_and_pulley_hole_diam+post_diam,xy_tensioner_body_height+bevel_height],center=true);
      }
    }

    module holes() {
      for(y=[front,rear]) {
        translate([pos_x+width/2,y*(belt_and_pulley_hole_diam/2+post_diam/2),0]) {
          hull() {
            translate([-post_diam/2,0,0]) {
              hole(post_diam-bevel_height*2,xy_tensioner_body_height,res);
              hole(post_diam,xy_tensioner_body_height-bevel_height*2,res);
              translate([-width/4,0,0]) {
                cube([width/2,post_diam-bevel_height*2,xy_tensioner_body_height],center=true);
                cube([width/2,post_diam,xy_tensioner_body_height-bevel_height*2],center=true);
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

  module body() {
    //translate([xy_tensioner_screw_length/2-xy_motor_side/2-xy_tensioner_wall_width-xy_tensioner_wall_gap-xy_tensioner_nut_height-xy_motor_adjust_range,0,xy_tensioner_screw_offset_z+xy_tensioner_screw_hole_height/2]) {
    thread_pos_x = xy_tensioner_screw_length/2-xy_motor_side/2-xy_tensioner_wall_gap-xy_tensioner_wall_width-xy_tensioner_nut_height-xy_motor_adjust_range;
    translate([thread_pos_x,0,xy_tensioner_body_height-xy_tensioner_screw_height/2]) {
      thread();
    }
    translate([pos_x,-trim_rear_y_by/2+trim_front_y_by/2,xy_tensioner_body_height/2]) {
      depth = xy_motor_side-trim_rear_y_by-trim_front_y_by;
      hull() {
        rounded_cube(width-bevel_height*2,depth-bevel_height*2,xy_tensioner_body_height,rounded_diam);
        rounded_cube(width,depth,xy_tensioner_body_height-bevel_height*2,rounded_diam);
      }
    }
  }

  module holes() {
    translate([0,0,xy_tensioner_body_height/2]) {
      bevel_through_hole(belt_and_pulley_hole_diam,xy_tensioner_body_height,bevel_height);

      belt_opening_cutter();
      for(y=[front,rear]) {
        translate([xy_motor_side/2,y*belt_and_pulley_hole_diam/2,0]) {
        }
      }

      for(x=[left,right],y=[front,rear]) {
        translate([x*xy_motor_hole_spacing/2,y*xy_motor_hole_spacing/2,0]) {
          bevel_through_hole(m3_loose_diam,xy_tensioner_body_height,bevel_height);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module xy_tensioner_assembly() {
  adjust_range = xy_motor_adjust_range*1;
  translate([-adjust_range,0,-ab_plate_thickness]) {
    rotate([0,0,-90]) {
      NEMA(xy_motor);
      translate([0,0,xy_belt_upper_dist_from_extrusion]) {
        pulley_assembly(GT2x16_pulley);
      }
    }
  }
  translate([-xy_motor_pos_x,-xy_motor_pos_y,ab_plate_space_between_z/2]) {
    translate([xy_belt_idler_rear_pos_x,xy_belt_idler_rear_pos_y,0]) {
      for(z=[top,bottom]) {
        translate([0,0,z*(0.5+8/2)]) {
          pulley_assembly(f623_2x_idler);
        }
      }
    }
    translate([corner_pos_x,xy_belt_idler_rear_left_pos_y,0]) {
      for(z=[top,bottom]) {
        translate([0,0,z*(0.5+8/2)]) {
          pulley_assembly(f623_2x_idler);
        }
      }
    }
  }

  translate([-xy_motor_pos_x,-xy_motor_pos_y,-ab_plate_thickness/2]) {
    color("#77a") ab_motor_plate(bottom);
  }
  translate([-adjust_range,0,xy_tensioner_tolerance_z/2]) {
    xy_tensioner_body();
  }

  translate([-33,0,xy_tensioner_screw_offset_z+xy_tensioner_screw_height/2]) {
    rotate([0,-90,0]) {
      //xy_tensioner_nut(8);
    }
  }
}

xy_tensioner_assembly();
