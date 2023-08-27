include <config.scad>; 

belt_carriage_anchor_pos_x = carriage_width(yz_carriage_type)/2+3+belt_thickness/2;
belt_pos_y = -belt_width/2-0.5;
belt_length = z_support_extrusion_length;

carriage_idler_pos_x = belt_carriage_anchor_pos_x+belt_thickness/2+z_idler_od/2;
motor_pos_x = belt_carriage_anchor_pos_x+belt_thickness/2+z_idler_od+belt_thickness/2+z_pulley_diam/2;
motor_pos_y = belt_pos_y-belt_width/2-3.75;
motor_pos_z = bottom_pos_z-z_motor_side/2-extrusion_side/2;

z_frame_idler_pos_x = carriage_idler_pos_x + z_idler_od/2 + belt_thickness +  z_frame_idler_od/2;
z_frame_idler_extra_dist_z = 8;
z_frame_idler_pos_z = extrusion_side/2-carriage_width(yz_carriage_type)/2-z_frame_idler_od/2-belt_thickness/2-z_frame_idler_extra_dist_z;

z_carriage_idler_spacing = z_idler_od+belt_thickness*3;

module z_idler() {
  % color("silver") {
    difference() {
      union() {
        hole(z_idler_od,z_idler_width,resolution);
        for(z=[top,bottom]) {
          translate([0,0,z*(z_idler_width/2-z_idler_flange_width/2)]) {
            hole(z_idler_od+z_idler_flange_height*2,z_idler_flange_width,resolution);
          }
        }
      }
      hole(z_idler_id,z_idler_width+2,resolution);
    }
  }
}

module z_assembly(pos_z=0) {
  translate([z_support_beam_x_offset,0,z_support_pos_z]) {
    extrusion_makerbeam_xl(z_support_extrusion_length);
  }

  translate([0,-extrusion_side/2+belt_pos_y,0]) {
    rotate([90,0,0]) {
      belt_points = [
        [carriage_idler_pos_x,motor_pos_z,f623_2x_idler],
        [carriage_idler_pos_x,z_rail_top_pos_z-carriage_length(yz_carriage_type)/2-pos_z-z_carriage_idler_spacing/2,f623_2x_idler],
        [motor_pos_x,motor_pos_z,GT2x16_pulley],
        [z_frame_idler_pos_x,z_support_pos_z+z_support_extrusion_length/2+z_frame_idler_pos_z,z_frame_idler_type],
        [carriage_idler_pos_x,z_rail_top_pos_z-carriage_length(yz_carriage_type)/2-pos_z+z_carriage_idler_spacing/2,f623_2x_idler],
        [carriage_idler_pos_x,xy_pos_z-extrusion_side/2-1,f623_2x_idler],
      ];
      belt(GT2x6, belt_points, belt_colour = grey(20), tooth_colour = "#795C34", open = true, twist = undef, auto_twist = false, start_twist = false);
    }
  }

  translate([z_support_beam_x_offset,-extrusion_side/2,0]) {
    translate([0,0,z_rail_top_pos_z]) {
      translate([0,0,-z_rail_length/2]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            rail(yz_rail_type,z_rail_length);
          }
        }
      }
      translate([0,0,-carriage_length(yz_carriage_type)/2-pos_z]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            carriage(yz_carriage_type);
          }

          z_carriage();
        }
      }
    }

    translate([0,0,z_support_pos_z+z_support_extrusion_length/2]) {
      z_frame_idler_anchor();
    }

    // more compact, direct drive
    translate([30,-z_motor_side/2,bottom_pos_z-extrusion_side/2-z_motor_side/2-1]) {
      rotate([0,0,90]) {
        rotate([-90,0,0]) {
          rotate([0,0,90]) {
            //NEMA(z_motor);
          }
        }
      }
    }

    % translate([0,belt_pos_y,0]) {
      translate([belt_carriage_anchor_pos_x,0,0]) {
        //# cube([belt_thickness,belt_width,z_support_extrusion_length],center=true);
      }
    }
    // block-and-tackle, maybe?
    % translate([motor_pos_x,motor_pos_y,motor_pos_z]) {
      rotate([-90,0,0]) {
        rotate([0,0,90]) {
          NEMA(z_motor);
          translate([0,0,16.2]) {
            rotate([0,180,0]) {
              pulley(GT2x16_pulley);
            }
          }
        }
      }
    }
  }
}

for(z=[top,bottom]) {
  translate([0,0,z_support_pos_z+z*(z_support_extrusion_length/2+extrusion_side/2)]) {
    rotate([0,90,0]) {
      extrusion_makerbeam_xl(300);
    }
  }
}
translate([0,front*extrusion_side/2,z_support_pos_z+z_support_extrusion_length/2+extrusion_side/2]) {
  rotate([0,0,0]) {
    rotate([90,0,0]) {
      rail(yz_rail_type,y_rail_length);
      carriage(yz_carriage_type);
    }
  }
}

module z_carriage() {
  idler_pos_y = z_carriage_idler_spacing/2;

  module position_idlers() {
    for(y=[front,rear]) {
      translate([carriage_idler_pos_x,y*idler_pos_y,-belt_pos_y]) {
        children();
      }
    }
  }

  module body() {
    for(x=[left,right],y=[front,rear]) {
      belt_length = 200;
    }
  }

  module holes() {
    position_idlers() {
      z_idler();
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_frame_idler_anchor() {
  module position_idler() {
    //translate([z_frame_idler_pos_x,belt_pos_y,extrusion_side/2-carriage_width(yz_carriage_type)/2-z_idler_od/2-belt_thickness/2-2]) {
    translate([z_frame_idler_pos_x,belt_pos_y,z_frame_idler_pos_z]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module body() {
  }

  module holes() {
    position_idler() {
      translate([0,0,pulley_offset(z_frame_idler_type)]) {
        % pulley(z_frame_idler_type);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

z_assembly();
