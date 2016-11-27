include <positions.scad>;
include <main.scad>;

show_x = false;
show_x = true;
show_z = true;
show_z = false;
show_sheets = true;
show_sheets = false;
show_sides  = false;
show_sides  = true;
show_ends = true;
show_ends = false;

module x_axis() {
  translate([0,y_pos,0]) {
    for(side=[left,right]) {
      mirror([1+side,0,0]) {
        translate([-y_rod_x,0,0]) {
          y_carriage();
        }
      }
    }

    // x rods
    % for (side=[top,bottom]) {
      translate([0,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          rotate([0,0,22.5/2]) {
            cylinder(r=x_rod_diam/2,h=x_rod_len,center=true,$fn=16);
          }
        }
      }
    }

    translate([x_pos,0,0]) {
      x_carriage(); }
  }

  % for (end=[left,right]) {
    // y rods
    translate([y_rod_x*end,0,0]) {
      rotate([90,0,0]) {
        cylinder(r=y_rod_diam/2,h=y_rod_len+2,center=true,$fn=16);
      }
    }
  }
}

module assembly() {
  if (show_x) {
    x_axis();
  }

  module position_for_z() {
    translate([0,0,build_base_z-z_printed_portion_height/2+build_z*1-z_pos]) {
      children();
    }
  }

  if (show_z) {
    z_axis_stationary();
    translate([z_brace_sheet_pos_x,z_brace_sheet_pos_y,z_brace_sheet_pos_z]) {
      rotate([0,-90,0]) {
        color("lightblue") linear_extrude(height=sheet_thickness,center=true) {
          z_brace_sheet();
        }
      }
    }

    translate([0,0,build_z*1-z_pos]) {
      z_axis();
    }

    // belt retainers
    translate([-z_motor_side*(z_line_bearing_diam/2+belt_thickness/2),z_rod_pos_y,0]) {
      translate([0,0,top_sheet_pos_z-sheet_thickness/2-0.05]) {
        z_belt_anchor();
      }

      translate([0,0,bottom_sheet_pos_z+sheet_thickness/2]) {
        translate([0,0,belt_clamp_height]) {
          belt_clamp_tensioner();
        }

        translate([0,0,0]) {
          belt_tensioner_body();
        }
      }
    }

    // belts
    % color("black", 0.8) translate([0,z_rod_pos_y,0]) {
      // from carriage to idler
      hull() {
        translate([z_motor_side*(z_line_bearing_diam/2+belt_thickness/2),0,0]) {
          position_for_z() {
            translate([0,0,z_carriage_bearing_spacing/2]) {
              cube([belt_thickness,belt_width,1],center=true);
            }
          }
          translate([0,0,z_idler_pulley_pos_z]) {
            cube([belt_thickness,belt_width,1],center=true);
          }
        }
      }
      // from carriage to motor
      hull() {
        translate([z_motor_side*(z_line_bearing_diam/2+belt_thickness/2),0,0]) {
          position_for_z() {
            translate([0,0,-z_carriage_bearing_spacing/2]) {
              cube([belt_thickness,belt_width,1],center=true);
            }
          }
          translate([0,0,z_motor_pos_z]) {
            cube([belt_thickness,belt_width,1],center=true);
          }
        }
      }
      // from motor to idler
      hull() {
        translate([(z_idler_pulley_pos_x+(z_idler_pulley_diam/2+belt_thickness/2)*z_motor_side),0,z_idler_pulley_pos_z]) {
          cube([belt_thickness,belt_width,1],center=true);
        }
        translate([z_motor_pos_x+(z_pulley_diam/2+belt_thickness/2)*z_motor_side,0,z_motor_pos_z]) {
          cube([belt_thickness,belt_width,1],center=true);
        }
      }
      // from carriage to top
      hull() {
        translate([z_belt_carriage_to_anchor_pos_x,0,0]) {
          position_for_z() {
            translate([0,0,z_carriage_bearing_spacing/2]) {
              cube([belt_thickness,belt_width,1],center=true);
            }
          }
          translate([0,0,top_sheet_pos_z-sheet_thickness]) {
            cube([belt_thickness,belt_width,1],center=true);
          }
        }
      }
      // from carriage to bottom
      hull() {
        translate([z_belt_carriage_to_anchor_pos_x,0,0]) {
          position_for_z() {
            translate([0,0,-z_carriage_bearing_spacing/2]) {
              cube([belt_thickness,belt_width,1],center=true);
            }
          }
          translate([0,0,bottom_sheet_pos_z+sheet_thickness]) {
            cube([belt_thickness,belt_width,1],center=true);
          }
        }
      }
    }
  }

  translate([0,sheet_pos_y*front,sheet_pos_z]) {
    rotate([90,0,0]) {
      color("lightblue", sheet_opacity) {
        if (show_sheets) {
          linear_extrude(height=sheet_thickness,center=true) front_sheet();
        }
      }
    }
  }

  translate([0,0,top_sheet_pos_z]) {
    color("violet", sheet_opacity) {
      linear_extrude(height=sheet_thickness,center=true) top_sheet();
    }
  }

  translate([0,0,bottom_sheet_pos_z]) {
    color("yellowgreen", sheet_opacity) {
      linear_extrude(height=sheet_thickness,center=true) bottom_sheet();
    }
  }

  translate([0,sheet_pos_y*rear,sheet_pos_z]) {
    color("lightgreen", sheet_opacity) {
      rotate([90,0,0]) {
        //linear_extrude(height=sheet_thickness,center=true) rear_sheet();
      }
    }
  }

  for(side=[left,right]) {
    translate([side_sheet_pos_x*side,side_sheet_pos_y,side_sheet_pos_z]) {
      rotate([0,90*side,0]) {
        rotate([0,0,90*side]) {
          color("khaki", sheet_opacity) {
            if (show_sheets && show_sides) {
              linear_extrude(height=sheet_thickness,center=true) side_sheet();
            }
          }
        }
      }
    }
  }

  for(side=[left,right]) {
    mirror([1-side,0,0]) {
      translate([y_rod_x,sheet_pos_y+sheet_thickness/2,0]) {
        if (show_ends) {
          rear_xy_endcap();
        }
      }
      translate([y_rod_x,front*(sheet_pos_y+sheet_thickness/2),0]) {
        if (show_ends) {
          front_xy_endcap();
        }
      }
    }
  }

  // xy motors
  for(side=[left,right]) {
    translate([side*(xy_motor_pos_x),xy_motor_pos_y,xy_motor_pos_z]) {
      rotate([90,0,0]) {
        //% motor();

        translate([0,0,2+motor_shaft_len/2]) {
          % hole(pulley_diam,motor_shaft_len-4,resolution);
        }
      }
    }
  }

  // handle!
  // shouldn't put the handle here, because it's probably going to interfere with the bowden tube.
  translate([0,sheet_pos_y*rear-sheet_thickness,top_of_sheet]) {
    color("blue", sheet_opacity) {
      rotate([90,0,0]) {
        //handle();
      }
    }
  }

  // spool mount
  //for(side=[left,right]) {
  for(side=[-z_motor_side]) {
    translate([side*(side_sheet_pos_x-sheet_thickness/2-20),sheet_pos_y + sheet_thickness/2 + filament_spool_mount_spacer + filament_spool_width/2,z_motor_pos_z+filament_spool_outer_diam/2]) {
      rotate([90,0,0]) {
        //% filament_spool();
      }
    }
  }
}

assembly();
