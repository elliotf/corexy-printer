include <BOSL/threading.scad>;
include <NopSCADlib/lib.scad>;
include <lumpyscad/lib.scad>;
include <./config.scad>;
use <./main.scad>;

xy_tension_screw_diam = 17;
xy_tension_screw_length = 30;
xy_tension_screw_hole_height = ab_plate_space_between_z-xy_tension_screw_offset_z;
xy_tension_screw_height = xy_tension_screw_hole_height-0.3;
xy_tension_nut_diam = xy_tension_screw_diam+3*2;
xy_tension_nut_height = 15;
screw_thread_pitch = 2.5;
screw_thread_depth = screw_thread_pitch*0.45;
screw_thread_angle = 35;
screw_thread_tolerance = 0.5;

echo("xy_tension_nut_diam: ", xy_tension_nut_diam);

module nut_body() {
  rim_height = 2.25;
  base_diam = xy_tension_nut_diam-1;

  resolution = 128;

  module rim_profile() {
    hull() {
      translate([0,rim_height/2,0]) {
        translate([1,0,0]) {
          square([2,rim_height],center=true);
        }
        translate([xy_tension_nut_diam/2+rounded_diam/4,0,0]) {
          accurate_circle(rim_height,8);
        }
      }
    }
    translate([0,rim_height,0]) {
      translate([base_diam/4,rounded_diam/4,0]) {
        square([base_diam/2,rounded_diam/2],center=true);
      }
      translate([base_diam/2,0,0]) {
        rotate([0,0,0]) {
          round_corner_filler_profile(rounded_diam, resolution);
        }
      }
    }
  }

  module body() {
    rotate_extrude($fn=resolution) {
      rim_profile();
    }
    hull() {
      sides = 6;
      angle = 360/sides;
      for(i=[0:sides]) {
        rotate([0,0,i*angle]) {
          translate([0,xy_tension_nut_diam/2-rounded_diam/2,0]) {
            translate([0,0,xy_tension_nut_height-rounded_diam/2]) {
              sphere(r=rounded_diam/2);
            }
            translate([0,0,rim_height]) {
              //sphere(r=rounded_diam/2);
            }
          }
        }
      }
      translate([0,0,rim_height+rounded_diam/2]) {
        hole(base_diam,0.1,resolution);
      }
    }
  }

  module holes() {
    trapezoidal_threaded_rod(internal = true, thread_depth = screw_thread_depth, slop = screw_thread_tolerance, d=xy_tension_screw_diam, l=xy_tension_screw_length+10, pitch=screw_thread_pitch, thread_angle=screw_thread_angle, $fn=resolution, bevel=true);

    translate([0,0,xy_tension_nut_height+xy_tension_nut_diam]) {
      sphere(r=xy_tension_screw_diam*1.5);
    }
  }

  difference() {
    body();
    holes();
  }
}

module screw_sample() {
  intersection() {
    cube([100,100,xy_tension_screw_height],center=true);
    rotate([0,-90,0]) {
      translate([0,0,10+1]) {
        trapezoidal_threaded_rod(d=xy_tension_screw_diam, thread_depth=screw_thread_depth, l=xy_tension_screw_length, pitch=screw_thread_pitch, thread_angle=screw_thread_angle, $fn=64, bevel1=true);
      }
    }
  }
}

translate([0,ab_pod_depth*2,0]) {
  nut_body();

  translate([0,xy_tension_screw_diam/2+3+xy_tension_nut_diam/2,xy_tension_screw_height/2]) {
    screw_sample();
  }
}

% translate([-xy_motor_pos_x+35,-xy_motor_pos_y,0]) {
  translate([0,0,ab_plate_thickness/2-ab_plate_space_between_z-ab_plate_thickness]) {
    color("#77a") ab_motor_plate(-1);
  }
  translate([0,0,top_ab_plate_thickness/2]) {
    rotate([0,180,0]) {
      mirror([1,0,0]) {
        color("#7a7") ab_motor_plate(1);
      }
    }
  }
}

% difference() {
  translate([0,0,-xy_tension_screw_hole_height/2]) {
    union() {
      color("#a77") screw_sample();
      rotate([0,-90,0]) {
        translate([0,0,screw_thread_pitch*1.45]) {
          color("#77a") nut_body();
        }
      }
    }
  }
  translate([0,0,xy_tension_screw_hole_height/2]) {
    color("#ddd") cube([100,100,xy_tension_screw_hole_height*2],center=true);
  }
}
/*
*/


//psu(PD_150_12);
//pulley(f695_2x_idler);
//translate([0,-16.5,0]) {
//  rotate([-90,0,0]) {
//    rotate([0,0,90]) {
//      translate([-149.287,-243.45,-29.326]) {
//        import("voron-zero/STLs/X_Carriage_x1.stl");
//      }
//    }
//  }
//}
//type = MGN7H_carriage;
//translate([0,0,-carriage_height(type)]) {
//  //carriage(type);
//}
