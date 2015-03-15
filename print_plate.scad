include <config.scad>;
include <positions.scad>;
include <main.scad>

module plate() {
  for(side=[left,right]) {
    mirror([1-side,0,0]) {
      translate([rod_diam+line_bearing_diam-2,bearing_body_thickness+rod_diam,0]) {
        rotate([0,0,90]) {
          rotate([-90,0,0]) {
            front_xy_endcap();
          }
        }
      }
      translate([bearing_len/2+spacer*2,150/2-x_rod_spacing/2-rod_diam,y_carriage_width]) {
        rotate([0,0,90]) {
          rotate([0,90,0]) {
            y_carriage(1+side);
          }
        }
      }

      translate([bearing_len+wall_thickness*4+side_sheet_pos_x-y_rod_x,150/2-rod_diam-2,0]) {
        rotate([0,0,180]) {
          rotate([90,0,0]) {
            rear_xy_endcap();
          }
        }
      }

      translate([75-bearing_body_diam,bearing_body_diam,z_printed_portion_height/2]) {
        translate([-z_rod_pos_x,0,0]) {
          printed_z_portion();
        }
      }
    }
  }

  translate([-75-hotend_y+hotend_diam+bearing_body_diam/2,-x_rod_spacing-bearing_body_diam*1.5,x_carriage_width/2]) {
    rotate([0,0,-90]) {
      rotate([0,-90,0]) {
        x_carriage();
      }
    }
  }

  translate([-5,-75+z_motor_pos_x+4,0]) {
    rotate([0,0,90]) {
      rotate([90,0,0]) {
        z_motor_mount();
      }
    }
  }

  translate([2,0,z_brace_body_width/2]) {
    rotate([0,0,90]) {
      rotate([0,90,0]) {
        z_idler_top();
      }
    }
    translate([top_rear_brace_depth+6,-top_rear_brace_depth-6,0]) {
      rotate([0,0,180]) {
        mirror([1,0,0]) {
          rotate([0,90,0]) {
            z_idler_top();
          }
        }
      }
    }
  }

  //translate([-top_rear_brace_depth,-top_rear_brace_depth-8,z_brace_body_width/2]) {
  translate([75-3,-75+3,z_brace_body_width/2]) {
    rotate([0,0,180]) {
      rotate([0,90,0]) {
        z_idler_bottom();
      }
    }

    translate([-top_rear_brace_depth,top_rear_brace_depth*2,0]) {
      rotate([0,0,90]) {
        mirror([1,0,0]) {
          rotate([0,90,0]) {
            z_idler_bottom();
          }
        }
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
