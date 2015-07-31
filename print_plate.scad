include <config.scad>;
include <positions.scad>;
include <main.scad>

module plate() {
  for(side=[left,right]) {
    mirror([1-side,0,0]) {
      translate([rod_diam,bearing_body_thickness/2,0]) {
        rotate([0,0,90]) {
          rotate([-90,0,0]) {
            front_xy_endcap();
          }
        }
      }
      translate([x_rod_spacing-x_rod_diam,150/2-y_bearing_len/2-1,y_carriage_width]) {
        rotate([0,0,0]) {
          rotate([0,90,0]) {
            y_carriage(1+side);
          }
        }
      }

      translate([150/2-line_bearing_diam+2,bearing_body_diam+y_rod_diam+20,0]) {
        rotate([0,0,90]) {
          rotate([90,0,0]) {
            rear_xy_endcap();
          }
        }
      }

      translate([2,0,z_printed_portion_height/2]) {
        printed_z_portion();
      }

      translate([50,-x_rod_spacing-14,z_idler_pulley_bearing_retainer_thickness/2]) {
        rotate([0,0,0]) {
          z_idler_pulley_bearing_retainer();
        }
      }
      translate([-70+top_rear_brace_depth*2,-x_rod_spacing-top_rear_brace_depth,0]) {
        rotate([0,0,180]) {
          rotate([0,90,0]) {
            //z_idler_bottom();
          }
        }
      }
    }
  }

  translate([6,25,0]) {
    translate([0,0,z_belt_anchor_height]) {
      z_belt_anchor();
    }

    translate([20,13,belt_clamp_height/2]) {
     belt_clamp_tensioner();
    }
  }

  translate([-10,-40,x_carriage_width/2]) {
    rotate([0,0,90]) {
      rotate([0,-90,0]) {
        x_carriage();
      }
    }
  }

  % translate([0,0,-.5]) {
    difference() {
      cube([200,200,1],center=true);
      cube([150,150,2],center=true);
    }
  }
}

plate();
