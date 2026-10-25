include <./main.scad>;

rounded_diam = 4;
anchor_width = motor_xy_width;
narrow_anchor_depth = ab_corner_anchor_depth-extrusion_width(extrusion_main_type)-stick_ab_steppers_out_back;
side_anchor_thickness = 6;

motor_xy_dist_to_center = motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount;
space_between_motor_and_center = 0;
space_between_motor_and_corner = extrusion_vertical_spacing_x/2-extrusion_width(extrusion_vertical_type)/2-motor_xy_pos_x-motor_xy_width/2-0.3;

ensure_center_area_anchor_cohesion = 2;

motor_shoulder_clearance = NEMA_boss_radius(motor_type_xy)*2+0.3;
cut_through_height = 50;

motor_shoulder_hole_smaller_by = 4;
motor_shoulder_hole_smaller_diam = motor_shoulder_clearance-motor_shoulder_hole_smaller_by;

innermost_motor_shoulder_hole = motor_xy_pos_x-motor_xy_adjustment_amount-motor_shoulder_hole_smaller_diam/2;
wall_between_motor_and_center_spar = innermost_motor_shoulder_hole-extrusion_shortest_length/2-0.6;

center_anchor_center_pos_x = motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount-center_brace_anchor_length/2;

tolerance = 0.2;

space_between_elongated_motor_holes_x = motor_xy_hole_spacing-m3_through_hole_diam-motor_xy_adjustment_amount;
space_between_spar_and_elongated_holes_y = motor_xy_hole_spacing/2-m3_through_hole_diam/2-extrusion_width(extrusion_shortest_type)/2-rear_brace_offset_y-tolerance;

center_brace_rear_wall_thickness = m3_through_hole_diam+space_between_spar_and_elongated_holes_y;
center_brace_rear_wall_length = 8.5;

module ab_pod_upper(side,is_final) {
  top_pos_z = ab_top_pos_z;

  module body() {
    translate([0,0,top_pos_z]) {
      translate([0,0,ab_pod_upper_thickness/2]) {
        linear_extrude(height=ab_pod_upper_thickness,center=true,convexity=3) {
          corner_anchor_profile();
          upper_center_anchor_profile();
          upper_motor_area_profile();
          extrusion_lock_profile();
        }
      }
    }
    height_between_pod_plates = top_pos_z-motor_xy_pos_z-xy_motor_plate_thickness;
    translate([0,0,top_pos_z-height_between_pod_plates/2+1]) {
      linear_extrude(height=height_between_pod_plates+2,center=true,convexity=3) {
        upper_screw_area_filler_profile();
      }
    }
    dist_to_extrusion_spar_z = height_between_pod_plates-extrusion_width(extrusion_shortest_type);
    translate([0,0,top_pos_z]) {
      tab_height = 1;
      tab_width = 3;
      translate([center_anchor_center_pos_x,rear_brace_pos_y,-dist_to_extrusion_spar_z]) {
        difference() {
          rounded_cube(center_brace_anchor_length,tab_width,tab_height*2,tab_width);
          for(x=[-center_brace_anchor_length*0.2,center_brace_anchor_length*0.3]) {
            translate([x,0,-tab_height]) {
              cube([m3_through_hole_diam,tab_width*2,tab_height*2],center=true);
            }
          }
        }
      }
      translate([0,0,-dist_to_extrusion_spar_z/2+1]) {
        hull() {
          translate([0,rear_brace_pos_y,0]) {
            translate([center_anchor_center_pos_x,0,0]) {
              rounded_cube(center_brace_anchor_length,extrusion_width(extrusion_shortest_type),dist_to_extrusion_spar_z+2,rounded_diam);
            }
            translate([innermost_motor_shoulder_hole-wall_between_motor_and_center_spar/2,front*(extrusion_width(extrusion_shortest_type)/2-wall_between_motor_and_center_spar/2),0]) {
              hole(wall_between_motor_and_center_spar,dist_to_extrusion_spar_z+2,resolution);
            }
            translate([innermost_motor_shoulder_hole-wall_between_motor_and_center_spar/2,rear*(extrusion_width(extrusion_shortest_type)/2-wall_between_motor_and_center_spar/2),0]) {
              hole(wall_between_motor_and_center_spar,dist_to_extrusion_spar_z+2,resolution);
            }
            translate([motor_xy_pos_x,0,0]) {
              translate([-motor_xy_hole_spacing/2-motor_xy_adjustment_amount-m3_through_hole_diam/2-center_brace_rear_wall_length+m3_through_hole_diam/2,extrusion_width(extrusion_shortest_type)/2+tolerance+center_brace_rear_wall_thickness/2,0]) {
                rounded_cube(m3_through_hole_diam,center_brace_rear_wall_thickness,dist_to_extrusion_spar_z+2,m3_through_hole_diam);
              }
              translate([-motor_shoulder_clearance/2-motor_xy_adjustment_amount-wall_between_motor_and_center_spar,extrusion_width(extrusion_shortest_type)/2+space_between_spar_and_elongated_holes_y/2+tolerance,0]) { // FIXME: remove tolerance
                cube([1,space_between_spar_and_elongated_holes_y,dist_to_extrusion_spar_z+2],center=true);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    // position_endstop() {
    //   microswitch_hole_positions(y_endstop_type) {
    //     hole(1.7,2*(y_endstop_thickness/2+ab_pod_upper_thickness-1),resolution);
    //   }
    // }
    motor_holes(top_pos_z);
    translate([motor_xy_pos_x,motor_xy_pos_y,top_pos_z]) {
      hull() {
        hole(motor_shoulder_hole_smaller_diam,cut_through_height,resolution*2);
        translate([-motor_xy_adjustment_amount,0,0]) {
          hole(motor_shoulder_hole_smaller_diam,cut_through_height,resolution*2);
        }
      }
    }
    translate([motor_xy_pos_x-motor_shoulder_hole_smaller_diam/2-motor_xy_adjustment_amount,-extrusion_width(extrusion_shortest_type)/2,top_pos_z]) {
      translate([0,rear_brace_pos_y,0]) {
        translate([0,-wall_between_motor_and_center_spar/2,0]) {
          rotate([0,0,90]) {
            round_corner_filler(wall_between_motor_and_center_spar,cut_through_height);
          }
        }
      }
      translate([0,motor_xy_pos_y,0]) {
        translate([motor_shoulder_clearance/2,0,0]) {
          cube([motor_shoulder_clearance,extrusion_width(extrusion_shortest_type),cut_through_height],center=true);
        }
      }
    }

    recessed_bridging = [
      [center_anchor_center_pos_x-center_brace_anchor_length*0.2,rear_brace_pos_y,0],
      [center_anchor_center_pos_x+center_brace_anchor_length*0.3,rear_brace_pos_y,0],
    ];
    screw_through = [
      [outer_idler_pos_x,outer_idler_pos_y,0],
      [rear_idler_pos_x,rear_idler_pos_y,0],
      [non_motor_idler_pos_x,non_motor_idler_pos_y,0],
    ];
    translate([0,0,top_pos_z+xy_motor_plate_thickness]) {
      for(p=screw_through) {
        translate(p) {
          hole(3.4,500,resolution);
        }
      }
      // recess to make lengths match for center anchor
      recess_by = top_pos_z-motor_xy_pos_z-extrusion_width(extrusion_shortest_type)-xy_motor_plate_thickness;
      translate([0,0,-recess_by]) {
        for(p=recessed_bridging) {
          translate(p) {
            bridged_hole(m3_head_diam,m3_through_hole_diam,20,is_final);
          }
        }
      }
    }
  }
  // position_endstop() {
  //   % microswitch(y_endstop_type);
  // }

  //color(print_color) difference() {
  difference() {
    body();
    holes();
  }
}

module ab_pod_lower(side,is_final) {
  module body() {
    translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness-ab_pod_lower_thickness/2]) {
      linear_extrude(height=ab_pod_lower_thickness,center=true,convexity=2) {
        extrusion_lock_profile();
      }
    }
    translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness-ab_pod_lower_thickness/2]) {
      linear_extrude(height=ab_pod_lower_thickness,center=true,convexity=2) {
        corner_anchor_profile();
      }
    }
    translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness/2]) {
      linear_extrude(height=xy_motor_plate_thickness,center=true,convexity=2) {
        hull() {
          lower_center_anchor_profile();
          motor_plate_profile();
        }
      }
    }
    translate([extrusion_vertical_spacing_x/2-extrusion_side/2,extrusion_vertical_spacing_y/2+extrusion_side/2-ab_corner_anchor_depth/2+ab_corner_offset_y,0]) {
      translate([-side_anchor_thickness/2,0,gantry_pos_z]) {
        rounded_cube(side_anchor_thickness,ab_corner_anchor_depth,extrusion_side,wall_thickness*2);
      }
      for(y=[front,0,rear]) {
        translate([0,y*(ab_corner_anchor_depth/2-wall_thickness),0]) {
          hull() {
            translate([-space_between_motor_and_corner/2,0,motor_xy_pos_z+xy_motor_plate_thickness-ab_pod_lower_thickness/2]) {
              rounded_cube(space_between_motor_and_corner,wall_thickness*2,ab_pod_lower_thickness,wall_thickness*2);
            }
            translate([-side_anchor_thickness/2,0,gantry_pos_z]) {
              rounded_cube(side_anchor_thickness,wall_thickness*2,extrusion_side,wall_thickness*2);
            }
          }
        }
      }
    }
  }

  module holes() {
    motor_holes(motor_xy_pos_z+xy_motor_plate_thickness);

    module cutter(diam,height) {
      hull() {
        hole(diam,height,resolution*2);
        translate([-motor_xy_adjustment_amount,0,0]) {
          hole(diam,height,resolution*2);
        }
      }
    }

    translate([motor_xy_pos_x,motor_xy_pos_y,motor_xy_pos_z]) {
      shoulder_height = 2.2;
      cutter(motor_shoulder_hole_smaller_diam,cut_through_height);
      hull() {
        cutter(motor_shoulder_clearance,shoulder_height*2);
        cutter(motor_shoulder_hole_smaller_diam,(shoulder_height+motor_shoulder_hole_smaller_by/2)*2);
      }
    }

    translate([extrusion_vertical_spacing_x/2-extrusion_side/2-side_anchor_thickness,extrusion_vertical_spacing_y/2-extrusion_side/2,gantry_pos_z]) {
      for(y=[extrusion_side/2,extrusion_side-ab_corner_anchor_depth*0.75]) {
        translate([0,y,0]) {
          rotate([0,-90,0]) {
            hole(3.4,(side_anchor_thickness+space_between_motor_and_corner)*2,resolution);
          }
        }
      }
    }

    center_anchor_screw_inner_pos_x = center_anchor_center_pos_x-center_brace_anchor_length*0.2;
    center_anchor_screw_outer_pos_x = center_anchor_center_pos_x+center_brace_anchor_length*0.3;
    zip_tie_hole_id = 3;
    motor_zip_tie_pos_x = center_anchor_screw_outer_pos_x-zip_tie_hole_id/2+1;

    zip_tie_hole_width = 4;
    zip_tie_hole_thickness = 2;
    wall_between_wires_and_zip_ties = 1.5;
    od = zip_tie_hole_id + zip_tie_hole_thickness*2;

    module zip_tie_hole() {

      difference() {
        hole(od,zip_tie_hole_width,resolution);
        hole(zip_tie_hole_id,zip_tie_hole_width+1,resolution);
      }
    }

    translate([motor_zip_tie_pos_x,0,motor_xy_pos_z]) {
      for(y=[front,rear]) {
        translate([0,rear_brace_pos_y+y*(15/2+zip_tie_hole_width/2),0]) {
          rotate([90,0,0]) {
            zip_tie_hole();
          }
        }
      }
    }

    screw_through = [
      [outer_idler_pos_x,outer_idler_pos_y,0],
      [center_anchor_screw_outer_pos_x,rear_brace_pos_y,0],
      [center_anchor_screw_inner_pos_x,rear_brace_pos_y,0],
    ];
    thread_into_plastic = [
      [rear_idler_pos_x,rear_idler_pos_y,0],
      [non_motor_idler_pos_x,non_motor_idler_pos_y,0],
    ];
    translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness]) {
      for(p=screw_through) {
        translate(p) {
          hole(3.4,500,resolution);
        }
      }
      for(p=thread_into_plastic) {
        lead_in_height = 1;
        thread_depth = xy_motor_plate_thickness-0.2;
        translate(p) {
          hull() {
            hole(m3_through_hole_diam,lead_in_height*2,resolution);
            # hole(0.1,(lead_in_height+m3_through_hole_diam)*20,resolution);
          }

          hole(m3_thread_into_plastic_diam,thread_depth*2,resolution);
        }
      }
    }

    // belt tensioner set screw
    //set_screw_pos_x = extrusion_vertical_spacing_x/2+extrusion_side/2;
    set_screw_nut_thickness = 4;
    //set_screw_pos_x = extrusion_vertical_spacing_x/2 - extrusion_side/2 - side_anchor_thickness;
    set_screw_pos_x = extrusion_vertical_spacing_x/2 - extrusion_side/2 - space_between_motor_and_corner + set_screw_nut_thickness - 0.05;
    set_screw_pos_y = outer_idler_pos_y+m3_through_hole_diam/2+extrude_width*2+m3_through_hole_diam/2;
    //set_screw_pos_z = gantry_pos_z+extrusion_side/2+extrude_height*5+m3_through_hole_diam/2;
    set_screw_pos_z = motor_xy_pos_z - m3_through_hole_diam/2;
    translate([set_screw_pos_x,set_screw_pos_y,set_screw_pos_z]) {
      set_screw_cavity_length = space_between_motor_and_corner+extrusion_side;
      threaded_length = 14;

      nut_diam = 5.6; // nominally 5.5mm max, so this _should_ be a mild press fit
      nut_sides = 6;
      rotate([0,90,0]) {
        translate([0,0,set_screw_cavity_length/2]) {
          hole(m3_through_hole_diam,2*(set_screw_cavity_length+1),8);
        }
        // migrating to a square nut for now
        //hole(m3_thread_into_plastic_diam,2*(set_screw_cavity_length+1),8);
        //hole(m3_through_hole_diam,2*(set_screw_cavity_length-threaded_length),8);

        translate([0,0,-set_screw_nut_thickness/2 ]) {
          rotate([0,0,90]) {
            hull() {
              for(y=[0,-1]) {
                translate([0,y*(nut_diam),0]) {
                  hole(nut_diam,set_screw_nut_thickness,nut_sides);
                }
              }
            }
          }
        }
      }
    }
    /*
    translate([set_screw_pos_x,set_screw_pos_y,set_screw_pos_z]) {
      set_screw_cavity_length = space_between_motor_and_corner+extrusion_side;
      threaded_length = 14;

      nut_diam = 5.7;
      nut_thickness = 3.5;
      nut_sides = 6;
            % debug_axes(1);
      rotate([0,90,0]) {
        // migrating to a square nut for now
        //hole(m3_thread_into_plastic_diam,2*(set_screw_cavity_length+1),8);
        //hole(m3_through_hole_diam,2*(set_screw_cavity_length-threaded_length),8);
        hole(m3_through_hole_diam,2*(set_screw_cavity_length+1),8);

        translate([0,0,- set_screw_cavity_length + nut_thickness/2-0.02 ]) {
          rotate([0,0,90]) {
            hole(nut_diam,nut_thickness,nut_sides);
          }
        }
      }
    }
    */
  }

  //color(print_color) difference() {
  difference() {
    body();
    holes();
  }
}

module extrusion_lock_profile() {
  pin_depth = 1;
  module body() {
    translate([extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,0]) {
      for(x=[left,right]) {
        rotate([0,0,(x-1)*-135]) {
          mirror([x-1,0,0]) {
            translate([-extrusion_side/2,0,0]) {
              hull() {
                translate([0,extrusion_slot_width/2-pin_depth,0]) {
                  square([pin_depth*2,pin_depth*2],center=true);
                }
                translate([0,-extrusion_slot_width/2+pin_depth,0]) {
                  accurate_circle(pin_depth*2,8);
                }
              }
            }
          }
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

module corner_anchor_profile() {
  module body() {
    translate([extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,0]) {
      translate([-extrusion_side/2-space_between_motor_and_corner/2,extrusion_side/2-ab_corner_anchor_depth/2+ab_corner_offset_y,0]) {
        rounded_square(space_between_motor_and_corner,ab_corner_anchor_depth,wall_thickness*2);
      }
      combined_width = space_between_motor_and_corner+extrusion_side;
      translate([extrusion_side/2-combined_width/2,-extrusion_side/2-narrow_anchor_depth/2,0]) {
        rounded_square(combined_width,narrow_anchor_depth,rounded_diam);
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

module motor_plate_profile() {
  module body() {
    hull() {
      translate([motor_xy_pos_x,motor_xy_pos_y,0]) {
        rounded_square(motor_xy_width,motor_xy_width,motor_xy_rounded);
      }
    }
    translate([motor_xy_pos_x+motor_xy_width/2,motor_xy_pos_y+motor_xy_width/2-ab_corner_anchor_depth/2,0]) {
      square([rounded_diam*3,ab_corner_anchor_depth],center=true);
    }
    translate([motor_xy_pos_x+motor_xy_width/2,motor_xy_pos_y+motor_xy_width/2-ab_corner_anchor_depth,0]) {
      rotate([0,0,-90]) {
        round_corner_filler_profile(rounded_diam);
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

module lower_center_anchor_profile() {
  module body() {
    hull() {
      translate([motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount,0,0]) {
        translate([-ensure_center_area_anchor_cohesion+motor_xy_adjustment_amount/2,motor_xy_pos_y,0]) {
          rounded_square(motor_xy_rounded,motor_xy_width,motor_xy_rounded);
        }
        translate([0,rear_brace_pos_y,0]) {
          translate([-center_brace_anchor_length+rounded_diam/2,0,0]) {
            rounded_square(rounded_diam,extrusion_side,rounded_diam);
          }
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

module upper_center_anchor_profile() {
  module body() {
    hull() {
      translate([innermost_motor_shoulder_hole-wall_between_motor_and_center_spar/2,rear_brace_pos_y-extrusion_width(extrusion_shortest_type)/2+wall_between_motor_and_center_spar/2,0]) {
        accurate_circle(wall_between_motor_and_center_spar,resolution); // FIXME rounding the corner
      }
      translate([motor_xy_pos_x,0,0]) {
        translate([0,rear_brace_pos_y,0]) {
          translate([-motor_xy_width/2-motor_xy_adjustment_amount,0,0]) {
            translate([-center_brace_anchor_length+rounded_diam/2,0,0]) {
              rounded_square(rounded_diam,extrusion_width(extrusion_shortest_type),rounded_diam);
            }
          }
        }
        translate([0,motor_xy_pos_y,0]) {
          translate([-motor_xy_width/2-motor_xy_adjustment_amount/2,0,0]) {
            translate([-ensure_center_area_anchor_cohesion+motor_xy_width/4-motor_xy_rounded/2,motor_xy_width/2-motor_xy_rounded/2,0]) {
              rounded_square(motor_xy_width/2,motor_xy_rounded,motor_xy_rounded);
            }
          }
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

module upper_motor_area_profile() {
  hull() {
    translate([0,extrusion_vertical_spacing_y/2+extrusion_width(extrusion_vertical_type)/2-ab_corner_anchor_depth/2+ab_corner_offset_y,0]) {
      translate([extrusion_vertical_spacing_x/2-extrusion_width(extrusion_vertical_type)/2-space_between_motor_and_corner/2,0,0]) {
        rounded_square(space_between_motor_and_corner,ab_corner_anchor_depth,wall_thickness*2);
      }
      larger_rounded = motor_shoulder_hole_smaller_diam/2;
      translate([motor_xy_pos_x+motor_shoulder_hole_smaller_diam/2+larger_rounded/2,0,0]) {
        rounded_square(larger_rounded,ab_corner_anchor_depth,larger_rounded,resolution*2);
      }
    }
  }
  hull() {
    translate([motor_xy_pos_x,motor_xy_pos_y+motor_xy_width/4,0]) {
      rounded_square(motor_xy_width,motor_xy_width/2,rounded_diam);
    }
  }
}

module upper_screw_area_filler_profile() {
  module body() {
    // between brace extrusion and pulley
    hull() {
      translate([innermost_motor_shoulder_hole-wall_between_motor_and_center_spar/2,0,0]) {
        translate([0,rear_brace_pos_y,0]) {
          translate([0,-extrusion_width(extrusion_shortest_type)/2+wall_between_motor_and_center_spar/2,0]) {
            accurate_circle(wall_between_motor_and_center_spar,resolution);
          }
        }
        translate([0,motor_xy_pos_y,0]) {
          translate([0,motor_xy_hole_spacing/2-m3_through_hole_diam/2-1,0]) {
            square([wall_between_motor_and_center_spar,2],center=true);
          }
        }
      }
    }
    translate([motor_xy_pos_x-motor_xy_adjustment_amount-motor_shoulder_clearance/4,motor_xy_pos_y+motor_shoulder_clearance/4+1,0]) {
      square([motor_shoulder_clearance/2,motor_shoulder_clearance/2+1],center=true);
    }
    // meat between screw holes
    translate([motor_xy_pos_x,0,0]) {
      translate([0,motor_xy_pos_y,0]) {
        translate([-motor_xy_hole_spacing/2,motor_xy_hole_spacing/2-m3_through_hole_diam/2,0]) {
          square([space_between_elongated_motor_holes_x,m3_through_hole_diam],center=true);
        }
        translate([-motor_xy_adjustment_amount/2,motor_xy_hole_spacing/2-m3_through_hole_diam/2,0]) {
          rounded_square(space_between_elongated_motor_holes_x,m3_through_hole_diam*2,m3_through_hole_diam);

          for(x=[left,right]) {
            translate([x*space_between_elongated_motor_holes_x/2,0,0]) {
              square([m3_through_hole_diam,m3_through_hole_diam],center=true);
            }
          }
          //space_between_elongated_motor_holes_x = motor_xy_hole_spacing-m3_through_hole_diam-motor_xy_adjustment_amount;
          translate([-motor_xy_hole_spacing/2-motor_xy_adjustment_amount+m3_through_hole_diam/2,tolerance+space_between_spar_and_elongated_holes_y/2,0]) {
            square([m3_through_hole_diam,m3_through_hole_diam-tolerance-space_between_spar_and_elongated_holes_y],center=true);
          }
        }
      }
      translate([0,rear_brace_pos_y,0]) {
        translate([-motor_xy_hole_spacing/2-motor_xy_adjustment_amount-m3_through_hole_diam/2-center_brace_rear_wall_length/2,extrusion_width(extrusion_shortest_type)/2+tolerance+center_brace_rear_wall_thickness/2,0]) {
          rounded_square(center_brace_rear_wall_length,center_brace_rear_wall_thickness,m3_through_hole_diam);
        }
        translate([-motor_shoulder_clearance/2-motor_xy_adjustment_amount-wall_between_motor_and_center_spar,extrusion_width(extrusion_shortest_type)/2+space_between_spar_and_elongated_holes_y/2+tolerance,0]) { // FIXME: derive from spacing, remove tolerance
          square([center_brace_rear_wall_length*2,space_between_spar_and_elongated_holes_y],center=true);
        }
      }
    }
    // put meat by outermost,rearmost screw hole
    hull() {
      translate([0,motor_xy_pos_y+motor_xy_hole_spacing/2-m3_through_hole_diam,0]) {
        translate([motor_xy_pos_x+motor_xy_hole_spacing/2,0,0]) {
          accurate_circle(m3_through_hole_diam,resolution);
        }
        translate([innermost_motor_shoulder_hole,-motor_shoulder_clearance*0.15,0]) {
          square([m3_through_hole_diam,m3_through_hole_diam+motor_shoulder_clearance*0.3],center=true);
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

module motor_holes(z) {
  translate([motor_xy_pos_x,motor_xy_pos_y,z]) {
    /*
    # hull() {
      hole(motor_shoulder_clearance,cut_through_height,resolution*2);
      translate([-motor_xy_adjustment_amount,0,0]) {
        hole(motor_shoulder_clearance,cut_through_height,resolution*2);
      }
    }
    */
    motor_screw_hole_diam = m3_through_hole_diam;
    for(x=[left,right]) {
      for(y=[front,rear]) {
        hull() {
          for(a=[0,motor_xy_adjustment_amount]) {
            translate([x*(motor_xy_hole_spacing/2)-a,y*(motor_xy_hole_spacing/2),0]) {
              hole(motor_screw_hole_diam,cut_through_height,resolution);
            }
          }
        }
      }
      sink_heads_by = 2;
      screw_head_diam = 6;
      long_bridge = screw_head_diam+motor_xy_adjustment_amount;
      hole_length = motor_screw_hole_diam+motor_xy_adjustment_amount;
      hull() {
        for(a=[0,motor_xy_adjustment_amount]) {
          translate([x*(motor_xy_hole_spacing/2)-a,front*(motor_xy_hole_spacing/2),0]) {
            hole(screw_head_diam,sink_heads_by*2,resolution);
          }
        }
      }
      translate([x*(motor_xy_hole_spacing/2)-motor_xy_adjustment_amount/2,front*(motor_xy_hole_spacing/2),-sink_heads_by]) {
        intersection() {
          union() {
            cube([long_bridge,motor_screw_hole_diam,0.2*1*2],center=true);
            cube([hole_length,motor_screw_hole_diam,0.2*2*2],center=true);
            rounded_cube(hole_length,motor_screw_hole_diam,0.2*3*2,motor_screw_hole_diam,8);
          }
          rounded_cube(long_bridge,screw_head_diam,cut_through_height,screw_head_diam);
        }
      }
    }
  }
}

module old_y_endstop_mount() {
  // FIXME: offset (or make adjustable) so that the trigger is centered in X
  // FIXME: offset so that the trigger is centered in Z

  extrusion_width = 15; // FIXME: pull from config
  dist_from_brace_to_x_rail_y = 15;
  dist_from_brace_to_x_rail_z = 1.5;
  //overall_width = y_endstop_length+2*(wall_thickness*2+tolerance);
  backstop_height = 1; // avoid interfering with the pins
  pin_spacing = 5.08;

  switch_pos_y = front*(extrusion_shortest_side/2 + dist_from_brace_to_x_rail_y - y_endstop_width/2);
  switch_pos_z = dist_from_brace_to_x_rail_z;
  dist_between_switch_and_extrusion = abs(switch_pos_y)-y_endstop_width/2-extrusion_width/2;

  between_pin_thickness = 1.6;
  between_pin_length = dist_between_switch_and_extrusion-tolerance;
  between_pin_height = extrusion_width/2 - switch_pos_z + y_endstop_thickness/2 - tolerance*2;

  front_pos_y = switch_pos_y - y_endstop_width/2;

  outside_switch_length = abs(front_pos_y) - extrusion_width/2 - tolerance;
  outside_switch_thickness = wall_thickness*2;
  outside_switch_height = between_pin_height;

  roof_thickness = 1.4;
  height_above_extrusion = 3;

  thickness_above_switch = extrusion_width/2 - switch_pos_z - y_endstop_thickness/2;

  switch_area_overall_width = y_endstop_length + 2*(tolerance + outside_switch_thickness);
  switch_area_overall_depth = extrusion_width + tolerance + outside_switch_length;
  switch_area_overall_height = outside_switch_height + height_above_extrusion + roof_thickness;

  cable_retention_area_width = 5;
  cable_retention_area_depth = extrusion_width + tolerance + outside_switch_length/2;
  overall_width = switch_area_overall_width + 2*(cable_retention_area_width + outside_switch_thickness);

  top_pos_z = extrusion_width/2 + height_above_extrusion + roof_thickness;

  module position_endstop() {
    // in front of rear brace, to hit x rail directly
    translate([0,switch_pos_y,switch_pos_z]) {
      rotate([0,0,0]) {
        rotate([180,0,0]) {
          children();
        }
      }
    }
    /*
    // on top of rear brace
    translate([1.95,front*(extrusion_shortest_side/2 - y_endstop_width/2),extrusion_shortest_side/2+y_endstop_width/2+1]) {
      rotate([0,0,0]) {
        rotate([180,0,0]) {
          children();
        }
      }
    }
    */
  }

  module body() {
    // beside the switch
    // between the pins
    for(x=[left,right]) {
      translate([x*(pin_spacing/2),-extrusion_width/2-tolerance - between_pin_length/2,extrusion_width/2 - between_pin_height/2]) {
        rounded_cube(between_pin_thickness, between_pin_length, between_pin_height, between_pin_thickness);
      }
      translate([x*(switch_area_overall_width/2 - outside_switch_thickness/2),front_pos_y + outside_switch_length/2,extrusion_width/2 - outside_switch_height/2]) {
        rounded_cube(outside_switch_thickness, outside_switch_length, outside_switch_height, outside_switch_thickness);
      }

      translate([0,extrusion_width/2 - switch_area_overall_depth/2,extrusion_width/2 + height_above_extrusion/2 + roof_thickness/2]) {
        rounded_cube(switch_area_overall_width, switch_area_overall_depth, height_above_extrusion + roof_thickness, outside_switch_thickness);
      }

      translate([0,0,top_pos_z]) {
        translate([x*(overall_width/2 - outside_switch_thickness/2),extrusion_width/2 - cable_retention_area_depth/2,-(roof_thickness + height_above_extrusion)/2]) {
          rounded_cube(outside_switch_thickness, cable_retention_area_depth, height_above_extrusion + roof_thickness, outside_switch_thickness);
        }
        mirror([x-1,0,0]) {
          points = [
            [switch_area_overall_width/2 - outside_switch_thickness/2,front_pos_y + outside_switch_thickness/2,0],
            [overall_width/2 - outside_switch_thickness/2,extrusion_width/2 - cable_retention_area_depth + outside_switch_thickness/2,0],
            [overall_width/2 - outside_switch_thickness/2,- extrusion_width/2 - outside_switch_thickness/2,0],
          ];
          translate([0,0,-switch_area_overall_height/2]) {
            for(p=[0:len(points) - 2]) {
              hull() {
                translate(points[p]) {
                  hole(outside_switch_thickness, switch_area_overall_height, resolution);
                }
                translate(points[p+1]) {
                  hole(outside_switch_thickness, switch_area_overall_height, resolution);
                }
              }
            }
          }
        }
      }
    }
    translate([0,- extrusion_width/2 - tolerance - outside_switch_length/2,extrusion_width/2 - thickness_above_switch/2 + height_above_extrusion/2 + roof_thickness/2]) {
      rounded_cube(switch_area_overall_width, outside_switch_length, thickness_above_switch + height_above_extrusion + roof_thickness, outside_switch_thickness);
    }
    translate([0,0,top_pos_z]) {
      translate([0,extrusion_width/2 - switch_area_overall_depth/2,-1 * (height_above_extrusion/2 + roof_thickness/2)]) {
        rounded_cube(switch_area_overall_width, switch_area_overall_depth, height_above_extrusion + roof_thickness, outside_switch_thickness);
      }
      translate([0,0,- roof_thickness/2]) {
        hull() {
          translate([0,extrusion_width/2 - switch_area_overall_depth/2,0]) {
            rounded_cube(switch_area_overall_width, switch_area_overall_depth, roof_thickness, outside_switch_thickness);
          }
          translate([0,extrusion_width/2 - cable_retention_area_depth/2,0]) {
            rounded_cube(overall_width, cable_retention_area_depth, roof_thickness, outside_switch_thickness);
          }
        }
      }
    }
  }

  module holes() {
    position_endstop() {
      % microswitch(y_endstop_type);

      microswitch_hole_positions(y_endstop_type) {
        hole(microswitch_hole_d(y_endstop_type), 20, resolution);
      }
    }

    hole(3.4,30,resolution);
  }

  difference() {
    body();
    holes();
  }
}

module y_endstop_mount() { // smaller
  extrusion_width = 15; // FIXME: pull from config

  microswitch_backstop_height = 1.6; // avoid interfering with the pins
  microswitch_backstop_thickness = 5; // avoid interfering with the pins
  pin_spacing = 5.08;

  // NOTE: adjust this value to compensate for y endstop position
  dist_from_brace_to_x_rail_y = 14.7; // FIXME: determine rather than hardcode
  //dist_from_brace_to_x_rail_y = y_endstop_width + microswitch_backstop_thickness; // FIXME: determine rather than hardcode

  switch_pos_y = front*(extrusion_shortest_side/2 + dist_from_brace_to_x_rail_y - y_endstop_width/2);
  switch_pos_z = 3.2; // FIXME: determine rather than hardcode
  dist_between_switch_and_extrusion = abs(switch_pos_y)-y_endstop_width/2-extrusion_width/2;

  front_pos_y = switch_pos_y - y_endstop_width/2 + 1;

  thickness = 1;

  hole_depth = 5;
  mount_width = 20;
  mount_deep_width = hole_depth+thickness;
  mount_deep_depth = abs(switch_pos_y)-extrusion_width/2+3;
  mount_narrow_depth = 6;
  mount_height = 13;

  extrusion_slot_width = 3;
  extrusion_slot_depth = 1;

  module position_endstop() {
    // in front of rear brace, to hit x rail directly
    translate([0,switch_pos_y,switch_pos_z]) {
      rotate([0,-90,0]) {
        rotate([180,0,0]) {
          children();
        }
      }
    }
  }

  position_endstop() {
    % microswitch(y_endstop_type);
  }

  module body() {
    translate([y_endstop_thickness/2+mount_width/2,-extrusion_width/2,0]) {
      rotate([0,90,0]) {
        rounded_cube(extrusion_slot_width,extrusion_slot_depth*2,mount_width,thickness);
      }
    }
    hull() {
      translate([y_endstop_thickness/2+mount_width/2,-extrusion_width/2-mount_narrow_depth/2,0]) {
        rotate([0,90,0]) {
          rounded_cube(mount_height,mount_narrow_depth,mount_width,thickness);
        }
      }
      translate([y_endstop_thickness/2+mount_deep_width/2,0,0]) {
        translate([0,switch_pos_y+microswitch_backstop_thickness/2,switch_pos_z]) {
          rotate([0,90,0]) {
            rounded_cube(y_endstop_length,y_endstop_width+microswitch_backstop_thickness,mount_deep_width,thickness);
          }
        }
      }
    }
    translate([y_endstop_thickness/2,switch_pos_y+y_endstop_width/2+microswitch_backstop_thickness/2,switch_pos_z]) {
      rotate([0,90,0]) {
        rounded_cube(y_endstop_length,microswitch_backstop_thickness,microswitch_backstop_height*2,thickness);
      }
    }
  }

  module holes() {
    screw_head_meat = 2;

    translate([y_endstop_thickness/2+mount_width/2,-extrusion_width/2,0]) {
      // increase ease of printing; clear out slot near screw hole to reduce 90deg overhang
      hull() {
        translate([0,20/2,0]) {
          cube([4,20,20],center=true);

          translate([0,3,0]) {
            cube([4+3*2,20,20],center=true);
            
          }
        }
      }

      // screw hole
      translate([0,-screw_head_meat,0]) {
        rotate([-90,0,0]) {
          hole(m3_through_hole_diam,mount_deep_depth,resolution);
          translate([0,0,-mount_deep_depth/2]) {
            hole(m3_head_diam+0.4,mount_deep_depth,8);
          }
        }
      }
    }

    position_endstop() {
      microswitch_hole_positions(y_endstop_type) {
        hole(2,y_endstop_thickness+2*(hole_depth),resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module ab_pod_assembly(side,is_final) {
  translate([side*motor_xy_pos_x,motor_xy_pos_y,0]) {
    for(a=[0,motor_xy_adjustment_amount]) {
    //for(a=[0]) {
      translate([-side*a,0,motor_xy_pos_z]) {
        rotate([0,0,-side*90]) {
          % NEMA(motor_type_xy); // AB motor
        }
        translate([0,0,16-side*4.5]) {
          rotate([0,90+side*90,0]) {
            % pulley_assembly(xy_pulley_type);
          }
        }
      }
    }
  }

  mirror([side-1,0,0]) {
    ab_pod_lower(side,is_final);
    ab_pod_upper(side,is_final);
  }

  //translate([9.8,rear_brace_pos_y,rear_brace_pos_z]) {
  translate([15,rear_brace_pos_y,rear_brace_pos_z]) {
    y_endstop_mount();
  }

  translate([0,rear_brace_pos_y,rear_brace_pos_z]) {
    rotate([0,90,0]) {
      % color(frame_color) extrusion(extrusion_shortest_type,extrusion_shortest_length);
    }
  }
}

translate([0,rear_brace_pos_y,motor_xy_pos_z+ extrusion_shortest_side /2+xy_motor_plate_thickness]) {
  rotate([0,90,0]) {
    % color(frame_color) extrusion(extrusion_shortest_type,extrusion_shortest_length);
  }
}

ab_pod_assembly(right,is_final);
//ab_pod_assembly(right,is_final);
