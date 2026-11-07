include <lumpyscad/lib.scad>; 
include <NopSCADlib/lib.scad>;
include <./main.scad>;

psu_clamp_screw_area_width = 10;

//pi_type = RPI0;
//pi_type = RPI3A;
//pi_type = RPI3;
pi_type = RPI4;

ssr_height = 27.9;
ssr_width = 12.7;
ssr_depth = 29;

tolerance = 0.5;

psu_cavity_width = psu_width+tolerance;
psu_cavity_height = psu_height+tolerance;
psu_mount_wall_thickness = 2;
psu_air_gap = 4;
//crossbar_pos_x = -rear_z_offset_x+extrusion_side+15;
crossbar_pos_x = 0;
//crossbar_pos_y = -25;
//crossbar_pos_y = extrusion_main_length/2 - 45 - extrusion_side/2;
crossbar_pos_y = 45;
//crossbar_pos_z = -extrusion_side/2;
crossbar_pos_z = - skirt_height + psu_air_gap + psu_height + tolerance + psu_mount_wall_thickness + extrusion_side/2;


pi_width = pcb_width(pi_type);
pi_length = pcb_length(pi_type);
pi_height = 20;
pi_hole_spacing_x = 58;
pi_hole_spacing_y = 49;
pi_holes_offset_x = -pi_length/2+3.5+pi_hole_spacing_x/2;
pi_offset_x = -9;
pi_offset_y = 8;
pi_pos_y = pi_offset_y + pi_width/2;
pi_pcb_thickness = pcb_thickness(pi_type);

//mcu_type = BTT_SKR_V1_4_TURBO;
mcu_type = MELLOW_FLY_D5;
mcu_width = pcb_width(mcu_type);
mcu_length = pcb_length(mcu_type);

psu_mount_overall_width = psu_cavity_width+psu_mount_wall_thickness*2;
psu_mount_overall_height = psu_cavity_height+psu_mount_wall_thickness*2;
psu_mount_screw_body_diam = (psu_pos_z-psu_height/2+psu_mount_overall_height/2-extrusion_side/2)*2;

pcb_mount_thickness = 5;
pcb_pos_z = extrusion_side - deck_plate_thickness - pcb_mount_thickness;

deck_plate_screw_hole_diam = 3.2;
deck_plate_screw_area_x = 185;
deck_plate_screw_area_y = 150;
deck_plate_screw_area_y_bias = -20;
deck_plate_screws_across_y = 5;
deck_plate_screws_across_x = 4;
deck_plate_screw_spacing_x = deck_plate_screw_area_x/(deck_plate_screws_across_x-1);
deck_plate_screw_spacing_y = deck_plate_screw_area_y/(deck_plate_screws_across_y-1);
deck_plate_screw_min_x = -deck_plate_screw_area_x/2;
deck_plate_screw_min_y = deck_plate_screw_area_y_bias + extrusion_main_length/2 - deck_plate_screw_area_y;

// TODO:
// * rpi mount
// * psu mount
// * mcu mount
// * SSR mount

module mock_ssr() { // ED24D3 3A, from dimensions on https://www.sensata.com/sites/default/files/a/sensata-ed-series-ac-output-plug-in-ssr-datasheet.pdf
  spade_width = 4.8;
  spade_thickness = 0.5;
  spade_length = 5.1;

  front_spade_spacing = 7.6;
  rear_spade_spacing = 5.3;

  latch_from_bottom = 20.8;
  latch_width = 3;
  latch_depth = 2.5;
  latch_spacing = 9.9-latch_width;

  color("#777") {
    cube([ssr_width,ssr_depth,ssr_height],center=true);

    translate([0,-ssr_depth/2,-ssr_height/2+latch_from_bottom]) {
      for(x=[left,right]) {
        translate([x*(latch_spacing/2),0,0]) {
          hull() {
            translate([0,0,-0.5]) {
              cube([latch_width,latch_depth*2,1],center=true);
            }
            translate([0,1,-2.5/2-0.5]) {
              cube([latch_width,2,2.5+0.5],center=true);
            }
          }
        }
      }
    }
  }

  translate([front_spade_spacing/2,-ssr_depth/2+spade_width,ssr_height/2]) {
    color("lightgreen") hole(2.5,2,resolution);
  }

  translate([0,-ssr_depth/2+2+spade_width/2,-ssr_height/2]) {
    for(x=[left,right]) {
      translate([x*(front_spade_spacing/2),0,0]) {
        color("silver") cube([spade_thickness,spade_width,spade_length*2],center=true);
      }
    }
  }

  translate([0,ssr_depth/2-2,-ssr_height/2]) {
    for(y=[0,-1]) {
      translate([0,y*rear_spade_spacing,0]) {
        color("silver") cube([spade_width,spade_thickness,spade_length*2],center=true);
      }
    }
  }
}

module position_ssr() {
  translate([0,0,0]) {
    rotate([0,0,0]) {
      children();
    }
  }
}

module pi_crossbar_mount() {
  component_clearance = 7;
  screw_post_diam = 5;
  screw_hole_diam = 2.5;
  mount_cross_height = 7;
  screw_post_height = component_clearance + mount_cross_height;
  rounded_diam = 1;

  available_overall_depth = extrusion_main_length/2 + crossbar_pos_y - extrusion_side/2;

  module position_mounting_holes() {
    translate([0,pi_pos_y,-pi_pcb_thickness]) {
      for(y=[front,rear]) {
        translate([0,y*(pi_hole_spacing_y/2),0]) {
          children();
        }
      }
    }
  }

  module body() {
    position_mounting_holes() {
      translate([0,0,-screw_post_height/2]) {
        rotate([0,90,0]) {
          rounded_cube(screw_post_height,screw_post_diam,screw_post_diam,rounded_diam);
        }
      }
    }
    translate([0,available_overall_depth/2,- pi_pcb_thickness - component_clearance - mount_cross_height/2]) {
      rotate([0,90,0]) {
        rounded_cube(mount_cross_height,available_overall_depth,screw_post_diam,rounded_diam);
      }
    }
  }

  module holes() {
    position_mounting_holes() {
      translate([0,0,1-30/2]) {
        hole(screw_hole_diam,30,8);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

function deck_plate_screw_hole_pos(x,y) = [
  deck_plate_screw_min_x+x*deck_plate_screw_spacing_x,
  deck_plate_screw_min_y+y*deck_plate_screw_spacing_y,
  //extrusion_side - deck_plate_thickness,
  0,
];

module pi_mount() {
  spanner_height = pcb_mount_thickness/2;
  spanner_width = 3;
  post_height = pcb_mount_thickness;

  pi_hole_diam = 2.5;
  pi_post_diam = pi_hole_diam + spanner_width;

  deck_hole_diam = 2.9;
  deck_post_diam = deck_hole_diam + spanner_width;

  module position_deck_plate_hole(i) {
    positions = [
      // clockwise from front left
      deck_plate_screw_hole_pos(0,3),
      deck_plate_screw_hole_pos(0,4),
      deck_plate_screw_hole_pos(1,4),
      deck_plate_screw_hole_pos(1,3),
    ];

    translate(positions[i]) {
      children();
    }
  }

  module pi_post() {
    hull() {
    }
  }

  module deck_post() {
    hull() {
    }
  }

  module position_pi_hole(i) {
    center_x = -pi_length/2+3.5+pi_hole_spacing_x/2;
    center_y = 0;
    positions = [
      // clockwise from front left
      [center_x+pi_hole_spacing_x/2,pi_hole_spacing_y/2],
      [center_x-pi_hole_spacing_x/2,pi_hole_spacing_y/2],
      [center_x-pi_hole_spacing_x/2,-pi_hole_spacing_y/2],
      [center_x+pi_hole_spacing_x/2,-pi_hole_spacing_y/2],
    ];
    position_pi() {
      translate(positions[i]) {
        children();
      }
    }
  }

  module position_pi() {
    translate([-extrusion_main_length/2+pi_width/2+10,extrusion_main_length/2-pi_length/2-3,0]) {
      rotate([0,0,90]) {
        rotate([0,180,0]) {
          children();
        }
      }
    }
  }
  
  translate([0,0,pcb_pos_z]) {
    position_pi() {
      % pcb(pi_type);
    }
  }

  module body() {
    translate([0,0,pcb_pos_z+pcb_mount_thickness]) {
      translate([0,0,-post_height/2]) {
        for(i=[0:3]) {
          position_deck_plate_hole(i) {
            hole(deck_post_diam,post_height,resolution);
          }
          position_pi_hole(i) {
            hole(pi_post_diam,post_height,resolution);
          }
        }
      }

      translate([0,0,-spanner_height/2]) {
        for(i=[0:3]) {
          hull() {
            position_deck_plate_hole(i) {
              hole(spanner_width,spanner_height,resolution);
            }
            position_pi_hole(i) {
              hole(spanner_width,spanner_height,resolution);
            }
          }
        }
        hull() {
          position_pi_hole(0) {
            hole(spanner_width,spanner_height,resolution);
          }
          position_pi_hole(3) {
            hole(spanner_width,spanner_height,resolution);
          }
        }

        hull() {
          position_pi_hole(2) {
            hole(spanner_width,spanner_height,resolution);
          }
          position_pi_hole(1) {
            hole(spanner_width,spanner_height,resolution);
          }
        }

        hull() {
          position_deck_plate_hole(0) {
            hole(spanner_width,spanner_height,resolution);
          }
          position_deck_plate_hole(1) {
            hole(spanner_width,spanner_height,resolution);
          }
        }

        hull() {
          position_deck_plate_hole(2) {
            hole(spanner_width,spanner_height,resolution);
          }
          position_deck_plate_hole(3) {
            hole(spanner_width,spanner_height,resolution);
          }
        }
      }
    }
  }

  module holes() {
    for(i=[0:3]) {
      position_deck_plate_hole(i) {
        hole(deck_hole_diam,100,resolution);
      }
      position_pi_hole(i) {
        hole(pi_hole_diam,100,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module mcu_mount() {
  module position_mcu() {
    translate([25,-30,0]) {
      rotate([0,0,0]) {
        rotate([0,180,0]) {
          children();
        }
      }
    }
  }

  translate([0,0,pcb_pos_z]) {
    position_mcu() {
      % pcb(mcu_type);
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

module position_psu() {
  // on the very bottom
  union() {
    translate([psu_pos_x,psu_pos_y,psu_pos_z]) {
      rotate([0,0,180]) {
        rotate([0,0,0]) {
          children();
        }
      }
    }
  }
}


module fan_5015() {
  translate([0,0,-15/2]) {
    x_adjust = -44.25;
    y_adjust = 5.4;
    z_adjust = 100+15/2-0.44;
    translate([0,0,15]) {
      //import("5015_Blower_Fan.stl", convexity=0);
    }
    translate([x_adjust,y_adjust,z_adjust]) {
      import("external/Radial_Fan_50x15 v8.stl", convexity=2);
      //import("external/5015_Blower_Fan.stl", convexity=2);
    }
  }
}
 
module fan_4010() {
  module body() {
    cube([40,40,10],center=true);
  }

  module holes() {
    opening_offset = 6;
    translate([-2,opening_offset/2,0]) {
      //cube([40,26,10-4],center=true);
      cube([40,26-opening_offset,10-4],center=true);
    }

    translate([-1,-4,2]) {
      hole(25,10,resolution);
    }

    for(x=[left,right],y=[front,rear]) {
      mirror([x-1,y-1,0]) {
        translate([40/2,40/2,2]) {
          translate([-2.5,-2.5,0]) {
            hole(2,30,resolution);
          }
          rounded_cube(10,10,10,4);
        }
      }
    }
  }

  color("#333") difference() {
    body();
    holes();
  }
}

module fan_4020() {
  // 52.82 - 46.16
  // 3.33
  //translate([0,0,7]) {
  //translate([0,0,-12.5]) {
  fan_height = 20;
  translate([0,0,fan_height/2]) {
    x_adjust = 0;
    y_adjust = 0;
    z_adjust = 0;
    translate([x_adjust,y_adjust,z_adjust]) {
      import("external/turbo_fan_35x18.stl", convexity=2);
    }
  }
}

module deck_plate_screw_holes() {
  difference() {
    union() {
      for(x=[0:deck_plate_screws_across_x-1]) {
        for(y=[0:deck_plate_screws_across_y-1]) {
          translate([deck_plate_screw_min_x+x*deck_plate_screw_spacing_x,deck_plate_screw_min_y+y*deck_plate_screw_spacing_y,0]) {
            accurate_circle(deck_plate_screw_hole_diam, resolution);
          }
        }
      }
    }

    translate([0,deck_plate_screw_min_y+deck_plate_screw_spacing_y,0]) {
      // square([deck_plate_screw_spacing_x*2,deck_plate_screw_spacing_y],center=true);
    }
  }
}

module deck_plate_profile() {
  tolerance = 0.8;

  rounded_diam = 5;
  internal_side = extrusion_main_length - 2*tolerance;

  module body() {
    rounded_square(internal_side,internal_side,rounded_diam);
  }

  module holes() {
    deck_plate_screw_holes();

    // large enough to pass a stepper motor plug through
    hole_opening_width = 10+tolerance;
    hole_opening_depth = 8+tolerance;
    stepper_opening_tolerance = tolerance*2;
    stepper_opening_rounded_diam = 10;
    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        // front leadscrew steppers
        width = 2*(z_motor_mount_leadscrew_inside_extrusion_width+extrusion_side/2+stepper_opening_tolerance);
        depth = 2*(z_motor_mount_leadscrew_inside_extrusion_depth+extrusion_side/2+stepper_opening_tolerance);
        translate([extrusion_vertical_spacing_x/2,-extrusion_vertical_spacing_y/2,0]) {
          rounded_square(width,depth,stepper_opening_rounded_diam);

          translate([-width/2,extrusion_side/2+tolerance,0]) {
            rotate([0,0,90]) {
              round_corner_filler_profile(rounded_diam);
            }
          }
          translate([-extrusion_side/2-tolerance,depth/2,0]) {
            rotate([0,0,90]) {
              round_corner_filler_profile(rounded_diam);
            }
          }
        }

        // A/B stepper cables
        translate([extrusion_vertical_spacing_x/2-extrusion_side/2,extrusion_vertical_spacing_y/2-extrusion_side/2,0]) {
          rounded_square(2*hole_opening_width,2*hole_opening_depth,rounded_diam);

          translate([-hole_opening_width,-tolerance,0]) {
            rotate([0,0,180]) {
              round_corner_filler_profile(rounded_diam);
            }
          }
          translate([-tolerance,-hole_opening_depth,0]) {
            rotate([0,0,180]) {
              round_corner_filler_profile(rounded_diam);
            }
            
          }
        }
      }
    }

    //translate([leadscrew_rear_motor_offset_x,extrusion_vertical_spacing_y/2-leadscrew_rear_motor_offset_y,0]) {
    translate([leadscrew_rear_motor_offset_x,extrusion_vertical_spacing_y/2,0]) {
      // rear leadscrew stepper
      stepper_opening_width = z_motor_mount_side+stepper_opening_tolerance*2;
      stepper_opening_depth = z_motor_mount_side/2+leadscrew_rear_motor_offset_y+stepper_opening_tolerance;
      overall_opening_width = z_motor_mount_side + 2*(floor_plate_lip_width+hole_opening_width);
      overall_opening_depth = extrusion_side/2+tolerance+hole_opening_depth;
      rounded_square(stepper_opening_width,2*stepper_opening_depth,stepper_opening_rounded_diam);

      // bed/umbilical cables
      rounded_square(overall_opening_width,2*overall_opening_depth,rounded_diam);
      for(x=[left,right]) {
        mirror([x-1,0,0]) {
          translate([overall_opening_width/2,-extrusion_side/2-tolerance,0]) {
            rotate([0,0,-90]) {
              round_corner_filler_profile(rounded_diam);
            }
          }
          translate([stepper_opening_width/2,-overall_opening_depth,0]) {
            rotate([0,0,-90]) {
              round_corner_filler_profile(rounded_diam);
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

module deck_plate_printed() {
  module body() {
    linear_extrude(height=deck_plate_thickness,center=true) {
      deck_plate_profile();
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module wago_333() {
  rotate([0,180,0]) {
    import("stl/wago-mount-333.stl", convexity=2);
  }
}

module wago_55() {
  rotate([0,180,0]) {
    import("stl/wago-mount-55.stl", convexity=2);
  }
}

module wago_555() {
  rotate([0,180,0]) {
    import("stl/wago-mount-555.stl", convexity=2);
  }
}

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
electronics_assembly();
position_z_modules(0);

module electronics_assembly() {
  //translate([extrusion_main_length/2,0,extrusion_side/2]) {
  translate([extrusion_main_length/2,30,extrusion_side/2]) {
    rotate([0,0,-90]) {
      wago_555();
    }
  }

  translate([0,-extrusion_main_length/2,extrusion_side/2]) {
    rotate([0,0,180]) {
      wago_55();
    }
  }

  // left side
  // translate([left*(extrusion_main_length/2-50-2),-5,extrusion_side - deck_plate_thickness - 2 - 15/2]) {
  translate([left*(extrusion_main_length/2-50-2-20),-50-9,psu_pos_z + psu_height + 3 + 15/2]) {
    rotate([0,0,-90]) {
      rotate([0,0,180]) {
        % color("#333") fan_5015();
      }
    }
  }

  translate([0,0,extrusion_side - deck_plate_thickness/2]) {
    # linear_extrude(height=deck_plate_thickness,center=true) {
      //deck_plate_screw_holes();
    }
  }

  position_psu() {
    psu(psu_type);
  }

  mcu_mount();
  pi_mount();
}
