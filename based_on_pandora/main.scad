include <lumpyscad/lib.scad>; 
include <NopSCADlib/lib.scad>;
use <./toolhead.scad>;
use <./xy_joints.scad>;
use <./z_axis.scad>;
use <./probe.scad>;
use <./frame.scad>;
use <./ab_pods.scad>;
use <./electronics.scad>;

// FIXME:
// * bed cable chain mounts
// * Reduce unique vitamin count
//   * screws -- normalize on m3x10 for screwing to extrusion?
// * camera mount
//   * something like the v0 mount would be nice
//   * would need/want to avoid bed cable chain
// * light mounts
// * probe mount
//   * a slideswipe/unklickyslideswipe mount?
// * bottom panel mount
// * Access to adjust Z pulley set screw (though it's accessible through the belt hole for now)

// Need to compensate for euro slot, probably
// euro 2020 height : 19.88
// mgn7 rail height : 4.78
// mgn7 rail inside euro 2020 + euro 2020 height: 23.8
// rail is dropped by ~0.86mm

$fn=24;

is_final = false;

m3_threaded_insert_od = 5;
m3_threaded_insert_height = 4;

size_large = 0;
size_medium = 1;
size_small = 2;
size_small_2020 = 3;
size_medium_2020 = 4;
size_large_2020 = 5;
//printer_size = size_large;
//printer_size = size_medium;
//printer_size = size_small;
printer_size = size_small_2020; // B0rken
//printer_size = size_medium_2020; // B0rken
//printer_size = size_large_2020; // B0rken

m3_through_hole_diam = 3.3;
m3_thread_into_plastic_diam = 2.9;
m3_head_diam = 6; // very loose

m5_through_hole_diam = 5.4;
m5_thread_into_plastic_diam = 4.8;

m6_through_hole_diam = 6.3;
m6_head_diam = 11; // very loose

function screw_head_diam_for_extrusion(extrustion_type) = (extrusion_type == MakerbeamXL)
          ? m3_head_diam : (extrusion_type == E2020t)
                         ? m6_head_diam : 30;
function screw_shaft_diam_for_extrusion(extrusion_type) = (extrusion_type == MakerbeamXL)
          ? m3_through_hole_diam : (extrusion_type == E2020t)
                         ? m6_through_hole_diam : 40;

extrude_width = 0.4;
extrude_height = 0.2;
wall_thickness = extrude_width*3;
belt_width = 6;
belt_thickness = 1.5; // FIXME ?
deck_panel_thickness = 4;

belt_idler_od = 10; // F623
// maybe https://www.amazon.com/uxcell-Aluminum-Standoff-Quadcopter-Multirotors/dp/B08HL7VQFQ to have narrower diameter?
belt_idler_spacer_id = m3_through_hole_diam;
//belt_idler_spacer_od = belt_idler_spacer_id+2*(extrude_width*2*2)-0.5;
//belt_idler_spacer_od = 5;
belt_idler_spacer_od = 6;
belt_idler_spacer_length = 9; // f623*2 + 2*0.5 shim
belt_idler_stack_height = belt_idler_spacer_length*2;

psu_mount_gap = 4;
height_above_z_motor = 1;
height_below_z_motor = 4;
z_motor_type = NEMA17_47;
z_motor_side = NEMA_width(z_motor_type);
z_axis_screw_mount_thickness = 4;

sizes = [
  [
    [
      [500,MakerbeamXL],
      [300,MakerbeamXL],
      [250,MakerbeamXL],
      [200,MakerbeamXL],
    ], // extrusion_lengths
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
    [
      [235,235,6],
    ],
  ],
  [
    [
      [450,MakerbeamXL],
      [250,MakerbeamXL],
      [200,MakerbeamXL],
      [150,MakerbeamXL],
    ], // extrusion_lengths
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
    [
      [400,MakerbeamXL],
      [200,MakerbeamXL],
      [150,MakerbeamXL],
      [100,MakerbeamXL],
    ], // extrusion_lengths
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
  [
    [
      [400,E2020t],
      [200,E2020t],
      [150,E2020t],
      [100,MakerbeamXL],
    ], // extrusion_lengths
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
  /*
  [
    [
      [450,E2020t],
      [270,E2020t],
      [200,E2020t],
      [150,E2020t],
    ], // extrusion_lengths
    [
      [MGN9H_carriage,MGN9,250], // X axis
      [MGN7H_carriage,MGN7,220], // Y axis
      [MGN7H_carriage,MGN7,220], // Z axis
    ],
    [NEMA17_47,NEMA17_47,NEMA17_27,250],
    //[NEMA14_52,NEMA17_47,NEMA17_27,200], // untested
    [
      // electronics
      LRS_150_24,
    ],
    [
      [180,180,6],
    ],
  ],
  [
    [
      [500,E2020t],
      [350,E2020t],
      [250,E2020t],
      [200,E2020t],
    ], // extrusion_lengths
    [
      [MGN9H_carriage,MGN9,300], // X axis
      [MGN7H_carriage,MGN7,250], // Y axis
      [MGN7H_carriage,MGN7,250], // Z axis
    ],
    [NEMA17_47,NEMA17_47,NEMA17_27,300],
    //[NEMA14_52,NEMA17_47,NEMA17_27,200], // untested
    [
      // electronics
      LRS_150_24,
    ],
    [
      [235,235,6],
    ],
  ],
  */
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
x_axis_offset_y = 2;

echo("build_volume: ", build_volume);

extrusion_vertical_length = printer_config[0][0][0];
extrusion_main_length = printer_config[0][1][0];
extrusion_short_length = printer_config[0][2][0];
extrusion_shortest_length = printer_config[0][3][0];

extrusion_vertical_type = printer_config[0][0][1];
extrusion_main_type = printer_config[0][1][1];
extrusion_short_type = printer_config[0][2][1];
extrusion_shortest_type = printer_config[0][3][1];

extrusion_vertical_side = extrusion_width(extrusion_vertical_type);
extrusion_main_side = extrusion_width(extrusion_main_type);
extrusion_short_side = extrusion_width(extrusion_short_type);
extrusion_shortest_side = extrusion_width(extrusion_shortest_type);

extrusion_type = extrusion_vertical_type;

//extrusion_side = 15;
extrusion_side = extrusion_width(extrusion_type);

//extrusion_side = 20;
//extrusion_slot_width = 3;
extrusion_slot_width = extrusion_channel_width(extrusion_type);

motor_type_xy = printer_config[2][0];
motor_type_z = printer_config[2][0];

build_volume = [
  printer_config[RAIL_CONFIGURATION][x][2] - x_carriage_width - 3,
  //printer_config[RAIL_CONFIGURATION][y][2] - carriage_length(printer_config[RAIL_CONFIGURATION][y][0])+2.5,
  //printer_config[RAIL_CONFIGURATION][y][2] - carriage_length(printer_config[RAIL_CONFIGURATION][y][0])+6.5, // once we have a vampire bat-like extrusionless X gantry
  //printer_config[RAIL_CONFIGURATION][y][2] - carriage_length(printer_config[RAIL_CONFIGURATION][y][0])+4.5+x_axis_offset_y*2, // probe mount hits motor plate with NEMA17
  printer_config[RAIL_CONFIGURATION][y][2] - carriage_length(printer_config[RAIL_CONFIGURATION][y][0])+3.5+extrusion_side-15, // probe mount hits motor plate with NEMA17
  printer_config[RAIL_CONFIGURATION][z][2] - carriage_length(printer_config[RAIL_CONFIGURATION][z][0]),
];

build_plate_dimensions = printer_config[MISC][0];

skirt_height = 0;
bottom_pos_z = 0;
//extrusion_base_pos_z = extrusion_side/2;
extrusion_base_pos_z = extrusion_side/2;

z_motor_pos_z = bottom_pos_z-z_motor_side/2-height_above_z_motor;
z_base_motor_mount_overall_height = abs(z_motor_pos_z)+z_motor_side/2+height_below_z_motor;

extrusion_vertical_spacing_x = extrusion_main_length+extrusion_side;
extrusion_vertical_spacing_y = extrusion_vertical_spacing_x;

extrusion_vertical_pos_z = bottom_pos_z+extrusion_vertical_length/2;

z_carriage = printer_config[1][z][0];
z_rail = printer_config[1][z][1];
z_rail_length = printer_config[1][z][2];

bottom_panel_side = extrusion_main_length + 13; // based on voron 0 bottom panel
bottom_panel_hole_spacing_x = extrusion_main_length - 3.14; // voron 0 bottom panel hole spacing is 196.86 and 196.91.
bottom_panel_hole_spacing_y = extrusion_main_length - 3.09; // voron 0 bottom panel hole spacing is 196.86 and 196.91.

printed_height_extension_height = 0;
top_pos_z = extrusion_vertical_length+printed_height_extension_height;
//gantry_pos_z = bottom_pos_z+extrusion_side+extrusion_main_length-extrusion_side/2;
//gantry_pos_z = z_rail_length+37.5;
gantry_pos_z = extrusion_side+z_rail_length+27.5;
//gantry_pos_z = 180+15/2;

effective_radius = 6.68-1.38/2; // effective radius of F623 + belt

front_idler_room_y = 32; // 35;
//front_idler_extrusion_dist_y = 6.5;
//front_idler_extrusion_dist_y = 6.8;
rear_idler_dist_from_end = 7.5;
//front_idler_extrusion_dist_y = 6.8;
front_idler_extrusion_dist_y = 6.5;
front_idler_clearance_bearing_dist_x = 2.65;
front_idler_clearance_bearing_dist_y = 11.5;

x_carriage = printer_config[1][x][0];
x_rail = printer_config[1][x][1];
x_rail_length = printer_config[1][x][2];

y_carriage = printer_config[1][y][0];
y_rail = printer_config[1][y][1];
y_rail_length = printer_config[1][y][2];
y_rail_pos_y = -extrusion_vertical_spacing_y/2+extrusion_side/2+front_idler_room_y+y_rail_length/2;

//front_idler_pos_x = extrusion_vertical_spacing_x/2+2;
front_idler_pos_x = extrusion_vertical_spacing_x/2;
front_idler_pos_y = -extrusion_vertical_spacing_y/2+extrusion_width(extrusion_vertical_type)/2+front_idler_extrusion_dist_y;
front_idler_clearance_pos_x = front_idler_pos_x-front_idler_clearance_bearing_dist_x;
front_idler_clearance_pos_y = front_idler_pos_y+front_idler_clearance_bearing_dist_y;

xy_rear_idler_pos_x = front_idler_pos_x;
xy_front_idler_pos_x = front_idler_pos_x-front_idler_clearance_bearing_dist_x;

xy_carriage_bearing_dist_y = 11.38;
xy_carriage_bearing_dist_x = front_idler_clearance_bearing_dist_x;

//x_carriage_offset_y = carriage_length(y_carriage)/2-extrusion_side-carriage_height(x_carriage);
x_carriage_offset_space = 15; // since we're trying extrusionless X for now
x_carriage_offset_y = carriage_length(y_carriage)/2-x_carriage_offset_space-carriage_height(x_carriage);

//xy_front_idler_offset_pos_y = x_carriage_offset_y-effective_radius+x_axis_offset_y; // based on y carriage
//xy_rear_idler_offset_pos_y = xy_front_idler_offset_pos_y+xy_carriage_bearing_dist_y; // based on y carriage

rear_idler_pos_x = extrusion_vertical_spacing_x/2-extrusion_side/2-front_idler_extrusion_dist_y;
//rear_idler_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2-front_idler_extrusion_dist_y+1;
rear_idler_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2-rear_idler_dist_from_end;

outer_idler_pos_x = front_idler_pos_x;
//outer_idler_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-front_idler_extrusion_dist_y;
//outer_idler_pos_y = y_rail_pos_y+y_rail_length/2+front_idler_extrusion_dist_y;
//outer_idler_pos_y = y_rail_pos_y+y_rail_length/2+10;
//outer_idler_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-8;
//outer_idler_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2-ab_corner_anchor_depth+(12)/2+0.2;
outer_idler_pos_y = extrusion_vertical_spacing_y/2-extrusion_side/2-7.5;

//ab_corner_anchor_depth = 30; //-rear_brace_offset_y; // FIXME: take rear central brace offset into account?
//ab_corner_anchor_depth = 28.4; //-rear_brace_offset_y; // FIXME: take rear central brace offset into account?
ab_corner_anchor_depth = (extrusion_vertical_spacing_y/2+extrusion_side/2)-(outer_idler_pos_y-m3_through_hole_diam/2-2);

//non_motor_idler_pos_x = extrusion_vertical_spacing_x/2-23;
//non_motor_idler_pos_y = outer_idler_pos_y+5.8;
//non_motor_idler_pos_y = motor_xy_pos_y;
idler_motor_delta = 2;
non_motor_idler_pos_x = extrusion_vertical_spacing_x/2-extrusion_side/2-16+idler_motor_delta;
//non_motor_idler_pos_y = outer_idler_pos_y+5.8;
//non_motor_idler_pos_y = outer_idler_pos_y+10;
//non_motor_idler_pos_y = rear_idler_pos_y-10.6;
non_motor_idler_pos_y = outer_idler_pos_y+2.9;

xy_carriage_base_thickness = 4;
xy_carriage_top_thickness = 6;
x_extrusion_above_y_carriage = xy_carriage_base_thickness+1.4;

belt_idler_flange_width = 1;
belt_idler_flange_thickness = 1;
belt_idler_shim_thickness = 0.5;
xy_bottom_belt_above_carriage_base = belt_idler_flange_thickness+belt_idler_shim_thickness+belt_width/2; // flange + 0.5mm shim
xy_belt_spacing = 6+belt_idler_flange_thickness*2+belt_idler_shim_thickness*2;
xy_belt_center_extrusion_offset_z = carriage_height(y_carriage)+xy_carriage_base_thickness+xy_bottom_belt_above_carriage_base+xy_belt_spacing/2;
xy_belt_center_pos_z = gantry_pos_z+extrusion_side/2+xy_belt_center_extrusion_offset_z;
ab_top_pos_z = xy_belt_center_pos_z+belt_idler_stack_height/2;

z_pulley_type = GT2x16_pulley; // for more torque
xy_pulley_type = GT2x16_pulley; // not enough room for the non-motor idler, but might be able to use another F623 instead of the spacer?
//xy_pulley_type = GT2x20_pulley;
motor_xy_width = NEMA_width(motor_type_xy);
motor_xy_hole_spacing = NEMA_holes(motor_type_xy)[1]-NEMA_holes(motor_type_xy)[0];
motor_xy_rounded = motor_xy_width-motor_xy_hole_spacing;
//motor_xy_pos_x = extrusion_vertical_spacing_x/2-extrusion_side/2-motor_xy_width/2-20; // inside chamber
motor_xy_pos_x = non_motor_idler_pos_x-motor_xy_hole_spacing/2+0.5-idler_motor_delta;
//motor_xy_pos_x = motor_xy_width/2 + 12/2; // outside chamber on the back
motor_xy_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2-motor_xy_width/2; // inside chamber
//motor_xy_pos_y = extrusion_vertical_spacing_y/2+extrusion_side/2+motor_xy_width/2+panel_thickness+3; // outside chamber on the  back
//motor_xy_pos_z = gantry_pos_z+extrusion_side/2+carriage_height(y_carriage);
motor_xy_pos_z = gantry_pos_z+extrusion_side/2+4.2; // it's +4 on pandora's box, yielding a motor plate thickness of 6

//rear_brace_dist_from_back = 10;
//rear_brace_offset_y = (extrusion_vertical_spacing_y/2-rear_brace_dist_from_back)-motor_xy_pos_y;
//rear_brace_offset_y = 5;
//rear_brace_offset_y = (extrusion_vertical_spacing_y/2-ab_corner_anchor_depth+extrusion_width(extrusion_vertical_type)/2+extrusion_width(extrusion_shortest_type)/2)-motor_xy_pos_y;
rear_brace_offset_y = (extrusion_vertical_spacing_y/2-ab_corner_anchor_depth+extrusion_width(extrusion_vertical_type)/2+extrusion_width(extrusion_shortest_type)/2)-motor_xy_pos_y+(20-15)/2;

motor_xy_adjustment_amount = 7;

//y_rail_sunk_into_extrusion = 0;
//z_rail_sunk_into_extrusion = 0;
y_rail_sunk_into_extrusion = (extrusion_main_type == E2020t) ? 0.8 : 0;  // FIXME: see if this is correct enough
z_rail_sunk_into_extrusion = (extrusion_vertical_type == E2020t) ? 0.8 : 0;  // FIXME: see if this is correct enough

xy_bottom_of_belt_idler_stack = xy_belt_center_pos_z-xy_belt_spacing/2-belt_width/2-belt_idler_flange_thickness-belt_idler_shim_thickness;
xy_motor_plate_thickness = xy_bottom_of_belt_idler_stack-motor_xy_pos_z;
ab_pod_lower_thickness = xy_bottom_of_belt_idler_stack-gantry_pos_z-extrusion_side/2;
//ab_pod_upper_thickness = xy_motor_plate_thickness;
ab_pod_upper_thickness = 6;
frame_anchor_plastic_thickness = 6;

//rear_z_offset_x = motor_xy_width/2;
//rear_z_offset_x = right*(5+extrusion_side/2);
//rear_z_offset_x = left*5;
//rear_z_offset_x = right*carriage_width(z_carriage)/2;
//rear_z_offset_x = right*(carriage_width(z_carriage)/2-extrusion_side/2);
rear_brace_pos_y = motor_xy_pos_y+rear_brace_offset_y;
rear_brace_pos_z = motor_xy_pos_z+extrusion_width(extrusion_shortest_type)/2+xy_motor_plate_thickness;
rear_brace_distance_from_rear = extrusion_vertical_spacing_y/2-rear_brace_pos_y;
rear_z_offset_x = 0;

//nozzle_x_extrusion_dist_y = 27.35;
nozzle_x_extrusion_dist_y = 29;
//nozzle_x_extrusion_dist_z = 42;
nozzle_x_extrusion_dist_z = 32.95;

//center_brace_anchor_length = 22.75;
center_brace_anchor_length = 18;
//center_brace_plate_thickness = 9;

max_center_brace_width = 45;
center_brace_width = min(max_center_brace_width,2*(motor_xy_pos_x-motor_xy_width/2-motor_xy_adjustment_amount-center_brace_anchor_length)-0.2);

module bridged_hole(od,id,length=50,is_final=1,num_sides=resolution) {
  render() {
    hole(id,length,resolution);
    translate([0,0,length/4]) {
      hole(od,length/2,num_sides);
    }
    if (is_final) {
      intersection() {
        union() {
          cube([od,id,0.2*1*2],center=true);
          cube([id,id,0.2*2*2],center=true);
          hole(id,0.2*3*2,8);
        }
        hole(od,0.2*3*3,num_sides);
      }
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

module extrusion_l(length) {
  if (extrusion_side == 15) {
    //% extrusion(MakerbeamXL, length); // very different from makerbeam xl
    extrusion_makerbeam_xl(length);
  } else if (extrusion_side == 20) {
    //% extrusion_2020(length);
    extrusion(E2020t, length);
  } else {
    // wat
  }
}

module center_brace_anchor() {
  rounded_diam = 2;

  //top_of_vertical_brace = bottom_pos_z+extrusion_side+extrusion_main_length;
  top_of_vertical_brace = extrusion_main_length;

  dist_to_brace_x = -rear_z_offset_x;
  //dist_to_brace_y = motor_xy_pos_y-extrusion_vertical_spacing_y/2;
  dist_to_vertical_brace_y = -extrusion_side;
  dist_to_brace_y = motor_xy_pos_y-extrusion_vertical_spacing_y/2+rear_brace_offset_y;
  dist_to_brace_z = motor_xy_pos_z+xy_motor_plate_thickness-top_of_vertical_brace;
  thickness = max(xy_motor_plate_thickness,dist_to_brace_z);

  dist_to_belts = 0;

  module body() {
    hull() {
      translate([rear_z_offset_x,0,top_of_vertical_brace]) {
        translate([0,extrusion_vertical_spacing_y/2-extrusion_side,0]) {
          translate([0,0,dist_to_brace_z/2]) {
            rounded_cube(extrusion_side+rounded_diam,extrusion_side,dist_to_brace_z,rounded_diam);
          }
          translate([dist_to_brace_x,dist_to_brace_y+extrusion_side,dist_to_brace_z]) {
            translate([0,0,-thickness/2]) {
              rounded_cube(center_brace_width,extrusion_side+dist_to_belts,thickness,rounded_diam);
            }
          }
        }

      }
    }
  }

  module holes() {
    translate([rear_z_offset_x,extrusion_vertical_spacing_y/2,top_of_vertical_brace]) {
      translate([0,dist_to_vertical_brace_y,dist_to_brace_z]) {
        translate([0,0,-dist_to_brace_z+frame_anchor_plastic_thickness]) {
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
        translate([0,0,-frame_anchor_plastic_thickness]) {
          for(x=[left,right]) {
            translate([x*(center_brace_width*0.3),0,0]) {
              hole(m3_through_hole_diam,50+thickness*2,resolution);
              rotate([0,180,0]) {
                bridged_hole(m3_head_diam,m3_through_hole_diam);
              }
                //hole(m3_head_diam,(20)*2,resolution);
                //hole(0.1,(dist_to_brace_z-thickness+m3_head_diam)*2,resolution);
              hull() {
              }
            }
          }
        }
        wiring_hole_depth = dist_to_belts-wall_thickness*2;
        translate([0,extrusion_side/2+wiring_hole_depth/2,0]) {
          //rounded_cube(center_brace_width-wall_thickness*4,wiring_hole_depth,thickness*10,1);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module half_rail_nut_bar(rail_type,rail_length,is_final) {
  screw_type = rail_screw(rail_type);
  screw_hole_diam = screw_radius(screw_type)*2;

  nut_type = screw_nut(screw_type);
  nut_diam = 2*nut_trap_flat_radius(nut_type);
  nut_height = 3;

  extrusion_slot_width = extrusion_channel_width(extrusion_main_type);
  //extrusion_wall_thickness = extrusion_spar_thickness(extrusion_main_type);
  extrusion_wall_thickness = extrusion_tab_thickness(extrusion_main_type);
  extrusion_cavity_width = extrusion_channel_width_internal(extrusion_main_type);
  extrusion_cavity_depth = 4;
  plastic_below_extrusion_surface = 1;
  nut_depth_below_extrusion_wall = 0.6;
  meat_below_extrusion = 1.6;

  echo("extrusion_wall_thickness: ", extrusion_wall_thickness);

  echo("screw_hole_diam: ", screw_hole_diam);
  echo("nut_diam: ", nut_diam);

  module body() {
    translate([rail_length/4,0,0]) {
      translate([0,0,-extrusion_wall_thickness/2-plastic_below_extrusion_surface]) {
        cube([rail_length/2-4,extrusion_slot_width-0.4,extrusion_wall_thickness],center=true);
      }
      hull() {
        translate([0,0,-extrusion_wall_thickness]) {
          translate([0,0,-meat_below_extrusion/2]) {
            cube([rail_length/2-4,extrusion_cavity_width-0.5,meat_below_extrusion],center=true);
          }
          translate([0,0,-extrusion_cavity_depth/2]) {
            cube([rail_length/2-4,5.5,extrusion_cavity_depth],center=true);
          }
        }
      }
    }
  }

  module holes() {
    rail_hole_positions(rail_type, rail_length) {
      translate([0,0,-extrusion_wall_thickness-nut_depth_below_extrusion_wall]) {
        rotate([0,0,90]) {
          rotate([0,180,0]) {
            bridged_hole(nut_diam,screw_hole_diam,30,is_final,6);
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

module assembly(pct_x,pct_y,pct_z) {
  /*
  // right side
  translate([extrusion_vertical_spacing_x/2+extrusion_side/2,0,-z_motor_side/2-3]) {
    rotate([0,90,0]) {
      % iec(IEC_320_C14_switched_fused_inlet);
    }
  }
  */

  // right side
  translate([left*(extrusion_vertical_spacing_x/2+extrusion_side/2),extrusion_main_length/2-30,-z_motor_side/2-3]) {
    rotate([0,-90,0]) {
      //% iec(IEC_320_C14_switched_fused_inlet);
    }
  }

  //translate([right*(extrusion_vertical_spacing_x/2-extrusion_side/2-22.3),10,12.2/2+extrusion_side/2]) {
  translate([right*(extrusion_vertical_spacing_x/2-extrusion_side/2-22.3-2),10,12.2/2+extrusion_side/2-2]) {
    rotate([0,0,90]) {
      rotate([180,0,0]) {
        //% color("orange") import("../../Voron-2/STLs/Electronics_Bay/wago_221-415_mount_3by5.stl");
      }
    }
  }
  // on bottom back rail towards left
  translate([left*(extrusion_vertical_spacing_x/2-extrusion_side/2-42),extrusion_vertical_spacing_y/2-extrusion_side/2-22.3,12.2/2+extrusion_side/2]) {
    rotate([0,0,180]) {
      rotate([180,0,0]) {
        //% color("orange") import("../../VoronUsers/printer_mods/BlueBear/Wago_221_mount/WAGO_221-413_3x3-mount-screw.stl");
      }
    }
  }
  // on bottom left rail towards back
  translate([left*(extrusion_vertical_spacing_x/2-extrusion_side/2-22.3),rear*(extrusion_vertical_spacing_x/2-extrusion_side/2-42),12.2/2+extrusion_side/2]) {
    rotate([0,0,-90]) {
      rotate([180,0,0]) {
        //% color("orange") import("../../VoronUsers/printer_mods/BlueBear/Wago_221_mount/WAGO_221-413_3x3-mount-screw.stl");
      }
    }
  }
  // on bottom right rail towards back
  translate([right*(extrusion_vertical_spacing_x/2-extrusion_side/2-22.3),rear*(extrusion_vertical_spacing_x/2-extrusion_side/2-42-30),12.2/2+extrusion_side/2]) {
    rotate([0,0,90]) {
      rotate([180,0,0]) {
        //% color("orange") import("../../VoronUsers/printer_mods/BlueBear/Wago_221_mount/WAGO_221-413_3x3-mount-screw.stl");
      }
    }
  }

  //pos_x = -x_rail_length/2+carriage_length(x_carriage)+pct_x*printer_config[BUILD_DIMENSIONS][x];
  //pos_y = pct_y*printer_config[BUILD_DIMENSIONS][y];
  //pos_z = pct_z*printer_config[BUILD_DIMENSIONS][z];
  //pos_x = -x_rail_length/2+x_carriage_width/2+pct_x*build_volume[x];
  pos_x = -build_volume[x]/2+pct_x*build_volume[x];
  pos_y = pct_y*build_volume[y]-x_axis_offset_y;
  pos_z = pct_z*build_volume[z];

  y_carriage_pos_y = y_rail_pos_y-y_rail_length/2+carriage_length(y_carriage)/2+pos_y;

  panel_thickness = 3;
  //side_panel_height = 332;
  side_panel_height = extrusion_vertical_length-9*2;
  panel_width = 212;

  frame_assembly();

  //echo("side_panel_height: ", side_panel_height);
  //echo("panel_width: ", panel_width);
  for(r=[0,90,180,270]) {
    rotate([0,0,r]) {
      //if (0) { //printed_height_extension_height > 0) {
      if (printed_height_extension_height > 0) {
        translate([extrusion_vertical_spacing_x-6.5,-extrusion_vertical_spacing_y-3.5,top_pos_z-80]) {
          rotate([0,0,90]) {
            % color("orange") import("./external/box-zero-Top_Corner_x4.stl");
          }
        }
      }
    }
  }

  z_axis_assembly(pos_z);
  for(x=[left,right]) {
    ab_pod_assembly(x,is_final);
  }
  y_axis_assembly(pos_y,is_final);

  module position_x_axis() {
    translate([0,x_axis_offset_y,gantry_pos_z+extrusion_side/2+carriage_height(y_carriage)]) {
      translate([0,y_carriage_pos_y,0]) {
        children();
      }
    }
  }

  position_x_axis() {
    translate([0,carriage_length(y_carriage)/2-x_carriage_offset_space/2,extrusion_side/2+x_extrusion_above_y_carriage]) {
      translate([0,-x_carriage_offset_space/2,0]) {
        rotate([90,0,0]) {
          % rail(x_rail,x_rail_length);
        }
        translate([pos_x,0,0]) {
          rotate([90,0,0]) {
            % carriage(x_carriage);
          }
          translate([0,1,0]) {
            translate([0,0,-extrusion_side/2]) {
              translate([0,-nozzle_x_extrusion_dist_y,-nozzle_x_extrusion_dist_z+1]) {
                % color("red") hole(1.5,2,resolution);
              }
            }
            translate([0,front*(15/2+carriage_height(x_carriage)),0]) {
              rotate([-90,0,0]) {
                % color("orange") import("../Pandoras_Box/STLs/Gantry/x_carriage.stl");
              }
            }
            % color("lightblue") toolhead();
          }
        }
      }
    }
  }

  module belt_path(side,belt_tension_amount=0) {
    anchor_for = [-pos_x,0,pos_x];
    color_for = ["blue", 0, "red"];

    x_carriage_pos_x = anchor_for[side+1];
    x_carriage_pos_y = y_carriage_pos_y+x_carriage_offset_y;

    xy_carriage_pos_x = front_idler_pos_x;
    xy_front_idler_pos_y = x_carriage_pos_y-effective_radius+x_axis_offset_y;
    xy_rear_idler_pos_y = xy_front_idler_pos_y+xy_carriage_bearing_dist_y;
    xy_carriage_pos_y = y_carriage_pos_y;

    belt_points = [
      [x_carriage_pos_x+10,x_carriage_pos_y+x_axis_offset_y,0],
      [xy_front_idler_pos_x,xy_front_idler_pos_y,f623_2x_idler],
      //[front_idler_clearance_pos_x+effective_radius,front_idler_clearance_pos_y,0],
      [front_idler_clearance_pos_x+effective_radius,front_idler_clearance_pos_y,0],
      [xy_front_idler_pos_x,front_idler_clearance_pos_y,f623_2x_idler],
      [front_idler_pos_x,front_idler_pos_y,f623_2x_idler],
      [outer_idler_pos_x,outer_idler_pos_y,f623_2x_idler],
      //[motor_xy_pos_x,motor_xy_pos_y,xy_pulley_type],
      [non_motor_idler_pos_x,non_motor_idler_pos_y,f623_2x_idler],
      [motor_xy_pos_x-belt_tension_amount,motor_xy_pos_y,xy_pulley_type],
      //[motor_xy_pos_x,motor_xy_pos_y,GT2x20_pulley],
      [rear_idler_pos_x,rear_idler_pos_y,f623_2x_idler],
      [-rear_idler_pos_x,rear_idler_pos_y,f623_2x_idler],
      //[-non_motor_idler_pos_x,non_motor_idler_pos_y,f623_2x_idler,"solo"],
      [-non_motor_idler_pos_x,non_motor_idler_pos_y,f623_2x_idler],
      [-outer_idler_pos_x,outer_idler_pos_y,f623_2x_idler],
      [-front_idler_pos_x,xy_rear_idler_pos_y,f623_2x_idler],
      [x_carriage_pos_x-10,x_carriage_pos_y+x_axis_offset_y,0],
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
  //% belt_path(right,motor_xy_adjustment_amount);

  translate([0,0,gantry_pos_z-15/2]) {
    rotate([0,0,0]) {
      // probe_assembly();
    }
  }

  electronics_assembly();
}
