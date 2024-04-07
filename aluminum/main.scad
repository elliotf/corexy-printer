use <NopSCADlib/lib.scad>;
include <config.scad>;
use <z-assembly.scad>;
use <toolhead.scad>;
use <v0-parts.scad>;
use <xy-gantry.scad>;
use <xy-tensioner.scad>;

// Ideas
//
// use DIN933 (hex-head bolt) for things
// * https://www.fasteners.eu/standards/DIN/933/
// * as a shaft with the head tucked into extrusion slot for tensioning Z axis belts

show_top = (0) ? true : false;

idler_stack_height = 33;

module assembly(pos_x=0, pos_y=0, pos_z=0) {
  //xy_belt_y_carriage_idler_outer_pos_y = 157.5-spar_main_len/2+xy_belt_idler_dist_from_end-build_volume_y+pos_y-extrusion_side;
  base_x_rail_pos = y_rail_pos_y-y_rail_length/2+carriage_length(yz_carriage_type)/2+pos_y+extrusion_side/2;
  old_xy_belt_y_carriage_idler_outer_pos_y = rear_support_pos_y-extrusion_side/2-13   -build_volume_y+pos_y+fudge_x_rail_back;
  xy_belt_y_carriage_idler_outer_pos_y = rear_support_pos_y-extrusion_side/2-13-build_volume_y+pos_y+fudge_x_rail_back;
  //xy_belt_y_carriage_idler_inner_pos_y = 146.12-spar_main_len/2+xy_belt_idler_dist_from_end-build_volume_y+pos_y-extrusion_side;
  //xy_belt_y_carriage_idler_inner_pos_y = rear_support_pos_y-extrusion_side/2-24.38-build_volume_y+pos_y+fudge_x_rail_back;
  old_xy_belt_y_carriage_idler_inner_pos_y = rear_support_pos_y-extrusion_side/2-24.38-build_volume_y+pos_y+fudge_x_rail_back;
  xy_belt_y_carriage_idler_inner_pos_y = base_x_rail_pos-extrusion_side/2;
  //xy_belt_x_carriage_anchor_pos_y = 152.3-spar_main_len/2+xy_belt_idler_dist_from_end-build_volume_y+pos_y-extrusion_side;
  //xy_belt_x_carriage_anchor_pos_y = rear_support_pos_y-extrusion_side/2-18.2-build_volume_y+pos_y+fudge_x_rail_back;
  xy_belt_x_carriage_anchor_pos_y = rear_support_pos_y-extrusion_side/2-16.2-build_volume_y+pos_y+fudge_x_rail_back;
  //x_carriage_pos_x = -build_volume_x/2+pos_x;
  x_carriage_pos_x = -x_rail_len/2+carriage_length(x_carriage_type)/2+pos_x;

  for(x=[left,right]) {
    for(y=[front,rear]) {
      translate([x*(corner_pos_x),y*(corner_pos_y),corner_pos_z]) {
        extrusion_makerbeam_xl(corner_extrusion_length);
      }
    }

    translate([x*corner_pos_x,0,0]) {
      if (show_top) {
        translate([0,0,top_pos_z]) {
          rotate([90,0,0]) {
            extrusion_makerbeam_xl(side_extrusion_length);
          }
        }
      }
      for(z=[bottom_pos_z,xy_pos_z]) {
        translate([0,0,z]) {
          rotate([90,0,0]) {
            extrusion_makerbeam_xl(side_extrusion_length);
          }
        }
      }
    }
  }

  position_z_assembly() {
    z_assembly(pos_z);
  }

  translate([0,rear_support_pos_y,0]) {
    translate([0,0,xy_pos_z]) {
      rotate([0,90,0]) {
        extrusion_makerbeam_xl(front_rear_extrusion_length);
      }
    }
    translate([0,0,bottom_pos_z]) {
      rotate([0,90,0]) {
        extrusion_makerbeam_xl(front_rear_extrusion_length);
      }
    }
  }

  if (show_top) {
    for(y=[front,rear]) {
      translate([0,y*corner_pos_y,top_pos_z]) {
        rotate([0,90,0]) {
          extrusion_makerbeam_xl(front_rear_extrusion_length);
        }
      }
    }
  }

  translate([0,front*corner_pos_y,bottom_pos_z]) {
    rotate([0,90,0]) {
      extrusion_makerbeam_xl(front_rear_extrusion_length);
    }
  }

  position_y_rails() {
    rotate([0,-90,0]) {
      rotate([0,0,90]) {
        rail(yz_rail_type,y_rail_length);
        //carriage(yz_carriage_type);
      }
    }
  }

  module belt_path(mirrored) {
    anchor_x = x_carriage_pos_x;
    heights = [xy_belt_lower_dist_from_extrusion,0,xy_belt_upper_dist_from_extrusion];
    start_anchor_x_for = [anchor_x+1,0,-anchor_x+1];
    end_anchor_x_for = [anchor_x-1,0,-anchor_x-1];

    diag_points = [
      [left*(xy_belt_idler_inner_pos_x),old_xy_belt_y_carriage_idler_inner_pos_y],
      [left*(xy_belt_idler_outer_pos_x),old_xy_belt_y_carriage_idler_outer_pos_y],
    ];
    for(p = diag_points) {
      translate(p) {
        % debug_axes(2);
      }
    }

    belt_points = [
      [start_anchor_x_for[mirrored],xy_belt_x_carriage_anchor_pos_y,0],
      [right*(xy_belt_idler_outer_pos_x),xy_belt_y_carriage_idler_outer_pos_y,f623_2x_idler],
      [right*(xy_belt_idler_outer_pos_x),rear*xy_belt_idler_rear_left_pos_y,f623_2x_idler],
      //[right*(xy_belt_idler_extra_pos_x),xy_belt_idler_extra_pos_y,f623_2x_idler], // corner cutting idler
      //[right*(xy_motor_pos_x),rear*(xy_motor_pos_y),GT2x16_pulley],
      //[right*(xy_belt_idler_rear_pos_x),rear*(spar_main_len/2+extrusion_side-xy_belt_idler_dist_from_end),f623_2x_idler], // 180deg return to opposite side
      //[left*(xy_belt_idler_rear_pos_x),rear*(spar_main_len/2+extrusion_side-xy_belt_idler_dist_from_end),f623_2x_idler],
      //[left*(xy_belt_idler_extra_pos_x),xy_belt_idler_extra_pos_y,f623_2x_idler], // corner cutting idler
      [left*(xy_belt_idler_outer_pos_x),rear*xy_belt_idler_rear_left_pos_y,f623_2x_idler],
      [left*(xy_belt_idler_outer_pos_x),front*(spar_main_len/2-xy_belt_idler_dist_from_end),f623_2x_idler], // front idler
      [left*(xy_belt_idler_inner_pos_x),xy_belt_y_carriage_idler_inner_pos_y,f623_2x_idler],
      [end_anchor_x_for[mirrored],xy_belt_x_carriage_anchor_pos_y,0],
    ];
    mirror([mirrored,0,0]) {
      translate([0,0,heights[mirrored]]) {
        belt(GT2x6, belt_points, belt_colour = grey(20), tooth_colour = "#795C34", open = true, twist = undef, auto_twist = false, start_twist = false);

        for(i = [1:len(belt_points)-2]) {
          p = belt_points[i];
          type = p[2];
          translate([p[x],p[y],0]) {
            pulley_assembly(type);
          }
        }
      }
    }

  }

  for(x=[left,right]) {
    // A == right motor == red
    // B == left motor == blue
    //colors = ["blue",0,"red"];
    translate([0,0,xy_pos_z+extrusion_side/2]) {
      //color(colors[x+1]) belt_path(x-1);
      belt_path(x+1);
    }
  }

  module position_x_axis() {
    translate([0,0,xy_pos_z]) {
      children();
    }
  }

  module x_carriage(carriage_type=false) {
    translate([0,-16.5,0]) {
      rotate([-90,0,0]) {
        rotate([0,0,90]) {
          translate([-149.287,-243.45,-29.326]) {
            import("voron-zero/STLs/X_Carriage_x1.stl");
          }
        }
      }
    }
    toolhead();
  }

  position_x_axis() {
    //translate([0,y_rail_pos_y+y_rail_length/2-carriage_length(yz_carriage_type)/2-build_volume_y+pos_y,0]) {
    translate([0,y_rail_pos_y-y_rail_length/2+carriage_length(yz_carriage_type)/2+pos_y,0]) {
      translate([0,fudge_x_rail_back+carriage_length(yz_carriage_type/2)-extrusion_side/2,carriage_width(yz_carriage_type)/2+x_extrusion_dist_from_y_extrusion_z]) {
        translate([0,0,extrusion_side/2]) {
          rotate([0,90,0]) {
            extrusion_makerbeam_xl(spar_main_len);
          }
        }
        translate([0,0,extrusion_side]) {
          rail(x_rail_type,x_rail_len);
          translate([x_carriage_pos_x,0,0]) {
            carriage(x_carriage_type);
            translate([0,0,carriage_height(x_carriage_type)]) {
              x_carriage();
            }
          }
        }
      }
      for(x=[left,right]) {
        mirror([x-1,0,0]) {
          translate([corner_pos_x-extrusion_side/2,0,0]) {
            //% debug_axes(5);

            rotate([0,-90,0]) {
              rotate([0,0,90]) {
                carriage(yz_carriage_type);
              }
            }
          }
        }
      }
      translate([0,0,0]) {
        translate([corner_pos_x-extrusion_side/2-carriage_height(yz_carriage_type),0,0]) {
          xy_carriage_right_upper();
          xy_carriage_right_lower();
        }
      }
    }
  }

  module position_y_rails() {
    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        //translate([corner_pos_x-extrusion_side/2,rear_support_pos_y/2-corner_pos_y/2,xy_pos_z]) {
        translate([corner_pos_x-extrusion_side/2,y_rail_pos_y,xy_pos_z]) {
          rotate([0,0,0]) {
            //% debug_axes(2);
            children();
          }
        }
      }
    }
  }

  module position_bed() {
    //y_pos = rear_support_pos_y-extrusion_side/2-carriage_height(yz_carriage_type)-carriage_width(yz_carriage_type)/2-extrusion_side/2;
    y_pos = rear_support_pos_y-extrusion_side/2-carriage_height(yz_carriage_type)+z_support_beam_rear_bed_offset_y;
    //fudge = 0;
    //y_pos = rear_support_pos_y-extrusion_side/2+fudge;
    //translate([0,y_pos,xy_pos_z-extrusion_side/2-build_volume_z]) {
    //translate([0,y_pos,z_rail_top_pos_z-carriage_length(yz_carriage_type)/2-pos_z]) {
    translate([0,y_pos,z_rail_top_pos_z-pos_z]) {
      children();
    }
  }

  position_bed() {
    plate_thickness = 6.150;
    translate([0,-build_volume_y/2+z_support_beam_rear_bed_offset_y+4.5,carriage_length(yz_carriage_type)/2-plate_thickness/2]) {
      color("#777") difference() {
        cube([build_volume_x,build_volume_y,plate_thickness],center=true);

        translate([0,build_volume_y/2-5,0]) {
          hole(3,plate_thickness+1,resolution);
        }
        for(x=[left,right]) {
          translate([x*(build_volume_x/2-5),front*(build_volume_y/2-5),0]) {
            hole(3,plate_thickness+1,resolution);
          }
        }
      }
    }

    depth_rail_offset_y = 0;
    // adjust more for build plate, etc

    translate([0,-spar_bed_depth_len,-extrusion_side/2]) {
      translate([0,spar_bed_depth_len/2-z_support_beam_rear_bed_offset_y/2,0]) {
        rotate([90,0,0]) {
          extrusion_makerbeam_xl(spar_bed_depth_len);
        }
      }
      translate([0,-extrusion_side/2,0]) {
        rotate([0,90,0]) {
          extrusion_makerbeam_xl(spar_bed_across_len);
        }
      }
    }
  }

  module position_build_volume() {
    //translate([0,front*corner_pos_y+extrusion_side/2+build_volume_y/2+15,xy_pos_z-extrusion_side/2-build_volume_z/2]) {
    translate([0,front*corner_pos_y+extrusion_side/2+build_volume_y/2+15,z_rail_top_pos_z+build_volume_z/2-pos_z]) {
      children();
    }
    //translate([0,(front*corner_pos_y+rear_support_pos_y)/2-10,xy_pos_z-extrusion_side/2-build_volume_z/2]) {
    //translate([0,(front*corner_pos_y)+build_volume_y/2+21,xy_pos_z-extrusion_side/2-build_volume_z/2]) {
    //position_bed() {
    //  translate([0,-build_volume_y/2-extrusion_side-10,build_volume_z/2]) {
    //    children();
    //  }
    //}
  }

  psu_type = LRS_150_24;
  module position_psu() {
    psu_center_z = psu_length(psu_type)/2;
    // vertically
    //translate([-spar_main_len/2+5+psu_width(psu_type)/2,rear_support_pos_y+extrusion_side/2+3,bottom_pos_z+psu_center_z]) {
    //  rotate([-90,0,0]) {
    // horizontally
    /*
    */
    translate([-spar_main_len/2+4+psu_width(psu_type)/2,rear_support_pos_y+extrusion_side/2+3,bottom_pos_z+psu_center_z]) {
      rotate([-90,0,0]) {
        rotate([0,0,-90]) {
          children();
        }
      }
    }
    translate([-spar_main_len/2+psu_width(psu_type)/2,spar_main_len/2-psu_length(psu_type)/2,bottom_pos_z-extrusion_side/2]) {
      rotate([0,0,-90]) {
        rotate([180,0,0]) {
          //children();
        }
      }
    }
  }

  position_psu() {
    psu(psu_type);
  }

  module position_mcu() {
    //translate([-spar_main_len/2+mcu_breathing_room+pcb_length(BTT_SKR_V1_4_TURBO)/2,corner_pos_y-mcu_breathing_room-pcb_length(BTT_SKR_V1_4_TURBO)/2,bottom_pos_z-extrusion_side/2-5]) {
    //mcu_breathing_room = 0;
    mcu_breathing_room = 5;
    mcu_type = BTT_SKR_V1_4_TURBO;
    translate([-spar_main_len/2+mcu_breathing_room+pcb_width(mcu_type)/2,rear_support_pos_y-extrusion_side/2-mcu_breathing_room-pcb_length(mcu_type)/2,bottom_pos_z-extrusion_side/2]) {
      rotate([0,0,90]) {
        rotate([0,180,0]) {
          //children();
        }
      }
    }
    // bottom front
    translate([0,front*corner_pos_y+pcb_length(mcu_type)/2,bottom_pos_z-extrusion_side/2]) {
      rotate([0,0,90]) {
        rotate([0,180,0]) {
          children();
        }
      }
    }
    translate([corner_pos_x-extrusion_side/2-pcb_width(mcu_type)/2,rear_support_pos_y+extrusion_side/2+3,bottom_pos_z+extrusion_side/2+pcb_length(mcu_type)/2+20]) {
      rotate([-90,0,0]) {
        rotate([0,0,-90]) {
          children();
        }
      }
    }
  }

  position_mcu() {
    % pcb(BTT_SKR_V1_4_TURBO);
  }

  module position_z_assembly() {
    mirror([1,0,0]) {
      translate([z_support_beam_rear_x_offset,rear_support_pos_y,0]) {
        children();
      }
    }

    mirrored = 1;
    if (mirrored) {
      // mirrored
      for(x=[left,right]) {
        mirror([x-1,0,0]) {
          translate([corner_pos_x,z_support_side_pos_y,0]) {
            mirror([0,1,0]) {
              rotate([0,0,-90]) {
                //translate([z_support_beam_side_x_offset,0,0]) {
                translate([0,0,0]) {
                  children();
                }
              }
            }
          }
        }
      }
    } else {
      // rotational
      for(x=[left,right]) {
        translate([x*corner_pos_x,z_support_side_pos_y,0]) {
          rotate([0,0,x*-90]) {
            children();
          }
        }
      }
    }
  }

  module position_ab_motor(x_offset,z_offset=0) {
    translate([xy_motor_pos_x-x_offset,xy_motor_pos_y,xy_pos_z+extrusion_side/2+z_offset]) {
      rotate([0,0,90]) {
        rotate([0,0,0]) {
          NEMA(xy_motor);
        }
      }
    }
  }
  // AB motors
  for(x=[left,right]) {
    mirror([x-1,0,0]) {
      // V0/Tiny-M -ish style
      % color("#aaa", 0.8) position_ab_motor(0);
      % color("#ddd", 0.4) position_ab_motor(xy_motor_adjust_range,-0.02);

      // upside down
      translate([corner_pos_x-xy_motor_side/2+extrusion_side/2,corner_pos_y-xy_motor_side/2-extrusion_side/2,xy_pos_z+40]) {
        rotate([0,0,90]) {
          rotate([0,180,0]) {
            // NEMA(xy_motor);
          }
        }
      }
    }
    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        translate([0,0,xy_motor_pos_z+ab_plate_thickness/2]) {
          color("#7a7") ab_motor_plate(bottom);

          translate([xy_motor_pos_x-xy_motor_adjust_range*0,xy_motor_pos_y,ab_plate_thickness/2+0.1]) {
            //xy_tensioner_body(16);
          }
        }
        translate([0,0,xy_pos_z+extrusion_side/2+ab_plate_thickness+ab_plate_space_between_z+top_ab_plate_thickness/2+0.1]) {
          rotate([0,180,0]) {
            //color("#77a") ab_motor_plate(top);
          }
        }
      }
    }
  }

  position_build_volume() {
    //% cube([build_volume_x,build_volume_y,build_volume_z],center=true);
    //cube([10,10,10],center=true);
  }

  for(x=[left,right]) {
    translate([x*corner_pos_x,-corner_pos_x+extrusion_side/2,xy_pos_z+extrusion_side/2]) {
      front_idler_top(x);
      front_idler_bottom(x);
      translate([0,0,40]) {
        //front_idler_generic(left,bottom);
      }
    }
  }
}
