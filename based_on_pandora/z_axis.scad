include <./main.scad>;

pom_nut_od = 10.2;
pom_nut_flange_od = 22;
pom_nut_screw_spacing = 16;
pom_nut_screw_hole_diam = 3.5;
pom_nut_flange_height = 3.5;
pom_nut_above_flange_height = 10;
pom_nut_below_flange_height = 1.5;
pom_nut_overall_height = pom_nut_below_flange_height+pom_nut_flange_height+pom_nut_above_flange_height;

rounded_diam = 2;

carriage_idler_spacing = 14;

z_screw_length = printer_config[MOTOR_CONFIGURATION][3];
//z_motor_type = printer_config[MOTOR_CONFIGURATION][z];
z_motor_type = NEMA17_47;
z_motor_side = NEMA_width(z_motor_type);

rail_offset_x = extrusion_vertical_spacing_x/2;
rail_offset_y = extrusion_vertical_spacing_y/2-extrusion_side/2;
rail_offset_z = bottom_pos_z + extrusion_side + z_rail_length/2 + 9;

leadscrew_diam = 8;

mgn_width = carriage_width(z_carriage);
mgn_height = carriage_height(z_carriage);
mgn_length = carriage_length(z_carriage);

stepper_pos_z = bottom_pos_z - 5;
//stepper_offset_x = z_motor_side/2+3/2;
stepper_offset_x = z_motor_side/2;
//stepper_offset_y = -z_motor_side/2+extrusion_side/2+3/2;
//stepper_offset_y = -pom_nut_flange_od/2;
//stepper_offset_y = -z_motor_side/2+extrusion_side/2-3/2;
stepper_offset_y = -z_motor_side/2+extrusion_side/2;
stepper_offset_z = -10;

screw_pos_y = extrusion_main_length/2-motor_xy_width/2;
screw_stepper_pos_z = -10;
z_rail_positions = [
  [[rear_z_offset_x,rail_offset_y,0],[180,0],[0,0,0]],
  [[right*(rail_offset_x),front*rail_offset_y,0],[-90,180],[0,0,0]],
  [[left*(rail_offset_x),front*rail_offset_y,0],[-90,180],[1,0,0]],
];
// using rear module as reference

pom_nut_offset_z = -carriage_length(z_carriage)/2; //+pom_nut_below_flange_height+pom_nut_flange_height;

carriage_offset_z = z_rail_length/2-carriage_length(z_carriage)/2-0; // - pos_z;

tolerance = 0.4;
skew_tolerance = 1;
pom_nut_cavity_diam = pom_nut_od+skew_tolerance;
nut_carrier_base_diam = pom_nut_flange_od+skew_tolerance+3*2;
nut_carrier_floor_thickness = 2;
nut_carrier_base_thickness = nut_carrier_floor_thickness+4;

mgn_mount_thickness = 5;
mgn_mount_cap_thickness = 4;

top_idler_pos_z = gantry_pos_z-extrusion_side/2-12;
carriage_idler_center_pos_z = rail_offset_z+carriage_offset_z;
carriage_idler_pos_x = extrusion_side/2-belt_idler_od/2+0.4;
//carriage_idler_pos_x = extrusion_side/2+mgn_height-belt_idler_od/2-3.5; // something about belt_thickness here?
//carriage_idler_pos_x = extrusion_side/2+mgn_height/2+mgn_mount_thickness;
return_pos_x = carriage_idler_pos_x+10+1.5;
anchor_pos_x = carriage_idler_pos_x-belt_idler_od/2-belt_pitch_to_back(GT2x6);

toothed_to_smooth_dist = belt_pulley_pr(GT2x6, GT2x16_pulley, twisted=true);
motor_pos_x = carriage_idler_pos_x+10/2+toothed_to_smooth_dist;
motor_pos_z = bottom_pos_z-z_motor_side/2-3;

anchor_middle_pos_z = gantry_pos_z-extrusion_side/2;
anchor_bottom_pos_z = bottom_pos_z+extrusion_side;

//belt_plane_offset = mgn_width/2+9/2+mgn_mount_cap_thickness+tolerance;
belt_plane_offset = mgn_width/2+9/2+mgn_mount_thickness+tolerance;
idler_pos_x     = belt_plane_offset;

dist_between_belt_and_corner = belt_plane_offset-extrusion_side/2-belt_width/2;

extrusion_carrier_edge_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-17;
//extrusion_carrier_edge_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-4;

mgn_hole_spacing = 13;
//bed_assembly_offset_z = -extrusion_side/2;
//bed_assembly_offset_z = -mgn_hole_spacing;
//bed_assembly_offset_z = -mgn_length/2;
bed_assembly_offset_z = -5;
//bed_assembly_offset_z = 0;

plate_thickness = build_plate_dimensions[z];
//bed_plate_insulation_spacer_length = 5;
bed_plate_insulation_spacer_diam = 8;
bed_plate_insulation_spacer_length = 10;
bed_plate_offset_y = -extrusion_side/2-bed_plate_insulation_spacer_diam-1;


module pom_nut() {
  module body() {
    translate([0,0,-pom_nut_below_flange_height-pom_nut_flange_height+pom_nut_overall_height/2]) {
      hole(pom_nut_od,pom_nut_overall_height,resolution);
    }
    translate([0,0,-pom_nut_flange_height/2]) {
      hole(pom_nut_flange_od,pom_nut_flange_height,resolution);
    }
  }

  module holes() {
    for(r=[0,90,180,270]) {
      rotate([0,0,r]) {
        translate([0,pom_nut_screw_spacing/2,0]) {
          hole(pom_nut_screw_hole_diam,pom_nut_overall_height,resolution);
        }
      }
    }
  }

  color("#333") difference() {
    body();
    holes();
  }
}

module gt2_teeth() {
}

module belt_anchor_top() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module belt_anchor_middle() {
  //anchor_middle_idler_id = 3; // F623
  anchor_middle_idler_id = m5_thread_into_plastic_diam; // FR105

  idler_stack_bevel_height = 1;
  idler_stack_height = 8+idler_stack_bevel_height*2;
  rounded_diam = 2;
  overall_height = 14;
  idler_pos_y = -return_pos_x+extrusion_side/2;
  idler_cavity_diam = 14;
  wall_thickness = extrusion_width*4*2;
  depth_around_idler = idler_cavity_diam+wall_thickness*2;

  idler_area_depth = abs(idler_pos_y) + depth_around_idler/2;
  idler_area_width = -extrusion_side/2+belt_plane_offset+idler_stack_height/2+wall_thickness;

  //extrusion_front_thickness = abs(idler_pos_y)+anchor_middle_idler_id/2+wall_thickness;
  //extrusion_side_thickness = abs(belt_plane_offset)-extrusion_side/2+belt_width/2+1;
  extrusion_front_thickness = 14;
  //extrusion_side_thickness = 14;
  extrusion_side_thickness = dist_between_belt_and_corner-2;

  zip_tie_width = 3;
  zip_tie_thickness = 2;

  module position_idler() {
    translate([belt_plane_offset,idler_pos_y,top_idler_pos_z]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }

  module body() {
    translate([0,0,top_idler_pos_z]) {
      translate([extrusion_side/2+extrusion_side_thickness/2,extrusion_side/2,0]) {
        rounded_cube(extrusion_side_thickness,extrusion_side+0,overall_height,rounded_diam);
      }
      translate([extrusion_side/2+idler_area_width/2,-idler_area_depth/2+wall_thickness/2,0]) {
        rounded_cube(idler_area_width,idler_area_depth+wall_thickness,overall_height,rounded_diam);
      }
      translate([rounded_diam,front*(extrusion_front_thickness/2),0]) {
        rounded_cube(extrusion_side+rounded_diam*2,extrusion_front_thickness,overall_height,rounded_diam);
      }
    }
  }

  module holes() {
    position_idler() {
      difference() {
        rotate([0,-90,0]) {
          rounded_cube(idler_stack_height,idler_cavity_diam,overall_height*2,rounded_diam);
        }
        for(z=[top,bottom]) {
          mirror([0,0,z-1]) {
            translate([0,0,-8/2]) {
              small_od = 6.5;
              large_od = small_od+idler_stack_bevel_height*2;
              bevel(large_od,small_od,idler_stack_bevel_height);
            }
          }
        }
      }
      hole(anchor_middle_idler_id,2*(extrusion_side/2+belt_plane_offset-wall_thickness),resolution);
      translate([0,0,idler_area_width/2]) {
        hole(5,idler_area_width,resolution);
      }
    }

    for(z=[top,bottom]) {
      spacing = anchor_middle_idler_id+m3_through_hole_diam+extrude_height*5;

      // front
      translate([0,0,top_idler_pos_z+z*(spacing/2)]) {
        rotate([90,0,0]) {
          hole(m3_through_hole_diam,extrusion_side*3,resolution);
        }
      }
      // side
      translate([0,extrusion_side/2,top_idler_pos_z+z*(spacing/2)]) {
        rotate([0,90,0]) {
          hole(m3_through_hole_diam,extrusion_side*3,resolution);
        }
      }
    }

    translate([extrusion_side/2+extrusion_side_thickness,carriage_idler_pos_x+extrusion_side/2,top_idler_pos_z]) {
      //cube([belt_width*2,1.5,overall_height+1],center=true);
    }

    /*
    zip_tie_cavity_width = belt_width+3;
    zip_tie_cavity_depth = 8;
    translate([extrusion_side/2+extrusion_side_thickness,extrusion_side-zip_tie_cavity_depth/2,top_idler_pos_z]) {
      difference() {
        rounded_cube((zip_tie_cavity_width+zip_tie_thickness)*2,zip_tie_cavity_depth+zip_tie_thickness*2,zip_tie_width,zip_tie_cavity_depth+zip_tie_thickness*2);
        rounded_cube(zip_tie_cavity_width*2,zip_tie_cavity_depth,zip_tie_width+1,zip_tie_cavity_depth);
        // avoid odd bridging
        translate([0,0,zip_tie_width/2]) {
          cube([belt_width*2,zip_tie_cavity_depth*2,extrude_height*2],center=true);
        }
      }
    }
    */
  }

  difference() {
    body();
    holes();
  }
}

module belt_anchor_bottom() {
  rounded_diam = 2;
  mount_width = dist_between_belt_and_corner*2+belt_width;
  mount_depth = extrusion_side;
  mount_thickness = 8;
  screw_anchor_body_diam = m3_through_hole_diam+extrusion_width*3*2*2;

  doubled_belt_thickness = 1.95;

  module position_smooth_side_of_belt() {
    translate([belt_plane_offset,0,extrusion_side]) {
      children();
    }
  }

  module body() {
    translate([extrusion_side/2+mount_width/2,extrusion_side/2,extrusion_side+mount_thickness/2]) {
      rounded_cube(mount_width,mount_depth,mount_thickness,rounded_diam);
    }
  }

  module holes() {
    translate([belt_plane_offset,extrusion_side/2,extrusion_side]) {
      for(x=[left,right]) {
        translate([x*(belt_width/2+dist_between_belt_and_corner/2),0,0]) {
          hole(m3_through_hole_diam,40,resolution);
        }
      }
      translate([0,-carriage_idler_pos_x+belt_idler_od/2,0]) {
        fudge = 0.2;
        belt_opening_width = belt_width+fudge;
        belt_opening_depth = doubled_belt_thickness+fudge;
        translate([0,belt_opening_depth/2,0]) {
          rounded_cube(belt_opening_width,belt_opening_depth,mount_thickness*5,fudge);
          
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module too_complex_for_now_belt_anchor_bottom() {
  // use a teardrop as an anchor for now
  // we should make it adjustable, though
  // doubled over belts have a 1.95mm gap on tri-zero
  belt_loop_id = m3_through_hole_diam+extrude_width*2*2*2; // 5.7 on tri-zero
  belt_loop_od = belt_loop_id+belt_thickness*2; // 4.35*2 === 8.7 on tri-zero
  height = 10;

  module belt_loop_profile() {
    module body() {
      translate([0,height/2,0]) {
        square([extrusion_side,height],center=true);
      }
    }

    module holes() {
      translate([-carriage_idler_pos_x+belt_idler_od/2+belt_thickness/2,0,0]) {
        square([belt_thickness,100],center=true);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  translate([0,30,0]) {
    # belt_loop_profile();
  }

  module position_loop() {
    translate([belt_plane_offset,extrusion_side/2,extrusion_side]) {
      rotate([0,0,90]) {
        debug_axes(1);
        rotate([90,0,0]) {
          children();
        }
      }
    }
  }

  module body() {
    position_loop() {
      linear_extrude(height=1,center=true,convexity=2) {
      }
    }
  }

  module holes() {
    # position_loop() {
      linear_extrude(height=10,center=true,convexity=2) {
        belt_loop_profile();
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_carrier() {
  overall_height = carriage_length(z_carriage)-9;

  module position_idlers() {
    for(z=[top,bottom]) {
        for(z=[top,bottom]) {
          translate([idler_pos_x,extrusion_side/2-carriage_idler_pos_x,z*carriage_idler_spacing/2]) {
            rotate([0,90,0]) {
              children();
            }
          }
        }
    }
  }

  module body() {
    translate([mgn_mount_thickness/2+tolerance/2,front*(mgn_height+mgn_mount_thickness/2),0]) {
      rotate([0,90,0]) {
        rounded_cube(overall_height,mgn_mount_thickness,mgn_width+mgn_mount_thickness+tolerance,rounded_diam);
      }
    }
    hull() {
      translate([idler_pos_x-mgn_mount_thickness/2-9/2,front*(mgn_height+mgn_mount_thickness/2),0]) {
        rotate([0,90,0]) {
          rounded_cube(overall_height,mgn_mount_thickness,mgn_mount_thickness,rounded_diam);
        }
      }
      position_idlers() {
        translate([0,0,-9/2-mgn_mount_thickness/2]) {
          hole(12,mgn_mount_thickness,resolution);
        }
      }
    }
  }

  module holes() {
    translate([0,0,0]) {
      rotate([90,0,0]) {
        rotate([0,0,90]) {
          carriage_hole_positions(z_carriage) {
            hole(2.1,overall_height,resolution);
          }
        }
      }
      position_idlers() {
        translate([0,0,-mgn_mount_thickness/2]) {
          hole(m3_through_hole_diam,50,resolution);
        }
      }
    }

    translate([0,20-mgn_height,0]) {
      //cube([mgn_width,40,overall_height*2],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_carrier_bed_mount() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module z_ball_joint_side_endcap() {
  z_ball_diam = 9;
  z_ball_flat_height = 8; // FIXME: don't know yet
  z_ball_flat_diam = 5; // FIXME: don't know yet

  mount_backside_thickness = 4;
  mount_ball_support_thickness = 2;

  module z_ball() {
    intersection() {
      sphere(r=accurate_diam(z_ball_diam,resolution),$fn=resolution);
      translate([0,0,z_ball_diam/2-z_ball_flat_height/2]) {
        cube([z_ball_diam+1,z_ball_diam+1,z_ball_flat_height],center=true);
      }
    }
  }

  module position_z_ball() {
    translate([extrusion_side/2,0,extrusion_side/2+m3_thread_into_plastic_diam/2+wall_thickness]) {
      translate([0,0,0]) {
        rotate([0,90,0]) {
          children();
        }
      }
    }
  }

  module body() {
    position_z_ball() {
      % color("#ddd") z_ball();
      hull() {
        translate([0,0,z_ball_diam/2-z_ball_flat_height-1]) {
          hole(z_ball_flat_diam,2,resolution);
        }
        translate([0,0,bottom*(extrusion_side/2+mount_backside_thickness/2-mount_ball_support_thickness/2)]) {
          # hole(extrusion_side,mount_backside_thickness+mount_ball_support_thickness,resolution);
        }
      }
    }
    hull() {
      translate([0,rear*(extrusion_side/2+mount_backside_thickness/2),0]) {
        translate([extrusion_side/2,0,0]) {
          rotate([90,0,0]) {
            hole(extrusion_side,mount_backside_thickness,resolution);
          }
        }
        translate([-extrusion_side/2,0,0]) {
          rotate([90,0,0]) {
            rounded_cube(extrusion_side,extrusion_side,mount_backside_thickness,rounded_diam,resolution);
          }
        }
      }
    }
  }

  module holes() {
    translate([extrusion_side/2,0,0]) {
      rotate([90,0,0]) {
        hole(m3_through_hole_diam,40,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module old_z_ball_joint_side_endcap() {
  z_ball_diam = 9;
  z_ball_flat_height = 8; // FIXME: don't know yet
  z_ball_flat_diam = 5; // FIXME: don't know yet

  mount_backside_thickness = 4;
  mount_ball_support_thickness = 2;

  module z_ball() {
    intersection() {
      sphere(r=accurate_diam(z_ball_diam,resolution),$fn=resolution);
      translate([0,0,z_ball_diam/2-z_ball_flat_height/2]) {
        cube([z_ball_diam+1,z_ball_diam+1,z_ball_flat_height],center=true);
      }
    }
  }

  module body() {
    hull() {
      translate([extrusion_side/2,0,0]) {
        translate([0,front*5,0]) {
          rotate([90,0,0]) {
            % color("#ddd") z_ball();
            translate([0,0,z_ball_diam/2-z_ball_flat_height-1]) {
              hole(z_ball_flat_diam,2,resolution);
            }
          }
        }
        translate([0,rear*(extrusion_side/2+mount_backside_thickness/2-mount_ball_support_thickness/2),0]) {
          rotate([90,0,0]) {
            hole(extrusion_side,mount_backside_thickness+mount_ball_support_thickness,resolution);
          }
        }
      }
    }
    hull() {
      translate([0,rear*(extrusion_side/2+mount_backside_thickness/2),0]) {
        translate([extrusion_side/2,0,0]) {
          rotate([90,0,0]) {
            hole(extrusion_side,mount_backside_thickness,resolution);
          }
        }
        translate([-extrusion_side/2,0,0]) {
          rotate([90,0,0]) {
            rounded_cube(extrusion_side,extrusion_side,mount_backside_thickness,rounded_diam,resolution);
          }
        }
      }
    }
  }

  module holes() {
    translate([extrusion_side/2,0,0]) {
      rotate([90,0,0]) {
        hole(m3_through_hole_diam,40,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_axis_assembly_belted(pos_z) {
  translate([0,0,rail_offset_z+carriage_offset_z+mgn_length/2-extrusion_side/2]) {
    //translate([0,front*(extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-extrusion_side/2-5),0]) {
    translate([0,front*(extrusion_carrier_edge_pos_y-extrusion_side/2),-pos_z]) {
      translate([0,0,bed_assembly_offset_z]) {
        rotate([0,90,0]) {
          % extrusion(extrusion_main_length);
        }
        for(x=[left,right]) {
          mirror([x-1,0,0]) {
            translate([extrusion_main_length/2,0,0]) {
              z_ball_joint_side_endcap();
            }
          }
        }

        //length = extrusion_shortest_length;
        //rear_bed_extrusion_length = 2*(extrusion_carrier_edge_pos_y-extrusion_side/2);
        rear_bed_extrusion_length = extrusion_short_length;
        //rear_bed_extrusion_length = extrusion_shortest_length;
        rear_bed_extrusion_space_y = 0;
        //length = 150;
        //translate([left*(extrusion_side/2+mgn_width/2+2),extrusion_side/2+rear_bed_extrusion_length/2,0]) {
        translate([0,extrusion_side/2+rear_bed_extrusion_space_y+rear_bed_extrusion_length/2,0]) {
          rotate([90,0,0]) {
            % extrusion(rear_bed_extrusion_length);
          }
          translate([0,rear_bed_extrusion_length/2,0]) {
            rotate([0,0,90]) {
              //z_ball_joint_rear_endcap();
            }
          }
        }

        translate([0,build_plate_dimensions[y]/2+bed_plate_offset_y,extrusion_side/2+plate_thickness/2+bed_plate_insulation_spacer_length]) {
          % color("#CCC") difference() {
            cube(build_plate_dimensions,center=true);
            spacing_x = 110;
            spacing_y = 110;
            for(x=[left,right]) {
              translate([x*spacing_x/2,front*spacing_y/2,0]) {
                hole(m3_through_hole_diam,10,resolution);
              }
            }
            translate([0,rear*spacing_y/2,0]) {
              hole(m3_through_hole_diam,10,resolution);
            }
          }
        }
      }
    }
  }

  module belt_drive_z(motor_side=bottom) {
    rotate([0,0,180]) {
      effective_radius = 6.68-1.38/2;

      belt_points = [
        [anchor_pos_x,bottom_pos_z+extrusion_side*1.5,0],
        [carriage_idler_pos_x,carriage_idler_center_pos_z-carriage_idler_spacing/2-pos_z,f623_2x_idler],
        [motor_pos_x,motor_pos_z,GT2x16_pulley],
        [return_pos_x,top_idler_pos_z,f623_2x_idler],
        [carriage_idler_pos_x,carriage_idler_center_pos_z+carriage_idler_spacing/2-pos_z,f623_2x_idler],
        [anchor_pos_x,gantry_pos_z-extrusion_side,0],
      ];

      rotate([90,0,0]) {
        translate([motor_pos_x,motor_pos_z,-motor_side*(9/2+mgn_mount_thickness)]) {
          rotate([0,90-motor_side*90,0]) {
            rotate([0,0,-motor_side*90]) {
              % NEMA(z_motor_type);
            }
            translate([0,0,9.5]) {
              rotate([180,0,0]) {
                % pulley_assembly(GT2x16_pulley);
              }
            }
          }
        }
        translate([0,0,0]) {
          mirror([0,0,0]) {
            % belt(GT2x6, belt_points, belt_colour = grey(20), tooth_colour = "#795C34", open = true, twist = false, auto_twist = false, start_twist = true);

            for(i=[0:len(belt_points)-1]) {
              p = belt_points[i];
              if (p[2] == f623_2x_idler) {
                translate([p[0],p[1],0]) {
                  % pulley_assembly(f623_2x_idler);
                }
              } else {
              }
            }
          }
        }
      }
    }
  }

  for(x=[left,right]) {
    mirror([-x+1,0,0]) {
      translate([left*(extrusion_vertical_spacing_x/2-belt_plane_offset),front*(extrusion_vertical_spacing_y/2),0]) {
        rotate([0,0,-90]) {
          belt_drive_z();
        }
      }
    }
  }
  
  translate([belt_plane_offset,rear*(extrusion_vertical_spacing_x/2),0]) {
    rotate([0,0,90]) {
      belt_drive_z(top);
    }
  }

  // rear mount is not rotated
  module position_z_modules() {
    for(pod=z_rail_positions) {
      p = pod[0];
      motor_r = pod[1][0];
      mount_r = pod[1][1];
      mirr = pod[2];
      translate(p) {
        mirror(mirr) {
          rotate([0,0,mount_r]) {
            belt_anchor_top();
            belt_anchor_middle();
            belt_anchor_bottom();
            translate([0,0,rail_offset_z]) {
              rotate([90,0,0]) {
                rotate([0,0,90]) {
                  % rail(z_rail,z_rail_length);
                }
              }

              translate([0,0,carriage_offset_z-pos_z]) {
                z_carrier();
                rotate([90,0,0]) {
                  rotate([0,0,90]) {
                    % carriage(z_carriage);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  position_z_modules();
}

module z_axis_assembly_leadscrew(pos_z) {
  rounded_diam = 2;

  z_screw_length = printer_config[MOTOR_CONFIGURATION][3];
  z_motor_type = printer_config[MOTOR_CONFIGURATION][z];
  z_motor_side = NEMA_width(z_motor_type);

  rail_offset_x = extrusion_vertical_spacing_x/2;
  rail_offset_y = extrusion_vertical_spacing_y/2-extrusion_side/2;
  rail_offset_z = bottom_pos_z + extrusion_side + z_rail_length/2 + 15;

  leadscrew_diam = 8;

  mgn_width = carriage_width(z_carriage)+0.4;
  mgn_height = carriage_height(z_carriage);
  mgn_length = carriage_length(z_carriage);

  stepper_pos_z = bottom_pos_z - 5;
  //stepper_offset_x = z_motor_side/2+3/2;
  stepper_offset_x = z_motor_side/2;
  //stepper_offset_y = -z_motor_side/2+extrusion_side/2+3/2;
  //stepper_offset_y = -pom_nut_flange_od/2;
  //stepper_offset_y = -z_motor_side/2+extrusion_side/2-3/2;
  stepper_offset_y = -z_motor_side/2+extrusion_side/2;
  stepper_offset_z = -10;

  screw_pos_y = extrusion_main_length/2-motor_xy_width/2;
  screw_stepper_pos_z = -10;
  z_rail_positions = [
    [[rear_z_offset_x,rail_offset_y,0],[180,0],[0,0,0]],
    [[right*(rail_offset_x),front*rail_offset_y,0],[-90,180],[0,0,0]],
    [[left*(rail_offset_x),front*rail_offset_y,0],[-90,180],[1,0,0]],
  ];
  // using rear module as reference

  pom_nut_offset_z = -carriage_length(z_carriage)/2; //+pom_nut_below_flange_height+pom_nut_flange_height;

  carriage_offset_z = z_rail_length/2-carriage_length(z_carriage)/2-pos_z;

  skew_tolerance = 1;
  pom_nut_cavity_diam = pom_nut_od+skew_tolerance;
  nut_carrier_base_diam = pom_nut_flange_od+skew_tolerance+3*2;
  nut_carrier_floor_thickness = 2;
  nut_carrier_base_thickness = nut_carrier_floor_thickness+4;

  translate([0,0,rail_offset_z+carriage_offset_z+pom_nut_offset_z+mgn_length/2]) {
    translate([0,front*(rail_offset_y+stepper_offset_y-nut_carrier_base_diam/2-extrusion_side/2-5),0]) {
      rotate([0,90,0]) {
        % extrusion(extrusion_main_length);
      }

      length = extrusion_shortest_length;
      spacer = 10;
      translate([0,extrusion_side/2+spacer+length/2,0]) {
        rotate([90,0,0]) {
          % extrusion(length);
        }
      }

      translate([0,120*0.33,extrusion_side/2+4]) {
        //% cube(build_volume,center=true);
        //# % color("#CCC") cube([120,120,6],center=true);
      }
    }
  }

  module z_carrier() {
    overall_height = carriage_length(z_carriage);

    mgn_mount_thickness = 5;

    module position_pom_nut() {
      translate([stepper_offset_x,stepper_offset_y,-carriage_length(z_carriage)/2]) {
        children();
      }
    }

    module body() {
      position_pom_nut(){
        translate([0,0,nut_carrier_base_thickness/2]) {
          hole(nut_carrier_base_diam,nut_carrier_base_thickness,resolution*2);
        }
      }
      translate([mgn_mount_thickness/2,front*(mgn_height+mgn_mount_thickness/2),0]) {
        rounded_cube(mgn_width+mgn_mount_thickness,mgn_mount_thickness,overall_height,rounded_diam);
      }
      side_depth = mgn_height+mgn_mount_thickness;
      translate([mgn_width/2+mgn_mount_thickness/2,front*side_depth/2,0]) {
        rounded_cube(mgn_mount_thickness,side_depth,overall_height,rounded_diam);
      }
    }

    module holes() {
      translate([0,0,0]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            carriage_hole_positions(z_carriage) {
              hole(2.1,overall_height,resolution);
            }
          }
        }
      }

      position_pom_nut() {
        hole(pom_nut_cavity_diam,overall_height*2+1,resolution);
        base_r = 28;
        for(r=[base_r,base_r+90]) {
          rotate([0,0,r]) {
            small_diam = m3_through_hole_diam+skew_tolerance;
            large_diam = m3_head_diam+skew_tolerance;
            rounded_cube(small_diam,pom_nut_screw_spacing+small_diam,overall_height*2+1,small_diam);
            translate([0,0,nut_carrier_floor_thickness+overall_height]) {
              rounded_cube(large_diam,pom_nut_screw_spacing+large_diam,overall_height*2,large_diam);
            }
          }
        }
      }
      translate([0,20-mgn_height,0]) {
        cube([mgn_width,40,overall_height*2],center=true);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module position_z_modules() {
    for(pod=z_rail_positions) {
      p = pod[0];
      motor_r = pod[1][0];
      mount_r = pod[1][1];
      mirr = pod[2];
      translate(p) {
        mirror(mirr) {
          rotate([0,0,mount_r]) {
            translate([0,0,rail_offset_z]) {
              rotate([90,0,0]) {
                rotate([0,0,90]) {
                  % rail(z_rail,z_rail_length);
                }
              }

              translate([0,0,carriage_offset_z]) {
                z_carrier();
                rotate([90,0,0]) {
                  rotate([0,0,90]) {
                    % carriage(z_carriage);
                  }
                }
              }
            }
            translate([stepper_offset_x,stepper_offset_y,0]) {
              translate([0,0,rail_offset_z+carriage_offset_z+pom_nut_offset_z]) {
                % pom_nut();
              }
              translate([0,0,stepper_offset_z]) {
                rotate([0,0,motor_r]) {
                  % NEMA(z_motor_type);
                  translate([0,0,z_screw_length/2]) {
                    % color("silver") hole(8,z_screw_length,resolution);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  position_z_modules();
}

module z_axis_assembly(pos_z) {
  //z_axis_assembly_leadscrew(pos_z);
  z_axis_assembly_belted(pos_z);
}
