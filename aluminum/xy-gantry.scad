include <config.scad>;

module front_idler_bottom(side) {
  front_idler_generic(side,bottom);
}

module front_idler_top(side) {
  front_idler_generic(side,top);
}

module front_idler_generic(side,bevel_side) {
  idler_stack_height = 33;
  side_index = side+1; // 0 and 2
  bevel_index = bevel_side+1; // 1 and 3

  belt_pos_z = [
    xy_belt_lower_dist_from_extrusion,
    0,
    xy_belt_upper_dist_from_extrusion,
  ];

  flat_pos_z = [
    0, 0, idler_stack_height
  ];

  height = abs(flat_pos_z[bevel_index]-belt_pos_z[side_index]) - xy_idler_width/2 - bevel_height;

  module profile(inset_by=0) {
    body_width = 14-inset_by;
    hull() {
      translate([0,xy_belt_idler_dist_from_end,0]) {
        accurate_circle(body_width,resolution);
      }
      translate([0,2,0]) {
        rounded_square(body_width,4-inset_by,2-inset_by);
      }
    }
  }

  module body() {
    bevel_amount = 0.6;
    hull() {
      linear_extrude(height=height-bevel_amount,center=true,convexity=3) {
        profile();
      }
      linear_extrude(height=height,center=true,convexity=3) {
        profile(bevel_amount);
      }
    }
    tolerance = 0.2;
    nut_slot_depth = 2.5-tolerance;
    nut_slot_width = 5.7-tolerance;
    screw_slot_width = 3-tolerance;
    screw_slot_depth = 1.1+nut_slot_depth;

    hull() {
      rounded_cube(screw_slot_width-bevel_amount,2*screw_slot_depth-bevel_amount,height,2-bevel_amount);
      rounded_cube(screw_slot_width,2*screw_slot_depth,height-bevel_amount,2);
    }
    translate([0,-screw_slot_depth+nut_slot_depth/2-tolerance/2,0]) {
      hull() {
        rounded_cube(nut_slot_width-bevel_amount,nut_slot_depth-bevel_amount,height,2-bevel_amount);
        rounded_cube(nut_slot_width,nut_slot_depth,height-bevel_amount,2);
      }
    }
    translate([0,0,0]) {
    }
    mirror([0,0,bevel_index]) {
      translate([0,xy_belt_idler_dist_from_end,height/2+bevel_height]) {
        bevel(xy_idler_bevel_large,xy_idler_bevel_small,bevel_height+0.1);
      }
    }
  }

  module holes() {
    translate([0,xy_belt_idler_dist_from_end,0]) {
      hole(xy_idler_id+0.3,idler_stack_height*2,resolution);
    }
  }

  translate([0,0,flat_pos_z[bevel_index]-(height/2*bevel_side)]) {
    difference() {
      body();
      holes();
    }
  }
}

module front_idler_base(height=1,bevel_side) {
  module profile(inset_by=0) {
    body_width = 14-inset_by;
    hull() {
      translate([0,xy_belt_idler_dist_from_end,0]) {
        accurate_circle(body_width,resolution);
      }
      translate([0,2,0]) {
        rounded_square(body_width,4-inset_by,2-inset_by);
      }
    }
  }

  module body() {
    bevel_amount = 0.6;
    hull() {
      linear_extrude(height=height-bevel_amount,center=true,convexity=3) {
        profile();
      }
      linear_extrude(height=height,center=true,convexity=3) {
        profile(bevel_amount);
      }
    }
  }

  module holes() {
    translate([0,xy_belt_idler_dist_from_end,0]) {
      hole(xy_idler_id+0.3,idler_stack_height*2,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module ab_motor_plate(top_or_bottom=bottom) {
  side_index = top_or_bottom+1;

  heights=[ab_plate_thickness, 0, top_ab_plate_thickness];
  height=heights[side_index];

  frame_screw_hole_diam = 3.3;
  frame_screw_hole_meat_diam = frame_screw_hole_diam + extrude_width*3*2*2;

  left_pos_x = xy_motor_pos_x-xy_motor_side/2-xy_motor_adjust_range-xy_tensioner_wall_gap-xy_tensioner_wall_width;
  near_right_pos_x = spar_main_len/2;
  far_right_pos_x = corner_pos_x+extrusion_side/2;
  front_pos_y = rear_support_pos_y-frame_screw_hole_meat_diam/2;
  far_rear_pos_y = corner_pos_y+extrusion_side/2;
  near_rear_pos_y = spar_main_len/2;

  screw_length = 35;

  bevel_height = 0.3;

  screw_offset_wall_height = xy_tensioner_screw_offset_z/2-top_or_bottom*xy_tensioner_screw_offset_z/2;
  overall_height = height+(ab_plate_space_between_z-xy_tensioner_screw_offset_z)/2+screw_offset_wall_height;

  xy_tensioner_wall_max_pos_y = far_rear_pos_y-ab_pod_room_for_belts-xy_motor_pos_y;
  xy_tensioner_wall_mid_pos_y = xy_tensioner_screw_opening_max/2;
  xy_tensioner_wall_min_pos_y = xy_tensioner_screw_opening_min/2;
  xy_tensioner_wall_wide_depth = xy_tensioner_wall_max_pos_y-xy_tensioner_wall_min_pos_y;
  xy_tensioner_wall_narrow_depth = xy_tensioner_wall_max_pos_y-xy_tensioner_wall_mid_pos_y;

  xy_tensioner_wall_screw_spacing_y = xy_tensioner_wall_mid_pos_y*2+xy_tensioner_wall_narrow_depth;

  module main_body_profile(inset_by=0) {
    main_pos = [
      [left_pos_x+rounded_diam/2,front_pos_y+rounded_diam/2],
      [left_pos_x+rounded_diam/2,far_rear_pos_y-rounded_diam/2],
      [near_right_pos_x-rounded_diam/2,far_rear_pos_y-rounded_diam/2],
      [near_right_pos_x-rounded_diam/2,front_pos_y+rounded_diam/2],
    ];

    hull() {
      for(p=main_pos) {
        translate(p) {
          //accurate_circle(rounded_diam-inset_by*2,resolution);
        }
      }
    }
  }

  module position_idlers() {
    translate([xy_belt_idler_rear_pos_x,xy_belt_idler_rear_pos_y,0]) {
      children();
    }
    translate([corner_pos_x,xy_belt_idler_rear_left_pos_y,0]) {
      children();
    }
  }

  module anchor_body_profile(inset_by=0) {
    anchor_pos = [
      [near_right_pos_x-rounded_diam/2,near_rear_pos_y-rounded_diam/2],
      [far_right_pos_x-rounded_diam/2,near_rear_pos_y-rounded_diam/2],
      [near_right_pos_x-rounded_diam/2,front_pos_y+rounded_diam/2],
    ];

    hull() {
      for(p=anchor_pos ) {
        translate(p) {
          //accurate_circle(rounded_diam-inset_by*2,resolution);
        }
      }
      translate([corner_pos_x,xy_belt_idler_rear_left_pos_y,0]) {
        //accurate_circle(xy_belt_idler_dist_from_end*2-inset_by*2,resolution);
      }
    }
  }

  module hole_profile() {
    translate([xy_motor_pos_x-xy_motor_adjust_range,xy_motor_pos_y,0]) {
      hull() {
        accurate_circle(xy_motor_hole_spacing-frame_screw_hole_meat_diam,resolution);
        translate([xy_motor_adjust_range,0,0]) {
          accurate_circle(xy_motor_hole_spacing-frame_screw_hole_meat_diam,resolution);
        }
      }
      for(x=[left,right],y=[front,rear]) {
        translate([x*xy_motor_hole_spacing/2,y*xy_motor_hole_spacing/2,0]) {
          hull() {
            accurate_circle(3.4,resolution);
            translate([xy_motor_adjust_range,0,0]) {
              accurate_circle(3.4,resolution);
            }
          }
        }
      }
    }
    translate([corner_pos_x,corner_pos_y,0]) {
      square([extrusion_side,extrusion_side],center=true);
      translate([-extrusion_side/2,extrusion_side/2,0]) {
        rotate([0,0,180]) {
          round_corner_filler_profile(rounded_diam);
        }
      }
      translate([extrusion_side/2,-extrusion_side/2,0]) {
        rotate([0,0,180]) {
          round_corner_filler_profile(rounded_diam);
        }
      }
      translate([-extrusion_side/2,-extrusion_side/2,0]) {
        hull() {
          accurate_circle(rounded_diam/2,resolution);
          translate([rounded_diam/2,rounded_diam/2,0]) {
            accurate_circle(rounded_diam,resolution);
          }
        }
      }
    }
    // xy_belt_idler_rear_pos_x = xy_motor_pos_x+xy_motor_side/2+xy_idler_od/2+1;
    translate([xy_belt_idler_rear_pos_x,xy_belt_idler_rear_pos_y,0]) {
      accurate_circle(3.4,resolution);
    }
    translate([corner_pos_x,xy_belt_idler_rear_left_pos_y,0]) {
      accurate_circle(3.4,resolution);
    }
  }

  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module old_ab_motor_plate(top_or_bottom=bottom) {
  side_index = top_or_bottom+1;

  heights=[ab_plate_thickness, 0, top_ab_plate_thickness];
  height=heights[side_index];

  frame_screw_hole_diam = 3.3;
  frame_screw_hole_meat_diam = frame_screw_hole_diam + extrude_width*3*2*2;

  left_pos_x = xy_motor_pos_x-xy_motor_side/2-xy_motor_adjust_range-xy_tensioner_wall_gap-xy_tensioner_wall_width;
  near_right_pos_x = spar_main_len/2;
  far_right_pos_x = corner_pos_x+extrusion_side/2;
  front_pos_y = rear_support_pos_y-frame_screw_hole_meat_diam/2;
  far_rear_pos_y = corner_pos_y+extrusion_side/2;
  near_rear_pos_y = spar_main_len/2;

  screw_length = 35;

  bevel_height = 0.3;

  screw_offset_wall_height = xy_tensioner_screw_offset_z/2-top_or_bottom*xy_tensioner_screw_offset_z/2;
  overall_height = height+(ab_plate_space_between_z-xy_tensioner_screw_offset_z)/2+screw_offset_wall_height;

  xy_tensioner_wall_max_pos_y = far_rear_pos_y-ab_pod_room_for_belts-xy_motor_pos_y;
  xy_tensioner_wall_mid_pos_y = xy_tensioner_screw_opening_max/2;
  xy_tensioner_wall_min_pos_y = xy_tensioner_screw_opening_min/2;
  xy_tensioner_wall_wide_depth = xy_tensioner_wall_max_pos_y-xy_tensioner_wall_min_pos_y;
  xy_tensioner_wall_narrow_depth = xy_tensioner_wall_max_pos_y-xy_tensioner_wall_mid_pos_y;

  xy_tensioner_wall_screw_spacing_y = xy_tensioner_wall_mid_pos_y*2+xy_tensioner_wall_narrow_depth;

  module main_body_profile(inset_by=0) {
    main_pos = [
      [left_pos_x+rounded_diam/2,front_pos_y+rounded_diam/2],
      [left_pos_x+rounded_diam/2,far_rear_pos_y-rounded_diam/2],
      [near_right_pos_x-rounded_diam/2,far_rear_pos_y-rounded_diam/2],
      [near_right_pos_x-rounded_diam/2,front_pos_y+rounded_diam/2],
    ];

    hull() {
      for(p=main_pos) {
        translate(p) {
          accurate_circle(rounded_diam-inset_by*2,resolution);
        }
      }
    }
  }

  module position_idlers() {
    translate([xy_belt_idler_rear_pos_x,xy_belt_idler_rear_pos_y,0]) {
      children();
    }
    translate([corner_pos_x,xy_belt_idler_rear_left_pos_y,0]) {
      children();
    }
  }

  module anchor_body_profile(inset_by=0) {
    anchor_pos = [
      [near_right_pos_x-rounded_diam/2,near_rear_pos_y-rounded_diam/2],
      [far_right_pos_x-rounded_diam/2,near_rear_pos_y-rounded_diam/2],
      [near_right_pos_x-rounded_diam/2,front_pos_y+rounded_diam/2],
    ];

    hull() {
      for(p=anchor_pos ) {
        translate(p) {
          accurate_circle(rounded_diam-inset_by*2,resolution);
        }
      }
      translate([corner_pos_x,xy_belt_idler_rear_left_pos_y,0]) {
        accurate_circle(xy_belt_idler_dist_from_end*2-inset_by*2,resolution);
      }
    }
  }

  module hole_profile() {
    translate([xy_motor_pos_x-xy_motor_adjust_range,xy_motor_pos_y,0]) {
      hull() {
        accurate_circle(xy_motor_hole_spacing-frame_screw_hole_meat_diam,resolution);
        translate([xy_motor_adjust_range,0,0]) {
          accurate_circle(xy_motor_hole_spacing-frame_screw_hole_meat_diam,resolution);
        }
      }
      for(x=[left,right],y=[front,rear]) {
        translate([x*xy_motor_hole_spacing/2,y*xy_motor_hole_spacing/2,0]) {
          hull() {
            accurate_circle(3.4,resolution);
            translate([xy_motor_adjust_range,0,0]) {
              accurate_circle(3.4,resolution);
            }
          }
        }
      }
    }
    translate([corner_pos_x,corner_pos_y,0]) {
      square([extrusion_side,extrusion_side],center=true);
      translate([-extrusion_side/2,extrusion_side/2,0]) {
        rotate([0,0,180]) {
          round_corner_filler_profile(rounded_diam);
        }
      }
      translate([extrusion_side/2,-extrusion_side/2,0]) {
        rotate([0,0,180]) {
          round_corner_filler_profile(rounded_diam);
        }
      }
      translate([-extrusion_side/2,-extrusion_side/2,0]) {
        hull() {
          accurate_circle(rounded_diam/2,resolution);
          translate([rounded_diam/2,rounded_diam/2,0]) {
            accurate_circle(rounded_diam,resolution);
          }
        }
      }
    }
    // xy_belt_idler_rear_pos_x = xy_motor_pos_x+xy_motor_side/2+xy_idler_od/2+1;
    translate([xy_belt_idler_rear_pos_x,xy_belt_idler_rear_pos_y,0]) {
      accurate_circle(3.4,resolution);
    }
    translate([corner_pos_x,xy_belt_idler_rear_left_pos_y,0]) {
      accurate_circle(3.4,resolution);
    }
  }

  module body() {
    hull() {
      linear_extrude(height=height,center=true,convexity=3) {
        main_body_profile(bevel_height);
      }
      linear_extrude(height=height-bevel_height*2,center=true,convexity=3) {
        main_body_profile(0);
      }
    }
    hull() {
      linear_extrude(height=height,center=true,convexity=3) {
        anchor_body_profile(bevel_height);
      }
      linear_extrude(height=height-bevel_height*2,center=true,convexity=3) {
        anchor_body_profile(0);
      }
    }
    position_idlers() {
      translate([0,0,height/2+xy_idler_post_bevel_height]) {
        bevel(xy_idler_post_od+xy_idler_post_bevel_height*2,xy_idler_post_od,xy_idler_post_bevel_height);
      }
    }

    frame_anchor_body_height = overall_height-height/2;
    translate([0,0,frame_anchor_body_height/2]) {
      frame_anchor_body_thickness = abs((xy_motor_pos_y-xy_motor_side/2)-front_pos_y);

      overall_width = abs(near_right_pos_x-left_pos_x);
      depth = frame_screw_hole_meat_diam/2+extrusion_side/2+xy_motor_space_in_front;
      translate([left_pos_x+overall_width/2,0,0]) {
        translate([0,front_pos_y+depth/2,0]) {
          rounded_cube(overall_width,depth,frame_anchor_body_height,rounded_diam);
        }
      }
    }

    translate([left_pos_x+xy_tensioner_wall_width/2,xy_motor_pos_y,height/2]) {
      wall_height = overall_height-height-screw_offset_wall_height;
      wall_offset_overall_depth = xy_tensioner_wall_max_pos_y*2+ab_pod_room_for_belts*2;
      if (screw_offset_wall_height > 0) {
        translate([0,xy_tensioner_wall_max_pos_y-wall_offset_overall_depth/2,screw_offset_wall_height/2-bevel_height]) {
          hull() {
            translate([-xy_tensioner_wall_width/4,0,0]) {
              rounded_cube(xy_tensioner_wall_width/2,wall_offset_overall_depth,screw_offset_wall_height+bevel_height*2,bevel_height*2,6);
            }
            translate([xy_tensioner_wall_width/4,0,0]) {
              rounded_cube(xy_tensioner_wall_width/2,wall_offset_overall_depth,screw_offset_wall_height+bevel_height*2,rounded_diam);
            }
          }
        }
      }
      translate([0,0,screw_offset_wall_height]) {
        for(y=[front,rear]) {
          hull() {
            translate([0,y*(xy_tensioner_wall_max_pos_y-xy_tensioner_wall_wide_depth/2),-1-bevel_height]) {
              translate([-xy_tensioner_wall_width/4,0,0]) {
                rounded_cube(xy_tensioner_wall_width/2,xy_tensioner_wall_wide_depth,2,bevel_height*2,6);
              }
              translate([xy_tensioner_wall_width/4,0,0]) {
                rounded_cube(xy_tensioner_wall_width/2,xy_tensioner_wall_wide_depth,2,rounded_diam);
              }
            }
            translate([0,y*(xy_tensioner_wall_max_pos_y-xy_tensioner_wall_narrow_depth/2),wall_height/2]) {
              translate([-xy_tensioner_wall_width/4,0,0]) {
                rounded_cube(xy_tensioner_wall_width/2,xy_tensioner_wall_narrow_depth,wall_height,bevel_height*2,6);
              }
              translate([xy_tensioner_wall_width/4,0,0]) {
                rounded_cube(xy_tensioner_wall_width/2,xy_tensioner_wall_narrow_depth,wall_height,rounded_diam);
              }
            }
          }
        }
      }
      translate([0,front*xy_tensioner_wall_max_pos_y-ab_pod_room_for_belts,screw_offset_wall_height+wall_height/2-1]) {
        rounded_cube(xy_tensioner_wall_width,xy_tensioner_wall_narrow_depth*2-0.1+ab_pod_room_for_belts*2,wall_height+2,rounded_diam);
      }
      /*
      hull() {
        translate([0,far_rear_pos_y-ab_pod_room_for_belts-rounded_diam/2,0]) {
          rounded_square(xy_tensioner_wall_width-inset_by,rounded_diam-inset_by,rounded_diam-inset_by);
        }
        translate([0,rear_support_pos_y,0]) {
          rounded_square(xy_tensioner_wall_width-inset_by,rounded_diam-inset_by,rounded_diam-inset_by);
        }
      }
      */
    }
  }

  module holes() {
    linear_extrude(height=height*3,center=true,convexity=3) {
      // hole_profile();
    }

    translate([0,0,height/2*bottom+overall_height/2]) {
      // frame mounting
      translate([0,rear_support_pos_y,0]) {
        first = left_pos_x + frame_screw_hole_meat_diam;
        last = near_right_pos_x - frame_screw_hole_meat_diam;
        dist_total = abs(last - first);
        num_screws = 4;
        dist_between = dist_total/(num_screws-1);

        for(i=[0:num_screws-1]) {
          translate([first+dist_between*i,0,0]) {
            bevel_through_hole(frame_screw_hole_diam,overall_height,bevel_height);
          }
        }
      }

      // adjust screw wall
      translate([left_pos_x+xy_tensioner_wall_width/2,xy_motor_pos_y,0]) {
        for(y=[front,rear]) {
          translate([0,y*xy_tensioner_wall_screw_spacing_y/2,0]) {
            bevel_through_hole(frame_screw_hole_diam,overall_height,bevel_height);
          }
        }
      }
    }

    // motor holes
    translate([xy_motor_pos_x-xy_motor_adjust_range,xy_motor_pos_y,0]) {
      shoulder_clearance = NEMA_boss_radius(xy_motor)*2+0.3;
      hull() {
        hole(shoulder_clearance,height,resolution);
        translate([xy_motor_adjust_range,0,0]) {
          hole(shoulder_clearance,height,resolution);
        }
      }
      for(z=[top,bottom]) {
        mirror([0,0,z-1]) {
          translate([0,0,height/2]) {
            hull() {
              bevel_hole(shoulder_clearance,bevel_height);
              translate([xy_motor_adjust_range,0,0]) {
                bevel_hole(shoulder_clearance,bevel_height);
              }
            }
          }
        }
      }
      for(x=[left,right],y=[front,rear]) {
        translate([x*xy_motor_hole_spacing/2,y*xy_motor_hole_spacing/2,0]) {
          hull() {
            hole(3.4,height,resolution);
            translate([xy_motor_adjust_range,0,0]) {
              hole(3.4,height,resolution);
            }
          }
          for(z=[top,bottom]) {
            mirror([0,0,z-1]) {
              translate([0,0,height/2]) {
                hull() {
                  bevel_hole(3.4,bevel_height);
                  translate([xy_motor_adjust_range,0,0]) {
                    bevel_hole(3.4,bevel_height);
                  }
                }
              }
            }
          }
        }
      }
    }

    // idler holes
    position_idlers() {
      translate([0,0,height/2*bottom]) {
        hole(xy_idler_post_id,height*3,resolution);
        bevel_hole(xy_idler_post_id,bevel_height);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}
