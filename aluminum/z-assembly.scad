include <config.scad>; 

z_idler_type = f695_2x_idler;
//z_idler_type = f623_2x_idler;
//z_frame_main_idler_type = f695_2x_idler;
z_frame_main_idler_type = f623_2x_idler;
z_frame_main_idler_id = pulley_bore(z_frame_main_idler_type); // F695
z_frame_main_idler_od = pulley_od(z_frame_main_idler_type); // F695

z_pulley_type = GT2x16_pulley;
z_pulley_rotation_distance = 16*2;
z_pulley_diam = (z_pulley_rotation_distance/pi_approx);
//z_pulley_diam = pulley_offset(z_pulley_type)*2;
z_idler_id = pulley_bore(z_idler_type);
z_idler_od = pulley_od(z_idler_type);
z_idler_width = 8; // F623
z_idler_flange_width = 1; // F623
z_idler_flange_height = 1; // F623

belt_carriage_anchor_pos_x = carriage_width(yz_carriage_type)/2+belt_thickness/2;
belt_pos_y = -belt_width/2-0.5;
belt_length = z_support_extrusion_length;

positional_offset_x = z_idler_od*0.3;

carriage_idler_pos_x = belt_carriage_anchor_pos_x+belt_thickness/2+z_idler_od/2;
motor_pos_y = belt_pos_y-belt_width/2-3.75;
motor_pos_z = bottom_pos_z-z_motor_side/2-extrusion_side/2;

z_frame_main_idler_extra_dist_z = 2; // ensure we don't collide with the XY carriage or toolhead
z_frame_main_idler_pos_z = extrusion_side/2-carriage_width(yz_carriage_type)/2-z_frame_main_idler_od/2-belt_thickness/2-z_frame_main_idler_extra_dist_z;

// use an extra belt idler so:
// * we can move the main idler closer to vertical support
// * we do not need to worry about alignment of bearings caused by belt thickness as it
// FIXME: we need to use a smaller diameter bearing than the z carriage bearing to avoid the belt rubbing on the stationary side
z_frame_positioner_idler_type = f623_2x_idler;
z_frame_positioner_idler_od = pulley_od(z_frame_positioner_idler_type);
z_frame_positioner_idler_pos_x = carriage_idler_pos_x+z_idler_od/2-z_frame_positioner_idler_od/2;
z_frame_positioner_idler_top_pos_z = z_frame_main_idler_pos_z-z_frame_main_idler_od/2-pulley_od(z_frame_positioner_idler_type)/2-3;
z_frame_positioner_idler_bottom_pos_z = 0;

z_frame_main_idler_pos_x = z_frame_positioner_idler_pos_x+positional_offset_x;
//z_frame_main_idler_pos_x = carriage_idler_pos_x + z_idler_od/2 + belt_thickness +  z_frame_main_idler_od/2 - positional_offset_x;

//motor_pos_x = belt_carriage_anchor_pos_x+belt_thickness/2+z_idler_od+belt_thickness/2+z_pulley_diam/2 - positional_offset_x;
motor_pos_x = z_frame_positioner_idler_pos_x+positional_offset_x;

z_carriage_idler_spacing = z_idler_od+belt_thickness*2.5;
z_carriage_idler_offset = -2; // let the z carriage hit the frame before the bearings

module z_assembly(pos_z=0) {
  translate([z_support_beam_x_offset,0,z_support_pos_z]) {
    % extrusion_makerbeam_xl(z_support_extrusion_length);
  }

  translate([0,-extrusion_side/2+belt_pos_y,0]) {
    rotate([90,0,0]) {
      belt_points = [
        [carriage_idler_pos_x,motor_pos_z,z_idler_type],
        [carriage_idler_pos_x,z_rail_top_pos_z-carriage_length(yz_carriage_type)/2-pos_z+z_carriage_idler_offset-z_carriage_idler_spacing/2,z_idler_type],
        [motor_pos_x,motor_pos_z,GT2x16_pulley],
        [z_frame_main_idler_pos_x,z_support_pos_z+z_support_extrusion_length/2+z_frame_main_idler_pos_z,z_frame_main_idler_type],
        [carriage_idler_pos_x,z_rail_top_pos_z-carriage_length(yz_carriage_type)/2-pos_z+z_carriage_idler_offset+z_carriage_idler_spacing/2,z_idler_type],
        //[carriage_idler_pos_x,xy_pos_z-carriage_width(yz_carriage_type)/2-1,z_idler_type],
        [carriage_idler_pos_x,z_support_pos_z+z_support_extrusion_length/2+z_frame_positioner_idler_top_pos_z,z_idler_type],
      ];
      % belt(GT2x6, belt_points, belt_colour = grey(20), tooth_colour = "#795C34", open = true, twist = undef, auto_twist = false, start_twist = true);
    }
  }

  translate([z_support_beam_x_offset,-extrusion_side/2,0]) {
    translate([0,0,z_rail_top_pos_z]) {
      translate([0,0,-z_rail_length/2]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            % rail(yz_rail_type,z_rail_length);
          }
        }
      }
      translate([0,0,-carriage_length(yz_carriage_type)/2-pos_z]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            % carriage(yz_carriage_type);
          }

          z_carriage();
        }
      }
    }

    translate([0,0,z_support_pos_z+z_support_extrusion_length/2]) {
      z_frame_main_idler_anchor();
    }

    translate([0,0,z_support_pos_z+z_support_extrusion_length/2]) {
      z_frame_motor_mount();
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
      % extrusion_makerbeam_xl(300);
    }
  }
}
translate([0,front*extrusion_side/2,z_support_pos_z+z_support_extrusion_length/2+extrusion_side/2]) {
  rotate([0,0,0]) {
    rotate([90,0,0]) {
      % rail(yz_rail_type,y_rail_length);
      % carriage(yz_carriage_type);
    }
  }
}

module z_carriage() {
  module position_idlers() {
    for(y=[front,rear]) {
      translate([carriage_idler_pos_x,z_carriage_idler_offset+y*z_carriage_idler_spacing/2,0]) {
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
      % pulley(z_idler_type);
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_frame_main_idler_anchor() {
  idler_height = 8;
  idler_od = z_frame_main_idler_od;
  bevel_height = 0.5;
  bevel_post_id = pulley_bore(z_frame_main_idler_type)+0.2;
  bevel_post_od = bevel_post_id + 0.5*2*2;
  wall_thickness = 0.5*3;
  room_for_flange_and_belt = 2.5;
  height = xy_pos_z-z_rail_top_pos_z-extrusion_side/2-1.3;
  height_with_clearance = height-(carriage_width(yz_carriage_type)/2-extrusion_side/2)-2;
  main_body_width = z_frame_positioner_idler_pos_x+z_frame_main_idler_od/2+room_for_flange_and_belt+6+wall_thickness;
  bottom_pos_z = -height;

  idler_area_depth = abs(belt_pos_y)+idler_height/2+bevel_height+wall_thickness*2;
  overall_depth = idler_area_depth + extrusion_side;
  echo("overall_depth: ", overall_depth);
  echo("idler_area_depth: ", idler_area_depth);

  module position_main_idler() {
    translate([z_frame_main_idler_pos_x,belt_pos_y,z_frame_main_idler_pos_z]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module position_positioner_idler() {
    translate([z_frame_positioner_idler_pos_x,belt_pos_y,z_frame_positioner_idler_top_pos_z]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module idler_pocket() {
    overall_od = idler_od+room_for_flange_and_belt*2;
    overall_height = idler_height+bevel_height*2;
    small_rounded_diam = 2;
    module profile() {
      hull() {
        translate([1,0,0]) {
          square([2,overall_height],center=true);
        }
        translate([overall_od/2-small_rounded_diam/2,0,0]) {
          rounded_square(small_rounded_diam,overall_height,small_rounded_diam);
        }
      }
    }

    rotate_extrude($fn=resolution*2,convexity=3) {
      profile();
    }
    translate([0,-20,0]) {
      rotate([90,0,0]) {
        rounded_cube(overall_od,overall_height,40,small_rounded_diam);
      }
    }
  }

  module position_idlers() {
    position_main_idler() {
      children();
    }
    position_positioner_idler() {
      children();
    }
  }

  module body() {
    echo("height: ", height);
    echo("screw_length=height+depth_to_engage_slot_nuts: ", height+depth_to_engage_slot_nuts);
    translate([extrusion_side/2+main_body_width/2,extrusion_side/2,-height/2]) {
      rounded_cube(main_body_width,extrusion_side,height,rounded_diam);
    }
    hull() {
      translate([0,front*idler_area_depth/2,bottom_pos_z+height_with_clearance/2]) {
        rounded_cube(extrusion_side,idler_area_depth,height_with_clearance,rounded_diam);
        translate([extrusion_side/2+main_body_width-rounded_diam/2,0,0]) {
          rounded_cube(rounded_diam,idler_area_depth,height_with_clearance,rounded_diam);
        }
      }
    }
    translate([extrusion_side/2+main_body_width/2,0,bottom_pos_z+height_with_clearance/2]) {
      cube([main_body_width,extrusion_side,height_with_clearance],center=true);
    }
  }


  module holes() {
    position_idlers() {
      //translate([0,0,pulley_offset(z_frame_main_idler_type)]) {
      translate([0,0,0]) {
        translate([0,0,pulley_offset(z_frame_main_idler_type)]) {
          % pulley(z_frame_main_idler_type);
        }
        idler_pocket();
        hole(bevel_post_id,100,resolution);

        translate([0,0,belt_pos_y-extrusion_side]) {
          rotate([0,0,90]) {
            hole(m3_nut_diam+0.2,m3_nut_height*2+2,6);
          }
        }
      }
    }

    translate([extrusion_side/2,extrusion_side/2,0]) {
      hole_positions_x = [
        m3_nut_diam/2+wall_thickness*2,
        main_body_width-m3_nut_diam/2-wall_thickness*2,
      ];
      for(x=hole_positions_x) {
        translate([x,0,0]) {
          hole(m3_loose_diam,200,resolution);
        }
      }
    }

    translate([0,0,bottom_pos_z+height_with_clearance/2]) {
      spacing = height_with_clearance*0.5;
      for(z=[top,bottom]) {
        translate([0,0,z*spacing/2]) {
          rotate([90,0,0]) {
            hole(m3_loose_diam,100,resolution);
          }
        }
      }
    }
  }

  module bridges() {
    position_idlers() {
      for(z=[top,bottom]) {
        mirror([0,0,z-1]) {
          translate([0,0,-idler_height/2]) {
            difference() {
              bevel(bevel_post_od+bevel_height*2,bevel_post_od,bevel_height);
              hole(bevel_post_id,bevel_height*3,resolution);
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
  bridges();
}

module z_frame_motor_mount() {
  module position_idler() {
    /*
    translate([z_frame_positioner_idler_pos_x,belt_pos_y,z_frame_main_idler_pos_z]) {
      rotate([90,0,0]) {
        children();
      }
    }
    */
  }

  module position_motor() {
    /*
    translate([z_frame_positioner_idler_pos_x,belt_pos_y,z_frame_positioner_idler_top_pos_z]) {
      rotate([90,0,0]) {
        children();
      }
    }
    */
  }

  module body() {
  }

  module holes() {
    position_idler() {
      translate([0,0,pulley_offset(z_frame_main_idler_type)]) {
        % pulley(z_frame_main_idler_type);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

z_assembly();
