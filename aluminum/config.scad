include <NopSCADlib/lib.scad>;
include <lumpyscad/lib.scad>; 

bevel_height = 0.8;

extrude_width = 0.4;
extrude_height = 0.2;

size = 0; // Voron Zero size
//size = 1; // ~200mm build volume cubed

//scale_by = 0.7;
scale_by = 1;

x_rail_type = MGN7;
x_carriage_type = MGN7H_carriage;
//x_rail_type = MGN9;
//x_carriage_type = MGN9C_carriage;

yz_rail_type = MGN7;
yz_carriage_type = MGN7H_carriage;
//yz_rail_type = MGN9;
//yz_carriage_type = MGN9C_carriage;

rounded_diam = 3;

sizes = [
  [
    [
      200, //spar_main_len             
      300, //spar_vertical_len         
      50,   //spar_vertical_added_space 
      200, //spar_zed_len              
      200, //spar_bed_across_len       
      100, //spar_bed_depth_len        
    ],
    [
      120, // build_volume_x
      120, // build_volume_y
      120, // build_volume_z
    ],
    [
      NEMA14_52, // XY motor
    ],
    [
      150, // x rail length
      150, // y rail length
      150, // z rail length
    ]
  ],
  [
    [
      300, //spar_main_len             
      500, //spar_vertical_len         
      0,   //spar_vertical_added_space 
      300, //spar_zed_len              
      300, //spar_bed_across_len       
      175, //spar_bed_depth_len        
    ],
    [
      200, // build_volume_x
      200, // build_volume_y
      200, // build_volume_z
    ],
    [
      NEMA17_47, // XY motor
    ],
    [
      250, // x rail length
      250, // y rail length
      250, // z rail length
    ],
  ],
];

spar_main_len             = sizes[size][0][0];
spar_vertical_len         = sizes[size][0][1];
spar_vertical_added_space = sizes[size][0][2];
spar_zed_len              = sizes[size][0][3];
spar_bed_across_len       = sizes[size][0][4];
spar_bed_depth_len        = sizes[size][0][5];

build_volume_x = sizes[size][1][0];
build_volume_y = sizes[size][1][1];
build_volume_z = sizes[size][1][2];

z_idler_type = f695_2x_idler;
//z_frame_idler_type = f695_2x_idler;
z_frame_idler_type = mr105f_2x_idler;

extrusion_side = 15; // makerbeam xl
belt_thickness = 2; // FIXME
belt_width = 6;
pi_approx = 3.141592;
z_pulley_type = GT2x16_pulley;
z_pulley_rotation_distance = 16*2;
z_pulley_diam = (z_pulley_rotation_distance/pi_approx);
//z_pulley_diam = pulley_offset(z_pulley_type)*2;
z_idler_id = 3; // F623
z_idler_od = 10; // F623
z_frame_idler_id = pulley_bore(z_frame_idler_type); // F695
z_frame_idler_od = pulley_od(z_frame_idler_type); // F695
z_idler_width = 8; // F623
z_idler_flange_width = 1; // F623
z_idler_flange_height = 1; // F623

z_motor = NEMA17_47;
z_motor_side = NEMA_width(z_motor);

overall_depth = spar_main_len+extrusion_side*2;
overall_width = spar_main_len+extrusion_side*2;

//xy_motor = NEMA14_52;
xy_motor = sizes[size][2][0];
//xy_motor = z_motor;
xy_motor_side = NEMA_width(xy_motor);
xy_pulley_type = GT2x16_pulley;
xy_pulley_rotation_distance = 16*2;
xy_pulley_diam = (xy_pulley_rotation_distance/pi_approx);

front_rear_extrusion_length = spar_main_len*scale_by;
side_extrusion_length = spar_main_len*scale_by;
corner_extrusion_length = spar_vertical_len*scale_by;

bottom_pos_z = 45+extrusion_side/2;

corner_pos_x = side_extrusion_length/2+extrusion_side/2;
corner_pos_y = front_rear_extrusion_length/2+extrusion_side/2;
corner_pos_z = bottom_pos_z-extrusion_side/2+corner_extrusion_length/2;
z_support_extrusion_length = spar_main_len*scale_by;

xy_motor_space_behind = 1;
xy_motor_space_in_front = 0.5;
ab_pod_depth = xy_motor_side-15+xy_motor_space_behind+xy_motor_space_in_front;
echo("ab_pod_depth: ", ab_pod_depth);
rear_support_pos_y = side_extrusion_length/2-ab_pod_depth-extrusion_side/2;

xy_motor_adjust_range = 12;
xy_motor_dist_from_side = xy_motor_side/2+20; // ~76mm of space between tension adjustment nuts
xy_motor_pos_x = corner_pos_x-extrusion_side/2-xy_motor_dist_from_side;
xy_motor_pos_y = rear_support_pos_y+xy_motor_side/2+extrusion_side/2+xy_motor_space_in_front;

xy_idler_id = z_idler_id;
xy_idler_od = z_idler_od;
xy_idler_width = z_idler_width;
xy_idler_bevel_small = xy_idler_id+extrude_width*2*2;
xy_idler_bevel_large = xy_idler_id+extrude_width*2*2+bevel_height*2;
xy_belt_idler_outer_pos_x = spar_main_len/2+extrusion_side-7.5;
xy_belt_idler_dist_from_end = 7.5;
xy_belt_carriage_inner_dist_to_outside = 18.880;
xy_belt_idler_inner_pos_x = spar_main_len/2+extrusion_side-xy_belt_carriage_inner_dist_to_outside;
//xy_belt_rear_corner_cut_dist_x = spar_main_len/2-xy_motor_pos_x-xy_motor_side/2-8;
//xy_belt_idler_rear_pos_x = spar_main_len/2-xy_belt_rear_corner_cut_dist_x;
xy_belt_idler_rear_pos_x = spar_main_len/2-xy_belt_idler_dist_from_end-4;
//xy_belt_rear_corner_cut_dist_y = 18; // drive this off of the pulley diam?
//xy_belt_idler_rear_left_pos_y = spar_main_len/2-xy_belt_rear_corner_cut_dist_y;
xy_belt_idler_rear_left_pos_y = xy_motor_pos_y-10/2-xy_pulley_diam/2-3;
xy_belt_idler_extra_pos_x = spar_main_len/2-xy_belt_idler_dist_from_end;
xy_belt_idler_extra_pos_y = xy_motor_pos_y-2; // corner cutting idler

// xy_belt_carriage_outer_dist_to_outside = 7.5;
// xy_belt_front_idler_dist_to_outside = belt_carriage_outer_dist_to_outside;
xy_belt_upper_dist_from_extrusion = 21;
xy_belt_lower_dist_from_extrusion = 12;
//
x_extrusion_dist_from_y_extrusion_z = 7;

head_pos_x = 0;
head_pos_y = 0;

top_pos_z = corner_pos_z+corner_extrusion_length/2-extrusion_side/2 + spar_vertical_added_space;
xy_pos_z = bottom_pos_z+z_support_extrusion_length+extrusion_side;

z_support_pos_z = bottom_pos_z+extrusion_side/2+z_support_extrusion_length/2;
//z_support_side_pos_y = front*(side_extrusion_length/2-extrusion_side-build_volume_y*0.35);
//z_support_side_pos_y = rear_support_pos_y-7.5-spar_bed_depth_len-extrusion_side/2;
//z_support_side_pos_y = -corner_pos_y+extrusion_side+25;
z_support_beam_x_offset = 0; // carriage_width(yz_carriage_type)/2+extrusion_side/2+1;
z_support_beam_rear_x_offset = carriage_width(yz_carriage_type)/2+extrusion_side/2+1;
z_support_beam_rear_bed_offset_y = -15;
z_support_beam_side_x_offset = carriage_width(yz_carriage_type)/2+extrusion_side/2+1;
z_support_side_pos_y = rear_support_pos_y-extrusion_side/2-carriage_height(yz_carriage_type)+z_support_beam_rear_bed_offset_y-spar_bed_depth_len-extrusion_side/2+z_support_beam_side_x_offset;//+carriage_width(yz_carriage_type)/2;
//z_support_side_pos_y = rear_support_pos_y-extrusion_side/2-spar_bed_depth_len-extrusion_side/2;

//y_rail_length = corner_pos_y+rear_support_pos_y-extrusion_side-10;
//y_rail_length = 150*scale_by;
x_rail_len = sizes[size][3][0]*scale_by;
y_rail_length = sizes[size][3][1]*scale_by;
//y_rail_length = 250*scale_by;
echo("y_rail_length: ", y_rail_length);
echo("hello?");

y_rail_pos_y = rear_support_pos_y-extrusion_side/2-y_rail_length/2;

z_rail_length = z_support_extrusion_length-50;
//z_rail_top_pos_z = bottom_pos_z+extrusion_side/2+20+z_rail_length;
z_rail_top_pos_z = xy_pos_z-extrusion_side/2-15;

//yz_rail_type = MGN9;
//yz_carriage_type = MGN9C_carriage;

