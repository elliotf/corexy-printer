include <lumpyscad/lib.scad>; 
include <NopSCADlib/lib.scad>;
use <./toolhead.scad>;
use <./xy_joints.scad>;
use <./z_axis.scad>;

size_large = 0;
size_medium = 1;
size_small = 2;
//printer_size = size_large;
//printer_size = size_medium;
printer_size = size_small;

m3_through_hole_diam = 3.3;
m3_thread_into_plastic_diam = 2.8;
m3_head_diam = 6; // very loose

m5_through_hole_diam = 5.4;
m5_thread_into_plastic_diam = 4.8;

extrude_width = 0.4;
extrude_height = 0.2;
wall_thickness = extrude_width*3;
extrusion_side = 15;
belt_width = 6;
belt_thickness = 1.5; // FIXME ?
panel_thickness = 3;

belt_idler_od = 10; // F623
belt_idler_spacer_id = m3_through_hole_diam;
belt_idler_spacer_od = belt_idler_spacer_id+2*(extrude_width*2*2);
belt_idler_spacer_length = 9; // f623*2 + 2*0.5 shim
belt_idler_stack_height = belt_idler_spacer_length*2;

sizes = [
  [
    [500,300,250,200], // extrusion_lengths
    [
      [MGN9H_carriage,MGN9,300], // X axis
      [MGN7H_carriage,MGN7,250], // Y axis
      [MGN7H_carriage,MGN7,225], // Z axis
    ],
    [NEMA17_47,NEMA17_47,NEMA17_27,300],
    //[NEMA14_52,NEMA17_47,NEMA17_27,300], // untested
    [
      // electronics
      LRS_150_24,
    ],
    [
      [235,235,6],
    ],
  ],
  [
    [500,250,200,150], // extrusion_lengths
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
    [
      [180,180,6],
    ],
  ],
  [
    [350,200,150,100], // extrusion_lengths
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
    [
      [120,120,6],
    ],
  ],
];

EXTRUSION_LENGTHS = 0;
RAIL_CONFIGURATION = 1;
MOTOR_CONFIGURATION = 2;
ELECTRONICS = 3;
MISC = 4;

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

build_plate_dimensions = printer_config[MISC][0];

skirt_height = 0;
bottom_pos_z = skirt_height;
extrusion_base_pos_z = extrusion_side/2;

extrusion_vertical_spacing_x = extrusion_main_length+extrusion_side;
extrusion_vertical_spacing_y = extrusion_vertical_spacing_x;

extrusion_vertical_pos_z = bottom_pos_z+extrusion_vertical_length/2;

z_carriage = printer_config[1][z][0];
z_rail = printer_config[1][z][1];
z_rail_length = printer_config[1][z][2];

top_pos_z = extrusion_vertical_length;
//gantry_pos_z = bottom_pos_z+extrusion_side+extrusion_main_length-extrusion_side/2;
gantry_pos_z = z_rail_length+50;
echo("gantry_pos_z: ", gantry_pos_z);

effective_radius = 6.68-1.38/2; // effective radius of F623 + belt

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

xy_rear_idler_pos_x = front_idler_pos_x;
xy_front_idler_pos_x = front_idler_pos_x-front_idler_clearance_bearing_dist_x;

xy_carriage_bearing_dist_y = 11.38;
xy_carriage_bearing_dist_x = front_idler_clearance_bearing_dist_x;

x_carriage_offset_y = carriage_length(y_carriage)/2-extrusion_side-carriage_height(x_carriage);

xy_front_idler_offset_pos_y = x_carriage_offset_y-effective_radius; // based on y carriage
xy_rear_idler_offset_pos_y = xy_front_idler_offset_pos_y+xy_carriage_bearing_dist_y; // based on y carriage

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

xy_carriage_base_thickness = 4;
xy_carriage_top_thickness = 6;
x_extrusion_above_y_carriage = xy_carriage_base_thickness+1.4;

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
motor_xy_pos_z = gantry_pos_z+extrusion_side/2+4.2; // it's +4 on pandora's box, yielding a motor plate thickness of 6

motor_xy_adjustment_amount = 5;

xy_bottom_of_belt_idler_stack = xy_belt_center_pos_z-xy_belt_spacing/2-belt_width/2-belt_idler_flange_thickness-belt_idler_shim_thickness;
xy_motor_plate_thickness = xy_bottom_of_belt_idler_stack-motor_xy_pos_z;
ab_pod_lower_thickness = xy_bottom_of_belt_idler_stack-gantry_pos_z-extrusion_side/2;
//ab_pod_upper_thickness = xy_motor_plate_thickness;
ab_pod_upper_thickness = 6;

//rear_z_offset_x = motor_xy_width/2;
//rear_z_offset_x = right*(5+extrusion_side/2);
//rear_z_offset_x = left*5;
rear_z_offset_x = left*0;

//nozzle_x_extrusion_dist_y = 27.35;
nozzle_x_extrusion_dist_y = 29;
//nozzle_x_extrusion_dist_z = 42;
nozzle_x_extrusion_dist_z = 32.95;

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

module assembly(pct_x,pct_y,pct_z) {
  //pos_x = -x_rail_length/2+carriage_length(x_carriage)+pct_x*printer_config[BUILD_DIMENSIONS][x];
  //pos_y = pct_y*printer_config[BUILD_DIMENSIONS][y];
  //pos_z = pct_z*printer_config[BUILD_DIMENSIONS][z];
  //pos_x = -x_rail_length/2+x_carriage_width/2+pct_x*build_volume[x];
  pos_x = -build_volume[x]/2+pct_x*build_volume[x];
  pos_y = pct_y*build_volume[y];
  pos_z = pct_z*build_volume[z];

  y_carriage_pos_y = y_rail_pos_y-y_rail_length/2+carriage_length(y_carriage)/2+pos_y;

  for(z=[bottom_pos_z+extrusion_side/2,top_pos_z-extrusion_side/2]) {
  //for(z=[bottom_pos_z+extrusion_side/2]) {
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
      % extrusion(extrusion_main_length);
    }
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

    top_of_vertical_brace = bottom_pos_z+extrusion_side+extrusion_main_length;

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
  //center_brace_anchor();

  z_axis_assembly(pos_z);

  module position_pi() {
    translate([pcb_length(RPI3)/2,-35,-5]) {
      rotate([180,0,0]) {
        //% pcb(RPI3);
      }
    }
    translate([pcb_length(RPI0)/2,-35,-5]) {
      rotate([180,0,0]) {
        % pcb(RPI0);
      }
    }
  }
  //position_pi();

  module position_skr_e3_mini() {
    /*
    //type = BTT_SKR_MINI_E3_V2_0; // only four steppers, would need two
    type = BTT_SKR_MINI_E3_V2_0;
    translate([0,0,extrusion_side-psu_height-5]) {
      rotate([0,0,-90]) {
        rotate([180,0,0]) {
          % pcb(type);
        }
      }
    }
    */
  }

  module position_mcu() {
    //type = BTT_SKR_MINI_E3_V2_0; // only four steppers, would need two
    type = BTT_SKR_V1_4_TURBO;
    // stacked below PSU
    translate([0,0,extrusion_side-psu_height-8]) {
      rotate([0,0,-90]) {
        rotate([180,0,0]) {
          //% pcb(type);
        }
      }
    }
    translate([pcb_width(type)/2+10,0,0]) {
      rotate([0,0,-90]) {
        rotate([180,0,0]) {
          % color("blue", 0.3) cube([64,90,20],center=true);
          % color("blue", 0.3) cube([90,64,20],center=true);
          % pcb(type);
        }
      }
    }
  }
  //position_mcu();

  psu_type = LRS_150_24;
  psu_length = psu_length(psu_type);
  psu_width = psu_width(psu_type);
  psu_height = psu_height(psu_type);
  module position_psu() {
    psu_center_z = psu_length/2;
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
    // LRS-350-24
    translate([-extrusion_vertical_spacing_x/2+extrusion_side/2+psu_width/2+3,extrusion_vertical_spacing_y/2-extrusion_side/2-psu_length/2-10,extrusion_side]) {
      rotate([0,0,-90]) {
        rotate([180,0,0]) {
          //children();
        }
      }
    }
    // LRS-350-24
    translate([0,-30,extrusion_side-30/2]) {
      rotate([0,0,0]) {
        rotate([180,0,0]) {
          // left to right alignment
          //children();
        }
      }
    }
    translate([-extrusion_vertical_spacing_x/2+extrusion_side/2+psu_width/2+3,extrusion_vertical_spacing_y/2-extrusion_side/2-psu_length/2-10,extrusion_side]) {
      rotate([0,0,-90]) {
        rotate([180,0,0]) {
          //children();
        }
      }
    }
    translate([left*(extrusion_vertical_spacing_x/2-extrusion_side/2-psu_width/2-3),front*(extrusion_vertical_spacing_y/2-psu_length/2-NEMA_width(motor_type_z)),extrusion_side-3]) {
      rotate([0,0,-90]) {
        rotate([180,0,0]) {
          // front to rear
          //children();
        }
      }
    }
    translate([left*(extrusion_vertical_spacing_x/2-extrusion_side/2-psu_length/2-5),-10,extrusion_side-3]) {
      rotate([0,0,0]) {
        rotate([180,0,0]) {
          // left to right alignment
          children();
        }
      }
    }
  }

  position_psu() {
    % psu(psu_type);
    //% cube([215,115,30],center=true);
  }

  for(x=[right]) {
    for(y=[front,rear]) {
      translate([x*(extrusion_vertical_spacing_x/2),y*(extrusion_vertical_spacing_y/2),extrusion_vertical_pos_z]) {
        % extrusion(extrusion_vertical_length);
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
    y_axis_assembly(pos_y);
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

    x_carriage_pos_x = anchor_for[side+1];
    x_carriage_pos_y = y_carriage_pos_y+x_carriage_offset_y;

    xy_carriage_pos_x = front_idler_pos_x;
    xy_front_idler_pos_y = x_carriage_pos_y-effective_radius;
    xy_rear_idler_pos_y = xy_front_idler_pos_y+xy_carriage_bearing_dist_y;
    xy_carriage_pos_y = y_carriage_pos_y;

    belt_points = [
      [x_carriage_pos_x+10,x_carriage_pos_y,0],
      [xy_front_idler_pos_x,xy_front_idler_pos_y,f623_2x_idler],
      //[front_idler_clearance_pos_x+effective_radius,front_idler_clearance_pos_y,0],
      [front_idler_clearance_pos_x+effective_radius,front_idler_clearance_pos_y,0],
      [xy_front_idler_pos_x,front_idler_clearance_pos_y,f623_2x_idler],
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
