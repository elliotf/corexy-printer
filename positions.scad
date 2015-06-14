include <config.scad>;
include <boxcutter.scad>;
use <util.scad>;

sheet_opacity          = 0.4;
sheet_opacity          = 1;

spool_diam = 18;
spool_len  = 25.5;

line_bearing_mount_thickness = 5;
bearing_body_thickness = line_bearing_thickness+spacer*2+wall_thickness*5;
echo("bearing_body_thickness:", bearing_body_thickness);
bearing_body_depth     = line_bearing_diam+spacer+wall_thickness*2;
bearing_body_diam      = line_bearing_nut_diam+wall_thickness*3;

x_rod_spacing        = y_bearing_diam + min_material_thickness * 2 + y_rod_diam;
x_rod_spacing        = lm8luu_bearing_diam + min_material_thickness * 2 + y_rod_diam;
x_carriage_width     = 45; // lm8luu
x_carriage_width     = x_bearing_len + min_material_thickness * 2;

y_carriage_line_bearing_y = x_rod_diam/2+line_bearing_inner/2 + min_material_thickness;
y_carriage_line_bearing_z = x_rod_spacing/2-rod_diam/2-min_material_thickness*3-line_bearing_washer_thickness*1.5-line_bearing_thickness;
y_carriage_line_bearing_z = 0;
y_line_bearing_from_rod   = 3;
y_carriage_width          = y_bearing_diam/2 + min_material_thickness*2 + spacer + line_bearing_diam;
y_carriage_depth          = (y_carriage_line_bearing_y + line_bearing_nut_diam/2 + min_material_thickness*2)*2;
y_carriage_height         = x_rod_spacing+rod_diam+min_material_thickness*4;
y_carriage_space          = y_carriage_line_bearing_y*2+line_bearing_diam;

x_rod_len            = build_x + x_carriage_width + y_carriage_width*2 + spacer*2 + bearing_diam + 15; // fill out 24x18 sheet

bottom_line_pos_y = y_carriage_line_bearing_y-line_bearing_effective_diam/2;
bottom_line_pos_z = y_carriage_line_bearing_z-(line_bearing_washer_thickness/2+line_bearing_thickness/2);
bottom_line_pos_z = y_carriage_line_bearing_z-(line_bearing_washer_thickness/2+line_bearing_thickness/2);

top_line_pos_y = bottom_line_pos_y + line_bearing_effective_diam;
top_line_pos_z = bottom_line_pos_z + line_bearing_thickness + line_bearing_washer_thickness;

tuner_pos_x          = 9.5;
tuner_pos_y          = top_line_pos_y+2.5;
tuner_shoulder_pos_z = top_line_pos_z+22.5;

hotend_y    = (x_bearing_diam/2 + wall_thickness + spacer + hotend_diam/2)*front;
hotend_z    = tuner_shoulder_pos_z;
hotend_z    = -x_rod_spacing/2-x_bearing_diam/2+hotend_dist_to_heatsink_bottom;

top_rear_brace_depth = z_motor_shaft_len - belt_width/2 + z_bearing_diam/2;
y_rod_len       = hotend_diam/2 + build_y + hotend_diam/2 + abs(hotend_y) + top_rear_brace_depth + sheet_thickness*2 - 7;
y_rod_x         = x_rod_len/2 - y_bearing_diam/2;

y_carriage_line_bearing_x = y_rod_x - y_carriage_width + line_bearing_diam/2;

min_sheet_material = 3;

top_of_sheet = x_rod_spacing/2;
hotend_sheet_clearance = (hotend_z-hotend_len-top_of_sheet-sheet_thickness*2)*bottom;

heatbed_and_glass_thickness = 4;
build_pos_x = 0;
build_pos_z = hotend_z-hotend_len-build_z/2-1;
build_base_z = build_pos_z-build_z/2-heatbed_and_glass_thickness-sheet_thickness/2;

space_between_y_rod_and_sheet = y_bearing_diam/2 + 4;
side_sheet_pos_x = y_rod_x + space_between_y_rod_and_sheet + sheet_thickness/2;
side_sheet_pos_y = 0;

z_axis_overhead   = sheet_thickness + heatbed_and_glass_thickness;
z_axis_height     = z_axis_overhead + z_bearing_len*2 + z_bearing_spacing;
z_axis_height     = build_y*.5;
z_bearing_spacing = z_axis_height-z_bearing_len*2;

front_sheet_width  = side_sheet_pos_x*2 - sheet_thickness;
rear_sheet_width   = front_sheet_width;
top_sheet_pos_z    = -y_carriage_height/2-5-sheet_thickness/2;
bottom_sheet_pos_z = build_pos_z - build_z/2 - z_axis_overhead - z_axis_height - sheet_thickness/2 - 4;
z_rod_len          = (top_sheet_pos_z - bottom_sheet_pos_z) + sheet_thickness;
sheet_height       = top_of_sheet - bottom_sheet_pos_z - sheet_thickness/2;
side_sheet_height  = sheet_height;
sheet_pos_y        = y_rod_len/2-sheet_thickness/2;
sheet_pos_z        = top_of_sheet-sheet_height/2;
side_sheet_pos_z   = sheet_pos_z;
top_sheet_depth    = sheet_pos_y*2-sheet_thickness;
side_sheet_depth   = sheet_pos_y*2 - sheet_thickness;
top_sheet_width    = side_sheet_pos_x*2 - sheet_thickness;

z_rod_sheet_dist_y = (z_motor_shaft_len - belt_width/2 - sheet_thickness);
z_rod_pos_x  = heatbed_hole_spacing_x/2-sheet_thickness/2;
z_rod_pos_x  = build_x/2-z_bearing_diam;
z_rod_pos_y  = rear*sheet_pos_y - sheet_thickness/2 - z_rod_sheet_dist_y;
z_rod_pos_z  = bottom_sheet_pos_z - sheet_thickness/2 + z_rod_len/2;

z_side_brace_pos_x = 0;
z_idler_sheet_dist_y            = z_line_bearing_diam/2+belt_thickness*2+spacer*3;
z_idler_sheet_dist_z            = z_line_bearing_diam/2+belt_thickness*4+spacer*4;
z_carriage_idler_sheet_dist_y   = z_idler_sheet_dist_y + z_line_bearing_diam/2 + belt_thickness + z_line_bearing_diam/2;

z_line_bearing_dist_from_sheet   = sheet_pos_y - z_rod_pos_y - sheet_thickness/2; // - z_rod_diam/2 - 1;
z_carriage_bearing_spacing       = (z_line_bearing_diam/2 + belt_thickness*2 + 1) *2;

/*
z_brace_screw_dist_from_corner = top_rear_brace_depth-wall_thickness-m3_nut_diam;
z_brace_screw_dist_from_corner = z_line_bearing_to_carriage_pos_z + 5/2 + wall_thickness + z_line_bearing_inner/2;
z_brace_screw_dist_from_corner = z_line_bearing_to_carriage_pos_z + z_line_bearing_inner/2 + wall_thickness + m3_nut_diam/2;
z_brace_screw_dist_from_corner = 21;
z_brace_body_width             = m3_nut_diam + wall_thickness*2;
z_brace_pos_x                  = z_line_bearing_thickness/2 + spacer*2 + z_brace_body_width/2;
*/
z_line_idler_bearing_pos_y   = sheet_pos_y - sheet_thickness/2 - z_line_bearing_dist_from_sheet;

z_printed_portion_height    = z_bearing_len*2 + z_bearing_spacing;
z_carriage_bearing_offset_z = -z_printed_portion_height*.4;
z_carriage_bearing_offset_z = -z_printed_portion_height*.5;
z_carriage_bearing_offset_y = (sheet_pos_y - sheet_thickness/2 - z_carriage_idler_sheet_dist_y) - z_rod_pos_y;
z_bearing_body_diam         = z_bearing_diam+wall_thickness*3;
z_bed_support_mount_width   = wall_thickness*3+m3_nut_thickness;
z_bed_support_mount_depth   = wall_thickness*4+m3_nut_thickness;
z_bed_support_pos_x         = z_rod_pos_x-z_bearing_body_diam/2+z_bed_support_mount_width+sheet_thickness/2;
z_support_arm_hole_count    = 4;
z_support_arm_hole_spacing  = z_printed_portion_height / (z_support_arm_hole_count + 1);

height_below_top_sheet = abs(-sheet_pos_z+top_sheet_pos_z + side_sheet_height/2);

z_belt_thickness_compensation = 1;

z_motor_pos_x            = left*(z_pulley_diam/2+z_line_bearing_diam/2+z_belt_thickness_compensation);
z_motor_pos_y            = rear*sheet_pos_y + sheet_thickness/2;
z_motor_pos_z            = bottom_sheet_pos_z + sheet_thickness/2 + motor_side/2;

z_idler_pulley_pos_x     = left*(z_idler_pulley_diam/2 + z_line_bearing_diam/2 + z_belt_thickness_compensation);
z_idler_pulley_pos_y     = z_line_idler_bearing_pos_y;
z_idler_pulley_pos_z     = top_sheet_pos_z-sheet_thickness/2-z_idler_pulley_diam;

main_opening_width  = y_rod_x*2 - y_carriage_width*2 - x_carriage_width*.25;
main_opening_depth  = top_sheet_depth - top_rear_brace_depth;
main_opening_height = min((sheet_height - top_rear_brace_depth),(sheet_height*.60));

build_pos_y = main_opening_depth - top_sheet_depth/2 - hotend_diam/2 - 5 - build_y/2;
echo("build_pos_y: ", build_pos_y);

x_pos = -build_x/2+build_x*0.0;
y_pos = (build_pos_y-build_y/2-hotend_y)+build_y*1.0;
z_pos = build_z*1.0+0;

handle_hole_width        = 125;
handle_hole_height       = 50;
handle_material_width    = 25;
handle_attachment_height = top_of_sheet - top_sheet_pos_z - sheet_thickness;

to_front_line_z           = y_carriage_line_bearing_z - line_bearing_washer_thickness/2 - line_bearing_thickness/2;
to_rear_line_z            = y_carriage_line_bearing_z + line_bearing_washer_thickness/2 + line_bearing_thickness/2;
to_front_line_z           = y_carriage_line_bearing_z + line_bearing_washer_thickness/2 + line_bearing_thickness/2;
to_rear_line_z            = y_carriage_line_bearing_z - line_bearing_washer_thickness/2 - line_bearing_thickness/2;
return_line_z             = to_front_line_z - line_bearing_effective_diam;
return_line_z             = top_sheet_pos_z + sheet_thickness/2 + 5;
return_line_x             = side_sheet_pos_x - sheet_thickness/2 - 3;
return_line_x             = y_rod_x + y_rod_diam/2;
opposite_to_motor_line_z  = to_rear_line_z - line_bearing_effective_diam*1.5;

xy_line_x   = y_carriage_line_bearing_x+line_bearing_effective_diam/2;

xy_motor_pos_x = side_sheet_pos_x - sheet_thickness/2 - spacer*3 - motor_side;
xy_motor_pos_x = xy_line_x - pulley_diam/2;
xy_motor_pos_y = front*sheet_pos_y + sheet_thickness/2;
xy_motor_pos_z = bottom_sheet_pos_z + sheet_thickness/2 + spacer*3 + motor_side/2;

endcap_side_screw_hole_pos_x = side_sheet_pos_x-y_rod_x;
endcap_side_screw_hole_pos_z = sheet_pos_z+sheet_height/2-bc_tab_from_end_dist-bc_tab_slot_pair_len/2;
endcap_top_screw_hole_pos_x  = top_sheet_width/2-y_rod_x-bc_tab_from_end_dist-bc_tab_slot_pair_len/2;
endcap_top_screw_hole_pos_z  = top_sheet_pos_z;

echo("X/Y/Z ROD LEN: ", x_rod_len, y_rod_len, z_rod_len);
echo("W/D/H: ", front_sheet_width, side_sheet_depth, sheet_height);
