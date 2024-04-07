include <NopSCADlib/lib.scad>;
include <lumpyscad/lib.scad>; 

module frame() {
  ab_pod_depth = 47;
  extrusion_side = 20;
  build_volume = 240;
  //front_rear_extrusion_length = build_volume+30*2;
  front_rear_extrusion_length = build_volume+130; // tiny-m is +110
  side_extrusion_pos_x = front_rear_extrusion_length/2+extrusion_side/2;
  //side_extrusion_length = build_volume+ab_pod_depth+20+30*2;
  side_extrusion_length = build_volume+130+20; // tiny-m is +110

  y_rail_len = build_volume + 60; // tiny-m is +50
  x_rail_len = build_volume + 69; // tiny-m is +50

  bottom_pos_z = 50+20/2;
  xy_support_pos_z = bottom_pos_z+20/2+build_volume+40/2;
  overall_height = xy_support_pos_z+40/2+160;

  rear_support_pos_y = side_extrusion_length/2-ab_pod_depth-20/2;

  pos_y = build_volume+20;
  pos_x = 0;

  translate([0,rear_support_pos_y,0]) {
    translate([0,0,xy_support_pos_z]) {
      rotate([0,90,0]) {
        extrusion_2040(front_rear_extrusion_length);
      }
    }
    translate([0,0,bottom_pos_z]) {
      rotate([0,90,0]) {
        extrusion_2020(front_rear_extrusion_length);
      }
    }
  }

  translate([0,rear_support_pos_y-20/2-20-30-build_volume/2,xy_support_pos_z-40/2-build_volume/2]) {
    //% cube([build_volume,build_volume,build_volume],center=true);
  }

  // gantry
  translate([0,0,0]) {
    carriage_offset = carriage_height(MGN9H_carriage); // + carriage_clearance(MGN9H_carriage);
    y_carriage_len = carriage_length(MGN9H_carriage);
    x_carriage_len = carriage_length(MGN12H_carriage);

    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        translate([-side_extrusion_pos_x+20/2,0,xy_support_pos_z]) {
          translate([0,rear_support_pos_y-y_rail_len/2-20/2,10]) {
            rotate([0,0,90]) {
              rotate([90,0,0]) {
                rail(MGN9, y_rail_len);

                translate([-y_rail_len/2+y_carriage_len/2+pos_y,0,0]) {
                  carriage(MGN9H_carriage);
                }
              }
            }
          }
        }   
      }
    }

    translate([0,rear_support_pos_y-20/2-y_rail_len+y_carriage_len/2+pos_y+20/2,xy_support_pos_z+37]) {
      rotate([0,90,0]) {
        extrusion_2020(front_rear_extrusion_length);
      }
      translate([0,0,20/2]) {
        rail(MGN12, x_rail_len);

        translate([-x_rail_len/2+x_carriage_len/2+pos_x,0,0]) {
          carriage(MGN12H_carriage);

          translate([0,front*50,0]) {
            //import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_belt_retainer.stl");
            //import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_cable_plate_alpha.stl");
            rotate([0,90,0]) {
              //import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_fan_duct_left.stl");
            }
            translate([70,0,0]) {
              rotate([0,-90,0]) {
                //import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_fan_duct_right.stl");
              }
            }
            translate([0,0,0]) {
              rotate([0,90,0]) {
                translate([17.2,-61,-42.5]) {
                  import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_toolhead_dragon_left.stl");
                }
              }
            }
            translate([0,0,0]) {
              rotate([0,-90,0]) {
                % debug_axes(2);
                translate([-20,-61,-40]) {
                  % debug_axes(2);
                  import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_toolhead_dragon_right.stl");
                }
              }
            }
            //import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_toolhead_dragon_right.stl");
            //import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_wing_bowden.stl");
            //import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_wing_lgx_lite.stl");
            //import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_wing_sailfin.stl");
            //import("tiny-m/STLs/essentials/Gantry/X_Axis/X_Carriage/printed_parts_MGN12_v4 - bw_dd_sch_wing_scherpa.stl");
          }
        }
      }
    }

    translate([-side_extrusion_pos_x+20/2,0,xy_support_pos_z]) {
      translate([carriage_offset,rear_support_pos_y-y_rail_len-30+y_carriage_len/2+pos_y,0]) {
        rotate([0,0,90]) {
          color("#c55") import("tiny-m/STLs/essentials/Gantry/X_Axis/XY_Joint/xy_join_v4_no_nuts - xy-join_left_bottom_v4_not_nut.stl");
          color("#5c5") import("tiny-m/STLs/essentials/Gantry/X_Axis/XY_Joint/xy_join_v4_no_nuts - xy-join_left_middle_v4_not_nut.stl");
          color("#55c") import("tiny-m/STLs/essentials/Gantry/X_Axis/XY_Joint/xy_join_v4_no_nuts - xy-join_left_top_v4_not_nut.stl");
        }
      }
    }

    translate([side_extrusion_pos_x-20/2,0,xy_support_pos_z]) {
      translate([-carriage_offset,rear_support_pos_y-y_rail_len-30+y_carriage_len/2+pos_y,0]) {
        rotate([0,0,-90]) {
          color("#c55") import("tiny-m/STLs/essentials/Gantry/X_Axis/XY_Joint/xy_join_v4_no_nuts - xy-join_right_bottom_v4_not_nut.stl");
          color("#5c5") import("tiny-m/STLs/essentials/Gantry/X_Axis/XY_Joint/xy_join_v4_no_nuts - xy-join_right_middle_v4_not_nut.stl");
          color("#55c") import("tiny-m/STLs/essentials/Gantry/X_Axis/XY_Joint/xy_join_v4_no_nuts - xy-join_right_top_v4_not_nut.stl");
        }
      }
    }
  }

  // AB drive units
  union() {
    translate([left*(front_rear_extrusion_length/2-56),rear_support_pos_y+20/2+46,xy_support_pos_z+40/2]) {
      rotate([0,0,180]) {
        color("#c55") import("tiny-m/STLs/essentials/Gantry/AB_drive_units/ab_drive v4 - a_drive_left_bottom_V4.stl");
        translate([0,0,0.2]) {
          color("#5c5") import("tiny-m/STLs/essentials/Gantry/AB_drive_units/ab_drive v4 - a_drive_left_top_V4.stl");
        }
      }
    }

    translate([right*(front_rear_extrusion_length/2-56),rear_support_pos_y+20/2+46,xy_support_pos_z+40/2]) {
      rotate([0,0,0]) {
        color("#c55") import("tiny-m/STLs/essentials/Gantry/AB_drive_units/ab_drive v4 - b_drive_right_bottom_V4.stl");
        translate([0,0,0.2]) {
          color("#5c5") import("tiny-m/STLs/essentials/Gantry/AB_drive_units/ab_drive v4 - b_drive_right_top_V4.stl");
        }
      }
    }
  }

  for(x=[left,right]) {
    mirror([x-1,0,0]) {
      translate([side_extrusion_pos_x,0,xy_support_pos_z]) {
        rotate([0,0,90]) {
          rotate([0,90,0]) {
            extrusion_2040(side_extrusion_length);
          }
        }
      }
      for(z=[bottom_pos_z,overall_height-20/2]) {
        translate([side_extrusion_pos_x,0,z]) {
          rotate([90,0,0]) {
            extrusion_2020(side_extrusion_length);
          }
        }
      }
      for(y=[front,rear]) {
        mirror([0,y-1,0]) {
          translate([side_extrusion_pos_x,side_extrusion_length/2+20/2,overall_height/2]) {
            extrusion_2020(overall_height);
          }
        }
      }
    }
    for(y=[front,rear],z=[bottom_pos_z,overall_height-20/2]) {
      mirror([0,y-1,0]) {
        translate([0,side_extrusion_length/2+20/2,z]) {
          rotate([0,90,0]) {
            extrusion_2020(front_rear_extrusion_length);
          }
        }
      }
    }
  }
}

frame();
