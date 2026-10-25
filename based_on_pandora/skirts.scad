include <./main.scad>;
use <./z_axis.scad>;

//foot_hole_spacing = z_motor_side + 10;
foot_hole_spacing = max(leadscrew_base_motor_offset_x, leadscrew_base_motor_offset_y) + 1 + z_motor_side / 2;
skirt_lock_feature_length = 8;
foot_plate_thickness = 6;
over_extrusion_by = 0.5; // ensure we cover the sharp corner
foot_cover_side = ceil(extrusion_side / 2 + foot_hole_spacing + m3_head_diam / 2 + 1 + skirt_lock_feature_length); // 65*2 = 130, leaving 100mm side/front skirt, which fits well on the bed
gap_between = 0.4;
skirt_cover_side = extrusion_main_length + 2 * extrusion_side - 2 * (foot_cover_side + gap_between);
skirt_thickness = extrusion_side + over_extrusion_by;
skirt_wall_thickness = 3;

slot_filler_height = extrusion_slot_width - extrude_height*2;
slot_filler_length = foot_hole_spacing-20; // -20 to make room for t slot nuts
slot_filler_depth = 0.5;
top_skirt_hole_spacing = skirt_cover_side - 2 * (skirt_wall_thickness + m3_head_diam);

bottom_panel_side = 213;

panel_lip_height = 2;
panel_lip_depth = (extrusion_main_length+extrusion_side*2 - bottom_panel_side)/2 - panel_lip_height + over_extrusion_by - 0.5;

// TODO:
// * panel lip
// * panel mounting holes
// * skirt reinforcement

module interlock_feature(thickness = extrusion_side, shrink_by = 0) {
  rounded_diam = 10;

  flat_area = skirt_height * 0.4;
  large_flat_area = flat_area + skirt_lock_feature_length * 2;

  module body() {
    rotate([90, 0, 0]) {
      hull() {
        for (y = [front, rear]) {
          mirror([0, y - 1, 0]) {
            translate([-rounded_diam / 2, large_flat_area / 2 - rounded_diam / 2, 0]) {
              hole(rounded_diam - shrink_by * 2, thickness, resolution);
            }
            translate([skirt_lock_feature_length - rounded_diam / 2, flat_area / 2 - rounded_diam / 2, 0]) {
              hole(rounded_diam - shrink_by * 2, thickness, resolution);
            }
          }
        }
        /*
        translate([-rounded_diam/2+skirt_lock_feature_length,0,0]) {
          rounded_cube(rounded_diam,flat_area,thickness,rounded_diam,resolution);
        }
        translate([-rounded_diam/2,0,0]) {
          rounded_cube(rounded_diam,flat_area+skirt_lock_feature_length*2,thickness,rounded_diam,resolution);
        }
        */
      }
    }
  }

  module holes(){}

  difference() {
    body();
    holes();
  }
}

module skirt_holes() {
  for (x = [left, right]) {
    // top of skirt
    translate([x * (top_skirt_hole_spacing / 2), skirt_height / 2 - skirt_wall_thickness, 0]) {
      rotate([-90, 0, 0]) {
        hole(m3_through_hole_diam, skirt_height * 3, resolution);

        translate([0, 0, -10 / 2]) {
          hole(m3_head_diam, 10, resolution);
        }
      }
    }

    // skirt sides
    mirror([x - 1, 0, 0]) {
      translate([(skirt_cover_side / 2 - skirt_wall_thickness), -skirt_height / 2 + skirt_wall_thickness + 1 + m3_head_diam / 2, 0]) {
        rotate([0, 90, 0]) {
          hole(m3_through_hole_diam, wall_thickness * 5, resolution);

          translate([0, 0, -10 / 2]) {
            hole(m3_head_diam, 10, resolution);
          }
        }
      }
    }
  }
}

module skirt_blank(shrink_by = 0) {
  module body() {
    translate([0, 0, 0]) {
      rounded_cube(skirt_cover_side - shrink_by * 2, skirt_height - shrink_by * 2, skirt_thickness, over_extrusion_by * 2);

      for (x = [left, right]) {
        mirror([x - 1, 0, 0]) {
          translate([skirt_cover_side / 2, 0, 0]) {
            rotate([90, 0, 0]) {
              interlock_feature(skirt_thickness, shrink_by);
            }
          }
        }
      }
    }
  }

  module holes(){}

  difference() {
    body();
    holes();
  }
}

module skirt_mesh() {
  mesh_thickness = 3;

  module body() {
    translate([0, 0, over_extrusion_by / 2]) {
      skirt_blank();
    }

    slot_filler_length = top_skirt_hole_spacing-30; // -30 to leave room for t slot nuts
    translate([0,skirt_height/2,0]) {
      hull() {
        rotate([0,0,0]) {
          rounded_cube(slot_filler_length,slot_filler_depth*2,slot_filler_height-slot_filler_depth*2,slot_filler_depth);
        }
        translate([0,-slot_filler_depth/2,0]) {
          rotate([0,0,0]) {
            rounded_cube(slot_filler_length+slot_filler_depth*2,slot_filler_depth,slot_filler_height,slot_filler_depth);
          }
        }
      }
    }

    // panel retention lip
    translate([0,-skirt_height/2,skirt_thickness/2+over_extrusion_by/2]) {
      rounded_diam = over_extrusion_by*2;
      translate([0,0,-panel_lip_depth/2]) {
        hull() {
          rounded_cube(skirt_cover_side,panel_lip_height*2,panel_lip_depth,rounded_diam);

          translate([0,panel_lip_height/2,-panel_lip_height]) {
            rounded_cube(skirt_cover_side,panel_lip_height,panel_lip_depth,rounded_diam);
          }
        }
      }
    }
  }

  module holes() {
    translate([0, 0, over_extrusion_by / 2 + mesh_thickness]) {
      skirt_blank(skirt_wall_thickness);
    }

    skirt_holes();
  }

  difference() {
    body();
    holes();
  }
}

module skirt_plug_panel() {
  mesh_thickness = 3;

  tolerance = 0.4;

  plug_type = IEC_320_C14_switched_fused_inlet;
  plug_screw_diam = m3_thread_into_plastic_diam;

  plug_hole_width = iec_body_w(plug_type) + tolerance;
  plug_hole_height = iec_body_h(plug_type) + tolerance;

  skew_socket_to_side = 10;

  module plug_hole(height, swell_by = 0) {
    rounded_cube(plug_hole_width + swell_by * 2, plug_hole_height + swell_by * 2, height, (iec_body_r(plug_type) * 2) - tolerance + swell_by * 2);
  }

  module position_plug() {
    translate([skew_socket_to_side, 0, extrusion_side / 2 + over_extrusion_by / 2]) {
      rotate([0, 0, 0]) {
        rotate([0, 0, 180]) {
          children();
        }
      }
    }
  }

  module body() {
    translate([0, 0, over_extrusion_by / 2]) {
      difference() {
        skirt_blank();
        translate([0, 0, -mesh_thickness]) {
          skirt_blank(skirt_wall_thickness);
        }
      }
    }

    position_plug() {
      plug_wall_height = extrusion_side * 0.7;
      translate([0, 0, -plug_wall_height / 2]) {
        plug_hole(plug_wall_height, skirt_wall_thickness);

        hull() {
          iec_screw_positions(plug_type) {
            hole(plug_screw_diam + skirt_wall_thickness * 2, plug_wall_height, resolution);
          }
        }
      }
    }
  }

  module holes() {
    skirt_holes();
    position_plug() {
      %iec(plug_type);
      plug_hole(100);

      iec_screw_positions(plug_type) {
        hole(plug_screw_diam, 100, resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module skirt_plug_foot() {
  tolerance = 0.4;

  plug_type = IEC_320_C14_switched_fused_inlet;
  plug_screw_diam = m3_thread_into_plastic_diam;

  plug_hole_width = iec_body_w(plug_type) + tolerance;
  plug_hole_length = iec_body_h(plug_type) + tolerance;
  plug_wall_height = extrusion_side * 2;

  module plug_hole(height, swell_by = 0) {
    rounded_cube(plug_hole_width + swell_by * 2, plug_hole_length + swell_by * 2, height, (iec_body_r(plug_type) * 2) - tolerance + swell_by * 2);
  }

  module position_plug() {
    //translate([extrusion_side / 2 + over_extrusion_by, foot_cover_side / 2 - skirt_lock_feature_length, -skirt_height / 2]) {
    //translate([extrusion_side / 2 + over_extrusion_by, plug_hole_height/2, -skirt_height / 2]) {
    translate([extrusion_side / 2 + over_extrusion_by, foot_hole_spacing / 2 + 4, -skirt_height + plug_hole_length / 2 + skirt_wall_thickness]) {
      rotate([0, 90, 0]) {
        rotate([0, 0, 270]) {
          children();
        }
      }
    }
  }

  position_plug() {
    %iec(plug_type);
  }

  module body() {
    foot() {
      position_plug() {
        translate([0, 0, -plug_wall_height / 2]) {
          plug_hole(plug_wall_height, skirt_wall_thickness);

          hull() {
            iec_screw_positions(plug_type) {
              hole(plug_screw_diam + skirt_wall_thickness * 2, plug_wall_height, resolution);
            }
          }
        }
      }
    }
  }

  module holes() {
    position_plug() {
      length = plug_wall_height * 2 + 1;
      hull() {
        plug_hole(length, -4);
        plug_hole(length + 4);
      }

      iec_screw_positions(plug_type) {
        hole(plug_screw_diam, length, resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module psu_mount_base() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module psu_mount_terminal_end() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module psu_mount_non_terminal_end() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module foot() {
  overall_length = foot_cover_side + over_extrusion_by;

  foot_screw_area_thickness = 6;

  fat_panel_lip_depth = panel_lip_depth + panel_lip_height;

  dist_to_panel_hole_x = (extrusion_vertical_spacing_x/2 - bottom_panel_hole_spacing/2);
  dist_to_panel_hole_y = (extrusion_vertical_spacing_y/2 - bottom_panel_hole_spacing/2);

  module body() {
    difference() {
      union() {
        // front
        translate([extrusion_side / 2 + over_extrusion_by - overall_length / 2, -over_extrusion_by / 2, -skirt_height / 2]) {
          rotate([0, 90, 0]) {
            rounded_cube(skirt_height, extrusion_side + over_extrusion_by, overall_length, over_extrusion_by * 2);
          }
        }
        // side
        translate([over_extrusion_by / 2, -over_extrusion_by - extrusion_side / 2 + overall_length / 2, -skirt_height / 2]) {
          rotate([0, 0, 90]) {
            rotate([90, 0, 0]) {
              rounded_cube(overall_length, skirt_height, extrusion_side + over_extrusion_by, over_extrusion_by * 2);
            }
          }
        }
      }

      translate([leadscrew_base_motor_offset_x, leadscrew_base_motor_offset_y, 0]) {
        extra_room = 2;
        rounded_diam = z_motor_side - z_motor_hole_spacing + extra_room;
        hull() {
          rounded_cube(z_motor_side + extra_room, z_motor_side + extra_room, skirt_height * 3, rounded_diam);
          translate([-10, 10, 0]) {
            rounded_cube(z_motor_side + extra_room, z_motor_side + extra_room, skirt_height * 3, rounded_diam);
          }
        }
      }
    }

    // screw_foot bridge
    hull() {
      translate([0,0,- skirt_height + foot_screw_area_thickness/2]) {
        translate([extrusion_side/4,dist_to_panel_hole_y+extrusion_side/2,0]) {
          rotate([0,90,0]) {
            rounded_cube(foot_screw_area_thickness,2*dist_to_panel_hole_y,extrusion_side/2,over_extrusion_by*2);
          }
        }
        translate([-dist_to_panel_hole_x-extrusion_side/2,-extrusion_side/4,0]) {
          rotate([0,90,0]) {
            rounded_cube(foot_screw_area_thickness,extrusion_side/2,2*dist_to_panel_hole_y,over_extrusion_by*2);
          }
        }
      }
    }

    // extrusion slot alignment
    union() {
      translate([0,foot_hole_spacing/2,0]) {
        hull() {
          rotate([0,90,0]) {
            rounded_cube(slot_filler_depth*2,slot_filler_length,slot_filler_height-slot_filler_depth*2,slot_filler_depth);
          }
          translate([0,0,-slot_filler_depth/2]) {
            rotate([0,90,0]) {
              rounded_cube(slot_filler_depth,slot_filler_length+slot_filler_depth*2,slot_filler_height,slot_filler_depth);
            }
          }
        }
      }

      translate([-foot_hole_spacing/2,0,0]) {
        hull() {
          rotate([0,90,0]) {
            rounded_cube(slot_filler_depth*2,slot_filler_height-slot_filler_depth*2,slot_filler_length,slot_filler_depth);
          }
          translate([0,0,-slot_filler_depth/2]) {
            rotate([0,90,0]) {
              rounded_cube(slot_filler_depth,slot_filler_height,slot_filler_length+slot_filler_depth*2,slot_filler_depth);
            }
          }
        }
      }
    }

    // panel lip
    union() {
      // front
      translate([extrusion_side / 2 + over_extrusion_by - overall_length / 2, -extrusion_side/2-over_extrusion_by + fat_panel_lip_depth/2, -skirt_height]) {
        rotate([0, 90, 0]) {
          rounded_cube(panel_lip_height*2, fat_panel_lip_depth, overall_length, over_extrusion_by * 2);
        }
      }
      // side
      translate([extrusion_side/2 + over_extrusion_by - fat_panel_lip_depth/2, -over_extrusion_by - extrusion_side / 2 + overall_length / 2, -skirt_height]) {
        rotate([0, 0, 90]) {
          rotate([90, 0, 0]) {
            rounded_cube(overall_length, panel_lip_height*2, fat_panel_lip_depth, over_extrusion_by * 2);
          }
        }
      }
    }

    children();
  }

  module position_mounting_holes() {
    translate([0, 0, -foot_plate_thickness]) {
      children();
      translate([-foot_hole_spacing, 0, 0]) {
        children();
      }
      translate([0, foot_hole_spacing, 0]) {
        children();
      }
    }
  }

  module holes() {
    position_mounting_holes() {
      hole(m3_through_hole_diam, skirt_height * 2, resolution);

      translate([0, 0, -skirt_height]) {
        hole(m3_head_diam, skirt_height * 2, resolution);
      }
    }

    for (m = [0, 1]) {
      mirror([m, m, 0]) {
        translate([extrusion_side / 2 - foot_cover_side, 0, -skirt_height / 2]) {
          interlock_feature(extrusion_side * 2);
        }
      }
    }

    translate([-dist_to_panel_hole_x,dist_to_panel_hole_y,-skirt_height]) {
      hole(m3_threaded_insert_od,foot_screw_area_thickness*2+1,resolution);
    }
  }

  difference() {
    body() {
      children();
    }
    holes();
  }
}

module bottom_panel() {
  module body() {
    rounded_square(bottom_panel_side, bottom_panel_side, bottom_panel_rounded_diam);
  }

  module holes() {
    for (x = [left, right], y = [front, rear]) {
      translate([x * (bottom_panel_hole_spacing / 2), y * (bottom_panel_hole_spacing / 2), 0]) {
        accurate_circle(4, resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module skirt_assembly() {
  echo("foot_cover_side:  ", foot_cover_side);
  echo("skirt_cover_side: ", skirt_cover_side);

  for (x = [left, right], y = [front, rear]) {
    mirror([x - 1, 0, 0]) {
      mirror([0, y - 1, 0]) {
        if (x != 1 || y != -1) {
          translate([extrusion_vertical_spacing_x / 2, -extrusion_vertical_spacing_y / 2, 0]) {
            foot();
          }
        }
      }
    }
  }

  translate([extrusion_vertical_spacing_y / 2, 0, -skirt_height / 2]) {
    rotate([0, 0, 90]) {
      rotate([90, 0, 0]) {
        //skirt_plug_panel();
      }
    }
  }
  mirror([0, 1, 0]) {
    translate([extrusion_vertical_spacing_x / 2, -extrusion_vertical_spacing_y / 2, 0]) {
      skirt_plug_foot();
    }
  }

  for (r = [0, 90, -90, 180]) {
    rotate([0, 0, r]) {
      translate([0, -extrusion_vertical_spacing_y / 2, -skirt_height / 2]) {
        rotate([90, 0, 0]) {
          //skirt_mesh();
        }
      }
    }
  }

  translate([0, 0, -skirt_height - bottom_panel_thickness / 2]) {
    //color(frame_color, 0.2) {
    color(frame_color) {
      linear_extrude(height=bottom_panel_thickness, center=true) {
        //bottom_panel();
      }
    }
  }
}

//skirt_mesh();
//z_axis_assembly(10);
skirt_assembly();
//skirt_plug_foot();
//foot();
