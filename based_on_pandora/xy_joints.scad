include <./main.scad>;

y_rail_pos_x = extrusion_vertical_spacing_x/2;
mgn_width = carriage_width(y_carriage);
mgn_height = carriage_height(y_carriage);
mgn_length = carriage_length(y_carriage);
center_channel_width = belt_idler_od-1;

m2_through_hole_diam = 2.2;
m2_head_diam = 4.2;

recess_idler_screws_head_depth = 3;

rounded_diam = 2;

compacting_idler_pos_x = front_idler_pos_x-front_idler_clearance_bearing_dist_x;
compacting_idler_pos_y = front_idler_pos_y+11.5;

front_idler_base_pos_x = extrusion_vertical_spacing_x/2;
front_idler_base_pos_y = front*(extrusion_vertical_spacing_y/2-extrusion_side/2);
front_idler_base_pos_z = gantry_pos_z+extrusion_side/2;
front_idler_main_body_depth = compacting_idler_pos_y-front_idler_base_pos_y+belt_idler_od/2+2;

body_bevel_height = 0.4;
screw_bevel_height = 0.5;
screw_bevel_small_od = m3_through_hole_diam+1;
screw_bevel_large_od = screw_bevel_small_od+screw_bevel_height*2;

overall_height = xy_carriage_base_thickness+belt_idler_spacer_length*2+xy_carriage_top_thickness+y_rail_sunk_into_extrusion;

function front_idler_pos_z(side) = (gantry_pos_z+extrusion_side/2+xy_belt_center_extrusion_offset_z)-xy_belt_spacing/2*side;

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

module xy_joint_single_piece(side, is_final) {
  idler_bevel_height = 0.5;

  rail_tolerance = 0.1;

  hole_spacing_x = y_carriage[7];
  hole_spacing_y = y_carriage[6];

  idler_front_pos_x = -front_idler_clearance_bearing_dist_x*side;
  idler_front_pos_y = x_carriage_offset_y+x_axis_offset_y-effective_radius;
  idler_front_pos_z = xy_belt_center_extrusion_offset_z-xy_belt_spacing/2*side;
  idler_rear_pos_x = 0;
  idler_rear_pos_z = xy_belt_center_extrusion_offset_z+xy_belt_spacing/2*side;
  idler_rear_pos_y = idler_front_pos_y+xy_carriage_bearing_dist_y;
  idler_body_diam = belt_idler_od+1.75;
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
  meat_beside_rail_at_end_of_support = 5;
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
    translate([0,0,-y_rail_sunk_into_extrusion]) {
      rotate([0,0,90]) {
        children();
      }
    }
  }

  module body() {
    translate([0,0,mgn_height+overall_height/2-y_rail_sunk_into_extrusion]) {
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
        translate([0,0,mgn_height+overall_height/2-y_rail_sunk_into_extrusion]) {
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
        translate([-side*(mgn_width),0,0]) {
          rotate([90,0,0]) {
            cube([mgn_width,mgn_height*2,40],center=true);
          }
        }
        translate([0,0,rail_pos_z-rail_width(x_rail)/2-meat_beside_rail_at_end_of_support-20]) {
          translate([-side*(extrusion_side/2+rail_support_length-meat_beside_rail_at_end_of_support/2),0,0]) {
            rotate([90,0,0]) {
              rounded_cube(meat_beside_rail_at_end_of_support,40,rail_body_meat+1,2);
            }
          }
          translate([-side*(mgn_width+0.5),0,0]) {
            rotate([90,0,0]) {
              rounded_cube(2,40,rail_body_meat+1,2);
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

    translate([0,0,mgn_height+overall_height]) {
      for(p=[[idler_front_pos_x,idler_front_pos_y,0],[idler_rear_pos_x,idler_rear_pos_y,0]]) {
        translate(p) {
          hole(m3_head_diam,recess_idler_screws_head_depth*2,resolution);
        }
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
          translate([0,-hole_spacing_y/2,idler_cavity_height/2]) {
            cube([belt_idler_cavity_diam*2,m2_head_diam,belt_cavity_height],center=true);
          }
        }
        translate([0,0,side*add_material_between_cavities/2]) {
          position_idler_rear() {
            translate([0,front*(belt_idler_belt_cavity_diam/2-belt_cavity_width/2),0]) {
              cube([mgn_length*2,belt_cavity_width,belt_cavity_height],center=true);
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

    translate([0,0,mgn_height]) { // FIXME: mgn_height-y_rail_sunk_into_extrusion ?
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

module position_front_idler(side) {
  translate([front_idler_pos_x*side,front_idler_pos_y,front_idler_pos_z(side)]) {
    children();
  }
}

module position_compacting_idler(side) {
  translate([compacting_idler_pos_x*side,compacting_idler_pos_y,front_idler_pos_z(side)]) {
    children();
  }
}

module front_idler_body(side,height) {
  width = 15;
  rounded_diam = 2;

  module profile(shrink_by=0) {
    hull() {
      translate([front_idler_base_pos_x*side,front_idler_base_pos_y]) {
        depth = belt_idler_od/2;
        translate([0,depth/2,0]) {
          rounded_square(width-shrink_by*2,depth-shrink_by*2,rounded_diam-shrink_by*2);
        }
      }
      translate([compacting_idler_pos_x*side,compacting_idler_pos_y]) {
        accurate_circle(belt_idler_od+1.75-shrink_by*2,resolution);
      }
      /*
      translate([front_idler_base_pos_x*side,front_idler_base_pos_y]) {
        translate([0,front_idler_main_body_depth/2,0]) {
          rounded_square(width-shrink_by*2,front_idler_main_body_depth-shrink_by*2,rounded_diam-shrink_by*2);
        }
      }
      */
    }
  }

  module body() {
    hull() {
      linear_extrude(height=height,center=true,convexity=3) {
        profile(body_bevel_height);
      }
      linear_extrude(height=height-body_bevel_height*2,center=true,convexity=3) {
        profile(0);
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

module front_idler_top(side,is_final) {
  // alternatively we could make the front idler like zruncho's BoxZero front ilders and key it into the extrusion
  // for reference: https://github.com/zruncho3d/BoxZero/blob/main/STLs/Front_Idler_Left_Upper_x1.stl
  //target_height = overall_height+mgn_height+m3_head_diam;
  target_height = overall_height+mgn_height+m3_head_diam/2;
  target_screw_length = 35; // in case we want to make it longer
  target_compacting_screw_length = 35;
  idler_cavity_height = front_idler_pos_z(side)-front_idler_base_pos_z+belt_idler_spacer_length/2;
  height = target_height-idler_cavity_height;

  module body() {
    translate([0,0,front_idler_base_pos_z]) {
      translate([0,0,idler_cavity_height+height/2]) {
        front_idler_body(side,height);
      }
    }
    position_front_idler(side) {
      translate([0,0,belt_idler_spacer_length/2-screw_bevel_height]) {
        rotate([180,0,0]) {
          bevel(screw_bevel_large_od,screw_bevel_small_od,screw_bevel_height);
        }
      }
    }
    position_compacting_idler(side) {
      translate([0,0,belt_idler_spacer_length/2-screw_bevel_height]) {
        rotate([180,0,0]) {
          bevel(screw_bevel_large_od,screw_bevel_small_od,screw_bevel_height);
        }
      }
    }
  }

  module holes() {
    position_front_idler(side) {
      hole(m3_through_hole_diam,height*5,resolution);
    }
    position_compacting_idler(side) {
      hole(m3_through_hole_diam,height*5,resolution);
    }

    translate([compacting_idler_pos_x*side,compacting_idler_pos_y,front_idler_base_pos_z+target_compacting_screw_length+2]) {
      bridged_hole(m3_head_diam,m3_through_hole_diam,target_compacting_screw_length+2,is_final);
    }
    translate([front_idler_pos_x*side,front_idler_pos_y,front_idler_base_pos_z]) {
      translate([0,0,-3+target_screw_length]) {
        bridged_hole(m3_head_diam,m3_through_hole_diam,target_screw_length+2,is_final);
      }
      translate([0,-m3_head_diam/2,target_height-m3_head_diam/2]) {
        depth = m3_head_diam;
        translate([0,depth/2,0]) {
          slot_length = m3_head_diam+z_axis_screw_mount_thickness;
          hull() {
            translate([0,-z_axis_screw_mount_thickness/2,0]) {
              rotate([-90,0,0]) {
                hole(m3_through_hole_diam,slot_length,resolution);
              }
              translate([0,0,20]) {
                cube([m3_through_hole_diam,slot_length,1],center=true);
              }
            }
          }
          hull() {
            rotate([-90,0,0]) {
              hole(m3_head_diam,depth,resolution);
            }
            translate([0,0,20]) {
              rounded_diam = 2;
              rounded_cube(m3_head_diam+rounded_diam,depth,1,rounded_diam);
            }
            translate([0,m3_head_diam/2,m3_head_diam/2+2]) {
              rotate([-90,0,0]) {
                hole(m3_through_hole_diam,slot_length,resolution);
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

module front_idler_bottom(side,is_final) {
  height = front_idler_pos_z(side)-belt_idler_spacer_length/2-extrusion_side/2-gantry_pos_z;

  module body() {
    translate([0,0,front_idler_base_pos_z]) {
      translate([0,0,height/2]) {
        front_idler_body(side,height);
      }
      hull() {
        translate([front_idler_base_pos_x*side,front_idler_base_pos_y+front_idler_main_body_depth,z_axis_screw_mount_thickness/2]) {
          hole(m3_head_diam+1,z_axis_screw_mount_thickness-body_bevel_height*2,resolution);
          hole(m3_head_diam+1-body_bevel_height*2,z_axis_screw_mount_thickness,resolution);
        }
        translate([0,0,z_axis_screw_mount_thickness/2]) {
          front_idler_body(side,z_axis_screw_mount_thickness);
        }
      }
      translate([front_idler_base_pos_x*side,front_idler_base_pos_y,height/2]) {
        tolerance = 0.2;
        tab_width = extrusion_channel_width(extrusion_main_type)-tolerance;
        tab_depth = 1;
        cube([tab_width,tab_depth*2,height],center=true);
      }
    }
    position_front_idler(side) {
      translate([0,0,-belt_idler_spacer_length/2+screw_bevel_height]) {
        bevel(screw_bevel_large_od,screw_bevel_small_od,screw_bevel_height);
      }
    }
    position_compacting_idler(side) {
      translate([0,0,-belt_idler_spacer_length/2+screw_bevel_height]) {
        bevel(screw_bevel_large_od,screw_bevel_small_od,screw_bevel_height);
      }
    }
  }

  module holes() {
    position_front_idler(side) {
      hole(m3_through_hole_diam,height*3,resolution);
    }
    position_compacting_idler(side) {
      translate([0,0,-belt_idler_spacer_length/2]) {
        hole(m3_thread_into_plastic_diam,2*(height-1),resolution);

        lead_in_length = 3;
        hull() {
          delta = m3_through_hole_diam-m3_thread_into_plastic_diam;
          hole(m3_thread_into_plastic_diam,2*(lead_in_length+delta),resolution);
          hole(m3_through_hole_diam,2*(lead_in_length),resolution);
        }
      }
    }
    translate([front_idler_base_pos_x*side,front_idler_base_pos_y,front_idler_base_pos_z]) {
      translate([0,front_idler_main_body_depth,z_axis_screw_mount_thickness]) {
        hole(m3_through_hole_diam,50,resolution);
        translate([0,0,25]) {
          hole(m3_head_diam,50,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module y_axis_assembly(pos_y,is_final) {
  for(x=[left,right]) {
    front_idler_top(x,is_final);
    front_idler_bottom(x,is_final);
  }

  translate([0,-extrusion_vertical_spacing_y/2+extrusion_side/2,gantry_pos_z+extrusion_side/2]) {
    //% color("orange") import("../Pandoras_Box/STLs/Gantry/idler_right_lower.stl");
    //% color("orange") import("../Pandoras_Box/STLs/Gantry/idler_right_upper.stl");
  }

  for(x=[left,right]) {
    translate([0,y_rail_pos_y,gantry_pos_z+extrusion_side/2]) {
      translate([x*extrusion_vertical_spacing_x/2,0,-y_rail_sunk_into_extrusion]) {
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

y_axis_assembly(-2,false);
translate([0,0,gantry_pos_z]) {
  for(x=[left,right]) {
    translate([x*(extrusion_vertical_spacing_x/2),0,0]) {
      rotate([90,0,0]) {
        % extrusion(extrusion_main_type,extrusion_main_length);
      }
    }
  }
}

for(x=[left,right]) {
  position_compacting_idler(x) {
    % pulley_assembly(f623_2x_idler);
  }
  position_front_idler(x) {
    % pulley_assembly(f623_2x_idler);
  }
}
