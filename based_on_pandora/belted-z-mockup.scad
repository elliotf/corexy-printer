include <./main.scad>;
use <./ab_pods.scad>;

module mockup() {
  module body() {
    translate([0,front*extrusion_side/2,extrusion_vertical_length/2]) {
      % extrusion(extrusion_vertical_length);
    }
    translate([0,extrusion_main_length/2,gantry_pos_z]) {
      rotate([90,0,0]) {
        % extrusion(extrusion_main_length);
      }
    }
    translate([0,extrusion_main_length/2,extrusion_side/2]) {
      rotate([90,0,0]) {
        % extrusion(extrusion_main_length);
      }
    }
    translate([-extrusion_main_length/2-extrusion_side/2,front*extrusion_side/2,extrusion_side/2]) {
      rotate([0,90,0]) {
        % extrusion(extrusion_main_length);
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

module assembly(pct_x,pct_y,pct_z) {
  //pos_x = -x_rail_length/2+carriage_length(x_carriage)+pct_x*printer_config[BUILD_DIMENSIONS][x];
  //pos_y = pct_y*printer_config[BUILD_DIMENSIONS][y];
  //pos_z = pct_z*printer_config[BUILD_DIMENSIONS][z];
  //pos_x = -x_rail_length/2+x_carriage_width/2+pct_x*build_volume[x];
  pos_x = -build_volume[x]/2+pct_x*build_volume[x];
  pos_y = pct_y*build_volume[y];
  pos_z = pct_z*build_volume[z];

  y_carriage_pos_y = y_rail_pos_y-y_rail_length/2+carriage_length(y_carriage)/2+pos_y;

  //for(z=[bottom_pos_z+extrusion_side/2,top_pos_z-extrusion_side/2]) {
  for(z=[bottom_pos_z+extrusion_side/2]) {
    translate([0,0,z]) {
      for(x=[left,right]) {
        translate([x*extrusion_vertical_spacing_x/2,0,0]) {
          rotate([90,0,0]) {
            % extrusion(extrusion_main_length);
          }
        }
      }
      for(y=[front,rear]) {
        translate([0,y*extrusion_vertical_spacing_y/2,0]) {
          rotate([0,90,0]) {
            % extrusion(extrusion_main_length);
          }
        }
      }
    }
  }
  translate([0,extrusion_vertical_spacing_y/2,0]) {
    translate([rear_z_offset_x,0,bottom_pos_z+extrusion_side+extrusion_main_length/2]) {
      % extrusion(extrusion_short_length);
    }
    //translate([0,front*10,motor_xy_pos_z+extrusion_side/2+xy_motor_plate_thickness]) {
    translate([0,motor_xy_pos_y-extrusion_vertical_spacing_y/2,motor_xy_pos_z+extrusion_side/2+xy_motor_plate_thickness]) {
      rotate([0,90,0]) {
        % extrusion(extrusion_shortest_length);
      }
    }
  }

  module center_brace_anchor() {
    rounded_diam = 2;
    max_width = 50;
    center_brace_width = min(max_width,2*(motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount-center_brace_anchor_length)-0.2);
    echo("center_brace_width: ", center_brace_width);

    top_of_vertical_brace = bottom_pos_z+extrusion_side+extrusion_short_length;

    dist_to_brace_x = -rear_z_offset_x;
    dist_to_brace_y = motor_xy_pos_y-extrusion_vertical_spacing_y/2;
    dist_to_brace_z = motor_xy_pos_z+xy_motor_plate_thickness-top_of_vertical_brace;
    thickness = xy_motor_plate_thickness;


    module body() {
      hull () {
        translate([rear_z_offset_x,extrusion_vertical_spacing_y/2,top_of_vertical_brace]) {
          translate([0,0,dist_to_brace_z/2]) {
            rounded_cube(extrusion_side,extrusion_side,dist_to_brace_z,rounded_diam);
          }

          translate([dist_to_brace_x,dist_to_brace_y,dist_to_brace_z]) {
            translate([0,0,-thickness/2]) {
              rounded_cube(center_brace_width,extrusion_side,thickness,rounded_diam);
            }
          }
        }
      }
    }

    module holes() {
        translate([rear_z_offset_x,extrusion_vertical_spacing_y/2,top_of_vertical_brace]) {
          translate([0,0,dist_to_brace_z]) {
            hole(m3_through_hole_diam,dist_to_brace_z*3,resolution);
            // FIXME: make this a support hole
            translate([0,0,-dist_to_brace_z+thickness]) {
              bridged_hole(m3_head_diam,m3_through_hole_diam);
            }
              /*
              hole(m3_head_diam,(dist_to_brace_z-thickness)*2,resolution);
              hole(0.1,(dist_to_brace_z-thickness+m3_head_diam)*2,resolution);
            hull() {
              hole(m3_head_diam,(dist_to_brace_z-thickness)*2,resolution);
              hole(0.1,(dist_to_brace_z-thickness+m3_head_diam)*2,resolution);
            }
            */
          }

          translate([dist_to_brace_x,dist_to_brace_y,dist_to_brace_z]) {
            translate([0,0,-thickness-20]) {
              for(x=[left,right]) {
                translate([x*(center_brace_width*0.3),0,0]) {
                  hole(m3_through_hole_diam,50+thickness*2,resolution);
                  hull() {
                    hole(m3_head_diam,(20)*2,resolution);
                    //hole(0.1,(dist_to_brace_z-thickness+m3_head_diam)*2,resolution);
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
  center_brace_anchor();

  pom_nut_od = 10.2;
  pom_nut_flange_od = 22;
  pom_nut_screw_spacing = 16;
  pom_nut_screw_hole_diam = 3.5;
  pom_nut_flange_height = 3.5;
  pom_nut_above_flange_height = 10;
  pom_nut_below_flange_height = 1.5;
  pom_nut_overall_height = pom_nut_below_flange_height+pom_nut_flange_height+pom_nut_above_flange_height;

  module pom_nut() {
    module body() {
      translate([0,0,-pom_nut_below_flange_height-pom_nut_flange_height+pom_nut_overall_height/2]) {
        hole(pom_nut_od,pom_nut_overall_height,resolution);
      }
      translate([0,0,-pom_nut_flange_height/2]) {
        hole(pom_nut_flange_od,pom_nut_flange_height,resolution);
      }
    }

    module holes() {
      for(r=[0,90,180,270]) {
        rotate([0,0,r]) {
          translate([0,pom_nut_screw_spacing/2,0]) {
            hole(pom_nut_screw_hole_diam,pom_nut_overall_height,resolution);
          }
        }
      }
    }

    color("#333") difference() {
      body();
      holes();
    }
  }


  z_axis_assembly(pos_z);

  psu_type = LRS_150_24;
  module position_psu() {
    psu_len = psu_length(psu_type);
    psu_wid = psu_width(psu_type);
    psu_center_z = psu_len/2;
    // vertically
    //translate([-spar_main_len/2+5+psu_width(psu_type)/2,rear_support_pos_y+extrusion_side/2+3,bottom_pos_z+psu_center_z]) {
    //  rotate([-90,0,0]) {
    // horizontally
    /*
    */
    /*
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
    */
    translate([-extrusion_vertical_spacing_x/2+extrusion_side/2+psu_wid/2,extrusion_vertical_spacing_y/2-extrusion_side/2-psu_len/2,0]) {
      rotate([0,0,-90]) {
        rotate([180,0,0]) {
          children();
        }
      }
    }
    translate([0,0,0]) {
      rotate([0,0,0]) {
        rotate([180,0,0]) {
          //children();
        }
      }
    }
  }

  position_psu() {
    % psu(psu_type);
  }

  for(x=[right]) {
    for(y=[front]) {
      translate([x*(extrusion_vertical_spacing_x/2),y*(extrusion_vertical_spacing_y/2),extrusion_vertical_pos_z]) {
        //% extrusion(extrusion_vertical_length);
      }
    }
  }
  for(x=[left,right]) {
    for(y=[front,rear]) {
      translate([x*(extrusion_vertical_spacing_x/2),y*(extrusion_vertical_spacing_y/2),extrusion_vertical_pos_z]) {
        % extrusion(extrusion_vertical_length);
      }
    }

    translate([x*extrusion_vertical_spacing_x/2,0,gantry_pos_z]) {
      rotate([90,0,0]) {
        % extrusion(extrusion_main_length);
      }
    }

    ab_pod_assembly(x);

    translate([x*extrusion_vertical_spacing_x/2,y_rail_pos_y,gantry_pos_z+extrusion_side/2]) {
      rotate([0,0,90]) {
        % rail(y_rail,y_rail_length);
      }

      translate([0,-y_rail_length/2+carriage_length(y_carriage)/2+pos_y,0]) {
        rotate([0,0,90]) {
          //xy_carriage(x);
        }
      }
    }
  }

  module position_x_axis() {
    translate([0,0,gantry_pos_z+extrusion_side/2+carriage_height(y_carriage)]) {
      translate([0,y_carriage_pos_y,0]) {
        children();
      }
    }
  }

  position_x_axis() {
    translate([0,carriage_length(y_carriage)/2-extrusion_side/2,extrusion_side/2+x_extrusion_above_y_carriage]) {
      rotate([0,90,0]) {
        % extrusion(extrusion_main_length);
      }
      translate([0,-extrusion_side/2,0]) {
        rotate([90,0,0]) {
          % rail(x_rail,x_rail_length);
        }
        translate([pos_x,0,0]) {
          translate([0,0,-extrusion_side/2]) {
            translate([0,-nozzle_x_extrusion_dist_y,-nozzle_x_extrusion_dist_z+1]) {
              % color("red") hole(1.5,2,resolution);
            }
          }
          rotate([90,0,0]) {
            % carriage(x_carriage);
          }
          translate([0,front*(extrusion_side/2+carriage_height(x_carriage)),0]) {
            rotate([-90,0,0]) {
              % color("orange") import("../Pandoras_Box/STLs/Gantry/x_carriage.stl");
            }
          }
          % color("lightblue") toolhead();
        }
      }
    }
  }

  module belt_path(side) {
    anchor_for = [-pos_x,0,pos_x];
    color_for = ["blue", 0, "red"];

    effective_radius = 6.68-1.38/2;

    x_carriage_pos_x = anchor_for[side+1];
    x_carriage_pos_y = y_carriage_pos_y+carriage_length(y_carriage)/2-extrusion_side-carriage_height(x_carriage);

    xy_carriage_pos_x = front_idler_pos_x;
    xy_front_idler_pos_y = x_carriage_pos_y-effective_radius;
    xy_rear_idler_pos_y = xy_front_idler_pos_y+xy_carriage_bearing_dist_y;
    xy_carriage_pos_y = y_carriage_pos_y;

    belt_points = [
      [x_carriage_pos_x+10,x_carriage_pos_y,0],
      [xy_carriage_pos_x-front_idler_clearance_bearing_dist_x,xy_front_idler_pos_y,f623_2x_idler],
      [front_idler_clearance_pos_x+effective_radius,front_idler_clearance_pos_y,0],
      [front_idler_pos_x-front_idler_clearance_bearing_dist_x,front_idler_clearance_pos_y,f623_2x_idler],
      [front_idler_pos_x,front_idler_pos_y,f623_2x_idler],
      [outer_idler_pos_x,outer_idler_pos_y,f623_2x_idler],
      //[motor_xy_pos_x,motor_xy_pos_y,GT2x16_pulley],
      [motor_xy_pos_x,motor_xy_pos_y,GT2x20_pulley],
      [rear_idler_pos_x,rear_idler_pos_y,f623_2x_idler],
      [-rear_idler_pos_x,rear_idler_pos_y,f623_2x_idler],
      [-non_motor_idler_pos_x,non_motor_idler_pos_y,f623_2x_idler,"solo"],
      [-outer_idler_pos_x,outer_idler_pos_y,f623_2x_idler],
      [-front_idler_pos_x,xy_rear_idler_pos_y,f623_2x_idler],
      [x_carriage_pos_x-10,x_carriage_pos_y,0],
    ];

    translate([0,0,xy_belt_center_pos_z]) {
      translate([0,0,-side*xy_belt_spacing/2]) {
        mirror([side-1,0,0]) {
          color(color_for[side+1]) belt(GT2x6, belt_points, belt_colour = grey(20), tooth_colour = "#795C34", open = true, twist = false, auto_twist = false, start_twist = false);

          for(i=[0:len(belt_points)-1]) {
            p = belt_points[i];
            if (p[2] == f623_2x_idler) {
              translate([p[0],p[1],0]) {
                % pulley_assembly(f623_2x_idler);

                if (p[3] == "solo") {
                  translate([0,0,side*xy_belt_spacing]) {
                    color("orange") {
                      difference() {
                        //hole(6,8,resolution);
                        hole(belt_idler_spacer_od,8,resolution);
                        hole(belt_idler_spacer_id,8+1,resolution);
                      }
                    }
                  }
                }
              }
            } else {
            }
          }
        }
      }
    }
  }

  % belt_path(left);
  % belt_path(right);
}

assembly(1,1,0);
