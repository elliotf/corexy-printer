include <lumpyscad/lib.scad>; 
include <NopSCADlib/lib.scad>;
include <./main.scad>;

psu_clamp_screw_area_width = 10;

//pi_type = RPI0;
//pi_type = RPI3A;
pi_type = RPI3;
//pi_type = RPI4;

ssr_height = 27.9;
ssr_width = 12.7;
ssr_depth = 29;

psu_type = sizes[printer_size][ELECTRONICS][0];
nopscadlib_psu_length = psu_length(psu_type); // this seems to be incorrect; NopSCADlib has 152.5
psu_length = (psu_type == LRS_150_24) ? 159  : psu_length(psu_type);
psu_length_delta = psu_length-nopscadlib_psu_length;
psu_width = psu_width(psu_type);
psu_height = psu_height(psu_type);

tolerance = 0.5;
psu_cavity_width = psu_width+tolerance;
psu_cavity_height = psu_height+tolerance;
psu_mount_wall_thickness = 2;

psu_air_gap = 4;
//crossbar_pos_x = -rear_z_offset_x+extrusion_side+15;
crossbar_pos_x = 0;
//crossbar_pos_y = -25;
//crossbar_pos_y = extrusion_main_length/2 - 45 - extrusion_side/2;
crossbar_pos_y = 0;
//crossbar_pos_z = -extrusion_side/2;
crossbar_pos_z = - skirt_height + psu_air_gap + psu_height + tolerance + psu_mount_wall_thickness + extrusion_side/2;

psu_pos_x = -10;
psu_pos_y = 5;
psu_pos_z = crossbar_pos_z - extrusion_side/2 - tolerance/2 - psu_mount_wall_thickness;
//psu_pos_y = 0;
//psu_pos_z = - skirt_height;


pi_width = pcb_width(pi_type);
pi_length = pcb_length(pi_type);
pi_hole_spacing_x = 58;
pi_hole_spacing_y = 49;
pi_holes_offset_x = -pi_length/2+3.5+pi_hole_spacing_x/2;
pi_offset_x = -9;
pi_offset_y = 8;
pi_pos_y = pi_offset_y + pi_width/2;
pi_pcb_thickness = pcb_thickness(pi_type);

psu_mount_overall_width = psu_cavity_width+psu_mount_wall_thickness*2;
psu_mount_overall_height = psu_cavity_height+psu_mount_wall_thickness*2;
psu_mount_screw_body_diam = (psu_pos_z-psu_height/2+psu_mount_overall_height/2-extrusion_side/2)*2;

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

module pi_mount() {
  module position_pi() {
    translate([pi_offset_x,pi_pos_y,0]) {
      rotate([0,180,0]) {
        rotate([0,0,180]) {
          children();
        }
      }
    }
  }
  
  module position_mounting_brackets() {
    for(x=[left,right]) {
      translate([pi_offset_x+pi_holes_offset_x,0,0]) {
        mirror([x-1,0,0]) {
          translate([pi_hole_spacing_x/2,0,0]) {
            children();
          }
        }
      }
    }
  }

  position_pi() {
    //% pcb(pi_type);
  }

  position_mounting_brackets() {
    //pi_crossbar_mount();
    // debug_axes(1);
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

module position_pi_mount() {
  translate([0,-extrusion_main_length/2,extrusion_side/2]) {
  //translate([left*(extrusion_vertical_spacing_x/2-extrusion_side/2),rear*(extrusion_vertical_spacing_y/2-extrusion_side/2),extrusion_side/2]) {
    rotate([0,0,0]) {
      rotate([0,0,0]) {
        children();
      }
    }
  }
}

//mcu_type = BTT_SKR_V1_4_TURBO;
mcu_type = MELLOW_FLY_D5;

module mcu_mount() {
  module position_mcu() {
    translate([0,-4,-extrusion_side/2+4]) {
      rotate([0,0,0]) {
        //children();
      }
    }
  }

  position_mcu() {
    % pcb(mcu_type);
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

module position_mcu_mount() {
  translate([0,crossbar_pos_y-extrusion_side/2-pcb_width(mcu_type)/2,crossbar_pos_z]) {
    rotate([0,0,0]) {
      rotate([0,0,0]) {
        children();
      }
    }
  }
}

module position_psu() {
  // on the very bottom
  union() {
    translate([psu_pos_x,psu_pos_y,psu_pos_z]) {
      rotate([0,0,180]) {
        rotate([180,0,0]) {
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

module electronics_assembly() {
  translate([0,crossbar_pos_y,crossbar_pos_z]) {
    rotate([0,90,0]) {
      //% extrusion_l(extrusion_main_length);
    }
  }

  /*
  // right rear position
  translate([crossbar_pos_x + extrusion_side/2 - 2,15,crossbar_pos_z+extrusion_side/2+15/2]) {
    translate([0,0,0]) {
      rotate([0,0,90]) {
        rotate([180,0,0]) {
          % color("#333") fan_5015();
        }
      }
    }
  }
  */
  // left position
  //translate([- extrusion_main_length/2+50,45,crossbar_pos_z+extrusion_side/2+15/2]) {
  translate([- extrusion_main_length/2+50,crossbar_pos_y - extrusion_side/2 - 1,crossbar_pos_z+extrusion_side/2+15/2]) {
    translate([0,0,0]) {
      rotate([0,0,-90]) {
        rotate([180,0,0]) {
          //% color("#333") fan_5015();
        }
      }
    }
  }
  translate([crossbar_pos_x - extrusion_side/2 - 2 - 15/2 - 8, - extrusion_main_length/2 + 50,crossbar_pos_z + extrusion_side * 1.5]) {
    translate([0,0,0]) {
      rotate([0,-90,0]) {
        rotate([0,0,180]) {
          % color("#333") fan_5015();
        }
      }
    }
  }
  translate([crossbar_pos_x + extrusion_side/2 + 40/2,-25,crossbar_pos_z+extrusion_side/2+10/2]) {
    translate([0,40+1,0]) {
      rotate([180,0,0]) {
        //fan_4010();
      }
    }
    rotate([0,0,0]) {
      rotate([180,0,0]) {
        //fan_4010();
      }
    }
  }

  //mirror([1,0,0]) {
    //translate([rear_z_offset_x-extrusion_side-15,0,crossbar_pos_z]) {
    translate([crossbar_pos_x,crossbar_pos_y,crossbar_pos_z]) {
      rotate([0,90,0]) {
        //% extrusion_l(extrusion_main_length);
      }
    }
  //}
  crossbar_pos_x = rear_z_offset_x + extrusion_side * 2.5;
    translate([crossbar_pos_x,crossbar_pos_y,crossbar_pos_z]) {
      rotate([90,0,0]) {
        % extrusion_l(extrusion_main_length);
      }
    }

  // back left corner
  translate([- extrusion_main_length/2 + pi_width/2 + 1,extrusion_main_length/2- pi_length/2 - 5,extrusion_side-5]) {
    rotate([180,0,0]) {
      rotate([0,0,90]) {
        //% pcb(pi_type);
      }
    }
  }

  // figuring it out
  translate([- extrusion_main_length/2 + pi_width/2 + 1,extrusion_main_length/2- pi_length/2 - 5,extrusion_side-5]) {
    rotate([180,0,0]) {
      rotate([0,0,90]) {
        //% pcb(pi_type);
      }
    }
  }

  // angled at the front
  translate([10,-extrusion_main_length/2 + extrusion_side,- skirt_height + 5]) {
    rotate([-45,0,0]) {
      translate([0,0,pcb_width(pi_type)/2]) {
        rotate([90,0,0]) {
          rotate([0,0,180]) {
            //% pcb(pi_type);
          }
        }
      }
    }
  }

  // behind crossbar
  translate([-extrusion_main_length/2+50+15+pcb_length(mcu_type)/2,20,crossbar_pos_z-extrusion_side/2+2]) {
    rotate([0,0,0]) {
      rotate([0,0,180]) {
        //% pcb(mcu_type);
      }
    }
  }

  // in front of crossbar
  mcu_width = pcb_width(mcu_type);
  mcu_length = pcb_length(mcu_type);
  translate([-extrusion_main_length/2+50+10+pcb_length(mcu_type)/2,crossbar_pos_y - extrusion_side/2 - 2 - mcu_width/2,crossbar_pos_z-extrusion_side/2+2]) {
    rotate([0,0,0]) {
      rotate([0,0,180]) {
        //% pcb(mcu_type);
      }
    }
  }
  translate([crossbar_pos_x - extrusion_side/2 - 2 - mcu_width/2,-extrusion_main_length / 2 + 50 + mcu_length/2,crossbar_pos_z-extrusion_side/2+2]) {
    rotate([0,0,0]) {
      rotate([0,0,90]) {
        % pcb(mcu_type);
      }
    }
  }

  position_psu() {
    psu(psu_type);
  }

  position_mcu_mount() {
    mcu_mount();
  }

  position_pi_mount() {
    pi_mount();
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
