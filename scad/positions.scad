include <config.scad>;

// rods
rod_z = belt_bearing_diam/2 + belt_bearing_groove_depth + screw_pad_height + spacer;
x_rod_z = rod_z;
y_rod_x = x_rod_len/2 + bearing_diam/2 + min_material_thickness;
y_rod_z_distance_to_x = 0;
y_rod_z = rod_z + y_rod_z_distance_to_x;

y_end_rear_rod_end_screw_y = y_clamp_len+screw_pad_outer_diam/2;

// idlers
xy_idler_x = y_rod_x - bearing_diam/2 - belt_bearing_diam/2 - min_material_thickness;
xy_idler_y = x_rod_spacing/2 - rod_diam/2 - belt_bearing_diam/2 - min_material_thickness/2;
xy_idler_z = x_rod_z + rod_diam/2 + min_material_thickness + belt_bearing_thickness/2 + spacer;

front_idler_x = xy_idler_x + belt_bearing_diam/2;
front_idler_x = xy_idler_x + belt_bearing_diam;
front_idler_y = -y_rod_len/2 - belt_bearing_inner/2 - min_material_thickness/2;
front_idler_z = xy_idler_z - belt_bearing_diam/2;
front_idler_z = xy_idler_z;

lower_rear_idler_x = front_idler_x - belt_bearing_diam/2;
lower_rear_idler_y = y_rod_len/2 - y_clamp_len + belt_bearing_diam/2;
lower_rear_idler_z = front_idler_z - belt_bearing_diam/2;

upper_rear_idler_x = lower_rear_idler_x;
upper_rear_idler_y = lower_rear_idler_y;
upper_rear_idler_z = xy_idler_z;

inner_rear_idler_x = xy_idler_x+belt_bearing_diam/2;
inner_rear_idler_y = y_rod_len/2+sheet_thickness+pulley_height/2;
inner_rear_idler_z = xy_idler_z;

outer_rear_idler_x = front_idler_x+belt_bearing_diam/2;
outer_rear_idler_x = front_idler_x+belt_bearing_diam*1.75;
outer_rear_idler_y = y_rod_len/2+belt_bearing_diam/2;
outer_rear_idler_z = xy_idler_z-2;

bed_zero = x_rod_z - (hotend_len - 10 - bearing_diam/2) - build_z;
side_panel_height = -1*bed_zero + motor_len + sheet_min_width;

// z axis
z_axis_smooth_threaded_dist_x = motor_side/2-rod_diam/2;
z_bearing_wrapper_thickness = min_material_thickness*1.5;
z_carriage_width = (z_axis_smooth_threaded_dist_x+z_bearing_diam/2+z_bearing_wrapper_thickness)*2;
z_carriage_depth = m5_nut_thickness+min_material_thickness*2;
z_carriage_height = z_bearing_len*2+min_material_thickness*3;

// need to calculate
top_sheet_to_z_threaded_dist_z = 8;

z_carriage_bolt_area_depth = z_carriage_depth*2+z_bearing_diam;
z_carriage_bolt_area_thickness = m5_nut_thickness+min_material_thickness*2;

z_threaded_rod_len = build_z+5+z_carriage_height;
z_threaded_rod_z = -top_sheet_to_z_threaded_dist_z - z_threaded_rod_len/2;
z_rod_len = z_threaded_rod_len + sheet_thickness + spacer + motor_shaft_len + top_sheet_to_z_threaded_dist_z;

z_rod_x = (top_sheet_width/2 - spacer*2 - zip_tie_thickness - z_bearing_diam/2);
z_rod_x = y_rod_x+z_bearing_diam/2+rod_diam;
z_rod_z = -z_rod_len/2+sheet_thickness;
z_motor_x = z_rod_x-z_axis_smooth_threaded_dist_x;

z_support_slot_height = z_carriage_height/4;
z_support_slot_len = z_carriage_width/2+sheet_thickness;
z_support_slot_len = z_carriage_width/4+sheet_thickness;
z_support_slots = [z_carriage_height/2-z_carriage_height/8,-z_carriage_height/4+z_carriage_height/8];

// in relation to the motor plate
z_carriage_x = -z_axis_smooth_threaded_dist_x/2;
z_carriage_x = 0;
z_carriage_y = z_bearing_diam/2+z_carriage_depth/2;

z_leadscrew_nut_body_height = m5_nut_thickness+min_material_thickness*2;
z_leadscrew_nut_body_diam = m5_nut_diam+min_material_thickness*2;

z_x_support_y = z_carriage_y+z_carriage_depth/2+sheet_thickness/2;
z_x_support_len = z_motor_x*2-z_carriage_width+z_support_slot_len*2;
z_y_support_x = (z_x_support_len-z_support_slot_len*2)/2+sheet_thickness/2;
z_y_support_x = z_motor_x-z_carriage_width/2-sheet_thickness/2;
z_y_support_len = build_y;

z_bed_support_width = z_y_support_x*2+sheet_thickness*2+3*2;
z_bed_support_depth = heatbed_depth+3*3;

z_axis_z = -z_rod_len+z_carriage_height/2+sheet_thickness+spacer;
z_motor_z = -z_threaded_rod_len/2-spacer-motor_shaft_len;

// sheets
top_sheet_opening_width = build_x + x_carriage_width;
top_sheet_opening_depth = build_y + x_carriage_depth*.7;
top_sheet_opening_depth = (y_rod_len/2-y_clamp_len-bearing_diam*1.5)*2;

box_width = (z_motor_x+z_carriage_width/2+spacer)*2;
box_depth = y_rod_len-sheet_thickness*1-y_clamp_len;
box_depth = y_rod_len;
box_height = -z_axis_z+z_carriage_height/2+motor_side+sheet_thickness;
box_y     = sheet_thickness/2+y_clamp_len/2;
box_y     = 0;

top_sheet_width = box_width;
top_sheet_depth = box_depth;

front_sheet_width  = box_width;
front_sheet_height = box_height;

side_sheet_depth  = box_depth;
side_sheet_height = box_height;

rear_sheet_width  = box_width;
rear_sheet_height = box_height;

bottom_sheet_width  = box_width;
bottom_sheet_depth = box_depth;

top_sheet_x = 0;
top_sheet_y = box_y;
top_sheet_z = -sheet_thickness/2;

front_sheet_x = 0;
front_sheet_y = box_y-box_depth/2-sheet_thickness/2;
front_sheet_z = -front_sheet_height/2-sheet_thickness;

side_sheet_x = box_width/2+sheet_thickness/2;
side_sheet_y = box_y;
side_sheet_z = -side_sheet_height/2-sheet_thickness;

rear_sheet_x = 0;
rear_sheet_y = box_y+box_depth/2+sheet_thickness/2;
rear_sheet_z = -rear_sheet_height/2-sheet_thickness;

bottom_sheet_x = 0;
bottom_sheet_y = box_y;
bottom_sheet_z = -box_height-sheet_thickness*1.5;

side_sheet_x = top_sheet_width/2+sheet_thickness/2;

// motors
xy_motor_x = xy_idler_x+belt_bearing_diam/2+pulley_diam/2;
xy_motor_y = rear_sheet_y-sheet_thickness/2;
xy_motor_z = -sheet_thickness-motor_side;
xy_pulley_above_motor_plate = (xy_idler_z-belt_bearing_diam/2)-xy_motor_z;
xy_pulley_above_motor_plate = spacer*2+pulley_height/2;
xy_pulley_above_motor_plate = sheet_thickness+pulley_height/2;
xy_pulley_above_motor_plate = sheet_thickness+1;

xy_pulley_idler_x = xy_motor_x;
xy_pulley_idler_y = xy_motor_y;
xy_pulley_idler_z = xy_motor_z-motor_side;
xy_pulley_idler_hole = m5_diam;

function get_inner_rear_idler_angle_y(short,long) = atan(short/long);
inner_rear_idler_angle_y = get_inner_rear_idler_angle_y(inner_rear_idler_z-xy_motor_z-pulley_diam/2,inner_rear_idler_x+xy_motor_x);

outer_rear_idler_angle_x = 3; // TODO: use trig to get angle?
outer_rear_idler_angle_x = 0; // TODO: use trig to get angle?
function get_outer_rear_idler_angle_y(short,long) = atan(short/long);
outer_rear_idler_angle_y = get_outer_rear_idler_angle_y(outer_rear_idler_x-xy_motor_x+pulley_diam/2,outer_rear_idler_z-xy_motor_z);

y_end_body_width = screw_pad_width;
y_end_body_depth = y_clamp_len + min_material_thickness + belt_bearing_inner + min_material_thickness*2;
y_end_body_height = y_rod_z + rod_diam/2 + min_material_thickness; //idler_clearance + rod_diam/2 + y_rod_z;
