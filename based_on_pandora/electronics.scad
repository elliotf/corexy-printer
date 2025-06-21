include <lumpyscad/lib.scad>; 
include <NopSCADlib/lib.scad>;
include <./main.scad>;

psu_clamp_screw_area_width = 10;

//pi_type = RPI0;
//pi_type = RPI3A;
pi_type = RPI3;

module position_pi() {
  translate([left*(extrusion_main_length/2-pcb_width(pi_type)/2),20,-20]) {
    rotate([0,0,-90]) {
      rotate([180,0,0]) {
        children();
      }
    }
  }
}

//mcu_type = BTT_SKR_V1_4_TURBO;
mcu_type = MELLOW_FLY_D5;
module position_skr_e3_mini() {
  /*
  //mcu_type = BTT_SKR_MINI_E3_V2_0; // only four steppers, would need two
  mcu_type = BTT_SKR_MINI_E3_V2_0;
  translate([0,0,extrusion_side-psu_height-5]) {
    rotate([0,0,-90]) {
      rotate([180,0,0]) {
        % pcb(mcu_type);
      }
    }
  }
  */
}

module position_mcu() {
  // stacked below PSU
  translate([0,0,extrusion_side/2-psu_height]) {
    rotate([0,0,-90]) {
      rotate([180,0,0]) {
        children();
      }
    }
  }

  translate([right*(extrusion_vertical_spacing_x/2-extrusion_side/2-95/2),front*(20),extrusion_side/2-3-20/2]) {
    rotate([0,0,0]) {
      rotate([180,0,0]) {
        // beside front-to-back psu
        //children();
      }
    }
  }

  translate([left*(extrusion_vertical_spacing_x/2-extrusion_side/2-95/2),extrusion_vertical_spacing_y/2-extrusion_side/2-70/2,extrusion_side/2-3-20/2]) {
    rotate([0,0,0]) {
      rotate([180,0,0]) {
        // rear corner
        //children();
      }
    }
  }
}

psu_type = sizes[printer_size][ELECTRONICS][0];
nopscadlib_psu_length = psu_length(psu_type); // this seems to be incorrect; NopSCADlib has 152.5
psu_length = (psu_type == LRS_150_24) ? 159  : psu_length(psu_type);
psu_length_delta = psu_length-nopscadlib_psu_length;
psu_width = psu_width(psu_type);
psu_height = psu_height(psu_type);

tolerance = 0.5;
psu_hole_width = psu_width+tolerance;
psu_hole_height = psu_height+tolerance;
psu_mount_wall_thickness = 2;

// below the deck panel on a mount, facing right
psu_pos_x = left*(extrusion_vertical_spacing_x/2-extrusion_side/2-psu_length/2-4);
psu_pos_y = extrusion_vertical_spacing_y/2-extrusion_side-z_motor_side/2-psu_width/2-10;
psu_pos_z = extrusion_side-deck_panel_thickness-psu_mount_wall_thickness-tolerance;

psu_mount_overall_width = psu_hole_width+psu_mount_wall_thickness*2;
psu_mount_overall_height = psu_hole_height+psu_mount_wall_thickness*2;
//psu_mount_screw_body_diam = m3_head_diam+2;
psu_mount_screw_body_diam = (psu_pos_z-psu_height/2+psu_mount_overall_height/2-extrusion_side/2)*2;

module position_psu() {
  union() {
    // stuck to the bottom of the deck panel facing left
    pos_x = right*(extrusion_vertical_spacing_x/2-extrusion_side/2-psu_length/2-psu_mount_gap);
    pos_y = extrusion_vertical_spacing_y/2-extrusion_side-z_motor_side/2-psu_width/2-10;
    translate([pos_x,pos_y,extrusion_side-deck_panel_thickness]) {
      rotate([0,0,0]) {
        rotate([180,0,0]) {
          //children();
        }
      }
    }
  }

  union() {
    // stuck to the bottom of the deck panel facing right
    pos_x = left*(extrusion_vertical_spacing_x/2-extrusion_side/2-psu_length/2-psu_mount_gap);
    pos_y = extrusion_vertical_spacing_y/2-extrusion_side-z_motor_side/2-psu_width/2-10;
    translate([pos_x,pos_y,extrusion_side-deck_panel_thickness-2]) {
      rotate([0,0,180]) {
        rotate([180,0,0]) {
          //children();
        }
      }
    }
  }

  union() {
    translate([psu_pos_x,psu_pos_y,psu_pos_z]) {
      rotate([0,0,180]) {
        rotate([180,0,0]) {
          children();
        }
      }
    }
  }

  // on the very bottom
  translate([left*(extrusion_vertical_spacing_x/2-extrusion_side/2-psu_length/2-psu_mount_gap),-10,extrusion_side/2]) {
    rotate([0,0,0]) {
      rotate([180,0,0]) {
        //children();
      }
    }
  }
}

module position_psu_mount_holes() {
  for(y=[front,rear]) {
    translate([0,y*(psu_mount_overall_width/2+m3_head_diam/2+1),extrusion_side/2]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }
}

// PSU mount inspired by https://github.com/MasturMynd/Pandoras_Box/tree/main/Mods/BitwiseOperat0r/PS_LRS150-LM200_1515Mount

module psu_mount_clamp() {
  thickness = 2.4;
  width = psu_clamp_screw_area_width;
  narrow_by = 2;

  module body() {
    rounded_cube(psu_clamp_screw_area_width,psu_clamp_screw_area_width,thickness,psu_clamp_screw_area_width*0.2);
    translate([-width/2,0,0]) {
      rounded_cube(psu_clamp_screw_area_width,psu_clamp_screw_area_width-narrow_by*2,thickness,psu_clamp_screw_area_width*0.2);
    }
  }

  module holes() {
    hole(m3_through_hole_diam,10,resolution);
  }

  difference() {
    body();
    holes();
  }
}

module psu_mount_terminal_side() {
  psu_terminal_area_depth = 12;
  psu_lip_depth = 5;
  metal_lip_below_terminals = 1;

  mount_depth = extrusion_main_length/2-psu_length/2-psu_pos_x;
  sheet_metal_thickness = 2; // plenty of slack
  psu_mount_overall_depth = mount_depth+psu_terminal_area_depth+psu_lip_depth;
  psu_mount_overall_height = psu_mount_screw_body_diam;

  mounting_hole_from_end = 22;

  screw_retainer_hole_diam = 5; // plenty of wiggle room for now
  screw_retainer_bevel_height = psu_mount_wall_thickness;
  screw_retainer_bevel_small_od = screw_retainer_hole_diam+2; // plenty of wiggle room for now
  screw_retainer_bevel_large_od = screw_retainer_bevel_small_od+screw_retainer_bevel_height*2; // plenty of wiggle room for now

  module position_screw_retainers() {
    position_psu() {
      translate([-psu_length/2+mounting_hole_from_end,-psu_hole_width/2,psu_height/2]) {
        rotate([90,0,0]) {
          children();
        }
      }
    }
  }

  module body() {
    hull() {
      translate([extrusion_main_length/2-z_axis_screw_mount_thickness,psu_pos_y,0]) {
        position_psu_mount_holes() {
          hole(psu_mount_screw_body_diam,z_axis_screw_mount_thickness*2,resolution);
        }

        rounded_diam = psu_mount_screw_body_diam/2;
        translate([0,0,rounded_diam/2+2.3]) {
          rotate([0,90,0]) {
            rounded_cube(rounded_diam,psu_mount_overall_width,z_axis_screw_mount_thickness*2,rounded_diam);
          }
        }
      }
    }
    translate([extrusion_main_length/2,psu_pos_y,0]) {
      translate([-psu_mount_overall_depth/2,0,extrusion_side/2]) {
        rotate([0,90,0]) {
          cube([psu_mount_overall_height,psu_mount_overall_width,psu_mount_overall_depth],center=true);
        }
      }
    }
    position_screw_retainers() {
      translate([0,0,psu_mount_wall_thickness*2]) {
        rotate([0,0,0]) {
          bevel(screw_retainer_bevel_large_od,screw_retainer_bevel_small_od,psu_mount_wall_thickness);
        }
      }
    }
    hull() {
      position_screw_retainers() {
        translate([0,0,psu_mount_wall_thickness/2]) {
          hole(screw_retainer_bevel_large_od,psu_mount_wall_thickness,resolution);
        }
      }
      position_psu() {
        translate([-psu_length/2,-psu_hole_width/2-psu_mount_wall_thickness/2,-psu_mount_wall_thickness+psu_mount_screw_body_diam/2]) {
          cube([2*(psu_terminal_area_depth+psu_lip_depth),psu_mount_wall_thickness,psu_mount_screw_body_diam-1],center=true);
        }
      }
    }
  }

  module holes() {
    translate([extrusion_main_length/2-psu_mount_overall_depth,psu_pos_y,psu_pos_z-psu_height/2]) {
      translate([0,0,0]) {
        cube([(psu_lip_depth+psu_terminal_area_depth+tolerance*2)*2,psu_hole_width,psu_hole_height],center=true);
      }
      translate([0,0,-psu_hole_height/2-metal_lip_below_terminals]) {
        cube([100,psu_hole_width,psu_hole_height*2],center=true);
      }
    }
    translate([extrusion_main_length/2-z_axis_screw_mount_thickness,psu_pos_y,0]) {
      position_psu_mount_holes() {
        hole(m3_through_hole_diam,100,resolution);
        translate([0,0,-50]) {
          hole(m3_head_diam+0.5,100,resolution);
        }
      }
    }
    for(y=[front,rear]) {
      translate([psu_pos_x+psu_length/2+psu_clamp_screw_area_width/2,psu_pos_y+y*(psu_hole_width/2-psu_clamp_screw_area_width/2),psu_pos_z-metal_lip_below_terminals-2]) {
        hole(m3_thread_into_plastic_diam,100,resolution);

        rotate([0,0,0]) {
          % color("lightblue") psu_mount_clamp();
        }
      }
    }
    position_screw_retainers() {
      hole(screw_retainer_hole_diam,psu_hole_width,resolution);
    }
  }

  union() {
    translate([right*(extrusion_vertical_spacing_x/2-extrusion_side/2-22.3-2),psu_pos_y,12.2/2+extrusion_side/2-1.4]) {
      intersection() {
        cube([100,psu_hole_width+0.2,100],center=true);
        rotate([0,0,90]) {
          rotate([180,0,0]) {
            color("orange") import("../../Voron-2/STLs/Electronics_Bay/wago_221-415_mount_3by5.stl");
          }
        }
      }
    }
    difference() {
      body();
      holes();
    }
  }
}

module psu_mount_non_terminal_side(side=right) {
  psu_indent_depth = 5;
  psu_lip_depth = 5;

  mount_depth = extrusion_main_length/2-abs(psu_pos_x)-psu_length/2;
  ledge_depth = psu_indent_depth*2;
  ledge_height = 13;
  sheet_metal_thickness = 2; // plenty of slack
  psu_mount_overall_depth = mount_depth+ledge_depth;

  module body() {
    hull() {
      translate([-extrusion_main_length/2+z_axis_screw_mount_thickness/2,psu_pos_y,0]) {
        position_psu_mount_holes() {
          hole(psu_mount_screw_body_diam,z_axis_screw_mount_thickness,resolution);
        }
      }
    }
    translate([-extrusion_main_length/2,psu_pos_y,0]) {
      translate([psu_mount_overall_depth/2,0,psu_pos_z-psu_height/2]) {
        rotate([0,90,0]) {
          rounded_cube(psu_mount_overall_height,psu_mount_overall_width,psu_mount_overall_depth,2);
        }
      }
    }
  }

  module holes() {
    translate([-extrusion_main_length/2,psu_pos_y+(20*side),psu_pos_z-psu_height/2]) {
      cube([100,psu_mount_overall_width,100],center=true);
    }
    translate([-extrusion_main_length/2+psu_mount_overall_depth,psu_pos_y,psu_pos_z-psu_height/2]) {
      translate([0,0,0]) {
        cube([(psu_lip_depth+tolerance*2)*2,psu_hole_width,psu_hole_height],center=true);
      }
      translate([0,0,psu_hole_height/2-ledge_height/2]) {
        cube([ledge_depth*2+tolerance,psu_hole_width,ledge_height],center=true);
      }
      translate([0,front*psu_hole_width/2+sheet_metal_thickness/2,0]) {
        cube([ledge_depth*2+tolerance,sheet_metal_thickness,psu_hole_height],center=true);
      } 
    }
    translate([-extrusion_main_length/2+z_axis_screw_mount_thickness/2,psu_pos_y,0]) {
      position_psu_mount_holes() {
        hole(m3_through_hole_diam,100,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module electronics_assembly() {
  for(x=[left,right]) {
    psu_mount_non_terminal_side(x);
  }

  psu_mount_terminal_side();

  position_psu() {
    translate([0,0,psu_height(psu_type)/2]) {
      //% color("#ccc") cube([psu_length(psu_type),psu_width(psu_type),psu_height(psu_type)],center=true);
    }
    for(x=[left,right]) {
      translate([x*psu_length_delta/2,0,0]) {
        psu(psu_type);
      }
    }
    translate([0,0,psu_height/2]) {
      //color("#ccc",0.2) cube([psu_length,psu_width,psu_height],center=true);
    }
  }

  position_mcu() {
    //mcu_type = BTT_SKR_MINI_E3_V2_0; // only four steppers, would need two
    //% color("blue", 0.3) cube([90,64,20],center=true); // mellow fly d5
    % pcb(mcu_type);
  }

  position_pi() {
    % pcb(pi_type);
  }
}

electronics_assembly();
position_z_modules(0);

module minimal_frame_assembly() {
  for(z=[bottom_pos_z+extrusion_side/2]) {
  //for(z=[bottom_pos_z+extrusion_side/2]) {
    translate([0,0,z]) {
      for(x=[left,right]) {
        translate([x*extrusion_vertical_spacing_x/2,0,0]) {
          rotate([90,0,0]) {
            % extrusion_l(extrusion_main_length);
          }
        }
      }
      for(y=[front,rear]) {
        translate([0,y*extrusion_vertical_spacing_y/2,0]) {
          rotate([0,90,0]) {
            % extrusion_l(extrusion_main_length);
          }
        }
      }
    }
  }
  for(x=[left,right]) {
    for(y=[front]) {
      translate([x*(extrusion_vertical_spacing_x/2),y*(extrusion_vertical_spacing_y/2),extrusion_vertical_pos_z]) {
        //extrusion(extrusion_vertical_type,extrusion_vertical_length);
      }
    }
  }
  translate([rear_z_offset_x,extrusion_vertical_spacing_y/2-extrusion_side,bottom_pos_z+extrusion_main_length/2]) {
    extrusion(extrusion_main_type,extrusion_main_length);
  }
}
minimal_frame_assembly();
