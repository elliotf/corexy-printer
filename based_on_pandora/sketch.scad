include <lumpyscad/lib.scad>; 
include <NopSCADlib/lib.scad>;

extrusion_side = 15;
belt_width = 6;
panel_thickness = 3;

sizes = [
  [
    [500,300,200,150], // extrusion_lengths
    [
      [MGN9C_carriage,MGN9,300], // X axis
      [MGN7H_carriage,MGN7,250], // Y axis
      [MGN7H_carriage,MGN7,250], // Z axis
    ],
    [NEMA17_47,NEMA17_47],
    //[NEMA14_52,NEMA17_47], // non_motor_idler_pos_y current position looks like it would foul on the belt with nema14
    [220,220,100], // build volume
  ],
  [
    [350,200,200,50], // extrusion_lengths
    [
      [MGN9C_carriage,MGN9,200], // X axis
      [MGN7H_carriage,MGN7,150], // Y axis
      [MGN7H_carriage,MGN7,150], // Z axis
    ],
    [NEMA17_47,NEMA17_47],
    //[NEMA14_52,NEMA17_47], // non_motor_idler_pos_y current position looks like it would foul on the belt with nema14
    [120,120,100], // build volume
  ],
];

EXTRUSION_LENGTHS = 0;
RAIL_CONFIGURATION = 1;
MOTOR_CONFIGURATION = 2;
BUILD_DIMENSIONS = 3;

size_large = 0;
size_small = 1;

printer_size = (0) ? size_large : size_small;
printer_config = sizes[printer_size];

build_volume = [
  printer_config[RAIL_CONFIGURATION][x][2] - carriage_length(printer_config[RAIL_CONFIGURATION][x][0]),
  printer_config[RAIL_CONFIGURATION][y][2] - carriage_length(printer_config[RAIL_CONFIGURATION][y][0]),
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
gantry_pos_z = bottom_pos_z+extrusion_side+extrusion_short_length+extrusion_side/2;

front_idler_room_y = 32; // 35;
front_idler_extrusion_dist_y = 6.5;
//front_idler_clearance_bearing_dist_x = 2.65;
front_idler_clearance_bearing_dist_x = 2;
//front_idler_clearance_bearing_dist_y = 11.5;
front_idler_clearance_bearing_dist_y = 12;

xy_carriage_bearing_dist_y = 11.38;
xy_carriage_bearing_dist_x = front_idler_clearance_bearing_dist_x;

x_carriage = printer_config[1][x][0];
x_rail = printer_config[1][x][1];
x_rail_length = printer_config[1][x][2];

y_carriage = printer_config[1][y][0];
y_rail = printer_config[1][y][1];
y_rail_length = printer_config[1][y][2];
y_rail_pos_y = -extrusion_vertical_spacing_y/2+extrusion_side/2+front_idler_room_y+y_rail_length/2;

z_carriage = printer_config[1][z][0];
z_rail = printer_config[1][z][1];
z_rail_length = printer_config[1][z][2];

xy_carriage_base_thickness = 4;
xy_bottom_belt_above_carriage_base = 1.5+belt_width/2; // flange + 0.5mm shim
xy_belt_spacing = 6+3;

motor_xy_width = NEMA_width(motor_type_xy);
motor_xy_pos_x = extrusion_vertical_spacing_x/2-extrusion_side/2-motor_xy_width/2-24; // inside chamber
//motor_xy_pos_x = motor_xy_width/2 + 12/2; // outside chamber on the back
motor_xy_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2-motor_xy_width/2; // inside chamber
//motor_xy_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2+motor_xy_width/2+panel_thickness+3; // outside chamber on the  back
//motor_xy_pos_z = gantry_pos_z+extrusion_side/2+carriage_height(y_carriage);
motor_xy_pos_z = gantry_pos_z+extrusion_side/2+6; // it's ~+4 on pandora's box

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
  pos_x = -x_rail_length/2+carriage_length(x_carriage)/2+pct_x*build_volume[x];
  pos_y = pct_y*build_volume[y];
  pos_z = pct_z*build_volume[z];

  y_carriage_pos_y = y_rail_pos_y-y_rail_length/2+carriage_length(y_carriage)/2+pos_y;

  for(z=[bottom_pos_z+extrusion_side/2,top_pos_z-extrusion_side/2]) {
    translate([0,0,z]) {
      for(x=[left,right]) {
        translate([x*extrusion_vertical_spacing_x/2,0,0]) {
          rotate([90,0,0]) {
            //% extrusion(extrusion_main_length);
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
    translate([0,0,gantry_pos_z-extrusion_side/2-extrusion_short_length/2]) {
      % extrusion(extrusion_short_length);
    }
    translate([0,0,gantry_pos_z]) {
      rotate([0,90,0]) {
        % extrusion(extrusion_shortest_length);
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

    translate([x*motor_xy_pos_x,motor_xy_pos_y,0]) {
      translate([0,0,motor_xy_pos_z]) {
        rotate([0,0,x*90]) {
          % NEMA(motor_type_xy);
        }
      }
      translate([0,0,gantry_pos_z+extrusion_side/2+carriage_height(y_carriage)+13+x*4.5]) {
        rotate([0,90-x*90,0]) {
          pulley_assembly(GT2x16_pulley);
        }
      }
    }

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
    x_extrusion_above_y_carriage = xy_carriage_base_thickness+1.4;
    translate([0,carriage_length(y_carriage)/2-extrusion_side/2,extrusion_side/2+x_extrusion_above_y_carriage]) {
      rotate([0,90,0]) {
        % extrusion(extrusion_main_length);
      }
      translate([0,-extrusion_side/2,0]) {
        rotate([90,0,0]) {
          % rail(x_rail,x_rail_length);
          translate([pos_x,0,0]) {
            % carriage(x_carriage);
          }
        }
      }
    }
  }

  module belt_path(side) {
    anchor_for = [-pos_x,0,pos_x];

    effective_radius = 6.68-1.38/2;

    x_carriage_pos_x = anchor_for[side+1];
    x_carriage_pos_y = y_carriage_pos_y+carriage_length(y_carriage)/2-extrusion_side-carriage_height(x_carriage);

    //front_idler_pos_x = extrusion_vertical_spacing_x/2+2;
    front_idler_pos_x = extrusion_vertical_spacing_x/2;
    front_idler_pos_y = -extrusion_vertical_spacing_y/2+extrusion_side/2+front_idler_extrusion_dist_y;
    front_idler_clearance_pos_x = front_idler_pos_x-front_idler_clearance_bearing_dist_x;
    front_idler_clearance_pos_y = front_idler_pos_y+front_idler_clearance_bearing_dist_y;

    xy_carriage_pos_x = front_idler_pos_x;
    xy_front_idler_pos_y = x_carriage_pos_y-effective_radius;
    xy_rear_idler_pos_y = xy_front_idler_pos_y+xy_carriage_bearing_dist_y;
    xy_carriage_pos_y = y_carriage_pos_y;

    outer_idler_pos_x = front_idler_pos_x;
    //outer_idler_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-front_idler_extrusion_dist_y;
    outer_idler_pos_y = y_rail_pos_y+y_rail_length/2+front_idler_extrusion_dist_y;

    rear_idler_pos_x = extrusion_vertical_spacing_x/2-extrusion_side/2-front_idler_extrusion_dist_y;
    rear_idler_pos_y = extrusion_vertical_spacing_y/2;

    //non_motor_idler_pos_x = extrusion_vertical_spacing_x/2-23;
    //non_motor_idler_pos_y = outer_idler_pos_y+5.8;
    //non_motor_idler_pos_y = motor_xy_pos_y;
    non_motor_idler_pos_x = extrusion_vertical_spacing_x/2-23;
    non_motor_idler_pos_y = outer_idler_pos_y+5.8;

    belt_points = [
      [x_carriage_pos_x+10,x_carriage_pos_y,0],
      [xy_carriage_pos_x-front_idler_clearance_bearing_dist_x,xy_front_idler_pos_y,f623_2x_idler],
      [front_idler_clearance_pos_x+effective_radius,front_idler_clearance_pos_y,0],
      [front_idler_pos_x-front_idler_clearance_bearing_dist_x,front_idler_clearance_pos_y,f623_2x_idler],
      [front_idler_pos_x,front_idler_pos_y,f623_2x_idler],
      [outer_idler_pos_x,outer_idler_pos_y,f623_2x_idler],
      [motor_xy_pos_x,motor_xy_pos_y,GT2x16_pulley],
      [rear_idler_pos_x,rear_idler_pos_y,f623_2x_idler],
      [-rear_idler_pos_x,rear_idler_pos_y,f623_2x_idler],
      [-non_motor_idler_pos_x,non_motor_idler_pos_y,f623_2x_idler],
      [-outer_idler_pos_x,outer_idler_pos_y,f623_2x_idler],
      [-front_idler_pos_x,xy_rear_idler_pos_y,f623_2x_idler],
      [x_carriage_pos_x-10,x_carriage_pos_y,0],
    ];

    translate([0,0,gantry_pos_z+extrusion_side/2]) {
      translate([0,0,carriage_height(y_carriage)+xy_carriage_base_thickness+xy_bottom_belt_above_carriage_base+xy_belt_spacing/2]) {
        translate([0,0,side*xy_belt_spacing/2]) {
          mirror([side-1,0,0]) {
            belt(GT2x6, belt_points, belt_colour = grey(20), tooth_colour = "#795C34", open = true, twist = false, auto_twist = false, start_twist = false);

            for(i=[0:len(belt_points)-1]) {
              p = belt_points[i];
              if (p[2] == f623_2x_idler) {
                translate([p[0],p[1],0]) {
                  % pulley_assembly(f623_2x_idler);
                }
              } else {
              }
            }
          }
        }
      }
    }
  }

  belt_path(left);
  belt_path(right);

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

assembly(1,0,0);
