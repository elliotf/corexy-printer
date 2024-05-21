include <./main.scad>;

rounded_diam = 2;

carriage_idler_spacing = 15;
//carriage_idler_spacing_offset_z = 2;
carriage_idler_spacing_offset_z = 0;

z_screw_length = printer_config[MOTOR_CONFIGURATION][3];
//z_motor_type = printer_config[MOTOR_CONFIGURATION][z];
z_motor_type = NEMA17_47;
z_motor_side = NEMA_width(z_motor_type);

rail_offset_x = extrusion_vertical_spacing_x/2;
rail_offset_y = extrusion_vertical_spacing_y/2-extrusion_side/2;
//rail_offset_z = bottom_pos_z + extrusion_side + z_rail_length/2 + 4;
rail_offset_z = bottom_pos_z + extrusion_side + z_rail_length/2 + 0;

leadscrew_diam = 8;

mgn_width = carriage_width(z_carriage);
mgn_height = carriage_height(z_carriage);
mgn_length = carriage_length(z_carriage);

stepper_pos_z = bottom_pos_z - 5;
//stepper_offset_x = z_motor_side/2+3/2;
stepper_offset_x = z_motor_side/2;
//stepper_offset_y = -z_motor_side/2+extrusion_side/2+3/2;
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

carriage_offset_z = z_rail_length/2-carriage_length(z_carriage)/2-0; // - pos_z;

tolerance = 0.4;

mgn_mount_thickness = 5;
mgn_mount_cap_thickness = 4;

top_idler_pos_z = gantry_pos_z-extrusion_side/2-12;
carriage_idler_center_pos_z = rail_offset_z+carriage_offset_z;
//return_pos_x = carriage_idler_pos_x+10+1.5;
//return_pos_x = carriage_idler_pos_x+10+1.5;
return_pos_x = mgn_width/2+belt_idler_od/2+1.75;
//carriage_idler_pos_x = mgn_width/2+belt_idler_od/2+3;
//carriage_idler_pos_x = extrusion_side/2+mgn_height-belt_idler_od/2-3.5; // something about belt_thickness here?
//carriage_idler_pos_x = extrusion_side/2+mgn_height/2+mgn_mount_thickness;
carriage_idler_pos_x = return_pos_x+belt_idler_od+1.4;
//anchor_pos_x = carriage_idler_pos_x-belt_idler_od/2-belt_pitch_to_back(GT2x6);
//anchor_pos_x = carriage_idler_pos_x-belt_idler_od/2-belt_pitch_to_back(GT2x6);
anchor_pos_x = carriage_idler_pos_x+belt_idler_od/2+1.5/2;

//toothed_to_smooth_dist = belt_pulley_pr(GT2x6, GT2x16_pulley, twisted=true);
toothed_to_smooth_dist = belt_pulley_pr(GT2x6, GT2x16_pulley, twisted=true);
//motor_pos_x = carriage_idler_pos_x+10/2+toothed_to_smooth_dist;
//motor_pos_x = carriage_idler_pos_x+10/2+toothed_to_smooth_dist;
//motor_pos_x = carriage_idler_pos_x-belt_pitch_to_back(GT2x6);
motor_pos_x = carriage_idler_pos_x-belt_idler_od/2-toothed_to_smooth_dist;
motor_pos_z = bottom_pos_z-z_motor_side/2-3;

anchor_middle_pos_z = gantry_pos_z-extrusion_side/2;
anchor_bottom_pos_z = bottom_pos_z+extrusion_side;

carrier_idler_tie_diam = 6;
carrier_idler_tie_thickness = 4;
carrier_idler_tie_clearance = 0.5;
//belt_plane_offset = mgn_width/2+9/2+mgn_mount_cap_thickness+tolerance;
//belt_plane_offset = mgn_width/2+9/2+mgn_mount_thickness+tolerance;
belt_plane_offset = extrusion_side/2+1+belt_width/2;
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
//bed_plate_insulation_spacer_length = 10;
bed_plate_insulation_spacer_length = 6; // 10mm spacer, but sunk down some amount. Really only to leave room for bed heater
//bed_plate_offset_y = -extrusion_side/2-bed_plate_insulation_spacer_diam-1;
bed_plate_offset_y = -20;
//rear_bed_extrusion_offset_x = 0;
rear_bed_extrusion_offset_x = left*(extrusion_side/2+bed_plate_insulation_spacer_diam/2);

//front_bed_extrusion_offset_from_bed_y = extrusion_side/2+bed_plate_insulation_spacer_diam/2+1;
//front_bed_extrusion_offset_from_bed_y = 5;
front_bed_extrusion_offset_from_bed_y = front*(extrusion_side/2);
extrusion_carrier_edge_pos_y = bed_plate_offset_y-build_plate_dimensions[y]/2+front_bed_extrusion_offset_from_bed_y;

echo("extrusion_carrier_edge_pos_y: ", extrusion_carrier_edge_pos_y);

bed_pivot_carriage_offset_x = belt_plane_offset+9/2+mgn_mount_thickness;
bed_pivot_carriage_offset_y = front*(mgn_height+mgn_mount_thickness/2);
//bed_pivot_carriage_offset_z = mgn_hole_spacing*0.25;
bed_pivot_carriage_offset_z = bed_assembly_offset_z+extrusion_side/2;

//front_bed_extrusion_length =  extrusion_vertical_spacing_x-extrusion_side-mgn_height*2-17*2;
front_bed_extrusion_length = extrusion_short_length;
echo("front_bed_extrusion_length: ", front_bed_extrusion_length);

z_carrier_mount_thickness = 4;
z_carrier_rounded_diam = min(z_carrier_mount_thickness,2);
z_carrier_height = carriage_length(z_carriage)-6;
z_carrier_pivot_gap_width = 1;
z_carrier_pivot_body_height = 2;

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

module old_belt_anchor_middle() {
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

module z_carrier_base() {
  //belt_idler_max_diam = belt_idler_od+belt_thickness*2+2;
  belt_idler_max_diam = carriage_idler_spacing-extrude_height*2;
  carriage_idler_bevel_height = 1;
  carriage_idler_stack_height = 8;
  idler_area_body_width = carriage_idler_stack_height+carriage_idler_bevel_height*2+z_carrier_mount_thickness*2;
  idler_area_body_depth = belt_idler_max_diam+z_carrier_mount_thickness*2;
  overall_depth = extrusion_side/2+carriage_idler_pos_x+idler_area_body_depth/2;

  module position_idlers() {
    translate([-belt_plane_offset,carriage_idler_pos_x,carriage_idler_spacing_offset_z]) {
      for(z=[top,bottom]) {
        mirror([0,0,z-1]) {
          translate([0,0,-carriage_idler_spacing/2]) {
            rotate([0,90,0]) {
              children();
            }
          }
        }
      }
    }
  }

  module position_carriage() {
    translate([-extrusion_side/2,0,0]) {
      rotate([0,-90,0]) {
        children();
      }
    }
  }

  module profile() {
    module body() {
      hull() {
        translate([-extrusion_side/2-mgn_height-z_carrier_mount_thickness/2,0,0]) {
          rounded_square(z_carrier_mount_thickness,mgn_width,z_carrier_rounded_diam);

          translate([0,extrusion_side/2+idler_area_body_depth/2,0]) {
            rounded_square(z_carrier_mount_thickness,idler_area_body_depth,z_carrier_rounded_diam);
          }
        }
      }
      translate([-belt_plane_offset,carriage_idler_pos_x,0]) {
        rounded_square(idler_area_body_width,idler_area_body_depth,z_carrier_rounded_diam+z_carrier_mount_thickness*2,resolution*2);
      }
    }

    module holes() {
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    linear_extrude(height=z_carrier_height,center=true,convexity=2) {
      profile();
    }
  }

  module holes() {
    position_carriage() {
      % carriage(z_carriage);
      carriage_hole_positions(z_carriage) {
        hole(2.1,z_carrier_height,resolution);
      }
    }
    position_idlers() {
      // for debug
      if (0) {
        translate([0,0,idler_area_body_width/2]) {
          cube([200,200,idler_area_body_width],center=true);
        }
      }
      difference() {
        hull() {
          cavity_thickness = carriage_idler_stack_height+carriage_idler_bevel_height*2;
          rotate_extrude(convexity=1) {
            hull() {
              translate([1,0,0]) {
                square([2,cavity_thickness],center=true);
              }
              translate([belt_idler_max_diam/2-z_carrier_rounded_diam/2,0,0]) {
                rounded_square(z_carrier_rounded_diam,cavity_thickness,z_carrier_rounded_diam,8);
              }
            }
          }
          translate([z_carrier_height/2,0,0]) {
            rotate([0,90,0]) {
              rounded_cube(cavity_thickness,belt_idler_max_diam,1,z_carrier_rounded_diam);
            }
          }
        }
        for(z=[top,bottom]) {
          mirror([0,0,z-1]) {
            translate([0,0,-8/2]) {
              small_od = m3_through_hole_diam+extrude_width*4;
              large_od = small_od+carriage_idler_bevel_height*2;
              bevel(large_od,small_od,carriage_idler_bevel_height);
            }
          }
        }
      }
      translate([0,0,-50]) {
        hole(m3_thread_into_plastic_diam,100,resolution);
      }
      translate([0,0,50]) {
        hole(m3_through_hole_diam,100,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_carrier_anchor_and_pivot(dist_between_carriage_and_extrusion,with_ledge_end=true) {
  anchor_width = 25;
  ledge_width = z_carrier_mount_thickness+8;
  ledge_depth = z_carrier_mount_thickness;
  ledge_height = 2;

  module body() {
    translate([-extrusion_side/2-mgn_height-z_carrier_mount_thickness-z_carrier_pivot_gap_width/2,0,-z_carrier_height/2+z_carrier_pivot_body_height/2]) {
      cube([z_carrier_pivot_gap_width+z_carrier_mount_thickness,z_carrier_mount_thickness,z_carrier_pivot_body_height],center=true);
    }
    hull() {
      translate([dist_between_carriage_and_extrusion-z_carrier_mount_thickness/2,0,bed_pivot_carriage_offset_z]) {
        hole(z_carrier_mount_thickness,extrusion_side,resolution);
      }
      translate([-extrusion_side/2-mgn_height-z_carrier_mount_thickness/2-z_carrier_mount_thickness-z_carrier_pivot_gap_width,0,-z_carrier_height/2+z_carrier_pivot_body_height/2]) {
        hole(z_carrier_mount_thickness,z_carrier_pivot_body_height,resolution);
      }

      translate([dist_between_carriage_and_extrusion-anchor_width+z_carrier_mount_thickness/2,0,bed_pivot_carriage_offset_z]) {
        hole(z_carrier_mount_thickness,extrusion_side,resolution);
      }
      bottom_delta = z_carrier_height/2+bed_pivot_carriage_offset_z-extrusion_side/2;
      translate([dist_between_carriage_and_extrusion-anchor_width+z_carrier_mount_thickness/2+bottom_delta,0,-z_carrier_height/2+bottom_delta/2]) {
        hole(z_carrier_mount_thickness,bottom_delta,resolution);
      }
    }
    // make assembly less fiddly by providing support while screwing in the anchor
    translate([dist_between_carriage_and_extrusion-ledge_width/2+z_carrier_mount_thickness+tolerance/2,0,bed_pivot_carriage_offset_z-extrusion_side/2]) {
      if (with_ledge_end) {
        translate([z_carrier_mount_thickness,z_carrier_mount_thickness/2,ledge_height/2]) {
          rounded_cube(z_carrier_mount_thickness,z_carrier_mount_thickness*2,ledge_height,z_carrier_mount_thickness,resolution);
        }
      }
      hull() {
        translate([0,z_carrier_mount_thickness/2,-ledge_height/2]) {
          rounded_cube(ledge_width,z_carrier_mount_thickness*2,ledge_height,z_carrier_mount_thickness,resolution);
        }
        translate([0,0,-ledge_height-z_carrier_mount_thickness]) {
          rounded_cube(ledge_width-z_carrier_mount_thickness*2,z_carrier_mount_thickness,ledge_height,z_carrier_mount_thickness,resolution);
        }
      }
    }
  }

  module holes() {
    translate([dist_between_carriage_and_extrusion-anchor_width/2,0,bed_pivot_carriage_offset_z]) {
      anchor_hole_spacing = 12;
      anchor_hole_offset = 1;
      for(x=[left,right]) {
        translate([anchor_hole_offset+x*anchor_hole_spacing/2,0,0]) {
          rotate([90,0,0]) {
            hole(m3_through_hole_diam,z_carrier_mount_thickness*3,resolution);
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

module bed_post_extrusion_mount() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module z_carrier_rear() {
  module body() {
    rotate([0,0,90]) {
      mirror([0,1,0]) {
        z_carrier_base();
      }
    }

    bed_pivot_offset_x = -rear_z_offset_x+rear_bed_extrusion_offset_x;
    extrusion_anchor_offset = bed_pivot_carriage_offset_z-extrusion_side/2;
    
    anchor_length = 25;
    dist_to_extrusion = 4;

    translate([-rear_z_offset_x,-extrusion_side/2-carriage_height(z_carriage)-z_carrier_mount_thickness/2,-z_carrier_height/2]) {
      translate([0,0,z_carrier_pivot_body_height]) {
        rounded_cube(z_carrier_mount_thickness,z_carrier_mount_thickness,z_carrier_pivot_body_height*2,z_carrier_rounded_diam);
      }
      translate([0,0,z_carrier_pivot_body_height/2]) {
        hull() {
          rounded_cube(z_carrier_mount_thickness,z_carrier_mount_thickness,z_carrier_pivot_body_height,z_carrier_rounded_diam);
          translate([0,-z_carrier_mount_thickness/2-z_carrier_pivot_gap_width-anchor_length/4,0]) {
            rounded_cube(z_carrier_mount_thickness,anchor_length/2,z_carrier_pivot_body_height,z_carrier_rounded_diam);
          }
        }
      }
    }
    translate([0,-extrusion_side/2-carriage_height(z_carriage)-z_carrier_mount_thickness-z_carrier_pivot_gap_width,-z_carrier_height/2]) {
      hull() {
        translate([0,0,z_carrier_pivot_body_height/2]) {
          translate([-rear_z_offset_x,-anchor_length/4,0]) {
            rounded_cube(z_carrier_mount_thickness,anchor_length/2,z_carrier_pivot_body_height,z_carrier_rounded_diam);
          }
          translate([bed_pivot_offset_x,-dist_to_extrusion/2-anchor_length/2,0]) {
            rounded_cube(extrusion_side,anchor_length+dist_to_extrusion,z_carrier_pivot_body_height,z_carrier_rounded_diam);
          }
        }
        translate([bed_pivot_offset_x,-dist_to_extrusion-anchor_length/2,z_carrier_height/2+extrusion_anchor_offset-1]) {
          rounded_cube(extrusion_side,anchor_length,2,z_carrier_rounded_diam);
        }
      }
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module z_carrier_front() {
  dist_between_carriage_and_extrusion_y = abs(extrusion_vertical_spacing_y/2)-front*extrusion_carrier_edge_pos_y-extrusion_side/2;
  dist_between_carriage_and_extrusion_x = front_bed_extrusion_length/2-extrusion_vertical_spacing_x/2;
  echo("dist_between_carriage_and_extrusion_x: ", dist_between_carriage_and_extrusion_x);

  module body() {
    z_carrier_base();

    translate([0,dist_between_carriage_and_extrusion_y-z_carrier_mount_thickness/2,0]) {
      z_carrier_anchor_and_pivot(dist_between_carriage_and_extrusion_x);
    }
  }

  module holes() {
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

              translate([0,0,-build_plate_dimensions[z]/2-5.1]) {
                % hole(bed_plate_insulation_spacer_diam,10,resolution);
              }
            }
          }
          translate([0,rear*spacing_y/2,0]) {
            hole(m3_through_hole_diam,10,resolution);

            translate([0,0,-build_plate_dimensions[z]/2-5.1]) {
              % hole(bed_plate_insulation_spacer_diam,10,resolution);
            }
          }
        }
      }
      translate([0,extrusion_carrier_edge_pos_y,0]) {
        rotate([0,90,0]) {
          //% extrusion(extrusion_main_length);
          % extrusion(front_bed_extrusion_length);
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
        //rear_bed_extrusion_length = extrusion_shortest_length;
        //rear_bed_extrusion_length = 150;
        rear_bed_extrusion_length = extrusion_short_length;
        //rear_bed_extrusion_length = extrusion_shortest_length;
        rear_bed_extrusion_space_y = 0;

        //length = 150;
        //translate([left*(extrusion_side/2+mgn_width/2+2),extrusion_side/2+rear_bed_extrusion_length/2,0]) {
        translate([rear_bed_extrusion_offset_x,extrusion_side/2+rear_bed_extrusion_space_y+rear_bed_extrusion_length/2,0]) {
          rotate([90,0,0]) {
            % extrusion(rear_bed_extrusion_length);
          }
        }
      }
    }
  }

  module belt_drive_z(motor_side=top) {
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
        translate([motor_pos_x,motor_pos_z,-motor_side*(belt_width/2+mgn_mount_thickness)]) {
          rotate([0,90-motor_side*90,0]) {
            rotate([0,0,-motor_side*90]) {
              % NEMA(z_motor_type);
            }
            //translate([0,0,9.5]) { // when 9/2 instead of belt_width/2
            translate([0,0,8]) {
              rotate([180,0,0]) {
                % pulley_assembly(GT2x16_pulley);
              }
            }
          }
        }
        translate([0,0,0]) {
          mirror([0,0,0]) {
            % belt(GT2x6, belt_points, belt_colour = grey(20), tooth_colour = "#795C34", open = true, twist = false, auto_twist = false, start_twist = false);

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
  //for(x=[right]) {
    mirror([x-1,0,0]) {
      translate([right*(extrusion_vertical_spacing_x/2-belt_plane_offset),front*(extrusion_vertical_spacing_y/2),0]) {
        rotate([0,0,-90]) {
          belt_drive_z();
        }
      }
    }
  }
  
  /*
  translate([rear_z_offset_x+belt_plane_offset,rear*(extrusion_vertical_spacing_y/2),0]) {
    rotate([0,0,90]) {
      belt_drive_z(top);
    }
  }
  */
  translate([rear_z_offset_x,rear*(extrusion_vertical_spacing_y/2-extrusion_side-belt_plane_offset),0]) {
    mirror([1,0,0]) {
      rotate([0,0,0]) {
        belt_drive_z(top);
      }
    }
  }

  /*
  translate([rear_z_offset_x,rear*(extrusion_vertical_spacing_y/2-extrusion_side*1.5),0]) {
    translate([0,0,rail_offset_z]) {
      rotate([90,0,0]) {
        rotate([0,0,90]) {
          % rail(z_rail,z_rail_length);
        }
      }

      translate([0,0,carriage_offset_z-pos_z]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            //% carriage(z_carriage);
          }
        }
      }
    }
  }
  */

  // rear mount is not rotated
  module position_z_modules() {
    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        translate([extrusion_vertical_spacing_x/2,front*extrusion_vertical_spacing_y/2,0]) {
          rotate([0,0,0]) {
            belt_anchor_top();
            //belt_anchor_middle(); // not used anymore, I think
            //belt_anchor_bottom();
            translate([0,0,rail_offset_z]) {
              translate([-extrusion_side/2,0,0]) {
                rotate([0,-90,0]) {
                  % rail(z_rail,z_rail_length);
                }
              }

              translate([0,0,carriage_offset_z-pos_z]) {
                z_carrier_front();
                translate([-extrusion_side/2,0,0]) {
                  rotate([0,-90,0]) {
                    //% carriage(z_carriage);
                  }
                }
              }
            }
          }
        }
      }
    }

    translate([rear_z_offset_x,rear*(extrusion_vertical_spacing_y/2-extrusion_side*1),0]) {
      translate([0,0,rail_offset_z]) {
        translate([0,front*extrusion_side/2,0]) {
          rotate([90,0,0]) {
            rotate([0,0,90]) {
              % rail(z_rail,z_rail_length);
            }
          }
        }

        rotate([0,0,00]) {
          translate([0,0,carriage_offset_z-pos_z]) {
            z_carrier_rear();
            translate([0,-extrusion_side/2,0]) {
              rotate([0,0,0]) {
                //% carriage(z_carriage);
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
