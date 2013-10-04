include <config.scad>;

// rods
rod_z = belt_bearing_diam/2 + belt_bearing_thickness/2 + min_material_thickness*2;
x_rod_z = rod_z;
y_rod_x = x_rod_len/2 + bearing_diam/2 + min_material_thickness;
y_rod_z_distance_to_x = 0;
y_rod_z = rod_z + y_rod_z_distance_to_x;

// idlers
xy_idler_x = y_rod_x - bearing_diam/2 - belt_bearing_diam/2 - min_material_thickness;
xy_idler_y = belt_bearing_diam/2 + belt_bearing_inner/2;
xy_idler_y = x_rod_spacing/2+bearing_diam-22;
xy_idler_y = x_rod_spacing/2-rod_diam/2-belt_bearing_inner/2-min_material_thickness/2;
xy_idler_z = x_rod_z + belt_bearing_diam/2;
xy_idler_z = x_rod_z + belt_bearing_thickness/2 + spacer;
xy_idler_z = x_rod_z + rod_diam/2 + min_material_thickness + belt_bearing_thickness/2 + spacer;
xy_idler_z = x_rod_z + bearing_diam/2 + tuner_shoulder_diam/2 - tuner_shaft_diam/2;

front_idler_x = xy_idler_x + belt_bearing_diam/2;
front_idler_y = -y_rod_len/2 - belt_bearing_inner/2 - min_material_thickness/2;
front_idler_z = xy_idler_z - belt_bearing_diam/2;

lower_rear_idler_x = front_idler_x - belt_bearing_diam/2;
lower_rear_idler_y = y_rod_len/2 - y_clamp_len + belt_bearing_diam/2;
lower_rear_idler_z = front_idler_z - belt_bearing_diam/2;

upper_rear_idler_x = lower_rear_idler_x;
upper_rear_idler_y = lower_rear_idler_y;
upper_rear_idler_z = xy_idler_z;

// motors
xy_motor_x = y_rod_x-motor_side/2-sheet_thickness/2 - spacer;
xy_motor_y = y_rod_len/2 + motor_side/2 + sheet_thickness/2 + spacer;
xy_motor_z = -sheet_thickness;
