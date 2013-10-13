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
xy_idler_z = x_rod_z + belt_bearing_diam*.5;

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
xy_motor_x = -1*(xy_idler_x+belt_bearing_diam/2-pulley_diam/2);
xy_motor_x = -1*(y_rod_x-motor_hole_spacing/2); // motor acts as lower rear idler
xy_motor_x = -1*(xy_idler_x+belt_bearing_diam/2+pulley_diam/2); // motor acts as lower rear idler
xy_motor_y = y_rod_len/2 + motor_side/2 + sheet_thickness/2 + spacer;
xy_motor_y = y_end_rear_rod_end_screw_y + motor_hole_spacing/2 + y_rod_len/2;
xy_motor_z = -sheet_thickness;
xy_pulley_above_motor_plate = (xy_idler_z-belt_bearing_diam/2)-xy_motor_z;
xy_pulley_above_motor_plate = sheet_thickness+spacer+pulley_height/2;
echo("PULLEY ABOVE MOTOR: ", xy_pulley_above_motor_plate);

xy_pulley_idler_x = xy_motor_x-motor_hole_spacing/2;
xy_pulley_idler_y = xy_motor_y+motor_hole_spacing/2;

bed_zero = x_rod_z - (hotend_len - 10 - bearing_diam/2) - build_z;
side_panel_height = -1*bed_zero + motor_len + sheet_min_width;

z_motor_x  = y_rod_x-sheet_thickness/2-z_motor_side/2;
z_motor_y  = z_motor_side/2+z_carriage_width/2+sheet_thickness+spacer;
z_motor_z  = -build_z;
z_motor_z  = bed_zero - z_motor_len;

z_rod_x = z_motor_x;
z_rod_y = 0;
z_rod_z = -z_rod_len/2;

z_carriage_z = bed_zero-heatbed_thickness-sheet_thickness/2;

// sheets
top_sheet_width = xy_motor_x*-2+motor_side+spacer*2;
top_sheet_depth = y_rod_len+sheet_min_width+motor_side;

top_sheet_y  = motor_side/2;
side_sheet_x = top_sheet_width/2+sheet_thickness/2;
