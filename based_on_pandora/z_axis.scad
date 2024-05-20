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
carriage_idler_spacing_offset_z = 2;

z_screw_length = printer_config[MOTOR_CONFIGURATION][3];
//z_motor_type = printer_config[MOTOR_CONFIGURATION][z];
z_motor_type = NEMA17_47;
z_motor_side = NEMA_width(z_motor_type);

rail_offset_x = extrusion_vertical_spacing_x/2;
rail_offset_y = extrusion_vertical_spacing_y/2-extrusion_side/2;
rail_offset_z = bottom_pos_z + extrusion_side + z_rail_length/2 + 4;

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
  [[rear_z_offset_x,rail_offset_y-extrusion_side,0],[180,0],[0,0,0]],
  [[right*(rail_offset_x),front*rail_offset_y,0],[-90,180],[0,0,0]],
  //[[left*(rail_offset_x),front*rail_offset_y,0],[-90,180],[1,0,0]],
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
carriage_idler_pos_x = extrusion_side/2-belt_idler_od/2+3;
//carriage_idler_pos_x = extrusion_side/2+mgn_height-belt_idler_od/2-3.5; // something about belt_thickness here?
//carriage_idler_pos_x = extrusion_side/2+mgn_height/2+mgn_mount_thickness;
return_pos_x = carriage_idler_pos_x+10+1.5;
anchor_pos_x = carriage_idler_pos_x-belt_idler_od/2-belt_pitch_to_back(GT2x6);

toothed_to_smooth_dist = belt_pulley_pr(GT2x6, GT2x16_pulley, twisted=true);
motor_pos_x = carriage_idler_pos_x+10/2+toothed_to_smooth_dist;
motor_pos_z = bottom_pos_z-z_motor_side/2-3;

anchor_middle_pos_z = gantry_pos_z-extrusion_side/2;
anchor_bottom_pos_z = bottom_pos_z+extrusion_side;

carrier_idler_tie_diam = 6;
carrier_idler_tie_thickness = 4;
carrier_idler_tie_clearance = 0.5;
//belt_plane_offset = mgn_width/2+9/2+mgn_mount_cap_thickness+tolerance;
//belt_plane_offset = mgn_width/2+9/2+mgn_mount_thickness+tolerance;
belt_plane_offset = extrusion_side/2+carrier_idler_tie_clearance+carrier_idler_tie_thickness+8/2;
idler_pos_x     = belt_plane_offset;

dist_between_belt_and_corner = belt_plane_offset-extrusion_side/2-belt_width/2;

//extrusion_carrier_edge_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-17;
//extrusion_carrier_edge_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-4;

mgn_hole_spacing = 13;
//bed_assembly_offset_z = -extrusion_side/2;
//bed_assembly_offset_z = -mgn_hole_spacing;
//bed_assembly_offset_z = -mgn_length/2;
bed_assembly_offset_z = -2;
//bed_assembly_offset_z = 0;

plate_thickness = build_plate_dimensions[z];
//bed_plate_insulation_spacer_length = 5;
bed_plate_insulation_spacer_diam = 8;
bed_plate_insulation_spacer_length = 10;
//bed_plate_insulation_spacer_length = 8; // 10mm spacer, but sunk down some amount. Really only to leave room for bed heater
//bed_plate_offset_y = -extrusion_side/2-bed_plate_insulation_spacer_diam-1;
bed_plate_offset_y = -20;
rear_bed_extrusion_offset_x = left*(extrusion_side/2+bed_plate_insulation_spacer_diam/2);

front_bed_extrusion_offset_from_bed_y = extrusion_side/2+bed_plate_insulation_spacer_diam/2+1;
extrusion_carrier_edge_pos_y = bed_plate_offset_y-build_plate_dimensions[y]/2+front_bed_extrusion_offset_from_bed_y;

echo("extrusion_carrier_edge_pos_y: ", extrusion_carrier_edge_pos_y);

z_ball_diam = 9;
z_ball_flat_height = 8; // FIXME: don't know yet
z_ball_flat_diam = 5; // FIXME: don't know yet
z_ball_pct_cover = 0.4;

//bed_pivot_carriage_offset_x = 0; //belt_plane_offset-9/2-(z_ball_pct_cover*z_ball_diam)/2;
bed_pivot_carriage_offset_x = belt_plane_offset+9/2+mgn_mount_thickness+z_ball_diam/2;
//bed_pivot_carriage_offset_y = front*(mgn_height+mgn_mount_thickness+wall_thickness*2+z_ball_diam/2);
bed_pivot_carriage_offset_y = front*(mgn_height+mgn_mount_thickness/2);
//bed_pivot_carriage_offset_z = mgn_hole_spacing*0.25;
bed_pivot_carriage_offset_z = bed_assembly_offset_z+extrusion_side/2;

module z_ball() {
  % color("#ddd") {
    intersection() {
      sphere(r=accurate_diam(z_ball_diam,resolution),$fn=resolution);
      translate([0,0,z_ball_diam/2-z_ball_flat_height/2]) {
        cube([z_ball_diam+1,z_ball_diam+1,z_ball_flat_height],center=true);
      }
    }
  }
}

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
  //anchor_middle_idler_thread_diam = m5_thread_into_plastic_diam; // FR105
  //anchor_middle_idler_id = m5_through_hole_diam; // FR105
  anchor_middle_idler_thread_diam = m3_thread_into_plastic_diam; // F623
  anchor_middle_idler_id = m3_through_hole_diam; // F623

  idler_stack_bevel_height = 1;
  idler_stack_height = 8+idler_stack_bevel_height*2;
  rounded_diam = 2;
  overall_height = 12;
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
        hole(anchor_middle_idler_id,idler_area_width,resolution);
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
    belt_loop_profile();
  }

  module position_loop() {
    translate([belt_plane_offset,extrusion_side/2,extrusion_side]) {
      rotate([0,0,90]) {
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
    position_loop() {
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
  pivot_area_thickness = z_ball_diam*z_ball_pct_cover;
  ball_cavity_fn = 64;
  ball_cavity_tolerance = 0.0;
  ball_cavity_capture_pct = 0.15;
  ball_cavity_opening_width = z_ball_diam*0.7;
  ball_cavity_vertical_slot_width = z_ball_diam*0.2;
  ball_cavity_vertical_slot_height = z_ball_diam+3*2;

  module position_pivot() {
    translate([bed_pivot_carriage_offset_x,bed_pivot_carriage_offset_y,bed_pivot_carriage_offset_z]) {
      rotate([90,0,0]) {
        rotate([0,0,90]) {
          children();
        }
      }
    }
  }

  module position_idlers() {
    for(z=[top,bottom]) {
        for(z=[top,bottom]) {
          translate([idler_pos_x,extrusion_side/2-carriage_idler_pos_x,carriage_idler_spacing_offset_z+z*carriage_idler_spacing/2]) {
            rotate([0,90,0]) {
              children();
            }
          }
        }
    }
  }

  module body() {
    //mgn_mount_plate_width = mgn_width/2+belt_plane_offset+9/2+mgn_mount_thickness-1;
    mgn_mount_plate_width = mgn_width/2+bed_pivot_carriage_offset_x+z_ball_diam/2+wall_thickness*4;
    translate([-mgn_width/2+mgn_mount_plate_width/2,front*(mgn_height+mgn_mount_thickness/2),0]) {
      rounded_cube(mgn_mount_plate_width,mgn_mount_thickness,overall_height,rounded_diam);
    }
    hull() {
      translate([idler_pos_x+mgn_mount_thickness/2+9/2,front*(mgn_height+mgn_mount_thickness/2),0]) {
        rotate([0,90,0]) {
          rounded_cube(overall_height,mgn_mount_thickness,mgn_mount_thickness,rounded_diam);
        }
      }
      position_idlers() {
        translate([0,0,9/2+mgn_mount_thickness/2]) {
          hole(12,mgn_mount_thickness,resolution);
        }
      }
    }

    hull() {
      bevel_height = 0.5;
      thickness = carrier_idler_tie_thickness-bevel_height;
      position_idlers() {
        translate([0,0,-8/2-bevel_height-thickness/2]) {
          hole(carrier_idler_tie_diam,thickness,resolution);
        }
      }
    }

    //# translate([mgn_width/2+tolerance+mgn_mount_thickness/2,0,0]) {
    /*
    translate([bed_pivot_carriage_offset_x,0,0]) {
      hull() {
        translate([0,-mgn_height-mgn_mount_thickness/2,0]) {
          rotate([0,90,0]) {
            rounded_cube(overall_height,mgn_mount_thickness,mgn_mount_thickness,rounded_diam);
          }
        }
        translate([0,bed_pivot_carriage_offset_y,0]) {
          rotate([0,90,0]) {
            rounded_cube(overall_height,z_ball_diam+2*(2*wall_thickness),mgn_mount_thickness,rounded_diam);
          }
        }
      }
    }
    */
  }

  module holes() {
    position_pivot() {
      //% z_ball();
      sphere(r=accurate_diam(z_ball_diam+ball_cavity_tolerance,resolution),$fn=resolution);
      hole(z_ball_diam*(1-ball_cavity_capture_pct),40,resolution);
      translate([overall_height/2,0,0]) {
        rounded_cube(overall_height,ball_cavity_opening_width,40,rounded_diam);
      }
      rounded_cube(ball_cavity_vertical_slot_height,ball_cavity_vertical_slot_width,40,rounded_diam);
      debug_axes(1);
      translate([-bed_pivot_carriage_offset_z+overall_height/2,0,0]) {
        for(x=[left,right]) {
          mirror([0,x-1,0]) {
            translate([0,ball_cavity_opening_width/2,0]) {
              rotate([0,0,90]) {
                round_corner_filler(rounded_diam,20);
              }
            }
          }
        }
      }
    }
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

module z_ball_joint_rear_endcap() {
  dist_between_carriage_and_extrusion = -9.8;
  dist_to_pivot_y = dist_between_carriage_and_extrusion-bed_pivot_carriage_offset_y;

  dist_from_extrusion_edge_to_z_ball_flat_x = -0.5+z_ball_diam-z_ball_flat_height;

  screw_hole_diam = m3_through_hole_diam;
  screw_body_diam = screw_hole_diam+extrude_width*4*2*2;
  screw_body_length = 15;

  bevel_small_od = screw_hole_diam+extrude_width*3*2;
  bevel_height = 4;
  screw_body_pos_x = 0;

  //echo("dist_between: ", dist_between_carriage_and_extrusion);

  module position_z_ball() {
    translate([-rear_bed_extrusion_offset_x,dist_to_pivot_y,-extrusion_side/2]) {
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
    }
    translate([0,dist_to_pivot_y,-extrusion_side/2]) {
      debug_axes(1);
      rotate([0,90,0]) {
        hull() {
          translate([0,0,0]) {
            hole(screw_body_diam,extrusion_side,resolution);
          }
          translate([0,0,extrusion_side/2+dist_from_extrusion_edge_to_z_ball_flat_x-bevel_height]) {
            hole(bevel_small_od,bevel_height*2,resolution);
          }
        }
      }
    }

    // attach to front bed assembly extrusion
    translate([0,0,0]) {
      hull() {
        translate([0,wall_thickness,0]) {
          rotate([0,90,0]) {
            rounded_cube(extrusion_side,wall_thickness*2,screw_body_length,wall_thickness);
          }
        }
        translate([0,0,-extrusion_side/2]) {
          translate([0,dist_to_pivot_y,0]) {
            rotate([0,90,0]) {
              hole(screw_body_diam,screw_body_length,resolution);
            }
          }
        }
      }
      hull() {
        translate([0,0,-extrusion_side/2-screw_body_diam/4]) {
          translate([0,dist_to_pivot_y,0]) {
            cube([screw_body_length,0.01,screw_body_diam/2],center=true);
          }
          translate([0,-extrusion_side/3,0]) {
            rotate([0,90,0]) {
              rounded_cube(screw_body_diam/2,extrusion_side,screw_body_length,wall_thickness);
            }
          }
        }
      }
    }
  }

  module holes() {
    position_z_ball() {
      hole(m3_through_hole_diam,screw_body_length*4,resolution);
    }
    translate([0,-extrusion_side/3,0]) {
      hole(m3_through_hole_diam,screw_body_length*3,8);
    }
    translate([0,wall_thickness*2,0]) {
      rotate([-90,0,0]) {
        hole(m3_through_hole_diam,screw_body_length*3,8);
        translate([0,0,10]) {
          hole(5.8,20,8);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_ball_joint_side_endcap() {
  dist_between_carriage_and_extrusion = front*(extrusion_vertical_spacing_y/2)-front*extrusion_carrier_edge_pos_y;
  screw_hole_diam = m3_through_hole_diam;
  screw_body_diam = screw_hole_diam+extrude_width*4*2*2;
  screw_body_length = 15;
  bevel_small_od = screw_hole_diam+extrude_width*3*2;
  bevel_height = 4;
  dist_to_pivot_y = dist_between_carriage_and_extrusion-bed_pivot_carriage_offset_y;
  screw_body_pos_x = extrusion_side/2-bed_pivot_carriage_offset_x+z_ball_diam/2-z_ball_flat_height-bevel_height-screw_body_length/2;

  //echo("dist_between: ", dist_between_carriage_and_extrusion);

  module position_z_ball() {
    translate([extrusion_side/2-bed_pivot_carriage_offset_x,dist_to_pivot_y,-extrusion_side/2]) {
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
    }
    translate([screw_body_pos_x,dist_to_pivot_y,-extrusion_side/2]) {
      rotate([0,90,0]) {
        hull() {
          translate([0,0,screw_body_length/2-1]) {
            hole(screw_body_diam,2,resolution);
          }
          translate([0,0,screw_body_length/2]) {
            hole(bevel_small_od,bevel_height*2,resolution);
          }
        }
      }
    }
    // attach to front bed assembly extrusion
    translate([screw_body_pos_x,0,0]) {
      hull() {
        translate([0,-extrusion_side/2-wall_thickness,0]) {
          rotate([0,90,0]) {
            rounded_cube(extrusion_side,wall_thickness*2,screw_body_length,wall_thickness);
          }
        }
        translate([0,0,-extrusion_side/2]) {
          translate([0,-extrusion_side/2-screw_body_diam/4,0]) {
            rotate([0,90,0]) {
              //# rounded_cube(screw_body_diam,screw_body_diam/2,screw_body_length,wall_thickness);
            }
          }
          translate([0,dist_to_pivot_y,0]) {
            rotate([0,90,0]) {
              hole(screw_body_diam,screw_body_length,resolution);
            }
          }
        }
      }
      hull() {
        translate([0,0,-extrusion_side/2-screw_body_diam/4]) {
          translate([0,dist_to_pivot_y,0]) {
            cube([screw_body_length,0.01,screw_body_diam/2],center=true);
          }
          translate([0,0,0]) {
            rotate([0,90,0]) {
              rounded_cube(screw_body_diam/2,extrusion_side,screw_body_length,wall_thickness);
              //hole(screw_body_diam,screw_body_length,resolution);
            }
          }
        }
      }
    }
  }

  module holes() {
    position_z_ball() {
      hole(m3_through_hole_diam,screw_body_length*4,resolution);
    }
    translate([screw_body_pos_x,0,0]) {
      hole(m3_through_hole_diam,screw_body_length*3,8);
      translate([0,front*(extrusion_side/2+wall_thickness*2),0]) {
        rotate([90,0,0]) {
          hole(m3_through_hole_diam,screw_body_length*3,8);
          translate([0,0,10]) {
            hole(5.8,20,8);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_axis_assembly_belted(pos_z) {
  translate([0,0,rail_offset_z+carriage_offset_z+extrusion_side/2]) {
    //translate([0,front*(extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-extrusion_side/2-5),0]) {
    translate([0,0,-pos_z+bed_assembly_offset_z]) {
      translate([0,bed_plate_offset_y,extrusion_side/2+plate_thickness/2+bed_plate_insulation_spacer_length]) {
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
      translate([0,extrusion_carrier_edge_pos_y,0]) {
        rotate([0,90,0]) {
          % extrusion(extrusion_main_length);
        }
        for(x=[left,right]) {
          mirror([x-1,0,0]) {
            translate([extrusion_main_length/2,0,0]) {
              //z_ball_joint_side_endcap();
            }
          }
        }

        translate([-60+rear_bed_extrusion_offset_x,-28,-15/2-6.1]) {
          import("../zruncho3d-tri-zero/STLs/Center_Brace_With_Wagos_x1.stl");
        }

        //length = extrusion_shortest_length;
        //rear_bed_extrusion_length = 2*(extrusion_carrier_edge_pos_y-extrusion_side/2);
        rear_bed_extrusion_length = extrusion_shortest_length;
        //rear_bed_extrusion_length = extrusion_short_length;
        //rear_bed_extrusion_length = extrusion_shortest_length;
        rear_bed_extrusion_space_y = 10;

        //length = 150;
        //translate([left*(extrusion_side/2+mgn_width/2+2),extrusion_side/2+rear_bed_extrusion_length/2,0]) {
        translate([rear_bed_extrusion_offset_x,extrusion_side/2+rear_bed_extrusion_space_y+rear_bed_extrusion_length/2,0]) {
          rotate([90,0,0]) {
            % extrusion(rear_bed_extrusion_length);
          }
          translate([0,rear_bed_extrusion_length/2,0]) {
            z_ball_joint_rear_endcap();
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
        [carriage_idler_pos_x,carriage_idler_center_pos_z+carriage_idler_spacing_offset_z-carriage_idler_spacing/2-pos_z,f623_2x_idler],
        [motor_pos_x,motor_pos_z,GT2x16_pulley],
        [return_pos_x,top_idler_pos_z,f623_2x_idler],
        [carriage_idler_pos_x,carriage_idler_center_pos_z+carriage_idler_spacing_offset_z+carriage_idler_spacing/2-pos_z,f623_2x_idler],
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

  //for(x=[left,right]) {
  for(x=[left]) {
    mirror([-x+1,0,0]) {
      translate([left*(extrusion_vertical_spacing_x/2-belt_plane_offset),front*(extrusion_vertical_spacing_y/2),0]) {
        rotate([0,0,-90]) {
          belt_drive_z();
        }
      }
    }
  }
  
  translate([belt_plane_offset,rear*(extrusion_vertical_spacing_y/2-extrusion_side),0]) {
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

module z_axis_assembly(pos_z) {
  //z_axis_assembly_leadscrew(pos_z);
  z_axis_assembly_belted(pos_z);
}

z_axis_assembly(0);
translate([extrusion_vertical_spacing_x/2,-extrusion_vertical_spacing_y/2,top_pos_z-extrusion_vertical_length/2]) {
  % extrusion(extrusion_vertical_length);
}
