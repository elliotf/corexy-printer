include <lumpyscad/lib.scad>; 
include <NopSCADlib/lib.scad>;

size_large = 0;
size_medium = 1;
size_small = 2;
//printer_size = size_large;
printer_size = size_small;
//printer_size = size_medium;

m3_through_hole_diam = 3.4;
m3_thread_into_plastic_diam = 2.8;
m3_head_diam = 6; // very loose

extrude_width = 0.4;
extrude_height = 0.2;
wall_thickness = extrude_width*3;
extrusion_side = 15;
belt_width = 6;
panel_thickness = 3;

belt_idler_spacer_id = m3_through_hole_diam;
belt_idler_spacer_od = belt_idler_spacer_id+2*(extrude_width*2*2);
belt_idler_spacer_length = 9; // f623*2 + 2*0.5 shim
belt_idler_stack_height = belt_idler_spacer_length*2;
echo("belt_idler_spacer_od: ", belt_idler_spacer_od);

sizes = [
  [
    [500,300,300,200], // extrusion_lengths
    [
      [MGN9H_carriage,MGN9,300], // X axis
      [MGN7H_carriage,MGN7,250], // Y axis
      [MGN7H_carriage,MGN7,250], // Z axis
    ],
    [NEMA17_47,NEMA17_47,NEMA17_27,300],
    //[NEMA14_52,NEMA17_47,NEMA17_27,300], // untested
    [
      // electronics
      LRS_150_24,
    ],
  ],
  [
    [450,250,250,150], // extrusion_lengths
    [
      [MGN9H_carriage,MGN9,250], // X axis
      [MGN7H_carriage,MGN7,200], // Y axis
      [MGN7H_carriage,MGN7,200], // Z axis
    ],
    [NEMA17_47,NEMA17_47,NEMA17_27,250],
    //[NEMA14_52,NEMA17_47,NEMA17_27,300], // untested
    [
      // electronics
      LRS_150_24,
    ],
  ],
  [
    [400,200,200,100], // extrusion_lengths
    [
      [MGN9H_carriage,MGN9,200], // X axis
      [MGN7H_carriage,MGN7,150], // Y axis
      [MGN7H_carriage,MGN7,150], // Z axis
    ],
    [NEMA17_47,NEMA17_47,NEMA17_27,200],
    //[NEMA14_52,NEMA17_47,NEMA17_27,200], // untested
    [
      // electronics
      LRS_150_24,
    ],
  ],
];

EXTRUSION_LENGTHS = 0;
RAIL_CONFIGURATION = 1;
MOTOR_CONFIGURATION = 2;
ELECTRONICS = 3;

printer_config = sizes[printer_size];

carriage_over_end_of_rail = 1; // how to take this into account?

dragon_burner_width = 55;
x_carriage_width = max(carriage_length(printer_config[RAIL_CONFIGURATION][x][0]), dragon_burner_width);

build_volume = [
  printer_config[RAIL_CONFIGURATION][x][2] - x_carriage_width - 5,
  printer_config[RAIL_CONFIGURATION][y][2] - carriage_length(printer_config[RAIL_CONFIGURATION][y][0])+2.5,
  printer_config[RAIL_CONFIGURATION][z][2] - carriage_length(printer_config[RAIL_CONFIGURATION][z][0]),
];

echo("build_volume: ", build_volume);

extrusion_vertical_length = printer_config[0][0];
extrusion_main_length = printer_config[0][1];
extrusion_short_length = printer_config[0][2];
extrusion_shortest_length = printer_config[0][3];

motor_type_xy = printer_config[2][0];
motor_type_z = printer_config[2][0];

skirt_height = 0;
bottom_pos_z = skirt_height;
extrusion_base_pos_z = extrusion_side/2;

extrusion_vertical_spacing_x = extrusion_main_length+extrusion_side;
extrusion_vertical_spacing_y = extrusion_vertical_spacing_x;

extrusion_vertical_pos_z = bottom_pos_z+extrusion_vertical_length/2;

top_pos_z = extrusion_vertical_length;
gantry_pos_z = bottom_pos_z+extrusion_side+extrusion_short_length;

front_idler_room_y = 32; // 35;
//front_idler_extrusion_dist_y = 6.5;
//front_idler_extrusion_dist_y = 6.8;
rear_idler_dist_from_end = 7.5;
front_idler_extrusion_dist_y = 6.8;
front_idler_clearance_bearing_dist_x = 2.65;
//front_idler_clearance_bearing_dist_y = 11.5;
front_idler_clearance_bearing_dist_y = 12;

x_carriage = printer_config[1][x][0];
x_rail = printer_config[1][x][1];
x_rail_length = printer_config[1][x][2];

y_carriage = printer_config[1][y][0];
y_rail = printer_config[1][y][1];
y_rail_length = printer_config[1][y][2];
y_rail_pos_y = -extrusion_vertical_spacing_y/2+extrusion_side/2+front_idler_room_y+y_rail_length/2;

//front_idler_pos_x = extrusion_vertical_spacing_x/2+2;
front_idler_pos_x = extrusion_vertical_spacing_x/2;
front_idler_pos_y = -extrusion_vertical_spacing_y/2+extrusion_side/2+front_idler_extrusion_dist_y;
front_idler_clearance_pos_x = front_idler_pos_x-front_idler_clearance_bearing_dist_x;
front_idler_clearance_pos_y = front_idler_pos_y+front_idler_clearance_bearing_dist_y;

rear_idler_pos_x = extrusion_vertical_spacing_x/2-extrusion_side/2-front_idler_extrusion_dist_y;
//rear_idler_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2-front_idler_extrusion_dist_y+1;
rear_idler_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2-rear_idler_dist_from_end;

ab_corner_anchor_depth = 30;

outer_idler_pos_x = front_idler_pos_x;
//outer_idler_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-front_idler_extrusion_dist_y;
//outer_idler_pos_y = y_rail_pos_y+y_rail_length/2+front_idler_extrusion_dist_y;
//outer_idler_pos_y = y_rail_pos_y+y_rail_length/2+10;
//outer_idler_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-8;
outer_idler_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2-ab_corner_anchor_depth+(12)/2+0.2;

//non_motor_idler_pos_x = extrusion_vertical_spacing_x/2-23;
//non_motor_idler_pos_y = outer_idler_pos_y+5.8;
//non_motor_idler_pos_y = motor_xy_pos_y;
non_motor_idler_pos_x = extrusion_vertical_spacing_x/2-extrusion_side/2-16;
//non_motor_idler_pos_y = outer_idler_pos_y+5.8;
//non_motor_idler_pos_y = outer_idler_pos_y+10;
non_motor_idler_pos_y = rear_idler_pos_y-11;

xy_carriage_bearing_dist_y = 11.38;
xy_carriage_bearing_dist_x = front_idler_clearance_bearing_dist_x;
xy_carriage_base_thickness = 4;
x_extrusion_above_y_carriage = xy_carriage_base_thickness+1.4;

z_carriage = printer_config[1][z][0];
z_rail = printer_config[1][z][1];
z_rail_length = printer_config[1][z][2];

belt_idler_flange_thickness = 1;
belt_idler_shim_thickness = 0.5;
xy_bottom_belt_above_carriage_base = belt_idler_flange_thickness+belt_idler_shim_thickness+belt_width/2; // flange + 0.5mm shim
xy_belt_spacing = 6+belt_idler_flange_thickness*2+belt_idler_shim_thickness*2;
xy_belt_center_pos_z = gantry_pos_z+extrusion_side/2+carriage_height(y_carriage)+xy_carriage_base_thickness+xy_bottom_belt_above_carriage_base+xy_belt_spacing/2;

motor_xy_width = NEMA_width(motor_type_xy);
motor_xy_hole_spacing = NEMA_holes(motor_type_xy)[1]-NEMA_holes(motor_type_xy)[0];
motor_xy_rounded = motor_xy_width-motor_xy_hole_spacing;
//motor_xy_pos_x = extrusion_vertical_spacing_x/2-extrusion_side/2-motor_xy_width/2-20; // inside chamber
motor_xy_pos_x = non_motor_idler_pos_x-motor_xy_hole_spacing/2+0.5;
//motor_xy_pos_x = motor_xy_width/2 + 12/2; // outside chamber on the back
motor_xy_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2-motor_xy_width/2; // inside chamber
//motor_xy_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2+motor_xy_width/2+panel_thickness+3; // outside chamber on the  back
//motor_xy_pos_z = gantry_pos_z+extrusion_side/2+carriage_height(y_carriage);
motor_xy_pos_z = gantry_pos_z+extrusion_side/2+4; // it's +4 on pandora's box, yielding a motor plate thickness of 6

motor_xy_adjustment_amount = 5;

xy_bottom_of_belt_idler_stack = xy_belt_center_pos_z-xy_belt_spacing/2-belt_width/2-belt_idler_flange_thickness-belt_idler_shim_thickness;
xy_motor_plate_thickness = xy_bottom_of_belt_idler_stack-motor_xy_pos_z;
ab_pod_lower_thickness = xy_bottom_of_belt_idler_stack-gantry_pos_z-extrusion_side/2;
ab_pod_upper_thickness = xy_motor_plate_thickness;

//rear_z_offset_x = motor_xy_width/2;
//rear_z_offset_x = right*(5+extrusion_side/2);
//rear_z_offset_x = left*5;
rear_z_offset_x = left*0;

nozzle_x_extrusion_dist_y = 27.35;
nozzle_x_extrusion_dist_z = 42;

center_brace_anchor_length = 24;
center_brace_plate_thickness = 9;

module bridged_hole(od,id,length=50) {
  hole(id,length,resolution);
  translate([0,0,length/4]) {
    hole(od,length/2,resolution);
  }
  intersection() {
    union() {
      cube([od,id,0.2*1*2],center=true);
      cube([id,id,0.2*2*2],center=true);
      hole(id,0.2*3*2,8);
    }
    hole(od,length,resolution);
  }
}

module xy_carriage(side) {
  module body() {
    % carriage(y_carriage);
  }

  module holes() {
  }

  mirror([x-1,0,0]) {
    difference() {
      body();
      holes();
    }
  }
}

module x_carriage() {
  translate([0,0,0]) {
    rotate([0,0,0]) {
      import("../Pandoras_Box/STLs/Gantry/x_carriage.stl");
    }
  }
}

module extrusion(length) {
  if (extrusion_side == 15) {
    % extrusion_makerbeam_xl(length);
  } else if (extrusion_side == 20) {
    % extrusion_2020(length);
  } else {
    % debug_axes(10);
  }
}

module ab_pod_assembly(side) {
  rounded_diam = 4;
  anchor_width = motor_xy_width;
  narrow_anchor_depth = ab_corner_anchor_depth-extrusion_side;
  side_anchor_thickness = 6;

  addition_backside_meat_for_center_anchor = 0; // (motor_xy_hole_spacing-extrusion_side-m3_head_diam)/2;

  motor_xy_dist_to_center = motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount;
  space_between_motor_and_center = 0;
  space_between_motor_and_corner = extrusion_vertical_spacing_x/2-extrusion_side/2-motor_xy_pos_x-motor_xy_width/2-0.3;

  motor_shoulder_clearance = NEMA_boss_radius(motor_type_xy)*2+0.3;
  cut_through_height = 50;

  innermost_motor_shoulder_hole = motor_xy_pos_x-motor_xy_adjustment_amount-motor_shoulder_clearance/2;
  wall_between_motor_and_center_spar = innermost_motor_shoulder_hole-extrusion_shortest_length/2-0.2;

  center_anchor_center_pos_x = motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount-center_brace_anchor_length/2;

  space_between_elongated_motor_holes_x = motor_xy_hole_spacing-m3_through_hole_diam-motor_xy_adjustment_amount;
  space_between_spar_and_elongated_holes_y = motor_xy_hole_spacing/2-m3_through_hole_diam/2-extrusion_side/2;

  module corner_anchor_profile() {
    module body() {
      translate([extrusion_vertical_spacing_x/2,extrusion_vertical_spacing_y/2,0]) {
        translate([-extrusion_side/2-space_between_motor_and_corner/2,extrusion_side/2-ab_corner_anchor_depth/2,0]) {
          rounded_square(space_between_motor_and_corner,ab_corner_anchor_depth,wall_thickness*2);
        }
        combined_width = space_between_motor_and_corner+extrusion_side;
        translate([extrusion_side/2-combined_width/2,-extrusion_side/2-narrow_anchor_depth/2,0]) {
          rounded_square(combined_width,narrow_anchor_depth,rounded_diam);
        }
      }
    }

    module holes() {
      /*
      corner_tolerance = 1;
      translate([extrusion_vertical_spacing_x/2-extrusion_side/2,extrusion_vertical_spacing_y/2-extrusion_side/2,0]) {
        hull() {
          accurate_circle(corner_tolerance,resolution);
          spread_across = 2;
          translate([spread_across/2,spread_across/2,0]) {
            square([spread_across,spread_across],center=true);
          }
        }
      }
      */
    }

    difference() {
      body();
      holes();
    }
  }

  module motor_plate_profile() {
    module body() {
      hull() {
        translate([0,motor_xy_pos_y,0]) {
          //rounded_square(space_between_motor_and_center,motor_xy_width,rounded_diam*2);
        }
        translate([motor_xy_pos_x-motor_xy_adjustment_amount,motor_xy_pos_y,0]) {
          rounded_square(motor_xy_width+motor_xy_adjustment_amount*2,motor_xy_width,motor_xy_rounded);
        }
      }
      translate([motor_xy_pos_x+motor_xy_width/2,motor_xy_pos_y+motor_xy_width/2-ab_corner_anchor_depth/2,0]) {
        square([rounded_diam*3,ab_corner_anchor_depth],center=true);
      }
      translate([motor_xy_pos_x+motor_xy_width/2,motor_xy_pos_y+motor_xy_width/2-ab_corner_anchor_depth,0]) {
        rotate([0,0,-90]) {
          round_corner_filler_profile(rounded_diam);
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

  module lower_center_anchor_profile() {
    module body() {
      hull() {
        translate([motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount,motor_xy_pos_y,0]) {
          rounded_square(motor_xy_rounded,motor_xy_width,motor_xy_rounded);

          translate([-center_brace_anchor_length+rounded_diam/2,addition_backside_meat_for_center_anchor/2,0]) {
            rounded_square(rounded_diam,extrusion_side+addition_backside_meat_for_center_anchor,rounded_diam);
          }
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

  module upper_center_anchor_profile() {
    module body() {
      hull() {
        translate([innermost_motor_shoulder_hole-wall_between_motor_and_center_spar/2,motor_xy_pos_y-extrusion_side/2,0]) {
          accurate_circle(wall_between_motor_and_center_spar,resolution);
        }
        translate([motor_xy_pos_x,motor_xy_pos_y,0]) {
          translate([0,addition_backside_meat_for_center_anchor/2,0]) {
            translate([-motor_xy_width/4,0,0]) {
              rounded_square(motor_xy_width/2,extrusion_side+addition_backside_meat_for_center_anchor,rounded_diam);
            }

            translate([-motor_xy_width/2-motor_xy_adjustment_amount,0,0]) {
              translate([motor_xy_width/4-motor_xy_rounded/2,motor_xy_width/2-motor_xy_rounded/2,0]) {
                rounded_square(motor_xy_width/2,motor_xy_rounded,motor_xy_rounded);
              }
              translate([-center_brace_anchor_length+rounded_diam/2,0,0]) {
                rounded_square(rounded_diam,extrusion_side+addition_backside_meat_for_center_anchor,rounded_diam);
              }
            }
          }
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

  module upper_motor_area_profile() {
    hull() {
      translate([0,extrusion_vertical_spacing_y/2+extrusion_side/2-ab_corner_anchor_depth/2,0]) {
        translate([extrusion_vertical_spacing_x/2-extrusion_side/2-space_between_motor_and_corner/2,0,0]) {
          rounded_square(space_between_motor_and_corner,ab_corner_anchor_depth,wall_thickness*2);
        }
        translate([motor_xy_pos_x+motor_shoulder_clearance/2+rounded_diam/2,0,0]) {
          rounded_square(rounded_diam,ab_corner_anchor_depth,rounded_diam);
        }
      }
    }
    hull() {
      translate([motor_xy_pos_x,motor_xy_pos_y+motor_xy_width/4,0]) {
        rounded_square(motor_xy_width,motor_xy_width/2,rounded_diam);
      }
    }
  }

  module upper_screw_area_filler_profile() {
    module body() {
      translate([innermost_motor_shoulder_hole,motor_xy_pos_y,0]) {
        hull() {
          translate([-wall_between_motor_and_center_spar/2,0,0]) {
            translate([0,-extrusion_side/2-wall_between_motor_and_center_spar/2+wall_between_motor_and_center_spar/2,0]) {
              accurate_circle(wall_between_motor_and_center_spar,resolution);
            }
            translate([0,motor_xy_hole_spacing/2-m3_through_hole_diam/2-1,0]) {
              square([wall_between_motor_and_center_spar,2],center=true);
            }
          }
          
        }
      }
      translate([motor_xy_pos_x-motor_xy_adjustment_amount-motor_shoulder_clearance/4-1,motor_xy_pos_y+motor_shoulder_clearance/4+1,0]) {
        square([motor_shoulder_clearance/2+1,motor_shoulder_clearance/2+1],center=true);
      }
      // meat between screw holes
      translate([motor_xy_pos_x,motor_xy_pos_y,0]) {
        translate([-motor_xy_adjustment_amount/2,motor_xy_hole_spacing/2-m3_through_hole_diam/2,0]) {
          rounded_square(space_between_elongated_motor_holes_x,m3_through_hole_diam*2,m3_through_hole_diam);
          for(x=[left,right]) {
            translate([x*space_between_elongated_motor_holes_x/2,0,0]) {
              square([m3_through_hole_diam,m3_through_hole_diam],center=true);
            }
          }
        }
        translate([-motor_shoulder_clearance/2-motor_xy_adjustment_amount-wall_between_motor_and_center_spar,extrusion_side/2+space_between_spar_and_elongated_holes_y/2,0]) {
          rounded_square(center_brace_anchor_length,space_between_spar_and_elongated_holes_y,space_between_spar_and_elongated_holes_y);
        }
      }
      // put meat by outermost,rearmost screw hole
      hull() {
        translate([0,motor_xy_pos_y+motor_xy_hole_spacing/2-m3_through_hole_diam,0]) {
          translate([motor_xy_pos_x+motor_xy_hole_spacing/2,0,0]) {
            accurate_circle(m3_through_hole_diam,resolution);
          }
          translate([innermost_motor_shoulder_hole,-motor_shoulder_clearance*0.15,0]) {
            square([m3_through_hole_diam,m3_through_hole_diam+motor_shoulder_clearance*0.3],center=true);
          }
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

  module ab_pod_upper() {
    top_pos_z = xy_belt_center_pos_z+belt_idler_stack_height/2;

    module body() {
      translate([0,0,top_pos_z]) {
        translate([0,0,ab_pod_upper_thickness/2]) {
          linear_extrude(height=ab_pod_upper_thickness,center=true,convexity=2) {
            corner_anchor_profile();
            upper_center_anchor_profile();
            upper_motor_area_profile();
          }
        }
      }
      height_between_pod_plates = top_pos_z-motor_xy_pos_z-xy_motor_plate_thickness;
      translate([0,0,top_pos_z-height_between_pod_plates/2+1]) {
        linear_extrude(height=height_between_pod_plates+2,center=true,convexity=3) {
          upper_screw_area_filler_profile();
        }
      }
      dist_to_extrusion_spar_z = height_between_pod_plates-extrusion_side;
      translate([0,0,top_pos_z]) {
        tab_height = 1;
        tab_width = 3;
        translate([center_anchor_center_pos_x,motor_xy_pos_y,-dist_to_extrusion_spar_z]) {
          difference() {
            rounded_cube(center_brace_anchor_length,tab_width,tab_height*2,tab_width);
            for(x=[-center_brace_anchor_length*0.2,center_brace_anchor_length*0.3]) {
              translate([x,0,-tab_height]) {
                cube([m3_through_hole_diam,tab_width*2,tab_height*2],center=true);
              }
            }
          }
        }
        translate([0,0,-dist_to_extrusion_spar_z/2+1]) {
          hull() {
            // center_anchor_center_pos_x = motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount-center_brace_anchor_length/2;
            translate([0,motor_xy_pos_y,0]) {
              translate([innermost_motor_shoulder_hole-wall_between_motor_and_center_spar/2,front*(extrusion_side/2),0]) {
                hole(wall_between_motor_and_center_spar,dist_to_extrusion_spar_z+2,resolution);
              }
              translate([center_anchor_center_pos_x,addition_backside_meat_for_center_anchor/2,0]) {
                rounded_cube(center_brace_anchor_length,extrusion_side+addition_backside_meat_for_center_anchor,dist_to_extrusion_spar_z+2,rounded_diam);
              }
              translate([motor_xy_pos_x,0,0]) {
                translate([-motor_shoulder_clearance/2-motor_xy_adjustment_amount-wall_between_motor_and_center_spar,extrusion_side/2+space_between_spar_and_elongated_holes_y/2,0]) {
                  rounded_cube(center_brace_anchor_length,space_between_spar_and_elongated_holes_y,dist_to_extrusion_spar_z+2,space_between_spar_and_elongated_holes_y);
                }
              }
            }
          }
        }
      }
    }

    module holes() {
      motor_holes(top_pos_z);
      translate([motor_xy_pos_x,motor_xy_pos_y,0]) {
        translate([-motor_shoulder_clearance/2-motor_xy_adjustment_amount,-extrusion_side/2,top_pos_z]) {
          translate([0,-wall_between_motor_and_center_spar/2,0]) {
            rotate([0,0,90]) {
              round_corner_filler(wall_between_motor_and_center_spar,cut_through_height);
            }
          }
          translate([motor_shoulder_clearance/2,0,0]) {
            cube([motor_shoulder_clearance,extrusion_side,cut_through_height],center=true);
          }
        }
      }

      recessed_bridging = [
        [center_anchor_center_pos_x-center_brace_anchor_length*0.2,motor_xy_pos_y,0],
        [center_anchor_center_pos_x+center_brace_anchor_length*0.3,motor_xy_pos_y,0],
      ];
      screw_through = [
        [outer_idler_pos_x,outer_idler_pos_y,0],
        [rear_idler_pos_x,rear_idler_pos_y,0],
        [non_motor_idler_pos_x,non_motor_idler_pos_y,0],
      ];
      translate([0,0,top_pos_z+xy_motor_plate_thickness]) {
        for(p=screw_through) {
          translate(p) {
            debug_axes();
            hole(3.4,500,resolution);
          }
        }
        // recess to make lengths match for center anchor
        recess_by = top_pos_z-motor_xy_pos_z-extrusion_side-xy_motor_plate_thickness;
        translate([0,0,-recess_by]) {
          for(p=recessed_bridging) {
            translate(p) {
              bridged_hole(m3_head_diam,m3_through_hole_diam);
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

  module motor_holes(z) {
    translate([motor_xy_pos_x,motor_xy_pos_y,z]) {
      hull() {
        hole(motor_shoulder_clearance,cut_through_height,resolution*2);
        translate([-motor_xy_adjustment_amount,0,0]) {
          hole(motor_shoulder_clearance,cut_through_height,resolution*2);
        }
      }
      motor_screw_hole_diam = m3_through_hole_diam;
      for(x=[left,right]) {
        for(y=[front,rear]) {
          hull() {
            for(a=[0,motor_xy_adjustment_amount]) {
              translate([x*(motor_xy_hole_spacing/2)-a,y*(motor_xy_hole_spacing/2),0]) {
                hole(motor_screw_hole_diam,cut_through_height,resolution);
              }
            }
          }
        }
        sink_heads_by = 2;
        screw_head_diam = 6;
        long_bridge = screw_head_diam+motor_xy_adjustment_amount;
        hole_length = motor_screw_hole_diam+motor_xy_adjustment_amount;
        hull() {
          for(a=[0,motor_xy_adjustment_amount]) {
            translate([x*(motor_xy_hole_spacing/2)-a,front*(motor_xy_hole_spacing/2),0]) {
              hole(screw_head_diam,sink_heads_by*2,resolution);
            }
          }
        }
        translate([x*(motor_xy_hole_spacing/2)-motor_xy_adjustment_amount/2,front*(motor_xy_hole_spacing/2),-sink_heads_by]) {
          intersection() {
            union() {
              cube([long_bridge,motor_screw_hole_diam,0.2*1*2],center=true);
              cube([hole_length,motor_screw_hole_diam,0.2*2*2],center=true);
              rounded_cube(hole_length,motor_screw_hole_diam,0.2*3*2,motor_screw_hole_diam,8);
            }
            rounded_cube(long_bridge,screw_head_diam,cut_through_height,screw_head_diam);
            /*
            translate([0,0,cut_through_height-sink_heads_by]) {
              hull() {
                for(a=[0,motor_xy_adjustment_amount]) {
                  translate([a,0,0]) {
                    //hole(screw_head_diam,cut_through_height,resolution);
                  }
                }
              }
            }
            */
          }
        }
      }
    }
  }

  module ab_pod_lower() {
    module body() {
      translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness-ab_pod_lower_thickness/2]) {
        linear_extrude(height=ab_pod_lower_thickness,center=true,convexity=2) {
          corner_anchor_profile();
        }
      }
      translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness/2]) {
        linear_extrude(height=xy_motor_plate_thickness,center=true,convexity=2) {
          lower_center_anchor_profile();
        }
      }
      translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness/2]) {
        linear_extrude(height=xy_motor_plate_thickness,center=true,convexity=2) {
          motor_plate_profile();
        }
      }
      translate([extrusion_vertical_spacing_x/2-extrusion_side/2,extrusion_vertical_spacing_y/2-extrusion_side/2,0]) {
        translate([-side_anchor_thickness/2,0,gantry_pos_z]) {
          rounded_cube(side_anchor_thickness,ab_corner_anchor_depth,extrusion_side,wall_thickness*2);
        }
        for(y=[front,0,rear]) {
          translate([0,y*(extrusion_side-wall_thickness),0]) {
            hull() {
              translate([-space_between_motor_and_corner/2,0,motor_xy_pos_z+xy_motor_plate_thickness-ab_pod_lower_thickness/2]) {
                rounded_cube(space_between_motor_and_corner,wall_thickness*2,ab_pod_lower_thickness,wall_thickness*2);
              }
              translate([-side_anchor_thickness/2,0,gantry_pos_z]) {
                rounded_cube(side_anchor_thickness,wall_thickness*2,extrusion_side,wall_thickness*2);
              }
            }
          }
        }
      }
    }

    module holes() {
      motor_holes(motor_xy_pos_z+xy_motor_plate_thickness);
      translate([motor_xy_pos_x,motor_xy_pos_y,motor_xy_pos_z]) {
      }

      translate([extrusion_vertical_spacing_x/2-extrusion_side/2-side_anchor_thickness,extrusion_vertical_spacing_y/2-extrusion_side/2,gantry_pos_z]) {
        for(y=[front,rear]) {
          translate([0,y*(extrusion_side/2),0]) {
            rotate([0,-90,0]) {
              hole(3.4,(side_anchor_thickness+space_between_motor_and_corner)*2,resolution);
            }
          }
        }
      }

      screw_through = [
        [outer_idler_pos_x,outer_idler_pos_y,0],
        [center_anchor_center_pos_x-center_brace_anchor_length*0.2,motor_xy_pos_y,0],
        [center_anchor_center_pos_x+center_brace_anchor_length*0.3,motor_xy_pos_y,0],
      ];
      thread_into_plastic = [
        [rear_idler_pos_x,rear_idler_pos_y,0],
        [non_motor_idler_pos_x,non_motor_idler_pos_y,0],
      ];
      translate([0,0,motor_xy_pos_z+xy_motor_plate_thickness]) {
        for(p=screw_through) {
          translate(p) {
            hole(3.4,500,resolution);
          }
        }
        for(p=thread_into_plastic) {
          lead_in_height = 3;
          thread_depth = xy_motor_plate_thickness+1;
          translate(p) {
            hull() {
              hole(m3_through_hole_diam,lead_in_height*2,resolution);
              hole(0.1,(lead_in_height+m3_through_hole_diam)*2,resolution);
            }
          
            hole(m3_thread_into_plastic_diam,thread_depth*2,resolution);
          }
        }
      }

      // belt tensioner set screw
      set_screw_pos_x = extrusion_vertical_spacing_x/2+extrusion_side/2;
      set_screw_pos_y = outer_idler_pos_y+m3_through_hole_diam/2+extrude_width*2+m3_through_hole_diam/2;
      set_screw_pos_z = gantry_pos_z+extrusion_side/2+extrude_height*5+m3_through_hole_diam/2;
      translate([set_screw_pos_x,set_screw_pos_y,set_screw_pos_z]) {
        set_screw_cavity_length = space_between_motor_and_corner+extrusion_side;
        threaded_length = 14;

        echo("set_screw_cavity_length: ", set_screw_cavity_length);
        rotate([0,90,0]) {
          hole(m3_thread_into_plastic_diam,2*(set_screw_cavity_length+1),8);
          hole(m3_through_hole_diam,2*(set_screw_cavity_length-threaded_length),8);
        }
      }
    }

    difference() {
      body();
      holes();
    }
  }

  translate([side*motor_xy_pos_x,motor_xy_pos_y,0]) {
    //for(a=[0,motor_xy_adjustment_amount]) {
    for(a=[0]) {
      translate([-side*a,0,motor_xy_pos_z]) {
        rotate([0,0,side*90]) {
          % NEMA(motor_type_xy); // AB motor
        }
        translate([0,0,16-side*4.5]) {
          rotate([0,90+side*90,0]) {
            % pulley_assembly(GT2x16_pulley);
          }
        }
      }
      /*
      translate([0,0,gantry_pos_z+extrusion_side/2+carriage_height(y_carriage)+13+side*4.5]) {
        rotate([0,90-side*90,0]) {
          % pulley_assembly(GT2x16_pulley);
        }
      }
      */
    }
  }

  mirror([side-1,0,0]) {
    ab_pod_lower();
    ab_pod_upper();
  }
}

module dragon_burner() {
  translate([0,-16.61-11.2,0]) {
    % color("red") hole(0.4,300,128);
  }
  //translate([0,-16.61,5.7]) {
  translate([0,-16.61,21.29]) {
    translate([0,-11.2,0]) {
      translate([0,0,0]) {
        rotate([0,0,0]) {
          translate([-36,-61.2,0.01]) {
            rotate([-90,0,0]) {
              rotate([90,0,0]) {
                rotate([0,0,180]) {
                  //color("blue") import("../chirpy-voron/V0/Dragon_Burner/STLs/v0.2/G2SA_Sherpa_Mount.stl");
                  import("../chirpy-voron/V0/Dragon_Burner/STLs/v0.2/G2SA_Sherpa_Mount.stl");
                }
              }
            }
          }
        }
      }

      translate([0,0,0]) {
        rotate([0,0,0]) {
          rotate([-90,0,0]) {
            translate([-147.85,162.5,-23.73]) {
              //color("red") import("../chirpy-voron/V0/Dragon_Burner/STLs/v0.2/Cowl_SlideSwipe.stl");
              import("../chirpy-voron/V0/Dragon_Burner/STLs/v0.2/Cowl_SlideSwipe.stl");
            }
          }
        }
      }

      translate([0,0,0]) {
        rotate([0,0,0]) {
          rotate([-90,0,0]) {
            translate([-330.05,161.68,-9.7]) {
              //color("green") import("../chirpy-voron/V0/Dragon_Burner/STLs/v0.2/Dragon_Mount.stl");
              import("../chirpy-voron/V0/Dragon_Burner/STLs/v0.2/Dragon_Mount.stl");
            }
          }
        }
      }
    }
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
    translate([rear_z_offset_x,0,bottom_pos_z+extrusion_side+extrusion_short_length/2]) {
      % extrusion(extrusion_short_length);
    }
    //translate([0,front*10,motor_xy_pos_z+extrusion_side/2+xy_motor_plate_thickness]) {
    translate([0,motor_xy_pos_y-extrusion_vertical_spacing_y/2,motor_xy_pos_z+extrusion_side/2+xy_motor_plate_thickness]) {
    //translate([0,0,bottom_pos_z+extrusion_side+extrusion_short_length+extrusion_side/2]) {
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

  module z_axis_assembly() {
    z_screw_length = printer_config[MOTOR_CONFIGURATION][3];
    z_motor_type = printer_config[MOTOR_CONFIGURATION][z];
    z_motor_side = NEMA_width(z_motor_type);
    front_screw_pos_x = extrusion_main_length/2-motor_xy_width/2-3/2;
    front_screw_pos_y = front*(extrusion_main_length/2-motor_xy_width/2-3/2);
    screw_stepper_pos_z = -10;
    z_screws = [
      [[left*(front_screw_pos_x),front_screw_pos_y,screw_stepper_pos_z],[-90,180],[1,0,0]],
      [[right*(front_screw_pos_x),front_screw_pos_y,screw_stepper_pos_z],[-90,180],[0,0,0]],
      [[rear_z_offset_x+extrusion_side/2+z_motor_side/2,rear*(extrusion_main_length/2-motor_xy_width/2-3/2),screw_stepper_pos_z],[-90,0],[0,0,0]],
    ];
    // using rear module as reference
    stepper_offset_x = -extrusion_side/2;
    stepper_offset_y = extrusion_side/2;
    stepper_offset_z = 0;

    module position_z_module() {
      for(screw=z_screws) {
        p = screw[0];
        motor_r = screw[1][0];
        mount_r = screw[1][1];
        mirr = screw[2];
        translate(p) {
          mirror(mirr) {
            rotate([0,0,mount_r]) {
              translate([left*(z_motor_side/2+extrusion_side/2),z_motor_side/2,z_screw_length/2]) {
                rotate([90,0,0]) {
                  rotate([0,0,90]) {
                    % rail(z_rail,z_rail_length);
                    % carriage(z_carriage);
                  }
                }
              }
              translate([stepper_offset_x,stepper_offset_y,0]) {
                rotate([0,0,motor_r]) {
                  % NEMA(z_motor_type);
                  translate([0,0,z_screw_length/2]) {
                    % color("silver") hole(8,z_screw_length,resolution);
                  }
                }
              }
            }
          }
        }
      }
    }

    position_z_module() {
      translate([0,0,z_stepper_pos_z]) {
        % NEMA(z_motor_type);
        translate([0,0,z_screw_length/2]) {
          % color("silver") hole(8,z_screw_length,resolution);
        }
      }
    }

    /*
    for(screw=z_screws) {
      p = screw[0];
      motor_r = screw[1][0];
      mount_r = screw[1][1];
      mirr = screw[2];
      translate(p) {
        mirror(mirr) {
          rotate([0,0,mount_r]) {
            translate([left*(z_motor_side/2+extrusion_side/2),z_motor_side/2,z_screw_length/2+rail_offset_z]) {
              rotate([90,0,0]) {
                rotate([0,0,90]) {
                  % rail(z_rail,z_rail_length);
                  % carriage(z_carriage);
                }
              }
            }
            rotate([0,0,motor_r]) {
              translate([0,stepper_offset_x,0]) {
                % NEMA(z_motor_type);
                translate([0,0,z_screw_length/2]) {
                  % color("silver") hole(8,z_screw_length,resolution);
                }
              }
            }
          }
        }
      }
    }
    */
  }

  z_axis_assembly();

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
          xy_carriage(x);
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
    //% debug_axes(1);
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
          % color("lightblue") dragon_burner();
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

  /*
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
  */
}

/*
pos_x = 1*printer_config[BUILD_DIMENSIONS][x];
pos_y = 0.2*printer_config[BUILD_DIMENSIONS][y];
pos_z = 0*printer_config[BUILD_DIMENSIONS][z];
*/

assembly(1,1,0);
