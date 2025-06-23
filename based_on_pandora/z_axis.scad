include <./main.scad>;

rounded_diam = 2;

carriage_idler_spacing = 15;
//carriage_idler_spacing_offset_z = 2;
carriage_idler_spacing_offset_z = 0;

z_screw_length = printer_config[MOTOR_CONFIGURATION][3];
//z_motor_type = printer_config[MOTOR_CONFIGURATION][z];

rail_offset_x = extrusion_vertical_spacing_x/2;
rail_offset_y = extrusion_vertical_spacing_y/2-extrusion_width(extrusion_vertical_type)/2;
//rail_offset_z = bottom_pos_z + extrusion_side + z_rail_length/2 + 4;
rail_offset_z = bottom_pos_z + extrusion_width(extrusion_main_type) + z_rail_length/2 + 0;

leadscrew_diam = 8;
lead_screw_length = 200;
leadscrew_nut_shaft_diam = 10.2;
leadscrew_nut_base_diam = 22;
leadscrew_nut_base_thickness = 3.5;
leadscrew_nut_base_inset = 1.5;
leadscrew_nut_shaft_length = leadscrew_nut_base_inset+leadscrew_nut_base_thickness+10;

//bed_extrusion_type = E2020t;
bed_extrusion_type = MakerbeamXL;

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

carriage_offset_z = z_rail_length/2-carriage_length(z_carriage)/2; // - pos_z;

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
carriage_idler_dist_from_return = belt_idler_od+1.4;
carriage_idler_pos_x = return_pos_x+carriage_idler_dist_from_return;
//anchor_pos_x = carriage_idler_pos_x-belt_idler_od/2-belt_pitch_to_back(GT2x6);
//anchor_pos_x = carriage_idler_pos_x-belt_idler_od/2-belt_pitch_to_back(GT2x6);
anchor_pos_x = carriage_idler_pos_x+belt_idler_od/2+0.4;

gt2_belt_pitch = 2;
approx_pi = 3.14159265359;
function calculatePulleyDiam(teeth) = ((teeth*gt2_belt_pitch)/approx_pi);

z_pulley_teeth = 16;
z_pulley_diam = calculatePulleyDiam(z_pulley_teeth);
largest_pulley_diam = calculatePulleyDiam(25);

carriage_anchor_pos_x = extrusion_side/2+z_pulley_diam+2;
carriage_anchor_center_pos_z = 0;
carriage_anchor_offset_z = rail_offset_z+carriage_offset_z;
carriage_anchor_spacing = 10;

//single_z_idler_pos_x = carriage_anchor_pos_x+belt_idler_od/2;
single_z_idler_pos_x = carriage_anchor_pos_x-belt_idler_od/2-1;
single_z_idler_pos_z = gantry_pos_z-extrusion_side/2-belt_idler_od/2-5+extrusion_side-15; // need to sneak it under the toolhead, mostly for MakerbeamXL. E2020t has tons of room

//belt_plane_offset = max(carriage_width(z_carriage),extrusion_width(extrusion_vertical_type))/2+0.5+belt_width/2;
//belt_plane_offset = max(carriage_width(z_carriage),extrusion_width(extrusion_vertical_type))/2+belt_idler_spacer_length/2;
belt_plane_offset = extrusion_width(extrusion_vertical_type)/2+belt_idler_spacer_length/2;

//toothed_to_smooth_dist = belt_pulley_pr(GT2x6, z_pulley_type, twisted=true);
//toothed_to_smooth_dist = belt_pulley_pr(GT2x6, z_pulley_type, twisted=true);
toothed_to_smooth_dist = belt_pulley_pr(GT2x6, z_pulley_type, twisted=false);
//motor_belt_path_offset = carriage_idler_pos_x-belt_idler_od/2-toothed_to_smooth_dist;
motor_belt_path_offset = carriage_anchor_pos_x-toothed_to_smooth_dist;
z_motor_offset_x = -belt_plane_offset-10;
z_motor_mount_front_desired_depth = 50;
z_base_motor_mount_overall_width = abs(z_motor_offset_x)+extrusion_side/2;
z_motor_mount_wall_thickness = 3;

rear_foot_depth = extrusion_side/2+65;

anchor_middle_pos_z = gantry_pos_z-extrusion_side/2;
anchor_bottom_pos_z = bottom_pos_z+extrusion_side;

z_carrier_mount_thickness = 4;

z_carrier_pivot_length = 3; // should be short enough so that it's not too sloppy
z_carrier_pivot_side = 3; // should be small enough so that it's not too stiff

z_belt_anchor_depth = 20.2;
max_depth_of_z_carrier = carriage_anchor_pos_x+z_belt_anchor_depth+0.4; // FIXME: thickness of belt
leadscrew_carrier_plate_thickness = 6;

carrier_idler_tie_diam = 6;
carrier_idler_tie_thickness = 4;
carrier_idler_tie_clearance = 0.5;
carriage_idler_bevel_height = 1;
carriage_idler_stack_height = 8;
//belt_plane_offset = mgn_width/2+9/2+mgn_mount_cap_thickness+tolerance;
//belt_plane_offset = mgn_width/2+9/2+mgn_mount_thickness+tolerance;

belt_idler_max_diam = carriage_idler_spacing-extrude_height*2;

z_carrier_idler_area_body_width = carriage_idler_stack_height+carriage_idler_bevel_height*2+z_carrier_mount_thickness*2;
z_carrier_idler_area_body_depth = belt_idler_max_diam+z_carrier_mount_thickness*2;

//belt_plane_offset = extrusion_side/2+1+belt_width/2;
//belt_plane_offset_rear = carriage_width(z_carriage)/2+tolerance+z_carrier_idler_area_body_width/2;
belt_plane_offset_rear = belt_plane_offset;
idler_pos_x     = belt_plane_offset;
dist_between_belt_and_corner = belt_plane_offset-extrusion_side/2-belt_width/2;

//extrusion_carrier_edge_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-17;
//extrusion_carrier_edge_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-4;

z_carriage_mount_height = mgn_length-3.5*2;
z_carriage_fastener_area_thickness = 10;
z_carriage_fastener_hole_spacing = 10;
z_carriage_fastener_area_width = 10;
mgn_hole_spacing = 13;
//bed_assembly_offset_z = -extrusion_side/2;
//bed_assembly_offset_z = -mgn_hole_spacing;
//bed_assembly_offset_z = -mgn_length/2;
bed_assembly_offset_z = z_carriage_mount_height/2-extrusion_width(bed_extrusion_type)+0;
//bed_assembly_offset_z = 0;

plate_thickness = build_plate_dimensions[z];
//bed_plate_insulation_spacer_length = 5;
bed_plate_insulation_spacer_diam = 8;
bed_plate_insulation_spacer_length = 10;
//bed_plate_insulation_spacer_length = 6; // 10mm spacer, but sunk down some amount. Really only to leave room for bed heater
//bed_plate_offset_y = -extrusion_side/2-bed_plate_insulation_spacer_diam-1;
bed_plate_offset_y = -17;

adjust_rear_belt_whatnots = 1+belt_idler_od/2+extrusion_side/2;

//front_bed_extrusion_offset_from_bed_y = 5+extrusion_side/2+bed_plate_insulation_spacer_diam/2+1;
front_bed_extrusion_offset_from_bed_y = 5+15/2+bed_plate_insulation_spacer_diam/2;
//front_bed_extrusion_offset_from_bed_y = front*(extrusion_side/2);
//front_bed_extrusion_offset_from_bed_y = 5-extrusion_side/2-bed_plate_insulation_spacer_diam/2;
//front_bed_extrusion_offset_from_bed_y = 5+extrusion_side/2+bed_plate_insulation_spacer_diam/2;
extrusion_carrier_edge_pos_y = bed_plate_offset_y-build_plate_dimensions[y]/2+front_bed_extrusion_offset_from_bed_y;

//rear_bed_extrusion_offset_x = -extrusion_side/2-bed_plate_insulation_spacer_diam/2;
rear_bed_extrusion_offset_x = 0;
//rear_bed_extrusion_offset_x = left*(extrusion_side/2+bed_plate_insulation_spacer_diam/2);
//rear_bed_extrusion_offset_x = extrusion_side/2+bed_plate_insulation_spacer_diam/2;
//length = extrusion_shortest_length;
//rear_bed_extrusion_length = 2*(extrusion_carrier_edge_pos_y-extrusion_side/2);
//rear_bed_extrusion_length = extrusion_shortest_length;
//rear_bed_extrusion_length = 140;
rear_bed_extrusion_length = 100;
//rear_bed_extrusion_length = extrusion_short_length;
//rear_bed_extrusion_length = extrusion_shortest_length;
//rear_bed_extrusion_dist_from_z_carriage = 4;
rear_bed_extrusion_dist_from_z_carriage = leadscrew_nut_base_diam/2+1;
//rear_bed_extrusion_pos_y = extrusion_vertical_spacing_y/2-extrusion_side-max_depth_of_z_carrier+adjust_rear_belt_whatnots-rear_bed_extrusion_length/2-rear_bed_extrusion_dist_from_z_carriage;
rear_bed_extrusion_pos_y = extrusion_vertical_spacing_y/2-extrusion_side*1.5-mgn_height-rear_bed_extrusion_length/2-rear_bed_extrusion_dist_from_z_carriage;

bed_pivot_carriage_offset_x = belt_plane_offset+9/2+mgn_mount_thickness;
bed_pivot_carriage_offset_y = front*(mgn_height+mgn_mount_thickness/2);
//bed_pivot_carriage_offset_z = mgn_hole_spacing*0.25;
bed_pivot_carriage_offset_z = bed_assembly_offset_z+extrusion_side/2;

//front_bed_extrusion_length =  extrusion_vertical_spacing_x-extrusion_side-mgn_height*2-17*2;
front_bed_extrusion_length = extrusion_short_length;

rear_carriage_mount_depth = max_depth_of_z_carrier-adjust_rear_belt_whatnots-extrusion_side/2-mgn_height;

z_idler_brace_body_diam = belt_idler_od+3;
//z_idler_brace_body_thickness = wall_thickness*4;
z_idler_brace_body_thickness = 3.4;
z_idler_bevel_height = 0.5;

rear_z_chain_width = 13.8;
rear_z_chain_depth = 10.8;
rear_z_chain_mounting_hole_spacing = 8;
rear_z_chain_mount_thickness = 4;
clear_z_top_idler = 3; // not sure if we need this, but just in case
rear_z_chain_pos_x = belt_plane_offset+mgn_width/2+0.2+rear_z_chain_width/2+clear_z_top_idler;

marks_for_side = [1,0,3];

module mock_leadscrew_nut() {
  module body() {
    translate([0,0,0]) {
      translate([0,0,leadscrew_nut_shaft_length/2-leadscrew_nut_base_inset ]) {
        hole(leadscrew_nut_shaft_diam,leadscrew_nut_shaft_length,resolution);
      }
      translate([0,0,leadscrew_nut_base_thickness/2]) {
        hole(leadscrew_nut_base_diam,leadscrew_nut_base_thickness,resolution);
      }
    }
  }

  module holes() {
    for(r=[0,90,180,270]) {
      rotate([0,0,r]) {
        translate([0,16/2,0]) {
          hole(3.5,leadscrew_nut_shaft_length*3,resolution/2);
        }
      }
    }
  }

  color("#555") difference() {
    body();
    holes();
  }
}

module z_idler_bevel() {
  height = 0.5;
  id = m3_through_hole_diam + 2;
  od = id + z_idler_bevel_height*2;
  translate([0,0,z_idler_bevel_height]) {
    bevel(od,id,z_idler_bevel_height);
  }
}

module position_bottom_panel_screw_holes() {
  for(x=[left,right],y=[front,rear]) {
    translate([x*bottom_panel_hole_spacing_x/2,y*bottom_panel_hole_spacing_y/2,-z_base_motor_mount_overall_height]) {
      children();
    }
  }
}

module z_idler_top_idler(is_final) {
  overall_width = (center_brace_width-extrusion_side)/2;
  overall_height = extrusion_main_length-single_z_idler_pos_z;
  idler_pos_y = extrusion_vertical_spacing_y/2-extrusion_width(extrusion_vertical_type)-single_z_idler_pos_x+adjust_rear_belt_whatnots;

  vertical_pos_y = extrusion_vertical_spacing_y/2-extrusion_width(extrusion_vertical_type);
  top_of_vertical_brace = extrusion_main_length;
  top_of_vertical_to_brace_y = rear_brace_pos_y-vertical_pos_y;
  top_of_vertical_to_brace_z = motor_xy_pos_z+xy_motor_plate_thickness-top_of_vertical_brace;

  module position_top() {
    translate([rear_z_offset_x,idler_pos_y,extrusion_main_length]) {
      children();
    }
  }

  module position_zip_ties() {
    position_top() {
      translate([0,extrusion_width(extrusion_vertical_type)/2+top_of_vertical_to_brace_y,0]) {
        rotate([-18,0,0]) {
          children();
        }
      }
    }
  }

  module position_idler() {
    translate([rear_z_offset_x+belt_plane_offset,idler_pos_y,single_z_idler_pos_z]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }

  module position_center_brace() {
    position_top() {
      translate([0,top_of_vertical_to_brace_y,top_of_vertical_to_brace_z]) {
        children();
      }
    }
  }

  module body() {
    top_of_extrusion_width = center_brace_width/2+extrusion_side/2;
    module top_of_idler_body() {
      position_top() {
        translate([extrusion_side/2+overall_width/2,0,rounded_diam/2]) {
          rotate([0,90,0]) {
            rounded_cube(rounded_diam,z_idler_brace_body_diam,overall_width,rounded_diam);
          }
        }
      }
    }
    position_center_brace() {
      translate([0,0,-frame_anchor_plastic_thickness/2]) {
        rotate([0,90,0]) {
          rounded_cube(frame_anchor_plastic_thickness,extrusion_width(extrusion_shortest_type),center_brace_width,rounded_diam);
        }
      }
    }
    hull() {
      position_top() {
        // top of extrusion
        translate([0,0,rounded_diam]) {
          rotate([0,90,0]) {
            rounded_cube(rounded_diam*2,extrusion_width(extrusion_vertical_type),extrusion_side,rounded_diam);
          }
        }
      }
      position_center_brace() {
        translate([center_brace_width/2-top_of_extrusion_width/2,0,-top_of_vertical_to_brace_z/2]) {
          rotate([0,90,0]) {
            rounded_cube(top_of_vertical_to_brace_z,extrusion_width(extrusion_shortest_type),top_of_extrusion_width,rounded_diam);
          }
        }
        translate([0,0,-top_of_vertical_to_brace_z/2]) {
          rotate([0,90,0]) {
            //rounded_cube(top_of_vertical_to_brace_z,extrusion_width(extrusion_shortest_type),center_brace_width,rounded_diam);
          }
        }
      }
      top_of_idler_body();
    }
    difference() {
      hull() {
        top_of_idler_body();
        position_idler() {
          translate([0,0,-belt_idler_spacer_length/2+overall_width/2]) {
            hole(z_idler_brace_body_diam,overall_width,resolution);
          }
        }
      }
      position_idler() {
        translate([0,0,-belt_idler_spacer_length/2]) {
          hole(z_idler_brace_body_diam+2,belt_idler_spacer_length*2,resolution);
        }
      }
    }

    position_idler() {
      rotate([180,0,0]) {
        translate([0,0,-belt_idler_spacer_length/2]) {
          z_idler_bevel();
        }
      }
    }
  }

  module holes() {
    position_idler() {
      translate([0,0,-belt_idler_spacer_length/2-3.6+16]) { // FIXME: figure out depth, figure out screw length
        //bridged_hole(m3_head_diam,m3_through_hole_diam,30,is_final);
        hole(m3_through_hole_diam,30,resolution);
      }
    }

    zip_tie_hole_width = 4;
    zip_tie_hole_thickness = 2;
    wall_between_wires_and_zip_ties = 1.5;
    wire_hole_diam = 8;

    module zip_tie_hole(diam) {
      difference() {
        id = diam+2*wall_between_wires_and_zip_ties;
        od = id + zip_tie_hole_thickness*2;
        hole(od,zip_tie_hole_width,resolution);
        hole(id,zip_tie_hole_width+1,resolution);
      }
    }

    position_center_brace() {
      translate([0,extrusion_width(extrusion_shortest_type)/2+4,-zip_tie_hole_width/2-1]) {
        zip_tie_hole(wire_hole_diam);
      }
    }

    position_zip_ties() {
      depth_into_plastic = top_of_vertical_to_brace_y-0.8;

      translate([0,wire_hole_diam/2-depth_into_plastic,0]) {
        hull() {
          hole(wire_hole_diam,50,resolution);
          // avoid overhangs because it's printed on its side
          additional_width = 2;
          translate([-additional_width/2,wire_hole_diam/2-0.5,0]) {
            cube([wire_hole_diam+additional_width,1,50],center=true);
          }
        }

        translate([0,0,zip_tie_hole_width/2+1]) {
          zip_tie_hole(wire_hole_diam);
        }
      }
    }

    head_hole_length = top_of_vertical_to_brace_z;
    position_top() {
      screw_head_diam = screw_head_diam_for_extrusion(extrusion_vertical_type);
      screw_shaft_diam = screw_shaft_diam_for_extrusion(extrusion_vertical_type);

      translate([0,0,frame_anchor_plastic_thickness]) {
        hole(screw_shaft_diam,20,resolution);

        translate([0,0,head_hole_length/2]) {
          hull() {
            hole(screw_head_diam,head_hole_length,resolution);
            for(x=[left,right]) {
              rotate([0,0,x*45]) {
                translate([0,-20,0]) {
                  cube([screw_head_diam,screw_head_diam,head_hole_length],center=true);
                }
              }
            }
          }
        }
      }

      for(z=[-overall_height*0.3]) {
        translate([0,0,z]) {
          rotate([0,90,0]) {
            hole(m3_through_hole_diam,100,resolution);
          }
        }
      }

      translate([0,top_of_vertical_to_brace_y,top_of_vertical_to_brace_z]) {
        for(x=[left,right]) {
          translate([x*(center_brace_width*0.3),0,0]) {
            rotate([0,180,0]) {
              hole(m3_through_hole_diam,20,resolution);
              translate([0,0,frame_anchor_plastic_thickness+head_hole_length/2]) {
                hole(m3_head_diam,head_hole_length,8);
              }
              hull() {
                inside_length = 10;
                outside_length = inside_length+frame_anchor_plastic_thickness+m3_head_diam;
                translate([0,0,top_of_vertical_to_brace_z]) {
                  translate([0,0,inside_length/2]) {
                    hole(m3_head_diam,inside_length,8);
                  }
                  translate([0,extrusion_width(extrusion_shortest_type),outside_length/2]) {
                    hole(m3_head_diam,outside_length,8);
                  }
                }
                translate([0,0,frame_anchor_plastic_thickness+head_hole_length]) {
                  hole(m3_head_diam,0.2,8);

                  translate([0,m3_head_diam,m3_head_diam]) {
                    hole(m3_head_diam,0.2,8);
                  }
                }
              }
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
}

module rear_z_chain_fixed_anchor() {
  translate([0,0,70]) {
    //rear_z_chain_fixed_anchor_mounted_on_rear_center_vertical();
  }
  rear_z_chain_fixed_anchor_mounted_on_rear_bottom_extrusion();
}

module rear_z_chain_fixed_anchor_mounted_on_rear_bottom_extrusion() {
  extra_height_above_mounting_holes = 15;
  chain_mount_height_above_extrusion = 32;
  //mount_height = rear_z_chain_mounting_hole_spacing+m3_threaded_insert_od*2+extra_height;
  mount_height = chain_mount_height_above_extrusion+rear_z_chain_mounting_hole_spacing/2+m3_threaded_insert_od/2+extra_height_above_mounting_holes;
  mount_thickness = 6;
  rounded_diam = 4;
  extrusion_pos_y = extrusion_vertical_spacing_y/2;
  anchor_pos_y = extrusion_pos_y-extrusion_side*1.5-rear_carriage_mount_depth+31;
  brace_wall_thickness = rounded_diam;
  anchor_width = rear_z_chain_width+brace_wall_thickness;
  extrusion_mount_width = abs(rear_z_chain_pos_x)-extrusion_side/2+anchor_width/2;
  extrusion_mount_offset = -rear_z_chain_pos_x+extrusion_side/2+extrusion_mount_width/2;
  extrusion_mount_depth = extrusion_vertical_spacing_y/2+extrusion_side/2-anchor_pos_y+mount_thickness;

  module position_z_chain_anchor() {
    translate([right*(rear_z_chain_pos_x),anchor_pos_y,chain_mount_height_above_extrusion]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module position_extrusion_mount() {
    position_z_chain_anchor() {
      translate([extrusion_mount_offset,-chain_mount_height_above_extrusion,0]) {
        children();
      }
    }
  }

  module position_extrusion_mount_holes() {
    hole_spacing = extrusion_mount_width-2*(m3_head_diam/2+4);
    translate([rear_z_chain_pos_x+extrusion_mount_offset,extrusion_pos_y,z_axis_screw_mount_thickness]) {
      for(x=[left,right]) {
        translate([x*hole_spacing/2,0,0]) {
          children();
        }
      }
    }
  }

  module position_z_chain_holes() {
    position_z_chain_anchor() {
      for(y=[top,bottom]) {
        translate([0,y*rear_z_chain_mounting_hole_spacing/2,0]) {
          children();
        }
      }
    }
  }

  module body() {
    position_z_chain_anchor() {
      sample_height = 50;
      translate([0,sample_height/2-rear_z_chain_mounting_hole_spacing/2,0]) {
        translate([0,0,-rear_z_chain_depth/2]) {
          % cube([rear_z_chain_width,sample_height,rear_z_chain_depth],center=true);
        }
        translate([0,0,30]) {
          % cube([rear_z_chain_width,sample_height,rear_z_chain_depth],center=true);
        }
      }
      translate([-brace_wall_thickness/2,mount_height/2-chain_mount_height_above_extrusion,mount_thickness/2]) {
        rounded_cube(anchor_width,mount_height,mount_thickness,rounded_diam);

        hull() {
          translate([-anchor_width/2+brace_wall_thickness/2,0,0]) {
            rounded_cube(brace_wall_thickness,mount_height,mount_thickness,rounded_diam);

            translate([0,-mount_height/2+mount_thickness/2,mount_thickness/2-extrusion_mount_depth/2]) {
              rounded_cube(brace_wall_thickness,mount_thickness,extrusion_mount_depth,rounded_diam);
            }
          }
        }
      }
    }
    position_extrusion_mount() {
      translate([0,mount_thickness/2,mount_thickness-extrusion_mount_depth/2]) {
        rounded_cube(extrusion_mount_width,mount_thickness,extrusion_mount_depth,rounded_diam);
      }
    }
  }

  module holes() {
    position_z_chain_holes() {
      hole(m3_threaded_insert_od,20,resolution);
    }
    position_extrusion_mount_holes() {
      translate([0,0,-mount_thickness/2+z_axis_screw_mount_thickness]) {
        rotate([0,0,0]) {
          bridged_hole(m3_head_diam,m3_through_hole_diam,30,false);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module rear_z_chain_fixed_anchor_mounted_on_rear_center_vertical() {
  extra_height = 12;
  mount_height = rear_z_chain_mounting_hole_spacing+m3_threaded_insert_od*2+extra_height;
  mount_thickness = extrusion_side-rear_z_chain_depth;
  rounded_diam = 4;
  pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2+mount_thickness/2;

  module position_extrusion_mount() {
    translate([0,pos_y,0]) {
      rotate([-90,0,0]) {
        children();
      }
    }
  }

  module position_extrusion_mount_holes() {
    position_extrusion_mount() {
      for(z=[top,bottom]) {
        translate([0,z*(mount_height/2-m3_through_hole_diam/2-4),0]) {
          children();
        }
      }
    }
  }

  module position_z_chain_anchor() {
    translate([right*(rear_z_chain_pos_x),pos_y,0]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module position_z_chain_holes() {
    position_z_chain_anchor() {
      for(y=[top,bottom]) {
        translate([0,-extra_height/2+y*rear_z_chain_mounting_hole_spacing/2,0]) {
          children();
        }
      }
    }
  }

  module body() {
    hull() {
      width = rear_z_chain_width;
      position_z_chain_anchor() {
        rounded_cube(extrusion_side,mount_height,mount_thickness,rounded_diam);
      }
      position_extrusion_mount() {
        rounded_cube(extrusion_side,mount_height,mount_thickness,rounded_diam);
      }
    }
  }

  module holes() {
    position_z_chain_holes() {
      hole(m3_threaded_insert_od,20,resolution);
    }
    position_extrusion_mount_holes() {
      translate([0,0,-mount_thickness/2+z_axis_screw_mount_thickness]) {
        rotate([0,0,0]) {
          bridged_hole(m3_head_diam,m3_through_hole_diam,30,is_final);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module position_front_z_idler() {
  translate([extrusion_vertical_spacing_x/2-belt_plane_offset,-extrusion_vertical_spacing_y/2+single_z_idler_pos_x,single_z_idler_pos_z]) {
    rotate([0,90,0]) {
      children();
    }
  }
}

module z_idler_front_brace_inner(is_final) {
  thickness = z_idler_brace_body_thickness;
  overall_thickness = belt_plane_offset+belt_idler_spacer_length/2+thickness-extrusion_side/2;
  inner_brace_height = belt_idler_od*3;
  room_for_belt = 1;
  hole_spacing = (inner_brace_height*0.5);

  module position_extrusion_body() {
    translate([extrusion_vertical_spacing_x/2-extrusion_side/2-overall_thickness/2,-extrusion_vertical_spacing_y/2,single_z_idler_pos_z+z_idler_brace_body_diam/2-inner_brace_height/2]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }
  module position_main_body() {
    position_extrusion_body() {
      translate([0,-room_for_belt/2,0]) {
        children();
      }
    }
  }

  module body() {
    position_front_z_idler() {
      translate([0,0,-belt_idler_spacer_length/2]) {
        z_idler_bevel();
      }
    }
    hull() {
      position_front_z_idler() {
        translate([0,0,-belt_idler_spacer_length/2-thickness/2]) {
          hole(z_idler_brace_body_diam,thickness,resolution); // FIXME: shim-free bevel
        }
      }
      position_main_body() {
        translate([0,0,-overall_thickness/2+thickness/2]) {
          rounded_cube(inner_brace_height,extrusion_side-room_for_belt,thickness,z_idler_brace_body_diam/2);
        }
      }
      translate([extrusion_vertical_spacing_x/2-belt_plane_offset-belt_idler_spacer_length/2-thickness/2,-extrusion_vertical_spacing_y/2,single_z_idler_pos_z]) {
        rotate([0,90,0]) {
          //rounded_cube(z_idler_brace_body_diam,extrusion_side,z_idler_brace_body_thickness,2);
        }
      }
    }

    position_main_body() {
      rounded_cube(inner_brace_height,extrusion_side-room_for_belt,overall_thickness,z_idler_brace_body_diam/2);
    }

    position_extrusion_body() {
      // tabs to help with alignment, but might be make it hard to use NDNs
      for(z=[top,bottom,0]) {
        tab_length = 6;
        tab_depth_in = 0.5;
        translate([z*(inner_brace_height/2-tab_length/2),0,overall_thickness/2]) {
          rounded_cube(tab_length,extrusion_slot_width-0.2,tab_depth_in*2,2);
        }
      }
    }
  }

  module holes() {
    position_front_z_idler() {
      hole(m3_through_hole_diam,50,resolution);
    }
    position_extrusion_body() {
      for(x=[left,right]) {
        translate([x*hole_spacing/2,0,overall_thickness/2-z_axis_screw_mount_thickness]) {
          rotate([180,0,0]) {
            bridged_hole(m3_head_diam,m3_through_hole_diam,30,is_final);
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

module z_idler_front_brace_corner(is_final=false) {
  slot_tolerance = 0.2;
  //overall_height = gantry_pos_z-extrusion_side/2-rail_offset_z-z_rail_length/2-0.5;;
  available_height = gantry_pos_z-extrusion_side/2-rail_offset_z-z_rail_length/2-0.5;;
  overall_height = (available_height > extrusion_side) ? extrusion_side : available_height;

  module body() {
    translate([extrusion_vertical_spacing_x/2,-extrusion_vertical_spacing_y/2,0]) {
      hull() {
        translate([0,0,gantry_pos_z-extrusion_side/2]) {
          translate([0,extrusion_side/2+1,-1]) {
            cube([extrusion_side,2,2],center=true);
          }
          translate([0,single_z_idler_pos_x+belt_idler_od+4,-1]) {
            cube([extrusion_side,1,2],center=true);
          }
        }
        //translate([0,extrusion_side/2+3,rail_offset_z+z_rail_length/2+1+0.5]) {
        translate([0,extrusion_side/2+3,gantry_pos_z-extrusion_side/2-overall_height/2]) {
          cube([extrusion_side,6,overall_height],center=true);
        }
      }
      tab_height = 7; // too long?
      translate([0,extrusion_side/2,gantry_pos_z-extrusion_side/2-tab_height/2]) {
        depth_into_slot = 3;
        rounded_cube(extrusion_slot_width-slot_tolerance,depth_into_slot*2,tab_height,2);
      }
    }
    position_front_z_idler() {
      height = 0.5;
      translate([0,0,belt_idler_spacer_length/2-height]) {
        id = m3_through_hole_diam + 2;
        od = id + height*2;
        rotate([180,0,0]) {
          bevel(od,id,height);
        }
      }
    }
  }

  module holes() {
    position_front_z_idler() {
      translate([0,0,0]) {
        hull() {
          depth_into_part = 3;
          delta = m3_through_hole_diam-m3_thread_into_plastic_diam;
          hole(m3_through_hole_diam,belt_idler_spacer_length+2*depth_into_part,resolution);
          hole(m3_thread_into_plastic_diam,belt_idler_spacer_length+2*(depth_into_part+delta),resolution);
        }
        hole(m3_thread_into_plastic_diam,100,resolution);
      }
    }
    translate([extrusion_vertical_spacing_x/2,-extrusion_vertical_spacing_y/2,0]) {
      translate([0,single_z_idler_pos_x+m3_through_hole_diam/2+m3_head_diam/2+wall_thickness*2,gantry_pos_z-extrusion_side/2-z_axis_screw_mount_thickness]) {
        hole(m3_through_hole_diam,40,resolution);
        translate([0,0,-20]) {
          hole(m3_head_diam,40,resolution);
        }
      }
      translate([0,extrusion_side/2+z_axis_screw_mount_thickness,gantry_pos_z-extrusion_side/2-overall_height+m3_head_diam/2+1]) {
        rotate([90,0,0]) {
          hole(m3_through_hole_diam,40,resolution);
          translate([0,0,-20]) {
            hole(m3_head_diam,40,resolution);
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

module z_carriage_bed_anchor_front(is_final,num_marks) {
  anchor_face_pos_x = -front_bed_extrusion_length/2+extrusion_vertical_spacing_x/2-belt_plane_offset-mgn_width/2-z_carriage_fastener_area_width/2-0.1;
  anchor_face_pos_y = -extrusion_carrier_edge_pos_y-extrusion_vertical_spacing_y/2+max_depth_of_z_carrier-z_carriage_fastener_area_thickness;
  anchor_face_pos_z = -extrusion_side/2-bed_assembly_offset_z+13/2;

  frontmost_face = -extrusion_width(bed_extrusion_type)/2-z_carrier_pivot_side;
  carriage_anchor_thickness = abs(frontmost_face)-abs(anchor_face_pos_y);

  pivot_center_pos_x = anchor_face_pos_x-z_carriage_fastener_area_width/2-z_carrier_pivot_length/2;

  module position_bed_pivot() {
    translate([pivot_center_pos_x,front*(extrusion_width(bed_extrusion_type)/2+z_carrier_pivot_side/2),0]) {
      children();
    }
  }

  module position_anchor_face() {
    translate([anchor_face_pos_x,anchor_face_pos_y,anchor_face_pos_z]) {
      children();
    }
  }

  module position_anchor_holes() {
    position_anchor_face() {
      for(z=[top,bottom]) {
        translate([0,0,z*z_carriage_fastener_hole_spacing/2]) {
          rotate([90,0,0]) {
            children();
          }
        }
      }
    }
  }

  module position_extrusion_anchor_holes() {
    translate([pivot_center_pos_x-z_carrier_pivot_length/2-extrusion_width(bed_extrusion_type)/2-z_carriage_fastener_hole_spacing/2,front*(extrusion_width(bed_extrusion_type)/2+z_carrier_pivot_side/2),0]) {
      for(x=[left,right]) {
        translate([x*z_carriage_fastener_hole_spacing/2,0,0]) {
          rotate([90,0,0]) {
            children();
          }
        }
      }
    }
  }

  module body() {
    hull() {
      position_anchor_face() {
        for(z=[top,bottom]) {
          translate([0,-carriage_anchor_thickness/2,z*z_carriage_fastener_hole_spacing/2]) {
            rotate([90,0,0]) {
              hole(z_carriage_fastener_area_width-0.2,carriage_anchor_thickness,resolution);
            }
          }
        }
      }
      position_bed_pivot() {
        translate([z_carrier_pivot_length/2+1,0,0]) {
          cube([2,z_carrier_pivot_side,z_carrier_pivot_side],center=true);
        }
        translate([z_carrier_pivot_length/2,0,0]) {
          rotate([90,0,0]) {
            //hole(z_carrier_pivot_side,z_carrier_pivot_side,resolution);
          }
        }
      }
    }

    position_bed_pivot() {
      cube([z_carrier_pivot_length,z_carrier_pivot_side,z_carrier_pivot_side],center=true);
    }

    hull() {
      position_extrusion_anchor_holes() {
        hole(extrusion_width(bed_extrusion_type),z_carrier_pivot_side,resolution);
      }

      position_bed_pivot() {
        translate([-z_carrier_pivot_length/2-1,0,0]) {
          cube([2,z_carrier_pivot_side,z_carrier_pivot_side],center=true);
        }
      }
    }
  }

  module holes() {
    position_anchor_holes() {
      translate([0,0,z_carriage_fastener_area_thickness/2]) {
        hole(m3_through_hole_diam,200,resolution);
      }
    }
    position_extrusion_anchor_holes() {
      hole(m3_through_hole_diam,40,resolution);
    }

    translate([pivot_center_pos_x-z_carrier_pivot_length/2-extrusion_width(bed_extrusion_type)/2,frontmost_face,extrusion_width(bed_extrusion_type)/2]) {
      mark_spacing = z_carriage_fastener_hole_spacing/2;
      mark_depth = 1;
      mark_side = 5;
      for(x=[0:num_marks-1]) {
        translate([mark_spacing*-x,0,0]) {
          rotate([-70,0,0]) {
            translate([0,-mark_side/2+mark_depth,-mark_side/2]) {
              cylinder(r=mark_side/2,h=mark_side*5,$fn=4);
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
}

module z_carriage_bed_anchor_rear(is_final,num_marks) {
  anchor_face_pos_x = -mgn_width/2;
  anchor_face_pos_y = rear_bed_extrusion_dist_from_z_carriage+rear_carriage_mount_depth/2;
  anchor_face_pos_z = -extrusion_side/2-bed_assembly_offset_z+13/2;

  carriage_anchor_thickness = 5;
  extrusion_anchor_thickness = mgn_width/2+carriage_anchor_thickness-extrusion_width(bed_extrusion_type)/2;

  //pivot_center_pos_y = rear_bed_extrusion_dist_from_z_carriage-z_carrier_pivot_length/2;
  pivot_center_pos_y = anchor_face_pos_y-rear_carriage_mount_depth/2-z_carrier_pivot_length/2;

  module position_bed_pivot() {
    translate([anchor_face_pos_x-carriage_anchor_thickness+z_carrier_pivot_side/2,pivot_center_pos_y,0]) {
      children();
    }
  }

  module position_anchor_face() {
    translate([anchor_face_pos_x,anchor_face_pos_y,anchor_face_pos_z]) {
      children();
    }
  }

  module position_anchor_holes() {
    position_anchor_face() {
      for(z=[top,bottom]) {
        translate([0,0,z*z_carriage_fastener_hole_spacing/2]) {
          rotate([0,-90,0]) {
            children();
          }
        }
      }
    }
  }

  module position_extrusion_anchor_holes() {
    translate([-extrusion_width(bed_extrusion_type)/2-extrusion_anchor_thickness/2,pivot_center_pos_y+front*(z_carrier_pivot_length/2+extrusion_width(bed_extrusion_type)/2+z_carriage_fastener_hole_spacing/2),0]) {
      for(y=[left,right]) {
        translate([0,y*z_carriage_fastener_hole_spacing/2,0]) {
          rotate([0,-90,0]) {
            children();
          }
        }
      }
    }
  }

  module body() {
    hull() {
      position_anchor_face() {
        for(z=[top,bottom]) {
          translate([-carriage_anchor_thickness/2,0,z*z_carriage_fastener_hole_spacing/2]) {
            rotate([0,90,0]) {
              hole(z_carriage_fastener_area_width-0.2,carriage_anchor_thickness,resolution);
            }
          }
        }
      }
      position_bed_pivot() {
        translate([0,z_carrier_pivot_length/2+1,0]) {
          cube([z_carrier_pivot_side,2,z_carrier_pivot_side],center=true);
        }
      }
    }

    position_bed_pivot() {
      cube([z_carrier_pivot_side,z_carrier_pivot_length,z_carrier_pivot_side],center=true);
    }
    hull() {
      position_extrusion_anchor_holes() {
        hole(extrusion_width(bed_extrusion_type),extrusion_anchor_thickness,resolution);
      }

      position_bed_pivot() {
        translate([0,-z_carrier_pivot_length/2-1,0]) {
          cube([z_carrier_pivot_side,2,z_carrier_pivot_side],center=true);
        }
      }
    }
  }

  module holes() {
    position_anchor_holes() {
      translate([0,0,z_carriage_fastener_area_thickness/2]) {
        hole(m3_through_hole_diam,200,resolution);
      }
    }
    position_extrusion_anchor_holes() {
      hole(m3_through_hole_diam,40,resolution);
    }

    translate([left*(extrusion_width(bed_extrusion_type)/2+extrusion_anchor_thickness),pivot_center_pos_y-(z_carrier_pivot_length/2+extrusion_width(bed_extrusion_type)/2),extrusion_width(bed_extrusion_type)/2]) {
      mark_spacing = z_carriage_fastener_hole_spacing/2;
      mark_depth = 1.2;
      mark_side = 5;
      for(y=[0:num_marks-1]) {
        translate([0,mark_spacing*-y,0]) {
          rotate([0,70,0]) {
            translate([-mark_side/2+mark_depth,0,-mark_side/2]) {
              cylinder(r=mark_side/2,h=mark_side*5,$fn=4);
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
}

module z_carrier_front(is_final) {
  module position_belt_anchor() {
    translate([-belt_plane_offset-0.1,max_depth_of_z_carrier,0]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module position_fastener_holes() {
    position_fastener_area() {
      for(y=[front,rear]) {
        translate([0,y*z_carriage_fastener_hole_spacing/2,0]) {
          children();
        }
      }
    }
  }

  module position_fastener_area() {
    position_belt_anchor() {
      translate([-mgn_width/2-z_carriage_fastener_area_width/2,13/2,0]) {
        children();
      }
    }
  }

  module body() {
    z_carrier_base(is_final) {
      hull() {
        position_belt_anchor() {
          translate([-mgn_width/4,0,z_carriage_fastener_area_thickness/2]) {
            rounded_cube(mgn_width/2,z_carriage_mount_height,z_carriage_fastener_area_thickness,2);
          }
        }
        position_fastener_holes() {
          translate([0,0,z_carriage_fastener_area_thickness/2]) {
            hole(z_carriage_fastener_area_width,z_carriage_fastener_area_thickness,resolution);
          }
        }
      }
    }
  }

  module holes() {
    position_fastener_holes() {
      translate([0,0,z_carriage_fastener_area_thickness/2]) {
        hole(m3_thread_into_plastic_diam,z_carriage_fastener_area_thickness+1,resolution);
        for(z=[top,bottom]) {
          translate([0,0,z*z_carriage_fastener_area_thickness/2]) {
            hull() {
              lead_in_depth = 0.4;
              delta = m3_through_hole_diam-m3_thread_into_plastic_diam;
              hole(m3_thread_into_plastic_diam,(lead_in_depth)*2+delta,resolution);
              hole(m3_through_hole_diam,lead_in_depth*2,resolution);
            }
          }
        }
      }
    }
    position_fastener_area() {
      translate([0,0,z_carriage_fastener_area_thickness]) {
        for(y=[front,rear]) {
          translate([0,y*z_carriage_fastener_hole_spacing/2,0]) {
            //hole(4.7,6*2,resolution);
            //hole(3.2,z_carriage_fastener_area_thickness*3,resolution);
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

module z_carrier_rear(is_final) {
  module position_anchor_holes() {
    for(z=[top,bottom]) {
      translate([0,extrusion_side/2+mgn_height+rear_carriage_mount_depth/2,13/2+z*z_carriage_fastener_hole_spacing/2]) {
        rotate([0,90,0]) {
          children();
        }
      }
    }
  }

  module position_z_chain_anchor() {
    translate([left*(rear_z_chain_pos_x),extrusion_side/2+mgn_height+rear_carriage_mount_depth-rear_z_chain_mount_thickness/2,0]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module position_z_chain_holes() {
    position_z_chain_anchor() {
      for(y=[top,bottom]) {
        translate([0,-3+y*rear_z_chain_mounting_hole_spacing/2,0]) {
          children();
        }
      }
    }
  }

  module body() {
    z_carrier_base(is_final,adjust_rear_belt_whatnots) {
      translate([0,max_depth_of_z_carrier-adjust_rear_belt_whatnots-rear_carriage_mount_depth/2,13/2]) {
        rotate([90,0,0]) {
          rounded_cube(mgn_width,z_carriage_fastener_hole_spacing+6+wall_thickness*3*2,rear_carriage_mount_depth,2);
        }
      }
      hull() {
        width = rear_z_chain_width;
        position_z_chain_holes() {
          rounded_diam = 2;
          rounded_cube(width,width*0.6,rear_z_chain_mount_thickness,rounded_diam);
        }
        position_z_chain_anchor() {
          translate([rear_z_chain_pos_x-belt_plane_offset-mgn_width/2+rounded_diam/2-0.2,0,0]) {
            rounded_cube(rounded_diam,z_carriage_mount_height,rear_z_chain_mount_thickness,rounded_diam);
          }
        }
      }
    }
  }

  module holes() {
    position_anchor_holes() {
      nut_cavity_diam = 5.7;
      nut_cavity_height = 4.4;

      hole(nut_cavity_diam,nut_cavity_height,6);
      translate([0,50/2,0]) {
        cube([nut_cavity_diam,50,nut_cavity_height],center=true);
      }
      translate([0,0,wall_thickness*2]) {
        hole(m3_through_hole_diam,mgn_width,resolution);
      }
    }

    position_z_chain_holes() {
      hole(m3_threaded_insert_od,20,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_carrier_base(is_final,offset_belt_anchor_by=0) {
  tolerance = 0.2;

  //belt_idler_max_diam = belt_idler_od+belt_thickness*2+2;
  //z_carrier_idler_area_body_width = carriage_idler_stack_height+carriage_idler_bevel_height*2+z_carrier_mount_thickness*2;
  //z_carrier_idler_area_body_depth = belt_idler_max_diam+z_carrier_mount_thickness*2;
  overall_depth = extrusion_side/2+carriage_idler_pos_x+z_carrier_idler_area_body_depth/2;
  dist_between_z_carriage_and_extrusion_x = front_bed_extrusion_length/2-extrusion_vertical_spacing_x/2;
  dist_between_z_carriage_and_extrusion_y = abs(extrusion_vertical_spacing_y/2)-front*extrusion_carrier_edge_pos_y;
  dist_to_bottom_of_extrusion = bed_assembly_offset_z;

  belt_anchor_opening_height = 11.4; // from pandora's box
  belt_anchor_opening_width = 9; // from pandora's box

  belt_opening_height = 2;
  belt_opening_width = 7;

  carrier_max_depth = max_depth_of_z_carrier-offset_belt_anchor_by;
  carriage_anchor_thickness = carrier_max_depth-(extrusion_side/2+mgn_height);
  // we need to work around either the carriage or the extrusion
  max_width_to_avoid = max(extrusion_width(extrusion_vertical_type)/2, mgn_width/2);
  width_after_avoiding_max = belt_plane_offset-max_width_to_avoid-tolerance;
  width_after_avoiding_mgn = belt_plane_offset-mgn_width/2-tolerance;

  module position_carriage() {
    translate([0,extrusion_side/2-z_rail_sunk_into_extrusion,0]) {
      rotate([-90,0,0]) {
        rotate([0,0,90]) {
          children();
        }
      }
    }
  }

  module position_belt_anchor() {
    translate([-belt_plane_offset,carrier_max_depth,0]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module body() {
    min_height = min(carriage_anchor_thickness+z_rail_sunk_into_extrusion,z_belt_anchor_depth);
    position_carriage() {
      translate([0,0,carrier_max_depth-extrusion_side/2+z_rail_sunk_into_extrusion/2]) {
        translate([0,0,-carriage_anchor_thickness/2]) {
          rounded_cube(z_carriage_mount_height,mgn_width,carriage_anchor_thickness+z_rail_sunk_into_extrusion,2);
        }
      }
    }

    position_belt_anchor() {
      max_belt_anchor_width = mgn_width/2+belt_opening_width/2-0.2;

      if (carriage_anchor_thickness < z_belt_anchor_depth && width_after_avoiding_mgn > width_after_avoiding_max) {
        avoid_mgn_depth = carriage_anchor_thickness+mgn_height-1.5;
        translate([0,0,avoid_mgn_depth/2]) {
          rounded_cube(width_after_avoiding_mgn*2,z_carriage_mount_height,avoid_mgn_depth,2);
        }
      }

      translate([mgn_width/2,0,min_height/2]) {
        // make sure carriage and anchor are connected
        cube([mgn_width,z_carriage_mount_height,min_height],center=true);
      }

      hull() {
        translate([0,0,z_belt_anchor_depth/2]) {
          rounded_cube(width_after_avoiding_max*2,z_carriage_mount_height,z_belt_anchor_depth,2);

          translate([-mgn_width/2+max_belt_anchor_width/4-0.1,0,0]) {
            rounded_cube(max_belt_anchor_width/2,z_carriage_mount_height,z_belt_anchor_depth,2);
          }
        }
      }
    }
  }

  module holes() {
    position_carriage() {
      % carriage(z_carriage);
      // FIXME: make printable, maybe using FSC ?
      translate([0,0,z_axis_screw_mount_thickness]) {
        carriage_hole_positions(z_carriage) {
          bridged_hole(4.4,2.1,max_depth_of_z_carrier*2,is_final);
        }
      }
      if (mgn_width > extrusion_width(extrusion_vertical_type)) {
        translate([0,0,0]) {
          for(z=[top,bottom]) {
            mirror([z-1,0,0]) {
              translate([belt_anchor_opening_height/2,mgn_width/2+0.2,mgn_height-20]) {
                round_corner_filler(2,40);
              }
            }
          }
        }
      }
    }

    position_belt_anchor() {
      hole(3.4,carrier_max_depth*3,resolution);

      tension_plate_thickness = 6;
      for(y=[front,rear]) {
        translate([0,y*(belt_anchor_opening_height/2-belt_opening_height/2),0]) {
          rounded_cube(belt_opening_width,belt_opening_height,carrier_max_depth*3,1);
        }
        mirror([0,y-1,0]) {
          translate([0,belt_anchor_opening_height/2,z_belt_anchor_depth]) {
            rotate([0,90,0]) {
              // round over the belt entrance
              round_corner_filler(2,belt_width);
            }
          }
        }
      }

      translate([belt_opening_width/2-belt_anchor_opening_width/2,0,tension_plate_thickness+z_belt_anchor_depth/2]) {
        rounded_cube(belt_anchor_opening_width,belt_anchor_opening_height,z_belt_anchor_depth,2);
      }
    }
  }

  difference() {
    union() {
      children();
      body();
    }
    holes();
  }
}

module z_carrier_front_leadscrew(motor_offset_x,motor_offset_y,is_final) {
  extrusion_anchor_length = 30;
  extrusion_anchor_thickness = 3;
  extrusion_anchor_screw_head_diam = m3_head_diam+0.2;
  extrusion_anchor_width = extrusion_anchor_screw_head_diam+1*2;
  extrusion_base_pos_z = bed_assembly_offset_z+extrusion_side/2-15/2;
  extrusion_anchor_height = z_carriage_mount_height/2+extrusion_base_pos_z;
  anchor_screw_spacing = extrusion_anchor_length*0.6;

  module position_extrusion_anchor() {
    translate([-extrusion_vertical_spacing_x/2+front_bed_extrusion_length/2,extrusion_carrier_edge_pos_y+extrusion_vertical_spacing_y/2,extrusion_base_pos_z]) {
      children();
    }
  }

  module position_bed_pivot() {
    position_extrusion_anchor() {
      translate([0,front*extrusion_anchor_width/2,0]) {
        rotate([0,0,45]) {
          translate([0,-z_carrier_pivot_length/2,-z_carrier_pivot_side/2]) {
            children();
          }
        }
      }
    }
  }

  module position_leadscrew() {
    translate([motor_offset_x,motor_offset_y,0]) {
      children();
    }
  }

  module body() {
    position_extrusion_anchor() {
      translate([-extrusion_anchor_length/2,0,0]) {
        rounded_cube(10,2.8,1*2,2);
        hull() {
          translate([0,0,-2/2]) {
            rounded_cube(extrusion_anchor_length,extrusion_anchor_width,2,2);
          }

          translate([0,0,-extrusion_anchor_height+2/2]) {
            rounded_cube(anchor_screw_spacing+extrusion_anchor_width,extrusion_anchor_width,2,extrusion_anchor_width);
          }
        }
      }
    }
    z_carrier_base_leadscrew(motor_offset_x,motor_offset_y,is_final) {
      position_bed_pivot() {
        rounded_cube(z_carrier_pivot_side,z_carrier_pivot_length*6,z_carrier_pivot_side,z_carrier_pivot_side);
      }
    }
  }

  module holes() {
    position_extrusion_anchor() {
      for(x=[left,right]) {
        translate([-extrusion_anchor_length/2+x*(anchor_screw_spacing/2),0,-extrusion_anchor_thickness]) {
          rotate([180,0,0]) {
            bridged_hole(extrusion_anchor_screw_head_diam,3.2,extrusion_anchor_thickness*4,is_final);
            translate([0,0,50/2]) {
              hole(extrusion_anchor_screw_head_diam,50,resolution);
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
}

module z_carrier_rear_leadscrew(motor_offset_x,motor_offset_y,is_final) {
  extrusion_anchor_length = 30;
  extrusion_anchor_thickness = 3;
  extrusion_anchor_screw_head_diam = m3_head_diam+0.2;
  extrusion_anchor_width = extrusion_anchor_screw_head_diam+1*2;
  extrusion_base_pos_z = bed_assembly_offset_z+extrusion_side/2-15/2;
  extrusion_anchor_height = z_carriage_mount_height/2+extrusion_base_pos_z;
  anchor_screw_spacing = extrusion_anchor_length*0.6;

  module position_extrusion_anchor() {
    translate([0,extrusion_side/2+mgn_height+rear_bed_extrusion_dist_from_z_carriage,extrusion_base_pos_z]) {
      children();
    }
  }

  module position_leadscrew() {
    translate([motor_offset_x,motor_offset_y,0]) {
      children();
    }
  }

  module position_z_chain_anchor() {
    translate([left*(rear_z_chain_pos_x),extrusion_side/2+mgn_height+rear_carriage_mount_depth-rear_z_chain_mount_thickness/2,0]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }
  
  module position_bed_pivot() {
    position_extrusion_anchor() {
      translate([0,-z_carrier_pivot_length/2,-z_carrier_pivot_side/2]) {
        children();
      }
    }
  }

  module position_z_chain_holes() {
    position_z_chain_anchor() {
      for(y=[top,bottom]) {
        translate([0,-3+y*rear_z_chain_mounting_hole_spacing/2,0]) {
          children();
        }
      }
    }
  }

  module body() {
    position_extrusion_anchor() {
      //bed_pivot_carriage_offset_z = bed_assembly_offset_z+extrusion_side/2;
      translate([0,extrusion_anchor_length/2,0]) {
        rounded_cube(2.8,10,1*2,2);
        hull() {
          translate([0,0,-2/2]) {
            rounded_cube(extrusion_anchor_width,extrusion_anchor_length,2,2);
          }

          translate([0,0,-extrusion_anchor_height+2/2]) {
            rounded_cube(extrusion_anchor_width,anchor_screw_spacing+extrusion_anchor_width,2,extrusion_anchor_width);
          }
        }
      }
    }
    z_carrier_base_leadscrew(motor_offset_x,motor_offset_y,is_final) {
      translate([0,max_depth_of_z_carrier-adjust_rear_belt_whatnots-rear_carriage_mount_depth/2,13/2]) {
        rotate([90,0,0]) {
          //rounded_cube(mgn_width,z_carriage_fastener_hole_spacing+6+wall_thickness*3*2,rear_carriage_mount_depth,2);
        }
      }
      hull() {
        width = rear_z_chain_width;
        position_z_chain_holes() {
          rounded_diam = 2;
          //rounded_cube(width,width*0.6,rear_z_chain_mount_thickness,rounded_diam);
        }
        position_z_chain_anchor() {
          translate([rear_z_chain_pos_x-belt_plane_offset-mgn_width/2+rounded_diam/2-0.2,0,0]) {
            //rounded_cube(rounded_diam,z_carriage_mount_height,rear_z_chain_mount_thickness,rounded_diam);
          }
        }
      }
      position_bed_pivot() {
        cube([z_carrier_pivot_side,z_carrier_pivot_length*2,z_carrier_pivot_side],center=true);
      }
      hull() {
        position_bed_pivot() {
          translate([0,-z_carrier_pivot_length/2-1,0]) {
            cube([z_carrier_pivot_side,2,z_carrier_pivot_side],center=true);

            translate([0,-leadscrew_carrier_plate_thickness/2-1.2,z_carrier_pivot_side/2-extrusion_anchor_height/2]) {
              rounded_cube(extrusion_anchor_width,leadscrew_carrier_plate_thickness,extrusion_anchor_height,2);
            }
          }
        }
      }
    }
  }

  module holes() {
    position_leadscrew() {
    }

    position_extrusion_anchor() {
      for(y=[front,rear]) {
        translate([0,extrusion_anchor_length/2+y*(anchor_screw_spacing/2),-extrusion_anchor_thickness]) {
          rotate([180,0,0]) {
            bridged_hole(extrusion_anchor_screw_head_diam,3.2,extrusion_anchor_thickness*4,is_final);
            translate([0,0,50/2]) {
              hole(extrusion_anchor_screw_head_diam,50,resolution);
            }
          }
        }
      }
    }

    position_z_chain_holes() {
      //hole(m3_threaded_insert_od,20,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_carrier_base_leadscrew(motor_offset_x,motor_offset_y,is_final) {
  tolerance = 0.2;

  //belt_idler_max_diam = belt_idler_od+belt_thickness*2+2;
  //z_carrier_idler_area_body_width = carriage_idler_stack_height+carriage_idler_bevel_height*2+z_carrier_mount_thickness*2;
  //z_carrier_idler_area_body_depth = belt_idler_max_diam+z_carrier_mount_thickness*2;
  overall_depth = extrusion_side/2+carriage_idler_pos_x+z_carrier_idler_area_body_depth/2;
  dist_to_bottom_of_extrusion = bed_assembly_offset_z;

  belt_anchor_opening_height = 11.4; // from pandora's box
  belt_anchor_opening_width = 9; // from pandora's box

  belt_opening_height = 2;
  belt_opening_width = 7;

  // we need to work around either the carriage or the extrusion
  max_width_to_avoid = max(extrusion_width(extrusion_vertical_type)/2, mgn_width/2);
  width_after_avoiding_max = belt_plane_offset-max_width_to_avoid-tolerance;
  width_after_avoiding_mgn = belt_plane_offset-mgn_width/2-tolerance;

  plate_thickness = leadscrew_nut_shaft_length-leadscrew_nut_base_thickness-leadscrew_nut_base_inset;
  nut_plate_shaft_hole_side = 16 + 3.5;
  nut_plate_head_hole_side = 16 + m3_head_diam + 0.5;
  nut_plate_diam = nut_plate_head_hole_side+4;

  module position_leadscrew() {
    translate([motor_offset_x,motor_offset_y,-z_carriage_mount_height/2]) {
      rotate([0,0,45]) {
        children();
      }
    }
  }

  module position_carriage() {
    translate([0,extrusion_side/2-z_rail_sunk_into_extrusion,0]) {
      rotate([-90,0,0]) {
        rotate([0,0,90]) {
          children();
        }
      }
    }
  }

  module body() {
    position_carriage() {
      translate([0,0,mgn_height+leadscrew_carrier_plate_thickness/2]) {
        rotate([0,90,0]) {
          rounded_cube(leadscrew_carrier_plate_thickness,mgn_width+2,z_carriage_mount_height,2);
        }
      }
    }

    // angled joint between mgn and leadscrew nut
    hull() {
      position_leadscrew() {
        joint_diam = 5;
        rotate([0,0,-45]) {
          translate([leadscrew_nut_shaft_diam/2+1/2+joint_diam/2,0,plate_thickness-1/2]) {
            hole(joint_diam,1,resolution);
          }
        }
      }
      position_carriage() {
        translate([0,mgn_width/2,mgn_height+leadscrew_carrier_plate_thickness/2]) {
          rotate([0,90,0]) {
            rounded_cube(leadscrew_carrier_plate_thickness,2,z_carriage_mount_height,2);
          }
        }
      }
    }
    // main plate joint between mgn and leadscrew nut
    hull() {
      position_leadscrew() {
        translate([0,0,plate_thickness/2]) {
          hole(nut_plate_diam,plate_thickness,resolution);
        }
      }
      position_carriage() {
        translate([z_carriage_mount_height/2-plate_thickness/2,0,mgn_height+leadscrew_carrier_plate_thickness/2]) {
          rotate([0,90,0]) {
            rounded_cube(leadscrew_carrier_plate_thickness,mgn_width+2,plate_thickness,2);
          }
        }
      }
    }
  }

  module holes() {
    position_leadscrew() {
      translate([0,0,-leadscrew_nut_base_thickness]) {
        % mock_leadscrew_nut();
      }
      translate([0,0,leadscrew_nut_shaft_length/2-leadscrew_nut_base_inset ]) {
        hole(leadscrew_nut_shaft_diam+1,leadscrew_nut_shaft_length*3,resolution);
      }
      for(r=[0,90]) {
        rotate([0,0,r]) {
          rounded_cube(16+3.5,3.5,100,3.5);
          translate([0,0,3+50]) {
            head_rounded_diam = m3_head_diam+0.5;
            rounded_cube(16+head_rounded_diam,head_rounded_diam,100,head_rounded_diam);
          }
          //hole(3.5,100,resolution/2);
        }
      }
    }
    position_carriage() {
      % carriage(z_carriage);
      translate([0,0,z_axis_screw_mount_thickness]) {
        carriage_hole_positions(z_carriage) {
          bridged_hole(4.4,2.1,max_depth_of_z_carrier*2,is_final);
        }
      }
      // make sure the body doesn't go try to through the carriage/extrusion
      hull() {
        translate([0,0,mgn_height-20]) {
          rotate([0,90,0]) {
            rounded_cube(40,mgn_width+1,z_carriage_mount_height*2,1);
          }
        }
        translate([0,0,-extrusion_side/2+1]) {
          rotate([0,90,0]) {
            rounded_cube(extrusion_side,extrusion_side+1,z_carriage_mount_height*2,1);
          }
        }
      }
    }
  }

  difference() {
    union() {
      children();
      body();
    }
    holes();
  }
}

module z_motor_mount_leadscrew_base(motor_offset_x,motor_offset_y,is_final) {
  motor_plate_thickness = 10;
  motor_shoulder_diam = 2*NEMA_boss_radius(z_motor_type)+1;

  z_motor_mount_height = motor_plate_thickness+extrusion_side-deck_panel_thickness;
  z_motor_mount_rounded_diam = m3_head_diam+4;
  z_motor_mount_side = z_motor_screw_spacing+z_motor_mount_rounded_diam;

  module position_motor() {
    translate([motor_offset_x,motor_offset_y,-motor_plate_thickness]) {
      rotate([0,0,0]) {
        children();
      }
    }
  }

  module body() {
    position_motor() {
      translate([0,0,z_motor_mount_height/2]) {
        hole(leadscrew_diam+7,z_motor_mount_height,resolution);
      }
      for(r=[0,-90]) {
        rotate([0,0,r]) {
          hull() {
            translate([z_motor_screw_spacing/2,0,0]) {
              for(y=[front,rear]) {
                translate([0,y*(z_motor_screw_spacing/2),0]) {
                  translate([0,0,z_motor_mount_height/2]) {
                    hole(m3_head_diam+2,z_motor_mount_height,resolution);
                  }
                }
              }
            }
            translate([z_motor_mount_side/2-z_motor_mount_rounded_diam/2,0,z_motor_mount_height/2]) {
              rounded_cube(z_motor_mount_rounded_diam,z_motor_mount_side,z_motor_mount_height,2);
            }
            for(s=[left,right]) {
              translate([z_motor_screw_spacing/2*s,z_motor_screw_spacing/2*s,0]) {
                translate([0,0,4/2]) {
                  //hole(m3_head_diam+4,4,resolution);
                }
                translate([0,0,z_motor_mount_height/2]) {
                  //hole(m3_head_diam+2,z_motor_mount_height,resolution);
                }
              }
            }
          }
        }
      }
      for(r=[0,90]) {
        rotate([0,0,r]) {
          hull() {
            for(s=[left,right]) {
              translate([z_motor_screw_spacing/2*s,z_motor_screw_spacing/2*s,0]) {
                translate([0,0,4/2]) {
                  hole(m3_head_diam+4,4,resolution);
                }
                translate([0,0,z_motor_mount_height/2]) {
                  hole(m3_head_diam+2,z_motor_mount_height,resolution);
                }
              }
            }
          }
        }
      }
      NEMA_screw_positions(z_motor_type) {
        translate([0,0,0]) {
          //bridged_hole(m3_head_diam,m3_through_hole_diam,30,is_final);
          //hole(m3_through_hole_diam,100,resolution);
          translate([0,0,4/2]) {
            //hole(m3_head_diam+4,4,resolution);
          }
        }
      }
    }
  }

  module holes() {
    position_motor() {
      for(r=[0,-90]) {
        rotate([0,0,r]) {
          translate([z_motor_mount_side/2,0,motor_plate_thickness+extrusion_side/2]) {
            for(y=[front,rear]) {
              //translate([0,y*(z_motor_hole_spacing/2-m3_head_diam-2),0]) {
              //translate([0,y*(z_motor_hole_spacing/2,0]) {
              translate([0,y*(z_motor_hole_spacing/2-m3_head_diam),0]) {
                rotate([0,-90,0]) {
                  hole(3.2,16,8);
                  hull() {
                    translate([0,0,4+5/2]) {
                      hole(m3_head_diam+0.2,5,10);
                      translate([extrusion_side/2-deck_panel_thickness,0,0]) {
                        hole(m3_head_diam+0.2,5,10);
                      }
                    }

                    translate([extrusion_side/2-deck_panel_thickness,0,6]) {
                      //hole(m3_head_diam+0.2,5,8);

                      translate([m3_head_diam/2,0,9]) {
                        hole(m3_head_diam,5,resolution);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      translate([0,0,lead_screw_length/2]) {
        % color("lightgrey") hole(8,lead_screw_length,resolution);
      }
      rotate([0,0,90]) {
        % NEMA(z_motor_type);
      }
      hull() {
        hole(motor_shoulder_diam,2*(motor_plate_thickness+1),resolution);
        hole(leadscrew_diam+2,3*(motor_plate_thickness+1),resolution);
      }
      hole(leadscrew_diam+2,100,resolution);
      NEMA_screw_positions(z_motor_type) {
        translate([0,0,4]) {
          //bridged_hole(m3_head_diam,m3_through_hole_diam,30,is_final);
          hole(m3_through_hole_diam,100,resolution);
          translate([0,0,40]) {
            hole(m3_head_diam,80,resolution);
          }
        }
      }
    }
    translate([motor_offset_x,motor_offset_y,extrusion_side]) {
      //cube([z_motor_side*2,z_motor_side*2,deck_panel_thickness*2],center=true);
    }
  }

  difference() {
    union() {
      body();
      children();
    }
    holes();
  }
}

module z_motor_mount_leadscrew_front(motor_offset_x,motor_offset_y,is_final) {
  module body() {
    z_motor_mount_leadscrew_base(motor_offset_x,motor_offset_y,is_final) {
    }
  }

  module holes() {
    for(r=[0,90]) {
      rotate([0,0,r]) {
        translate([0,0,extrusion_side/2]) {
          cube([140,extrusion_side,extrusion_side],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_motor_mount_leadscrew_rear(motor_offset_x,motor_offset_y,is_final) {
  module body() {
    z_motor_mount_leadscrew_base(motor_offset_x,motor_offset_y,is_final) {
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module z_motor_mount_base(adjust_belt_pos_y=0,additional_front,additional_rear,num_marks,is_final) {
  motor_offset_y = motor_belt_path_offset-adjust_belt_pos_y;
  motor_plate_thickness = 5;
  motor_shoulder_diam = 2*NEMA_boss_radius(z_motor_type)+1;

  overall_depth = z_motor_side+additional_front+additional_rear;
  frontmost_y = motor_offset_y-z_motor_side/2-additional_front;

  belt_cut_depth = z_base_motor_mount_overall_width-extrusion_side-motor_plate_thickness;
  belt_cut_width = belt_idler_od+3;

  module position_motor() {
    translate([z_motor_offset_x,motor_offset_y,z_motor_pos_z]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }

  module body() {
    translate([z_motor_offset_x+z_base_motor_mount_overall_width/2,frontmost_y+overall_depth/2,-z_base_motor_mount_overall_height/2]) {
      rotate([0,90,0]) {
        difference() {
          rounded_cube(z_base_motor_mount_overall_height,overall_depth,z_base_motor_mount_overall_width,2+z_motor_mount_wall_thickness*2);
          translate([0,0,motor_plate_thickness]) {
            rounded_cube(z_base_motor_mount_overall_height-z_motor_mount_wall_thickness*2,overall_depth-z_motor_mount_wall_thickness*2,z_base_motor_mount_overall_width,2);
          }
        }
      }
    }
    position_motor() {
      brace_thickness = 2;
      brace_height = z_base_motor_mount_overall_width*0.5;
      for(y=[front,rear]) {
        hull() {
          translate([0,y*(belt_cut_width/2+brace_thickness/2),motor_plate_thickness/2]) {
            translate([-motor_shoulder_diam/2,0,0]) {
              hole(brace_thickness,motor_plate_thickness,resolution);
            }
            translate([-z_motor_side/2+brace_thickness/2,0,brace_height/2]) {
              hole(brace_thickness,motor_plate_thickness+brace_height,resolution);
            }
          }
          translate([0,y*(motor_shoulder_diam/2-brace_thickness/2),motor_plate_thickness/2]) {
            translate([-motor_shoulder_diam*0.35,0,0]) {
              hole(brace_thickness,motor_plate_thickness,resolution);
            }
            translate([-z_motor_side/2+brace_thickness/2,0,brace_height/2]) {
              hole(brace_thickness,motor_plate_thickness+brace_height,resolution);
            }
          }
        }
      }
    }
  }

  module holes() {
    // mark which motor mount this is
    translate([0,frontmost_y+overall_depth,-z_base_motor_mount_overall_height/2]) {
      mark_height = 8;
      mark_width = 1;
      mark_spacing = 5;
      mark_depth = 0.5;
      mark_diam = 7;

      for(x=[0:num_marks-1]) {
        translate([mark_spacing*-x,0,0]) {
          hull() {
            cube([mark_width,mark_depth*2,mark_height],center=true);
            move_by = 2;
            translate([0,move_by,0]) {
              cube([mark_width+move_by*4,mark_depth,mark_height+move_by*4],center=true);
            }
          }
        }
      }
    }

    hull() {
      translate([z_motor_offset_x+motor_plate_thickness+belt_cut_depth/2,motor_offset_y,z_motor_pos_z+z_base_motor_mount_overall_height/2]) {
        for(y=[front,rear]) {
          translate([0,y*(belt_cut_width/2-belt_cut_width/8),0]) {
            cube([belt_cut_depth,belt_cut_width/4,z_base_motor_mount_overall_height],center=true);
          }
        }
      }
    }
    position_motor() {
      % NEMA(z_motor_type);
      hole(motor_shoulder_diam,2*(motor_plate_thickness+1),resolution);
      NEMA_screw_positions(z_motor_type) {
        translate([0,0,motor_plate_thickness]) {
          translate([0,0,0]) {
            hole(m3_through_hole_diam,100,resolution);
            translate([0,0,40]) {
              hole(m3_head_diam,80,resolution);
            }
          }
        }
      }

      //hole(min(25,motor_xy_hole_spacing),2*(z_base_motor_mount_overall_width-4),resolution);
      /*
      hull() {
        hole(motor_shoulder_diam,2*(belt_cut_depth),resolution);
        hole(10+tolerance,2*(z_base_motor_mount_overall_width-3),resolution);
      }
      hole(10+tolerance,2*(z_base_motor_mount_overall_width-1),resolution); // FIXME: Make printable with rim
      //hole(10+tolerance,2*(z_base_motor_mount_overall_width+1),resolution);
      hole(10-2,z_base_motor_mount_overall_width*3,resolution);
      */

    }
    /*
    translate([z_motor_offset_x,motor_offset_y,z_motor_pos_z]) {
      translate([0,0,motor_shoulder_diam/4]) {
        //cube([2*(belt_cut_depth+0.2),belt_cut_width,motor_shoulder_diam/2],center=true);
      }
      translate([0,0,z_base_motor_mount_overall_height/2]) {
        for(y=[front,rear]) {
          translate([0,y*(belt_cut_width/2-belt_cut_width/8),0]) {
            cube([2*(belt_cut_depth),belt_cut_width/4,z_base_motor_mount_overall_height],center=true);
          }
        }
        //cube([2*(belt_cut_depth),belt_cut_width,z_base_motor_mount_overall_height],center=true);
      }

      //set screw access
      translate([0,0,-z_base_motor_mount_overall_height/2]) {
        set_screw_hole_width = z_motor_side*0.3;
        set_screw_hole_depth = z_base_motor_mount_overall_width-8;
        rounded_cube(set_screw_hole_depth*2,set_screw_hole_width,z_base_motor_mount_overall_height,set_screw_hole_width,8);
        //cube([2*(z_base_motor_mount_overall_width-extrusion_side+4),5,z_base_motor_mount_overall_height],center=true);
      }
    }
    */
    /*
    translate([z_motor_offset_x,motor_offset_y,z_motor_pos_z]) {
      rotate([0,90,0]) {
        hole(NEMA_boss_radius(z_motor_type)*2+2,(pulley_depth)*2,resolution);
        hole(9,100,resolution);
      }
      for(y=[front,rear]) {
        translate([0,y*(toothed_to_smooth_dist-belt_thickness/3),0]) {
          rounded_cube(2*(dist_from_motor_to_belt+9/2),belt_thickness*2,z_motor_side*2,rounded_diam);
        }
      }
      translate([0,0,-z_motor_side/2]) {
        rounded_cube(2*(pulley_depth),10+2+3,z_motor_side,rounded_diam);
      }
    }

    */
  }

  difference() {
    union() {
      body();
      children();
    }
    holes();
  }
}

module z_motor_mount_front(is_final,num_marks) {
  extra_mounting_meat = z_motor_mount_front_desired_depth-abs(motor_belt_path_offset)-z_motor_side/2;
  extra_meat_rear = extra_mounting_meat;

  //extra_meat_front = motor_belt_path_offset-z_motor_side/2+extrusion_side/2;
  extra_meat_front = motor_belt_path_offset-z_motor_side/2+extrusion_side/2+3;

  extrusion_mounting_positions = [
    [0,z_motor_mount_front_desired_depth-m3_head_diam/2-5,0],
    [0,motor_belt_path_offset,0],
    //[extrusion_side/2-z_base_motor_mount_overall_width+wall_thickness*2+m3_head_diam/2,0,0],
    //[-extrusion_side/2-m3_head_diam/2,0,0],
    //[0,0,0],
  ];

  module body() {
    z_motor_mount_base(0,extra_meat_front,extra_meat_rear,num_marks,is_final) {
      translate([extrusion_side/2-z_base_motor_mount_overall_width/2,0,-z_base_motor_mount_overall_height/2]) {
        rotate([0,90,0]) {
          //rounded_cube(z_base_motor_mount_overall_height,extrusion_side,z_base_motor_mount_overall_width,2);
        }
        translate([0,motor_belt_path_offset+z_motor_side/2+extra_mounting_meat/2,0]) {
          rotate([0,90,0]) {
            //rounded_cube(z_base_motor_mount_overall_height,extra_mounting_meat*2,z_base_motor_mount_overall_width,2);
          }
        }
      }
    }

    translate([0,0,-z_axis_screw_mount_thickness]) {
      for(p=extrusion_mounting_positions) {
        translate(p) {
          rotate([180,0,0]) {
            bevel(9,6,1);
          }
        }
      }
    }
  }

  module holes() {
    translate([0,0,0]) {
      hole(screw_shaft_diam_for_extrusion(extrusion_vertical_type),z_motor_mount_wall_thickness*3,resolution);
      hole(screw_shaft_diam_for_extrusion(extrusion_vertical_type)-1,100,resolution);
    }

    for(p=extrusion_mounting_positions) {
      translate([0,0,-z_axis_screw_mount_thickness]) {
        translate(p) {
          hole(m3_through_hole_diam,100,resolution);
          translate([0,0,-50]) {
            //hole(m3_head_diam,100,resolution);
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

module z_motor_mount_rear(is_final) {
  extra_meat_depth = z_axis_screw_mount_thickness+4;
  extra_meat_height = extrusion_side-3.5;

  // actually rear, because we're rotated 180
  extra_meat_front = extrusion_side/2; //motor_belt_path_offset-adjust_rear_belt_whatnots;
  // actually front, because we're rotated 180
  extra_meat_rear = m3_through_hole_diam/2; //motor_belt_path_offset-adjust_rear_belt_whatnots;

  extrusion_mounting_positions = [
    //[0,0,0],
    [-extrusion_side/2+m3_head_diam,extrusion_side,0],
    [-extrusion_side/2+z_base_motor_mount_overall_width-m3_head_diam-z_axis_screw_mount_thickness,extrusion_side,0],
  ];

  module body() {
    rotate([0,0,180]) {
      num_marks = 2;
      z_motor_mount_base(adjust_rear_belt_whatnots,extra_meat_front,extra_meat_rear,num_marks,is_final) {
        translate([0,extrusion_side/2+extra_meat_depth/2+tolerance/2,0]) {
          rotate([0,90,0]) {
            //rounded_cube(extra_meat_height*2,extra_meat_depth,extrusion_side,2);
          }
        }
      }
    }
    translate([0,0,-z_axis_screw_mount_thickness]) {
      for(p=extrusion_mounting_positions) {
        translate(p) {
          rotate([180,0,0]) {
            bevel(9,6,1);
          }
        }
      }
    }
  }

  module holes() {
    hole(screw_shaft_diam_for_extrusion(extrusion_vertical_type),100,resolution);

    translate([0,0,-z_axis_screw_mount_thickness]) {
      for(p=extrusion_mounting_positions) {
        translate(p) {
          hole(m3_through_hole_diam,100,resolution);
          translate([0,0,-5]) {
            //hole(m3_head_diam,10,resolution);
          }
        }
      }
    }

    translate([0,-extrusion_side/2-z_axis_screw_mount_thickness,m3_head_diam/2+2]) {
      rotate([-90,0,0]) {
        hole(m3_through_hole_diam,100,resolution);
        translate([0,0,-50]) {
          hole(m3_head_diam,100,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module umbilical_wire_guard(is_final) {
  room_for_belts = 1.5;
  overall_width = center_brace_width;
  rear_brace_dist_from_back = extrusion_vertical_spacing_y/2-rear_brace_pos_y;
  overall_depth = rear_brace_dist_from_back - room_for_belts;
  overall_height = belt_idler_stack_height;
  thickness = 2;
  hole_spacing = center_brace_width-m3_through_hole_diam;
  screw_body_diam = m3_head_diam+2*2;

  module position_mounting_screws() {
    translate([0,0,0]) {
      rotate([-90,0,0]) {
        for(x=[left,right]) {
          mirror([x-1,0,0]) {
            translate([hole_spacing/2,0,0]) {
              children();
            }
          }
        }
      }
    }
  }

  module body() {
    for(x=[left,right]) {
      rotate([-90,0,0]) {
        mirror([x-1,0,0]) {
          hull() {
            translate([overall_width/2-rounded_diam/2,0,0]) {
              translate([0,0,thickness/2]) {
                rounded_cube(rounded_diam,extrusion_width(extrusion_shortest_type),thickness,rounded_diam);
              }
              translate([0,-overall_height/2+extrusion_width(extrusion_shortest_type)/2,overall_depth-thickness/2]) {
                rounded_cube(rounded_diam,overall_height,thickness,rounded_diam);
              }
            }
            translate([hole_spacing/2,0,overall_depth/2]) {
              intersection() {
                hole(screw_body_diam,overall_depth,resolution);
                translate([screw_body_diam/2-m3_through_hole_diam/2-wall_thickness,0,0]) {
                  cube([screw_body_diam,50,50],center=true);
                }
              }
            }
          }
        }
      }
    }
    rotate([-90,0,0]) {
      translate([0,-overall_height/2+extrusion_width(extrusion_shortest_type)/2,overall_depth-thickness/2]) {
        cube([overall_width-rounded_diam,overall_height,thickness],center=true);
      }
    }
  }

  module holes() {
    position_mounting_screws() {
      translate([0,0,z_axis_screw_mount_thickness]) {
        rotate([0,0,90]) {
          bridged_hole(m3_head_diam,m3_through_hole_diam,10,is_final);
        }
        translate([0,0,25]) {
          hole(m3_head_diam,50,resolution);
        }
      }
    }
    translate([0,overall_depth/2-thickness,0]) {
      //cube([hole_spacing-screw_body_diam+m3_through_hole_diam-wall_thickness,overall_depth,overall_height],center=true);
    }
  }

  translate([0,rear_brace_pos_y+extrusion_width(extrusion_shortest_type)/2,rear_brace_pos_z]) {
    difference() {
      body();
      holes();
    }
  }
}

module belt_drive_z(pos_z) {
  motor_side = top;
  belt_points = [
    [carriage_anchor_pos_x,carriage_anchor_offset_z+carriage_anchor_spacing/2-pos_z,0],
    [single_z_idler_pos_x,single_z_idler_pos_z,f623_2x_idler],
    [motor_belt_path_offset,z_motor_pos_z,z_pulley_type],
    [carriage_anchor_pos_x,carriage_anchor_offset_z-carriage_anchor_spacing/2-pos_z,0],
  ];

  rotate([0,0,180]) {
    effective_radius = 6.68-1.38/2;

    rotate([90,0,0]) {
      translate([motor_belt_path_offset,z_motor_pos_z,-motor_side*(belt_width/2+mgn_mount_thickness)]) {
        rotate([0,90-motor_side*90,0]) {
          translate([0,0,8]) {
            rotate([180,0,0]) {
              % pulley_assembly(z_pulley_type);
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

module position_z_modules(pos_z) {
  for(x=[left,right]) {
    mirror([x-1,0,0]) {
      translate([extrusion_vertical_spacing_x/2,front*extrusion_vertical_spacing_y/2,0]) {
        rotate([0,0,0]) {
          z_motor_mount_front(is_final, marks_for_side[x+1]);
          translate([0,0,rail_offset_z]) {
            translate([0,extrusion_side/2-z_rail_sunk_into_extrusion,0]) {
              rotate([-90,0,0]) {
                rotate([0,0,90]) {
                  % rail(z_rail,z_rail_length);
                }
              }
            }
            /*
            translate([-extrusion_side/2,0,0]) {
              rotate([0,-90,0]) {
                % rail(z_rail,z_rail_length);
              }
            }
            */

            translate([0,0,carriage_offset_z-pos_z]) {
              z_carrier_front(is_final);
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
    z_motor_mount_rear();
    translate([0,0,rail_offset_z]) {
      translate([0,front*(extrusion_side/2-z_rail_sunk_into_extrusion),0]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            % rail(z_rail,z_rail_length);
          }
        }
      }

      rotate([0,0,180]) {
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
  /*
  */
}

module position_z_leadscrew_modules(pos_z) {
  leadscrew_base_motor_offset_x = left*(extrusion_side/2+z_motor_screw_spacing/2+m3_head_diam/2+2);
  //leadscrew_base_motor_offset_x = left*(extrusion_side/2+z_motor_side/2);
  //leadscrew_base_motor_offset_y = rear*(extrusion_side/2+z_motor_screw_spacing/2+m3_head_diam/2);
  leadscrew_base_motor_offset_y = rear*(extrusion_side/2+z_motor_screw_spacing/2+m3_head_diam/2+2);
  //leadscrew_rear_motor_offset_x = left*(extrusion_side/2+leadscrew_nut_base_diam/2);
  //leadscrew_rear_motor_offset_x = left*(z_motor_side/2);
  leadscrew_rear_motor_offset_x = left*(mgn_width/2+1+leadscrew_nut_base_diam/2);
  leadscrew_rear_motor_offset_y = extrusion_side/2+mgn_height;
  //leadscrew_rear_motor_offset_x = 0;
  //leadscrew_rear_motor_offset_y = extrusion_side/2+mgn_height+leadscrew_nut_shaft_diam+1;

  module rail_assembly() {
    translate([0,0,rail_offset_z]) {
      translate([0,extrusion_side/2-z_rail_sunk_into_extrusion,0]) {
        rotate([-90,0,0]) {
          rotate([0,0,90]) {
            % rail(z_rail,z_rail_length);
          }
        }
      }
    }
  }

  for(x=[left,right]) {
    mirror([x-1,0,0]) {
      translate([extrusion_vertical_spacing_x/2,front*extrusion_vertical_spacing_y/2,0]) {
        translate([0,0,rail_offset_z+carriage_offset_z-pos_z]) {
          z_carrier_front_leadscrew(leadscrew_base_motor_offset_x,leadscrew_base_motor_offset_y,is_final);
        }
        z_motor_mount_leadscrew_front(leadscrew_base_motor_offset_x,leadscrew_base_motor_offset_y,is_final);
        rail_assembly();
      }
    }
  }

  translate([rear_z_offset_x,rear_z_pos_y,0]) {
    rotate([0,0,180]) {
      translate([0,0,rail_offset_z+carriage_offset_z-pos_z]) {
        z_carrier_rear_leadscrew(leadscrew_rear_motor_offset_x,leadscrew_rear_motor_offset_y,is_final);
      }
      z_motor_mount_leadscrew_rear(leadscrew_rear_motor_offset_x,leadscrew_rear_motor_offset_y,is_final);
      rail_assembly();
    }
  }
}

module z_drive_units(pos_z) {
  for(x=[left,right]) {
    mirror([x-1,0,0]) {
      translate([right*(extrusion_vertical_spacing_x/2-belt_plane_offset),front*(extrusion_vertical_spacing_y/2),0]) {
        rotate([0,0,-90]) {
          belt_drive_z(pos_z);
        }
      }
    }
  }
  translate([rear_z_offset_x+belt_plane_offset_rear,rear*(extrusion_vertical_spacing_y/2-extrusion_side+adjust_rear_belt_whatnots),0]) {
    mirror([0,0,0]) {
      rotate([0,0,90]) {
        belt_drive_z(pos_z);
      }
    }
  }

}

module z_axis_assembly_belted(pos_z,is_final) {
  for(x=[left,right]) {
    mirror([x-1,0,0]) {
      z_idler_front_brace_corner(is_final);
      z_idler_front_brace_inner(is_final);
    }
  }
  z_idler_top_idler(is_final);
  translate([0,0,extrusion_side]) {
    rear_z_chain_fixed_anchor();
  }
  umbilical_wire_guard(is_final);
  translate([0,0,rail_offset_z+carriage_offset_z+extrusion_side/2]) {
    //translate([0,front*(extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-extrusion_side/2-5),0]) {
    translate([0,0,-pos_z+bed_assembly_offset_z]) {
      translate([0,bed_plate_offset_y,extrusion_width(bed_extrusion_type)/2+plate_thickness/2+bed_plate_insulation_spacer_length]) {
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

      //length = 150;
      //translate([left*(extrusion_side/2+mgn_width/2+2),extrusion_side/2+rear_bed_extrusion_length/2,0]) {
      translate([rear_bed_extrusion_offset_x,rear_bed_extrusion_pos_y,0]) {
        rotate([90,0,0]) {
          % extrusion(bed_extrusion_type, rear_bed_extrusion_length);
        }
        //translate([-0.1,rear_bed_extrusion_length/2,0]) {
        translate([0,rear_bed_extrusion_length/2,0]) {
          z_carriage_bed_anchor_rear(is_final,2);
        }
      }
      translate([0,extrusion_carrier_edge_pos_y,0]) {
        rotate([0,90,0]) {
          //% extrusion_l(extrusion_main_length);
          //% extrusion(bed_extrusion_type, front_bed_extrusion_length);
          % extrusion(bed_extrusion_type, front_bed_extrusion_length);
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
      }

      // bed/carriage flex points/attachment
      for(x=[left,right]) {
        mirror([x-1,0,0]) {
          translate([front_bed_extrusion_length/2,extrusion_carrier_edge_pos_y,0]) {
            z_carriage_bed_anchor_front(is_final,marks_for_side[x+1]);
          }
        }
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

  position_z_modules(pos_z);
}

module z_axis_assembly_leadscrew(pos_z,is_final) {
  z_idler_top_idler(is_final);
  umbilical_wire_guard(is_final);

  translate([0,0,rail_offset_z+carriage_offset_z+extrusion_side/2]) {
    //translate([0,front*(extrusion_vertical_spacing_y/2-extrusion_side/2-mgn_height-mgn_mount_thickness-extrusion_side/2-5),0]) {
    translate([0,0,-pos_z+bed_assembly_offset_z]) {
      translate([0,bed_plate_offset_y,extrusion_width(bed_extrusion_type)/2+plate_thickness/2+bed_plate_insulation_spacer_length]) {
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

      //length = 150;
      //translate([left*(extrusion_side/2+mgn_width/2+2),extrusion_side/2+rear_bed_extrusion_length/2,0]) {
      translate([rear_bed_extrusion_offset_x,rear_bed_extrusion_pos_y,0]) {
        rotate([90,0,0]) {
          % extrusion(bed_extrusion_type, rear_bed_extrusion_length);
        }
        translate([0,rear_bed_extrusion_length/2,0]) {
          //z_carriage_bed_anchor_rear(is_final,2);
        }
      }
      translate([0,extrusion_carrier_edge_pos_y,0]) {
        rotate([0,90,0]) {
          //% extrusion_l(extrusion_main_length);
          % extrusion(bed_extrusion_type, front_bed_extrusion_length);
        }

        translate([-60+rear_bed_extrusion_offset_x,-28,-15/2-6.1]) {
          import("../zruncho3d-tri-zero/STLs/Center_Brace_With_Wagos_x1.stl");
        }
      }
    }
  }

  position_z_leadscrew_modules(pos_z);
}

module rear_foot(side=right) {
  width = extrusion_side*2;
  //width = extrusion_vertical_spacing_x/2+extrusion_side/2-52-abs(z_motor_offset_x);
  depth = rear_foot_depth;
  height = z_base_motor_mount_overall_height;
  rounded_diam = 4;
  wall_thickness = 3;

  module body() {
    translate([extrusion_side/2-width/2,extrusion_side/2-depth/2,-height/2]) {
      rotate([0,90,0]) {
        difference() {
          rounded_cube(height,depth,width,rounded_diam);
          translate([0,0,-wall_thickness]) {
            rounded_cube(height-wall_thickness*2,depth-wall_thickness*2,width,rounded_diam-wall_thickness);
          }
        }
      }
    }
  }

  module holes() {
    screw_head_diam = screw_head_diam_for_extrusion(extrusion_vertical_type);
    screw_shaft_diam = screw_shaft_diam_for_extrusion(extrusion_vertical_type);

    hole(screw_shaft_diam,wall_thickness*3,resolution);
    hole(4,height*3,resolution);

    translate([-extrusion_side/2-50,-extrusion_side/2-50,0]) {
      rounded_cube(100,100,100,wall_thickness);
    }

    screw_holes = [
      [extrusion_side-width,0,0],
      //[0,extrusion_side/2-depth/2,0],
      [0,extrusion_side/2-depth+extrusion_side/2,0],
    ];
    for(p=screw_holes) {
      translate(p) {
        hole(m3_through_hole_diam,wall_thickness*3,resolution);
        hole(2.5,height*3,resolution);
      }
    }

    translate([extrusion_side/2-width,-extrusion_side/2,0]) {
      round_corner_filler(extrusion_side*0.8,height*3);
    }

    translate([-extrusion_vertical_spacing_x/2,-extrusion_vertical_spacing_y/2,0]) {
      position_bottom_panel_screw_holes() {
        // heatset insert?
        hole(m3_threaded_insert_od,m3_threaded_insert_height*2,resolution);
      }
    }
  }

  mirror([side-1,0,0]) {
    difference() {
      body();
      holes();
    }
  }
}

module psu_foot() {
  plug_type = IEC_320_C14_switched_fused_inlet;
  plug_screw_diam = m3_thread_into_plastic_diam;

  plug_hole_width = iec_body_w(plug_type)+tolerance;
  plug_hole_height = iec_body_h(plug_type)+tolerance;

  module plug_hole(height,swell_by=0) {
    rounded_cube(plug_hole_width+swell_by*2,plug_hole_height+swell_by*2,height,(iec_body_r(plug_type)*2)-tolerance+swell_by*2);
  }

  module position_plug() {
    translate([extrusion_side/2,-plug_hole_height/2-extrusion_side/2+5,-z_base_motor_mount_overall_height/2]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }

  module body() {
    rear_foot(right);

    hull() {
      position_plug() {
        wall_height = 8;
        wall_thickness = 3;
        translate([0,0,-wall_height/2-tolerance]) {
          plug_hole(wall_height,wall_thickness);

          iec_screw_positions(plug_type) {
            hole(plug_screw_diam+4,wall_height,resolution);
          }
        }
      }
    }
  }

  module holes() {
    position_plug() {
      % iec(plug_type);
      plug_hole(100);

      iec_screw_positions(plug_type) {
        hole(plug_screw_diam,100,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module skirt_filler(side) {
  space_between_skirt_elements = 0.5;
  wall_thickness = 2;

  width = extrusion_side/2+m3_head_diam/2+1+wall_thickness;
  depth = extrusion_vertical_spacing_y-z_motor_mount_front_desired_depth-rear_foot_depth+extrusion_side/2-space_between_skirt_elements*2;
  height = z_base_motor_mount_overall_height;

  module body() {
    translate([extrusion_side/2-width/2,0,0]) {
      rotate([0,90,0]) {
        difference() {
          rounded_cube(height,depth,width,rounded_diam+wall_thickness*2);
          translate([0,0,-wall_thickness]) {
            rounded_cube(height-wall_thickness*2,depth-wall_thickness*2,width,rounded_diam);
          }
        }
      }
    }
  }

  module holes() {
    for(p=[
      [0,0,0],
      [0,front*(depth/2-wall_thickness-m3_head_diam),0],
      [0,rear*(depth/2-wall_thickness-m3_head_diam),0],
    ]) {
      translate(p) {
        hole(m3_through_hole_diam,height*3,resolution);
      }
    }
  }

  translate([
    0,
    -extrusion_vertical_spacing_y/2+z_motor_mount_front_desired_depth+space_between_skirt_elements+depth/2,
    -height/2
  ]) {
    mirror([side-1,0,0]) {
      difference() {
        body();
        holes();
      }
    }
  }
}

module z_axis_assembly(pos_z) {
  use_leadscrew = true;
  //use_leadscrew = false;
  if (use_leadscrew) {
    z_axis_assembly_leadscrew(pos_z);
  } else {
    z_axis_assembly_belted(pos_z);
    z_drive_units(pos_z);
  }
}

z_axis_assembly(30);
frame_assembly();
/*
translate([rear_z_offset_x,extrusion_vertical_spacing_y/2-extrusion_side,bottom_pos_z+extrusion_main_length/2]) {
  % extrusion_l(extrusion_main_length);
}
translate([extrusion_vertical_spacing_x/2,-extrusion_vertical_spacing_y/2,top_pos_z-extrusion_vertical_length/2]) {
  % extrusion_l(extrusion_vertical_length);
}
*/

translate([extrusion_vertical_spacing_x,0,0]) {
  z_motor_mount_front(is_final,1);
}
