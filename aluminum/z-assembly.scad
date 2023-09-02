include <config.scad>; 

z_idler_type = f623_2x_idler;
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
z_frame_bottom_idler_pos_z = 0;

// use an extra belt idler so:
// * we can move the main idler closer to vertical support
// * we do not need to worry about alignment of bearings caused by belt thickness as it
// FIXME: we need to use a smaller diameter bearing than the z carriage bearing to avoid the belt rubbing on the stationary side

idler_to_idler_belt_flip_spacing = 11.38; // FIXME: calculate this based on bearings
idler_to_pulley_belt_flip_spacing = pulley_od(GT2x16_pulley)/2+belt_thickness*0.3+z_idler_od/2; // FIXME: get correct "belt thickness" value
echo("idler_to_pulley_belt_flip_spacing: ", idler_to_pulley_belt_flip_spacing);
z_bearing_offset = idler_to_idler_belt_flip_spacing;
z_frame_main_idler_pos_x = carriage_idler_pos_x + z_bearing_offset;

motor_pos_x = belt_carriage_anchor_pos_x+belt_thickness/2+z_idler_od+belt_thickness/2+z_pulley_diam/2;

z_carriage_idler_spacing = z_idler_od+belt_thickness*2.5;
z_carriage_idler_offset = 0; // let the z carriage hit the frame before the bearings

module z_assembly(pos_z=0) {
  wall_thickness = 0.5*3;
  z_idler_height = 8;
  bevel_height = 0.5;
  //belt_plane_pos_x = carriage_width(yz_carriage_type)/2+bevel_height+m3_nut_height+z_idler_height/2;
  tolerance = 0.2;

  bevel_post_id = pulley_bore(z_idler_type)+0.2;
  bevel_post_od = bevel_post_id + 0.5*2*2;

  plate_thickness = 4;
  belt_plane_pos_x = carriage_width(yz_carriage_type)/2+plate_thickness+bevel_height+z_idler_height/2+tolerance;
  echo("carriage_idler_stack_width: ", z_idler_height+2*(bevel_height+plate_thickness));

  motor_type = NEMA17_47;
  motor_hole_spacing = NEMA_holes(motor_type)[1]-NEMA_holes(motor_type)[0];
  motor_side_of_belt = right;
  //motor_belt_offset = motor_side_of_belt*(belt_width/2+4);
  motor_belt_offset = motor_side_of_belt*(belt_width/2+9);
  motor_pos_x = belt_plane_pos_x+motor_belt_offset;
  //motor_pos_y = front*(pulley_od(GT2x16_pulley)/2+belt_thickness+1);
  motor_pos_y = -motor_hole_spacing/2+m3_loose_diam/2;
  motor_pos_z = bottom_pos_z-z_motor_side/2-extrusion_side/2-1;

  //carriage_idler_pos_y = motor_pos_y+idler_to_pulley_belt_flip_spacing;
  carriage_idler_pos_y = extrusion_side*0.4;
  room_for_flange_and_belt = 3;
  z_carriage_idler_spacing = carriage_length(yz_carriage_type)-z_idler_od-room_for_flange_and_belt;

  frame_idler_pos_y = carriage_idler_pos_y-idler_to_idler_belt_flip_spacing;
  frame_idler_top_pos_z = bottom*(
    carriage_width(yz_carriage_type)/2
    -extrusion_side/2
    +z_idler_od/2
    +belt_thickness*2
    +0 // make clearance for X carriage
  );
  frame_idler_bottom_pos_z = top*(
    //(z_rail_top_pos_z-z_rail_length-bottom_pos_z-extrusion_side/2)/2
    z_idler_od/2+room_for_flange_and_belt
  );

  translate([z_support_beam_x_offset,0,z_support_pos_z]) {
    % extrusion_makerbeam_xl(z_support_extrusion_length);
  }

  module z_carriage() {
    module position_idlers() {
      for(y=[top,bottom]) {
        translate([belt_plane_pos_x,y*z_carriage_idler_spacing/2,-carriage_idler_pos_y]) {
          rotate([0,90,0]) {
            children();
          }
        }
      }
    }

    module rounded_idler_body(diam) {
      module profile() {
        hull() {
          translate([1,0,0]) {
            square([2,plate_thickness],center=true);
          }
          translate([diam/2-rounded_diam/2,0,0]) {
            rounded_square(rounded_diam,plate_thickness,rounded_diam);
          }
        }
      }

      rotate_extrude($fn=resolution*2,convexity=3) {
        profile();
      }
    }

    module body() {
      position_idlers() {
        for(x=[left,right]) {
          mirror([0,0,x-1]) {
            translate([0,0,-z_idler_height/2]) {
              bevel(bevel_post_od+bevel_height*2,bevel_post_od,bevel_height);
            }
          }
        }
      }

      for(x=[left,right]) {
        translate([0,0,0]) {
          hull() {
            position_idlers() {
              mirror([0,0,x-1]) {
                translate([0,0,z_idler_height/2+bevel_height+plate_thickness/2]) {
                  rounded_idler_body(z_idler_od+room_for_flange_and_belt);
                }
              }
            }
            translate([belt_plane_pos_x+x*(z_idler_height/2+bevel_height+plate_thickness/2),0,carriage_height(yz_carriage_type)+plate_thickness/2]) {
              rounded_cube(plate_thickness,carriage_length(yz_carriage_type),plate_thickness,rounded_diam);
            }
          }
        }
      }

      translate([belt_plane_pos_x,0,carriage_clearance(yz_carriage_type)+plate_thickness/2+1]) {
        cube([z_idler_height+bevel_height*2+plate_thickness,carriage_length(yz_carriage_type),plate_thickness],center=true);
      }

      hull() {
        translate([0,0,carriage_height(yz_carriage_type)+plate_thickness/2]) {
          rounded_cube(carriage_width(yz_carriage_type),carriage_length(yz_carriage_type),plate_thickness,rounded_diam);
          
          translate([belt_plane_pos_x-z_idler_height/2-bevel_height-plate_thickness/2,0,0]) {
            rounded_cube(plate_thickness,carriage_length(yz_carriage_type),plate_thickness,rounded_diam);
          }
        }
      }
    }

    module holes() {
      position_idlers() {
        hole(m3_loose_diam,50,resolution);
        translate([0,0,pulley_offset(z_idler_type)]) {
          % pulley(z_idler_type);
        }
      }

      carriage_spacing_y = carriage_pitch_x(yz_carriage_type);
      carriage_spacing_x = carriage_pitch_y(yz_carriage_type);
      echo("carriage_spacing_x, carriage_spacing_y: ", carriage_spacing_x, carriage_spacing_y);
      for(x=[left,right],y=[front,rear]) {
        translate([x*carriage_spacing_x/2,y*carriage_spacing_y/2,0]) {
          hole(screw_radius(carriage_screw(yz_carriage_type))*2, 50, resolution);
        }
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module z_frame_idler_mount() {
    translate([belt_plane_pos_x,frame_idler_pos_y,frame_idler_top_pos_z]) {
      rotate([0,90,0]) {
        translate([0,0,pulley_offset(z_idler_type)]) {
          % pulley(z_idler_type);
        }
      }
    }
  }

  translate([z_support_beam_x_offset,-extrusion_side/2,z_support_pos_z+z_support_extrusion_length/2]) {
    z_frame_idler_mount();
  }

  module z_motor_mount() {
    offset_z = -bottom_pos_z-extrusion_side/2;

    module position_motor() {
      translate([motor_pos_x,motor_pos_y,motor_pos_z+offset_z]) {
        rotate([0,motor_side_of_belt*-90,0]) {
          children();
          /*
          rotate([0,0,180]) {
            NEMA(z_motor);
            translate([0,0,2.5]) {
              rotate([0,0,0]) {
                pulley(GT2x16_pulley);
              }
            }
          }
          */
        }
      }
    }

    module position_idler() {
      translate([belt_plane_pos_x,frame_idler_pos_y,frame_idler_bottom_pos_z]) {
        rotate([0,90,0]) {
          children();
        }
      }
    }

    module body() {
      position_motor() {
        rotate([0,0,180]) {
          % NEMA(z_motor);
          translate([0,0,2.5]) {
            rotate([0,0,0]) {
              % pulley(GT2x16_pulley);
            }
          }
        }
      }
      x_pos_min = -extrusion_side/2;
      x_pos_max = motor_pos_x;
      y_pos_min = motor_pos_y-z_motor_side/2;
      y_pos_max = extrusion_side;
      z_pos_min = motor_pos_z-z_motor_side/2+offset_z-extrusion_side;
      z_pos_mid = -extrusion_side;
      //z_pos_max = frame_idler_bottom_pos_z+z_idler_od/2+room_for_flange_and_belt;
      z_pos_max = z_rail_top_pos_z-z_rail_length-1+offset_z;
      flat_depth = z_idler_od+room_for_flange_and_belt;
      // empty translate for scope
      // main motor mount body
      translate([0,0,0]) {
        width = x_pos_max-x_pos_min;
        echo("width: ", width);
        height = abs(z_pos_min);
        extra_height = bottom_pos_z-extrusion_side/2-motor_pos_z-z_motor_side/2;
        depth = y_pos_max-y_pos_min;

        translate([motor_pos_x-width/2,y_pos_max-depth/2,z_pos_min+height/2]) {
          rotate([90,0,0]) {
            rounded_cube(width,z_motor_side+extra_height,depth,rounded_diam);
          }
        }
      }
      // empty translate for scope
      // mount to z vertical support
      translate([0,0,0]) {
        width = belt_plane_pos_x-z_idler_width/2-bevel_height+extrusion_side/2;
        depth = abs(y_pos_min);
        height = z_pos_max+extrusion_side+z_motor_side/2;

        hull() {
          translate([x_pos_min+width/2,0,0]) {
            translate([0,front*flat_depth/2,z_pos_max-height/2]) {
              rotate([90,0,0]) {
                rounded_cube(width,height,flat_depth,rounded_diam);
              }
            }
            translate([0,y_pos_min+1,z_pos_mid-rounded_diam/2]) {
              rotate([90,0,0]) {
                rounded_cube(width,rounded_diam,2,rounded_diam);
              }
            }
          }
        }
      }
      // empty translate for scope
      // support other side of z idler
      translate([0,0,0]) {
        width = x_pos_max-belt_plane_pos_x-z_idler_width/2-bevel_height;
        depth = abs(y_pos_min);
        height = z_pos_max+extrusion_side+z_motor_side/2;

        hull() {
          translate([x_pos_max-width/2,0,0]) {
            translate([0,front*flat_depth/2,z_pos_max-height/2]) {
              rotate([90,0,0]) {
                rounded_cube(width,height,flat_depth,rounded_diam);
              }
            }
            translate([0,y_pos_min+1,z_pos_mid-rounded_diam/2]) {
              rotate([90,0,0]) {
                rounded_cube(width,rounded_diam,2,rounded_diam);
              }
            }
          }
        }
      }
      position_idler() {
        for(x=[left,right]) {
          mirror([0,0,x-1]) {
            translate([0,0,-z_idler_height/2]) {
              bevel(bevel_post_od+bevel_height*2,bevel_post_od,bevel_height);
            }
            translate([0,0,pulley_offset(z_idler_type)]) {
              % pulley(z_idler_type);
            }
          }
        }
      }
    }

    module holes() {
      position_idler() {
        hole(m3_loose_diam,50,resolution);
        translate([0,0,pulley_offset(z_idler_type)]) {
          % pulley(z_idler_type);
        }
      }
      hull() {
        translate([belt_plane_pos_x,0,0]) {
          translate([0,motor_pos_y,motor_pos_z+offset_z]) {
            rotate([0,90,0]) {
              hole(z_idler_od+room_for_flange_and_belt*2,z_idler_width,resolution);
            }
          }
          translate([0,frame_idler_pos_y,frame_idler_bottom_pos_z]) {
            rotate([0,90,0]) {
              hole(z_idler_od+room_for_flange_and_belt*2,z_idler_width,resolution);
            }
          }
          translate([0,frame_idler_pos_y,z_support_pos_z+z_support_extrusion_length/2+frame_idler_top_pos_z]) {
            rotate([0,90,0]) {
              hole(z_idler_od+room_for_flange_and_belt*2,z_idler_width,resolution);
            }
          }
        }
      }
      position_motor() {
        //dist_to_shaft_support = motor_belt_offset+z_idler_width/2+bevel_height+3;
        dist_to_shaft_support = 20; // shaft is theoretically 24mm long; leave some extra meat
        pulley_clearance_diam = NEMA_boss_radius(z_motor)*2+1;
        translate([0,0,dist_to_shaft_support/2]) {
          hull() {
            hole(pulley_clearance_diam,dist_to_shaft_support,8);
            translate([-z_motor_side/2,0,0]) {
              cube([pulley_clearance_diam,dist_to_shaft_support,dist_to_shaft_support],center=true);
            }
          }
          translate([0,0,dist_to_shaft_support/2]) {
            // sized for 625 bearing
            hole(16+0.2,(5)*2,8);
            hole(16-2,(5+3)*2,8);
          }
        }
        translate([z_motor_side/2,0,motor_belt_offset]) {
          dist_to_extrusion = abs(motor_pos_y);
          //cube([z_motor_side,dist_to_extrusion*2,z_idler_width],center=true);
        }
        for(x=[left,right],y=[front,rear]) {
          translate([x*motor_hole_spacing/2,y*motor_hole_spacing/2,0]) {
            hole(m3_loose_diam,100,8);
          }
        }
      }
    }

    difference() {
      body();
      holes();
    }
  }

  translate([z_support_beam_x_offset,-extrusion_side/2,z_support_pos_z-z_support_extrusion_length/2]) {
    z_motor_mount();
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

    /*
    % translate([motor_pos_x,motor_pos_y,motor_pos_z]) {
      rotate([0,motor_side_of_belt*-90,0]) {
        rotate([0,0,180]) {
          NEMA(z_motor);
          translate([0,0,2.5]) {
            rotate([0,0,0]) {
              pulley(GT2x16_pulley);
            }
          }
        }
      }
    }
    */

    translate([belt_plane_pos_x,0,0]) {
      rotate([0,0,-90]) {
        rotate([90,0,0]) {
          belt_points = [
            [-carriage_idler_pos_y,z_support_pos_z-z_support_extrusion_length/2+5,z_idler_type],
            [-carriage_idler_pos_y,z_rail_top_pos_z-carriage_length(yz_carriage_type)/2-pos_z+z_carriage_idler_offset-z_carriage_idler_spacing/2,z_idler_type],
            //[-frame_idler_pos_y,z_rail_top_pos_z-z_rail_length-z_idler_od/2-1,z_idler_type],
            // bottom idler
            [-frame_idler_pos_y,bottom_pos_z+extrusion_side/2+frame_idler_bottom_pos_z,z_idler_type],
            [-motor_pos_y,motor_pos_z,GT2x16_pulley],
            [-frame_idler_pos_y,z_support_pos_z+z_support_extrusion_length/2+frame_idler_top_pos_z,z_frame_main_idler_type],
            [-carriage_idler_pos_y,z_rail_top_pos_z-carriage_length(yz_carriage_type)/2-pos_z+z_carriage_idler_offset+z_carriage_idler_spacing/2,z_idler_type],
            //[carriage_idler_pos_x,xy_pos_z-carriage_width(yz_carriage_type)/2-1,z_idler_type],
            [-carriage_idler_pos_y,z_support_pos_z+z_support_extrusion_length/2+z_frame_main_idler_pos_z,z_idler_type],
          ];
          % belt(GT2x6, belt_points, belt_colour = grey(20), tooth_colour = "#795C34", open = true, twist = undef, auto_twist = false, start_twist = true);

          /*
          bottom_idler = belt_points[2];
          translate([bottom_idler[x],bottom_idler[y],pulley_offset(z_idler_type)]) {
            % pulley(z_idler_type);
          }
          */
        }
      }
    }
  }
}

module old_z_assembly(pos_z=0) {
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
        [carriage_idler_pos_x,z_support_pos_z+z_support_extrusion_length/2+z_frame_main_idler_pos_z,z_idler_type],
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
  tolerance = 0.2;
  idler_height = 8;
  idler_od = z_frame_main_idler_od;
  bevel_height = 0.5;
  bevel_post_id = pulley_bore(z_frame_main_idler_type)+0.2;
  bevel_post_od = bevel_post_id + 0.5*2*2;
  wall_thickness = 0.5*3;
  room_for_flange_and_belt = 2.5;
  height = xy_pos_z-z_rail_top_pos_z-extrusion_side/2-1.3;
  height_with_clearance = height-(carriage_width(yz_carriage_type)/2-extrusion_side/2)-2;
  main_body_offset_x = tolerance;
  main_body_width = z_frame_main_idler_pos_x+z_frame_main_idler_od/2+room_for_flange_and_belt+6+wall_thickness-main_body_offset_x;
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

  module idler_pocket(swell_by=0) {
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
  }

  module body() {
    echo("height: ", height);
    echo("screw_length=height+depth_to_engage_slot_nuts: ", height+depth_to_engage_slot_nuts);
    translate([extrusion_side/2+main_body_width/2+main_body_offset_x,extrusion_side/2,-height/2]) {
      rounded_cube(main_body_width,extrusion_side,height,rounded_diam);
    }
    hull() {
      translate([0,front*idler_area_depth/2,bottom_pos_z+height_with_clearance/2]) {
        rounded_cube(extrusion_side,idler_area_depth,height_with_clearance,rounded_diam);
        translate([extrusion_side/2+main_body_width-rounded_diam/2+main_body_offset_x,0,0]) {
          rounded_cube(rounded_diam,idler_area_depth,height_with_clearance,rounded_diam);
        }
      }
    }
    translate([extrusion_side/2+main_body_width/2+main_body_offset_x,0,bottom_pos_z+height_with_clearance/2]) {
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
