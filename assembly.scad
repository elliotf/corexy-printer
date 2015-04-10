include <positions.scad>;
include <main.scad>;

hide_x = false;
hide_x = true;
hide_sheets = false;
hide_sheets = true;
hide_ends = false;
hide_ends = true;

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
      x_carriage();
    }
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
  if (!hide_x) {
    x_axis();
  }

  z_axis_stationary();

  translate([0,sheet_pos_y*front,sheet_pos_z]) {
    rotate([90,0,0]) {
      color("lightblue", sheet_opacity) {
        if (!hide_sheets) {
          linear_extrude(height=sheet_thickness,center=true) front_sheet();
        }
      }
    }
  }

  translate([0,0,top_sheet_pos_z]) {
    color("violet", sheet_opacity) {
      //linear_extrude(height=sheet_thickness,center=true) top_sheet();
    }
  }

  translate([0,0,bottom_sheet_pos_z]) {
    color("yellowgreen", sheet_opacity) {
      //linear_extrude(height=sheet_thickness,center=true) bottom_sheet();
    }
  }

  translate([0,sheet_pos_y*rear,sheet_pos_z]) {
    color("lightgreen", sheet_opacity) {
      rotate([90,0,0]) {
        linear_extrude(height=sheet_thickness,center=true) rear_sheet();
      }
    }
  }

  for(side=[left,right]) {
    translate([side_sheet_pos_x*side,side_sheet_pos_y,side_sheet_pos_z]) {
      rotate([0,90*side,0]) {
        rotate([0,0,90*side]) {
          color("khaki", sheet_opacity) {
            if (!hide_sheets) {
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
        if (!hide_ends) {
          rear_xy_endcap();
        }
      }
      translate([y_rod_x,front*(sheet_pos_y+sheet_thickness/2),0]) {
        if (!hide_ends) {
          front_xy_endcap();
        }
      }
    }
  }

  // xy motors
  for(side=[left,right]) {
    translate([side*(xy_motor_pos_x),xy_motor_pos_y,xy_motor_pos_z]) {
      rotate([-90,0,0]) {
        % motor();

        translate([0,0,2+motor_shaft_len/2]) {
          //% hole(pulley_diam,motor_shaft_len-4,resolution);
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
}

translate([0,0,build_z*1-z_pos]) {
  z_axis();
}

assembly();
