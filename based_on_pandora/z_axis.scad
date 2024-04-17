include <./main.scad>;

pom_nut_od = 10.2;
pom_nut_flange_od = 22;
pom_nut_screw_spacing = 16;
pom_nut_screw_hole_diam = 3.5;
pom_nut_flange_height = 3.5;
pom_nut_above_flange_height = 10;
pom_nut_below_flange_height = 1.5;
pom_nut_overall_height = pom_nut_below_flange_height+pom_nut_flange_height+pom_nut_above_flange_height;

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

module z_axis_assembly_belted(pos_z) {
  rounded_diam = 2;

  carriage_idler_spacing = 14;

  z_screw_length = printer_config[MOTOR_CONFIGURATION][3];
  //z_motor_type = printer_config[MOTOR_CONFIGURATION][z];
  z_motor_type = NEMA17_47;
  z_motor_side = NEMA_width(z_motor_type);

  rail_offset_x = extrusion_vertical_spacing_x/2;
  rail_offset_y = extrusion_vertical_spacing_y/2-extrusion_side/2;
  rail_offset_z = bottom_pos_z + extrusion_side + z_rail_length/2 + 15;

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

  carriage_offset_z = z_rail_length/2-carriage_length(z_carriage)/2-pos_z;

  tolerance = 0.4;
  skew_tolerance = 1;
  pom_nut_cavity_diam = pom_nut_od+skew_tolerance;
  nut_carrier_base_diam = pom_nut_flange_od+skew_tolerance+3*2;
  nut_carrier_floor_thickness = 2;
  nut_carrier_base_thickness = nut_carrier_floor_thickness+4;

  top_idler_pos_z = gantry_pos_z-extrusion_side/2-12;
  carriage_idler_center_pos_z = rail_offset_z+carriage_offset_z;
  carriage_idler_pos_x = extrusion_side/2-belt_idler_od/2+0.4;
  return_pos_x = carriage_idler_pos_x+10+1.5;
  anchor_pos_x = carriage_idler_pos_x-belt_idler_od/2-belt_pitch_to_back(GT2x6);

  toothed_to_smooth_dist = belt_pulley_pr(GT2x6, GT2x16_pulley, twisted=true);
  motor_pos_x = carriage_idler_pos_x+10/2+toothed_to_smooth_dist;
  motor_pos_z = bottom_pos_z-z_motor_side/2-3;

  anchor_top_pos_z = gantry_pos_z-extrusion_side/2;
  anchor_bottom_pos_z = bottom_pos_z+extrusion_side;

  mgn_mount_thickness = 5;

  extrusion_carrier_edge_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-3;

  translate([0,0,rail_offset_z+carriage_offset_z+mgn_length/2-extrusion_side/2]) {
    //translate([0,front*(extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-extrusion_side/2-5),0]) {
    translate([0,front*(extrusion_carrier_edge_pos_y-extrusion_side/2),0]) {
      rotate([0,90,0]) {
        //% extrusion(extrusion_main_length);
      }

      //length = extrusion_shortest_length;
      //rear_bed_extrusion_length = 2*(extrusion_carrier_edge_pos_y-extrusion_side/2);
      rear_bed_extrusion_length = extrusion_short_length;
      //length = 150;
      echo("rear_bed_extrusion_length: ", rear_bed_extrusion_length);
      spacer = 10;
      translate([left*(extrusion_side/2+mgn_width/2),extrusion_side/2+rear_bed_extrusion_length/2,0]) {
        rotate([90,0,0]) {
          //% extrusion(rear_bed_extrusion_length);
        }
      }

      plate_thickness = build_plate_dimensions[z];
      bed_spacer = 3;
      translate([0,build_plate_dimensions[y]/2-5,extrusion_side/2+plate_thickness/2+bed_spacer]) {
        /*
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
        */
      }
    }
  }


  module z_carrier() {
    overall_height = carriage_length(z_carriage)-9;

    module position_idlers() {
      for(z=[top,bottom]) {
          for(z=[top,bottom]) {
            translate([mgn_width/2+tolerance+mgn_mount_thickness+9/2,belt_idler_od/2-1,z*carriage_idler_spacing/2]) {
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
        translate([mgn_width/2+tolerance+mgn_mount_thickness/2,front*(mgn_height+mgn_mount_thickness/2),0]) {
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
          translate([0,0,-9/2-mgn_mount_thickness/2]) {
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



  belt_plane_offset = mgn_width/2+9/2+mgn_mount_thickness+tolerance;
  //mgn_mount_thickness = 5;
  module belt_drive_z(motor_side=bottom) {
    rotate([0,0,180]) {
      effective_radius = 6.68-1.38/2;

      echo("belt_pitch_to_back(GT2x6): ", belt_pitch_to_back(GT2x6));

      belt_points = [
        [anchor_pos_x,bottom_pos_z+extrusion_side*1.5,0],
        [carriage_idler_pos_x,carriage_idler_center_pos_z-carriage_idler_spacing/2,f623_2x_idler],
        [motor_pos_x,motor_pos_z,GT2x16_pulley],
        [return_pos_x,top_idler_pos_z,f623_2x_idler],
        [carriage_idler_pos_x,carriage_idler_center_pos_z+carriage_idler_spacing/2,f623_2x_idler],
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

  translate([extrusion_vertical_spacing_x/2,front*(extrusion_vertical_spacing_x/2-extrusion_side/2-mgn_height-mgn_mount_thickness-9/2),0]) {
    //belt_drive_z();
  }
  for(x=[left,right]) {
    mirror([-x+1,0,0]) {
      //translate([left*(extrusion_vertical_spacing_x/2-extrusion_side/2),front*(extrusion_vertical_spacing_y/2),0]) {
      translate([left*(extrusion_vertical_spacing_x/2-mgn_width/2-tolerance),front*(extrusion_vertical_spacing_y/2),0]) {
        translate([right*(mgn_mount_thickness+9/2),0,0]) {
          rotate([0,0,-90]) {
            belt_drive_z();
          }
        }
        translate([0,0,rail_offset_z]) {
          rotate([0,90,0]) {
            //% rail(z_rail,z_rail_length);
          }
          translate([0,0,carriage_offset_z]) {
            //z_carrier();
            rotate([0,0,0]) {
              rotate([0,90,0]) {
                //% carriage(z_carriage);
              }
            }
          }
        }
      }
    }
  }
  
  translate([belt_plane_offset,rear*(extrusion_vertical_spacing_x/2),0]) {
  //translate([mgn_width/2+tolerance+mgn_mount_thickness+9/2,rear*(extrusion_vertical_spacing_x/2),0]) {
    rotate([0,0,90]) {
      belt_drive_z(top);
    }
  }

  module anchor_top() {
    //anchor_top_idler_id = 3; // F623
    anchor_top_idler_id = 5; // FR105

    rounded_diam = 2;
    overall_height = 14;
    idler_pos_y = -return_pos_x+extrusion_side/2;
    idler_cavity_diam = 14;
    wall_thickness = extrusion_width*4*2;
    depth_around_idler = idler_cavity_diam+wall_thickness*2;

    idler_area_depth = abs(idler_pos_y) + depth_around_idler/2;
    idler_area_width = -extrusion_side/2+belt_plane_offset+9/2+wall_thickness;

    extrusion_front_thickness = abs(idler_pos_y)+anchor_top_idler_id/2+wall_thickness;
    extrusion_side_thickness = abs(belt_plane_offset)-extrusion_side/2+belt_width/2+1;

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
            rounded_cube(9,idler_cavity_diam,overall_height*2,rounded_diam);
          }
          for(z=[top,bottom]) {
            mirror([0,0,z-1]) {
              translate([0,0,-8/2]) {
                bevel(8,6,0.5);
              }
            }
          }
        }
        hole(anchor_top_idler_id,2*(extrusion_side/2+belt_plane_offset-wall_thickness),resolution);
      }

      for(z=[top,bottom]) {
        spacing = anchor_top_idler_id+m3_through_hole_diam+extrude_height*2;

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
        cube([belt_width*2,1.5,overall_height+1],center=true);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module anchor_bottom() {
    module body() {
    }

    module holes() {
    }

    difference() {
      body();
      holes();
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
            anchor_top();
            anchor_bottom();
            translate([0,0,rail_offset_z]) {
              rotate([90,0,0]) {
                rotate([0,0,90]) {
                  //% rail(z_rail,z_rail_length);
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
