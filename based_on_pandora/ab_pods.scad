include <./main.scad>;

rounded_diam = 4;
anchor_width = motor_xy_width;
narrow_anchor_depth = ab_corner_anchor_depth-extrusion_side;
side_anchor_thickness = 6;

addition_backside_meat_for_center_anchor = 0; // (motor_xy_hole_spacing-extrusion_side-m3_head_diam)/2;

motor_xy_dist_to_center = motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount;
space_between_motor_and_center = 0;
space_between_motor_and_corner = extrusion_vertical_spacing_x/2-extrusion_side/2-motor_xy_pos_x-motor_xy_width/2-0.3;

motor_shoulder_clearance = NEMA_boss_radius(motor_type_xy)*2+0.3;
cut_through_height = 50;

innermost_motor_shoulder_hole = motor_xy_pos_x-motor_xy_adjustment_amount-motor_shoulder_clearance/2;
wall_between_motor_and_center_spar = innermost_motor_shoulder_hole-extrusion_shortest_length/2-0.2;

center_anchor_center_pos_x = motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount-center_brace_anchor_length/2;

space_between_elongated_motor_holes_x = motor_xy_hole_spacing-m3_through_hole_diam-motor_xy_adjustment_amount;
space_between_spar_and_elongated_holes_y = motor_xy_hole_spacing/2-m3_through_hole_diam/2-extrusion_side/2;

echo("xy_motor_plate_thickness: ", xy_motor_plate_thickness);

module ab_pod_upper() {
  top_pos_z = xy_belt_center_pos_z+belt_idler_stack_height/2;

  module body() {
    translate([0,0,top_pos_z]) {
      translate([0,0,ab_pod_upper_thickness/2]) {
        linear_extrude(height=ab_pod_upper_thickness,center=true,convexity=2) {
          corner_anchor_profile();
          upper_center_anchor_profile();
          upper_motor_area_profile();
        }
      }
    }
    height_between_pod_plates = top_pos_z-motor_xy_pos_z-xy_motor_plate_thickness;
    translate([0,0,top_pos_z-height_between_pod_plates/2+1]) {
      linear_extrude(height=height_between_pod_plates+2,center=true,convexity=3) {
        upper_screw_area_filler_profile();
      }
    }
    dist_to_extrusion_spar_z = height_between_pod_plates-extrusion_side;
    translate([0,0,top_pos_z]) {
      tab_height = 1;
      tab_width = 3;
      translate([center_anchor_center_pos_x,motor_xy_pos_y,-dist_to_extrusion_spar_z]) {
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
          // center_anchor_center_pos_x = motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount-center_brace_anchor_length/2;
          translate([0,motor_xy_pos_y,0]) {
            translate([innermost_motor_shoulder_hole-wall_between_motor_and_center_spar/2,front*(extrusion_side/2),0]) {
              hole(wall_between_motor_and_center_spar,dist_to_extrusion_spar_z+2,resolution);
            }
            translate([center_anchor_center_pos_x,addition_backside_meat_for_center_anchor/2,0]) {
              rounded_cube(center_brace_anchor_length,extrusion_side+addition_backside_meat_for_center_anchor,dist_to_extrusion_spar_z+2,rounded_diam);
            }
            translate([motor_xy_pos_x,0,0]) {
              translate([-motor_shoulder_clearance/2-motor_xy_adjustment_amount-wall_between_motor_and_center_spar,extrusion_side/2+space_between_spar_and_elongated_holes_y/2,0]) {
                rounded_cube(center_brace_anchor_length,space_between_spar_and_elongated_holes_y,dist_to_extrusion_spar_z+2,space_between_spar_and_elongated_holes_y);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    motor_holes(top_pos_z);
    translate([motor_xy_pos_x,motor_xy_pos_y,0]) {
      translate([0,0,top_pos_z]) {
        hull() {
          hole(motor_shoulder_clearance,cut_through_height,resolution*2);
          translate([-motor_xy_adjustment_amount,0,0]) {
            hole(motor_shoulder_clearance,cut_through_height,resolution*2);
          }
        }
      }
      translate([-motor_shoulder_clearance/2-motor_xy_adjustment_amount,-extrusion_side/2,top_pos_z]) {
        translate([0,-wall_between_motor_and_center_spar/2,0]) {
          rotate([0,0,90]) {
            round_corner_filler(wall_between_motor_and_center_spar,cut_through_height);
          }
        }
        translate([motor_shoulder_clearance/2,0,0]) {
          cube([motor_shoulder_clearance,extrusion_side,cut_through_height],center=true);
        }
      }
    }

    recessed_bridging = [
      [center_anchor_center_pos_x-center_brace_anchor_length*0.2,motor_xy_pos_y,0],
      [center_anchor_center_pos_x+center_brace_anchor_length*0.3,motor_xy_pos_y,0],
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
      recess_by = top_pos_z-motor_xy_pos_z-extrusion_side-xy_motor_plate_thickness;
      translate([0,0,-recess_by]) {
        for(p=recessed_bridging) {
          translate(p) {
            bridged_hole(m3_head_diam,m3_through_hole_diam);
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

module ab_pod_lower() {
  module body() {
    translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness-ab_pod_lower_thickness/2]) {
      linear_extrude(height=ab_pod_lower_thickness,center=true,convexity=2) {
        corner_anchor_profile();
      }
    }
    translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness/2]) {
      linear_extrude(height=xy_motor_plate_thickness,center=true,convexity=2) {
        lower_center_anchor_profile();
      }
    }
    translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness/2]) {
      linear_extrude(height=xy_motor_plate_thickness,center=true,convexity=2) {
        motor_plate_profile();
      }
    }
    translate([extrusion_vertical_spacing_x/2-extrusion_side/2,extrusion_vertical_spacing_y/2-extrusion_side/2,0]) {
      translate([-side_anchor_thickness/2,0,gantry_pos_z]) {
        rounded_cube(side_anchor_thickness,ab_corner_anchor_depth,extrusion_side,wall_thickness*2);
      }
      for(y=[front,0,rear]) {
        translate([0,y*(extrusion_side-wall_thickness),0]) {
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
      smaller_by = 4;
      smaller_diam = motor_shoulder_clearance-smaller_by;
      cutter(smaller_diam,cut_through_height);
      hull() {
        cutter(motor_shoulder_clearance,shoulder_height*2);
        cutter(smaller_diam,(shoulder_height+smaller_by/2)*2);
      }
    }

    translate([extrusion_vertical_spacing_x/2-extrusion_side/2-side_anchor_thickness,extrusion_vertical_spacing_y/2-extrusion_side/2,gantry_pos_z]) {
      for(y=[front,rear]) {
        translate([0,y*(extrusion_side/2),0]) {
          rotate([0,-90,0]) {
            hole(3.4,(side_anchor_thickness+space_between_motor_and_corner)*2,resolution);
          }
        }
      }
    }

    screw_through = [
      [outer_idler_pos_x,outer_idler_pos_y,0],
      [center_anchor_center_pos_x-center_brace_anchor_length*0.2,motor_xy_pos_y,0],
      [center_anchor_center_pos_x+center_brace_anchor_length*0.3,motor_xy_pos_y,0],
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
        thread_depth = xy_motor_plate_thickness+1;
        translate(p) {
          hull() {
            hole(m3_through_hole_diam,lead_in_height*2,resolution);
            hole(0.1,(lead_in_height+m3_through_hole_diam)*2,resolution);
          }
        
          hole(m3_thread_into_plastic_diam,thread_depth*2,resolution);
        }
      }
    }

    // belt tensioner set screw
    set_screw_pos_x = extrusion_vertical_spacing_x/2+extrusion_side/2;
    set_screw_pos_y = outer_idler_pos_y+m3_through_hole_diam/2+extrude_width*2+m3_through_hole_diam/2;
    set_screw_pos_z = gantry_pos_z+extrusion_side/2+extrude_height*5+m3_through_hole_diam/2;
    translate([set_screw_pos_x,set_screw_pos_y,set_screw_pos_z]) {
      set_screw_cavity_length = space_between_motor_and_corner+extrusion_side;
      threaded_length = 14;

      echo("set_screw_cavity_length: ", set_screw_cavity_length);
      rotate([0,90,0]) {
        hole(m3_thread_into_plastic_diam,2*(set_screw_cavity_length+1),8);
        hole(m3_through_hole_diam,2*(set_screw_cavity_length-threaded_length),8);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module corner_anchor_profile() {
  module body() {
    translate([extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,0]) {
      translate([-extrusion_side/2-space_between_motor_and_corner/2,extrusion_side/2-ab_corner_anchor_depth/2,0]) {
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
      translate([motor_xy_pos_x-motor_xy_adjustment_amount,motor_xy_pos_y,0]) {
        rounded_square(motor_xy_width+motor_xy_adjustment_amount*2,motor_xy_width,motor_xy_rounded);
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
      translate([motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount,motor_xy_pos_y,0]) {
        rounded_square(motor_xy_rounded,motor_xy_width,motor_xy_rounded);

        translate([-center_brace_anchor_length+rounded_diam/2,addition_backside_meat_for_center_anchor/2,0]) {
          rounded_square(rounded_diam,extrusion_side+addition_backside_meat_for_center_anchor,rounded_diam);
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
      translate([innermost_motor_shoulder_hole-wall_between_motor_and_center_spar/2,motor_xy_pos_y-extrusion_side/2,0]) {
        accurate_circle(wall_between_motor_and_center_spar,resolution);
      }
      translate([motor_xy_pos_x,motor_xy_pos_y,0]) {
        translate([0,addition_backside_meat_for_center_anchor/2,0]) {
          translate([-motor_xy_width/4,0,0]) {
            rounded_square(motor_xy_width/2,extrusion_side+addition_backside_meat_for_center_anchor,rounded_diam);
          }

          translate([-motor_xy_width/2-motor_xy_adjustment_amount,0,0]) {
            translate([motor_xy_width/4-motor_xy_rounded/2,motor_xy_width/2-motor_xy_rounded/2,0]) {
              rounded_square(motor_xy_width/2,motor_xy_rounded,motor_xy_rounded);
            }
            translate([-center_brace_anchor_length+rounded_diam/2,0,0]) {
              rounded_square(rounded_diam,extrusion_side+addition_backside_meat_for_center_anchor,rounded_diam);
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
    translate([0,extrusion_vertical_spacing_y/2+extrusion_side/2-ab_corner_anchor_depth/2,0]) {
      translate([extrusion_vertical_spacing_x/2-extrusion_side/2-space_between_motor_and_corner/2,0,0]) {
        rounded_square(space_between_motor_and_corner,ab_corner_anchor_depth,wall_thickness*2);
      }
      translate([motor_xy_pos_x+motor_shoulder_clearance/2+rounded_diam/2,0,0]) {
        rounded_square(rounded_diam,ab_corner_anchor_depth,rounded_diam);
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
    translate([innermost_motor_shoulder_hole,motor_xy_pos_y,0]) {
      hull() {
        translate([-wall_between_motor_and_center_spar/2,0,0]) {
          translate([0,-extrusion_side/2-wall_between_motor_and_center_spar/2+wall_between_motor_and_center_spar/2,0]) {
            accurate_circle(wall_between_motor_and_center_spar,resolution);
          }
          translate([0,motor_xy_hole_spacing/2-m3_through_hole_diam/2-1,0]) {
            square([wall_between_motor_and_center_spar,2],center=true);
          }
        }
        
      }
    }
    translate([motor_xy_pos_x-motor_xy_adjustment_amount-motor_shoulder_clearance/4-1,motor_xy_pos_y+motor_shoulder_clearance/4+1,0]) {
      square([motor_shoulder_clearance/2+1,motor_shoulder_clearance/2+1],center=true);
    }
    // meat between screw holes
    translate([motor_xy_pos_x,motor_xy_pos_y,0]) {
      translate([-motor_xy_adjustment_amount/2,motor_xy_hole_spacing/2-m3_through_hole_diam/2,0]) {
        rounded_square(space_between_elongated_motor_holes_x,m3_through_hole_diam*2,m3_through_hole_diam);
        for(x=[left,right]) {
          translate([x*space_between_elongated_motor_holes_x/2,0,0]) {
            square([m3_through_hole_diam,m3_through_hole_diam],center=true);
          }
        }
      }
      translate([-motor_shoulder_clearance/2-motor_xy_adjustment_amount-wall_between_motor_and_center_spar,extrusion_side/2+space_between_spar_and_elongated_holes_y/2,0]) {
        rounded_square(center_brace_anchor_length,space_between_spar_and_elongated_holes_y,space_between_spar_and_elongated_holes_y);
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

module ab_pod_assembly(side) {
  translate([side*motor_xy_pos_x,motor_xy_pos_y,0]) {
    //for(a=[0,motor_xy_adjustment_amount]) {
    for(a=[0]) {
      translate([-side*a,0,motor_xy_pos_z]) {
        rotate([0,0,side*90]) {
          % NEMA(motor_type_xy); // AB motor
        }
        translate([0,0,16-side*4.5]) {
          rotate([0,90+side*90,0]) {
            % pulley_assembly(GT2x16_pulley);
          }
        }
      }
    }
  }

  mirror([side-1,0,0]) {
    ab_pod_lower();
    ab_pod_upper();
  }
}

module ab_pod_print_plate() {
  space_apart = 5;
  dist_x = extrusion_vertical_spacing_x/2-motor_xy_pos_x+extrusion_side/2+space_apart;
  for(x=[left,right]) {
    mirror([x-1,0,0]) {
    //mirror([0,0,0]) {
      translate([0,0,0]) {
        translate([motor_xy_width*1.2+space_apart,0,0]) {
          rotate([0,0,-90]) {
            rotate([180,0,0]) {
              translate([-motor_xy_pos_x,-motor_xy_pos_y,-motor_xy_pos_z-xy_motor_plate_thickness]) {
                ab_pod_lower();
              }
            }
          }
        }
        translate([motor_xy_width/2+space_apart/2,0,xy_motor_plate_thickness+belt_idler_stack_height]) {
          rotate([0,0,-90]) {
            rotate([180,0,0]) {
              translate([-motor_xy_pos_x,-motor_xy_pos_y,-motor_xy_pos_z-ab_pod_upper_thickness]) {
                ab_pod_upper();
              }
            }
          }
        }
      }
    }
  }
}

ab_pod_assembly(left);
ab_pod_assembly(right);
