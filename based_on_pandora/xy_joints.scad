include <./main.scad>;

y_rail_pos_x = extrusion_vertical_spacing_x/2;
mgn_width = carriage_width(y_carriage);
mgn_height = carriage_height(y_carriage);
mgn_length = carriage_length(y_carriage);
center_channel_width = belt_idler_od-1;

m2_through_hole_diam = 2.2;
m2_head_diam = 4.2;

rounded_diam = 2;

module countersunk_m2(depth=50,head_height=40) {

  hole(m2_through_hole_diam,depth*2,resolution);
  recess_by = 1;

  hull() {
    translate([0,0,head_height/2]) {
      hole(m2_head_diam,head_height,resolution);
      hole(m2_through_hole_diam,head_height+recess_by*2,resolution);
    }
  }
}

module elongated_bridged_hole(hole_diam,elongation_length,depth=30,is_final) {
  hull() {
    for(x=[left,right]) {
      translate([x*elongation_length/2,0,0]) {
        hole(hole_diam,depth,resolution);
      }
    }
  }
  if (is_final) {
    long_bridge = hole_diam+elongation_length+10;
    hole_length = hole_diam+elongation_length;
    translate([0,0,0]) {
      intersection() {
        union() {
          cube([long_bridge,hole_diam,0.2*1*2],center=true);
          cube([hole_length,hole_diam,0.2*2*2],center=true);
          rounded_cube(hole_length,hole_diam,0.2*3*2,hole_diam,8);
        }
        children();
      }
    }
  }
}


module xy_joint_profile() {
  module body() {
    diam = 2*(xy_front_idler_pos_x-(y_rail_pos_x-mgn_width/2));
    hull() {
      translate([y_rail_pos_x,0,0]) {
        rounded_square(mgn_width,mgn_length,rounded_diam);
      }
      translate([xy_front_idler_pos_x,xy_front_idler_offset_pos_y,0]) {
        accurate_circle(diam,resolution);
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

module position_mgn_holes() {
  mgn_hole_spacing_width = 12;
  mgn_hole_spacing_length = 13;

  for(x=[left,right],y=[front,rear]) {
    translate([y_rail_pos_x+x*mgn_hole_spacing_width/2,y*mgn_hole_spacing_length/2,0]) {
      children();
    }
  }
}

module xy_joint_bottom(side) {
  module body() {
    translate([0,0,mgn_height+xy_carriage_base_thickness/2]) {
      linear_extrude(height=xy_carriage_base_thickness,center=true,convexity=2) {
        xy_joint_profile();
      }
    }
  }

  module holes() {
    translate([0,0,mgn_height+xy_carriage_base_thickness]) {
      position_mgn_holes() {
        countersunk_m2();
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module xy_joint_top(side) {
  module body() {
    translate([0,0,mgn_height+xy_carriage_base_thickness+belt_idler_stack_height+xy_carriage_top_thickness/2]) {
      linear_extrude(height=xy_carriage_top_thickness,center=true,convexity=2) {
        xy_joint_profile();
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

module position_mgn(side) {
  translate([0,0,0]) {
    rotate([0,0,90]) {
      children();
    }
  }
}

module xy_joint_single_piece(side, is_final) {
  idler_bevel_height = 0.5;

  rail_tolerance = 0.1;

  hole_spacing_x = y_carriage[7];
  hole_spacing_y = y_carriage[6];

  overall_height = xy_carriage_base_thickness+belt_idler_spacer_length*2+xy_carriage_top_thickness;
  idler_front_pos_x = -front_idler_clearance_bearing_dist_x*side;
  idler_front_pos_y = x_carriage_offset_y+x_axis_offset_y-effective_radius;
  idler_front_pos_z = xy_belt_center_extrusion_offset_z-xy_belt_spacing/2*side;
  idler_rear_pos_x = 0;
  idler_rear_pos_z = xy_belt_center_extrusion_offset_z+xy_belt_spacing/2*side;
  idler_rear_pos_y = idler_front_pos_y+xy_carriage_bearing_dist_y;
  idler_body_diam = belt_idler_od+2.5;
  belt_idler_cavity_diam = belt_idler_od+2;
  belt_idler_belt_cavity_diam = belt_idler_cavity_diam+2;
  belt_cavity_width = 2.5;
  belt_cavity_height = 7;

  add_material_between_cavities = 0.2;
  idler_cavity_height = belt_idler_spacer_length-add_material_between_cavities;

  mgn_area_depth = carriage_length(y_carriage)-5;
  mgn_area_width = carriage_width(y_carriage);

  belt_return_path_side_cut_width = mgn_width/2-belt_idler_od/2+1;
  belt_return_path_side_cut_height = belt_idler_spacer_length*2;

  rail_adjustment_amount = 2;

  rail_hole_spacing = rail_pitch(x_rail);
  rail_hole_from_end = rail_end(x_rail);
  rail_support_length = rail_hole_spacing*3;

  rail_pos_y = x_carriage_offset_y+x_axis_offset_y+carriage_height(x_carriage);
  rail_pos_z = mgn_height+x_extrusion_above_y_carriage+extrusion_side/2;

  meat_behind_rail = mgn_area_depth/2-rail_pos_y;
  meat_below_carriage = 1.4;
  meat_beside_rail_at_end_of_support = 3.5;
  rail_body_meat = meat_behind_rail+meat_below_carriage;

  module position_rail() {
    translate([-side*(extrusion_side/2+x_rail_length/2),rail_pos_y,rail_pos_z]) {
      rotate([90,0,0]) {
        children();
      }
    }
  }

  module position_idler_front() {
    translate([idler_front_pos_x, idler_front_pos_y, idler_front_pos_z]) {
      rotate([0,0,0]) {
        children();
      }
    }
  }

  module position_idler_rear() {
    translate([idler_rear_pos_x, idler_rear_pos_y, idler_rear_pos_z]) {
      rotate([0,0,0]) {
        children();
      }
    }
  }

  module position_idlers() {
    position_idler_front() {
      children();
    }
    position_idler_rear() {
      children();
    }
  }

  module position_mgn() {
    rotate([0,0,90]) {
      children();
    }
  }

  module body() {
    translate([0,0,mgn_height+overall_height/2]) {
      translate([0,0,0]) {
        rotate([90,0,0]) {
          rounded_cube(mgn_area_width,overall_height,mgn_area_depth,1);
        }
      }
      hull() {
        translate([idler_front_pos_x,idler_front_pos_y,0]) {
          hole(idler_body_diam,overall_height,resolution);
        }
        translate([idler_rear_pos_x,idler_rear_pos_y,0]) {
          hole(idler_body_diam,overall_height,resolution);
        }
        translate([0,front*(mgn_area_depth/2-1),0]) {
          rotate([90,0,0]) {
            rounded_cube(mgn_area_width,overall_height,2,1);
          }
        }
      }
    }

    hull() {
      translate([0,mgn_area_depth/2-rail_body_meat/2,0]) {
        translate([0,0,mgn_height+overall_height/2]) {
          rotate([90,0,0]) {
            rounded_cube(mgn_area_width,overall_height,rail_body_meat,1);
          }
        }
        translate([-side*(extrusion_side/2+rail_support_length-meat_beside_rail_at_end_of_support/2),0,rail_pos_z]) {
          rotate([90,0,0]) {
            rounded_cube(meat_beside_rail_at_end_of_support,meat_beside_rail_at_end_of_support*2+rail_width(x_rail),rail_body_meat,2);
          }
        }
      }
    }
  }

  module bearing_cavity() {
    hull() {
      hole(belt_idler_cavity_diam,idler_cavity_height,resolution);
      hole(belt_idler_belt_cavity_diam,belt_cavity_height,resolution);
    }
  }

  module holes() {
    position_mgn() {
      % carriage(y_carriage);
    }

    module elongated_hex_hole() {
      hull() {
        for(x=[left,right]) {
          translate([x*rail_adjustment_amount,0,10]) {
            rotate([0,0,90]) {
              hole(5.6,20,6);
            }
          }
        }
      }
    }

    // clearance for motors
    translate([0,mgn_area_depth/2-rail_body_meat/2,0]) {
      hull() {
        translate([0,0,rail_pos_z-rail_width(x_rail)/2-meat_beside_rail_at_end_of_support-20]) {
          translate([-side*(extrusion_side/2+rail_support_length-meat_beside_rail_at_end_of_support/2),0,0]) {
            rotate([90,0,0]) {
              rounded_cube(meat_beside_rail_at_end_of_support*2,40,rail_body_meat+1,2);
            }
          }
          translate([-side*(mgn_width),0,0]) {
            rotate([90,0,0]) {
              rounded_cube(mgn_width-(6)*2,40,rail_body_meat+1,2);
            }
          }
        }
      }
    }

    position_rail() {
      sink_heads_by = 5;
      rail_hole_positions(x_rail, x_rail_length) {
        translate([0,0,-meat_behind_rail+sink_heads_by]) {
          rotate([180,0,0]) {
            elongated_hex_hole();
            elongated_bridged_hole(m3_through_hole_diam, rail_adjustment_amount,meat_behind_rail*2,is_final) {
              translate([0,0,-2]) {
                elongated_hex_hole();
              }
            }
          }
        }
        //debug_axes(1);
        /*
        hull() {
          for(x=[left,right]) {
            translate([x*rail_adjustment_amount/2,0,0]) {
              hole(m2_through_hole_diam,30,resolution);
            }
          }
        }
        hull() {
          for(x=[left,right]) {
            translate([x*rail_adjustment_amount/2,0,-meat_behind_rail]) {
              rotate([0,0,90]) {
                hole(m2_head_diam,5,6);
              }
            }
          }
        }
        */
      }

      rail_height = rail_height(x_rail)+rail_tolerance;
      rail_width = rail_width(x_rail)+rail_tolerance;
      translate([0,0,rail_height/2]) {
        cube([x_rail_length+rail_adjustment_amount,rail_width,rail_height],center=true);
      }
    }

    position_idlers() {
      translate([0,0,-belt_idler_spacer_length/2+idler_bevel_height]) {
        translate([0,0,25]) {
          hole(m3_through_hole_diam,50,resolution);
        }
        translate([0,0,-25]) {
          hole(m3_thread_into_plastic_diam,50,resolution);
        }
      }
    }

    translate([side*mgn_width/2,0,xy_belt_center_extrusion_offset_z]) {
      rotate([90,0,0]) {
        rounded_cube(belt_return_path_side_cut_width*2,belt_return_path_side_cut_height,mgn_length*2,1);
      }
    }

    translate([0,0,-side*add_material_between_cavities/2]) {
      position_idler_front() {
        hull() {
          bearing_cavity();
          for(x=[left,right]) {
            rotate([0,0,x*45]) {
              translate([-side*mgn_width,-mgn_width,0]) {
                bearing_cavity();
              }
            }
          }
        }
      }
      translate([0,front*belt_idler_cavity_diam/2,0]) {
        cube([belt_idler_belt_cavity_diam,belt_idler_cavity_diam,belt_cavity_height],center=true);
      }
      translate([-side*belt_idler_cavity_diam/2,0]) {
        cube([belt_idler_cavity_diam,belt_idler_belt_cavity_diam,belt_cavity_height],center=true);
      }
    }

    if (side == left) {
      hull() {
        translate([0,0,mgn_height+xy_carriage_base_thickness]) {
          translate([0,-hole_spacing_y/2,idler_cavity_height/4]) {
            cube([belt_idler_cavity_diam*2,m2_head_diam,idler_cavity_height/2],center=true);
          }
        }
        translate([0,0,side*add_material_between_cavities/2]) {
          position_idler_rear() {
            translate([0,front*(belt_idler_belt_cavity_diam/2-belt_cavity_width/2),-idler_cavity_height/4+0.5]) {
              cube([mgn_length*2,belt_cavity_width,idler_cavity_height/2],center=true);
            }
          }
        }
      }
    }
    translate([0,0,side*add_material_between_cavities/2]) {
      position_idler_rear() {
        hull() {
          translate([-side*mgn_length/2,front*(belt_idler_belt_cavity_diam/2-belt_cavity_width/2),0]) {
            cube([mgn_length,belt_cavity_width,belt_cavity_height],center=true);
          }
        }
        hull() {
          bearing_cavity();
          translate([side*mgn_width,0,0]) {
            bearing_cavity();
          }
        }
      }
    }

    translate([0,0,mgn_height]) {
      screw_head_height=7;

      for(x=[left,right],y=[front,rear]) {
        translate([x*(hole_spacing_x/2),y*(hole_spacing_y/2),0]) {
          translate([0,0,xy_carriage_base_thickness]) {
            countersunk_m2(xy_carriage_base_thickness+1,screw_head_height);
          }
        }
      }
      translate([-side*hole_spacing_x/2,-hole_spacing_y/2,xy_carriage_base_thickness+screw_head_height/2]) {
        hull() {
          hole(m2_head_diam,screw_head_height,resolution);

          translate([-side*m2_head_diam,0,0]) {
            hole(m2_head_diam,screw_head_height,resolution);
          }
        }
      }
      all_the_way=100;
      translate([-side*hole_spacing_x/2,hole_spacing_y/2,xy_carriage_base_thickness+all_the_way/2]) {
        hole(m2_head_diam,all_the_way,resolution);
      }
    }
  }

  module bridges() {
    position_idlers() {
      for(z=[top,bottom]) {
        mirror([0,0,z-1]) {
          translate([0,0,belt_idler_spacer_length/2-idler_bevel_height]) {
            id = m3_through_hole_diam + 2;
            od = id + idler_bevel_height*2;
            difference() {
              rotate([180,0,0]) {
                bevel(od,id,idler_bevel_height);
              }
              if (z==top) {
                hole(m3_through_hole_diam,idler_bevel_height*3,resolution);
              } else {
                hole(m3_thread_into_plastic_diam,idler_bevel_height*3,resolution);
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
  bridges();
}

module y_carriage_assembly(side,is_final) {
  module body() {
    xy_joint_single_piece(side,is_final);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module front_idler(side) {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module y_axis_assembly(pos_y,is_final) {
  for(x=[left,right]) {
    translate([0,y_rail_pos_y,gantry_pos_z+extrusion_side/2]) {
      translate([x*extrusion_vertical_spacing_x/2,0,0]) {
        rotate([0,0,90]) {
          % rail(y_rail,y_rail_length);
        }
      }

      translate([x*extrusion_vertical_spacing_x/2,0,0]) {
        translate([0,-y_rail_length/2+carriage_length(y_carriage)/2+pos_y,0]) {
          y_carriage_assembly(x,is_final);
        }
      }
    }
    /*
    mirror([0,0,0]) {
      translate([0,y_rail_pos_y,gantry_pos_z+extrusion_side/2]) {
        translate([x*extrusion_vertical_spacing_x/2,0,0]) {
          rotate([0,0,90]) {
            % rail(y_rail,y_rail_length);
          }
        }

        translate([0,-y_rail_length/2+carriage_length(y_carriage)/2+pos_y,0]) {
          y_carriage_assembly(x);
        }
      }
    }
    */
  }
}
