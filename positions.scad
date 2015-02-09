include <config.scad>;
include <boxcutter.scad>;
use <util.scad>;

sheet_opacity          = 0.4;
sheet_opacity          = 1;

spool_diam = 18;
spool_len  = 25.5;

x_rod_spacing        = bearing_diam + min_material_thickness * 2 + rod_diam;
x_carriage_width     = bearing_len + min_material_thickness * 2;
x_carriage_width     = 45;

y_carriage_belt_bearing_y = rod_diam/2+belt_bearing_inner/2 + min_material_thickness;
y_carriage_belt_bearing_z = -rod_diam/2-belt_bearing_inner/2+belt_bearing_effective_diam/2;
y_carriage_belt_bearing_z = -x_rod_spacing/2+rod_diam/2+min_material_thickness*3+belt_bearing_washer_thickness*1.5+belt_bearing_thickness;
y_belt_bearing_from_rod   = 3;
y_carriage_width          = bearing_diam/2 + min_material_thickness*2 + spacer + belt_bearing_diam;
y_carriage_depth          = (y_carriage_belt_bearing_y + belt_bearing_nut_diam/2 + min_material_thickness*2)*2;
y_carriage_height         = x_rod_spacing+rod_diam+min_material_thickness*4;
y_carriage_space          = y_carriage_belt_bearing_y*2+belt_bearing_diam;

x_rod_len            = build_x + x_carriage_width + y_carriage_width*2 + spacer*2 + bearing_diam;// + 40; // fill out 24x18 sheet
x_carriage_height    = x_rod_spacing + bearing_diam + min_material_thickness*2;
x_carriage_thickness = bearing_diam;

hotend_y    = (bearing_diam/2 + wall_thickness + spacer + hotend_diam/2)*front;
hotend_z    = x_carriage_height/2 + -hotend_len/2 + hotend_clamped_height;

top_rear_brace_depth = z_motor_shaft_len - belt_width/2 + z_bearing_diam/2;
y_rod_len       = hotend_diam/2 + build_y + hotend_diam/2 + abs(hotend_y) + top_rear_brace_depth + sheet_thickness*2;
y_rod_x         = x_rod_len/2 - bearing_diam/2;

y_carriage_belt_bearing_x = y_rod_x - y_carriage_width + belt_bearing_diam/2;

min_sheet_material = 3;

top_of_sheet = x_rod_spacing/2;
hotend_sheet_clearance = (hotend_z-hotend_len/2-top_of_sheet-sheet_thickness*2)*bottom;

build_pos_x = 0;
build_pos_z = hotend_z-hotend_len/2-build_z/2-1;

space_between_y_rod_and_sheet = bearing_diam/2 + 4;
side_sheet_pos_x = y_rod_x + space_between_y_rod_and_sheet + sheet_thickness/2;
side_sheet_pos_y = 0;

heatbed_and_glass_thickness = 4;

z_axis_overhead = sheet_thickness + heatbed_and_glass_thickness + motor_side;

front_sheet_width  = side_sheet_pos_x*2 - sheet_thickness;
rear_sheet_width   = front_sheet_width;
top_sheet_pos_z    = -y_carriage_height/2-5-sheet_thickness/2;
bottom_sheet_pos_z = build_pos_z - build_z/2 - z_axis_overhead - sheet_thickness/2; // - 35; // fill out 24x18 sheet
z_rod_len          = (top_sheet_pos_z - bottom_sheet_pos_z) + sheet_thickness;
sheet_height       = top_of_sheet - bottom_sheet_pos_z - sheet_thickness/2;
side_sheet_height  = sheet_height;
sheet_pos_y        = y_rod_len/2-sheet_thickness/2;
sheet_pos_z        = top_of_sheet-sheet_height/2;
side_sheet_pos_z   = sheet_pos_z;
top_sheet_depth    = sheet_pos_y*2-sheet_thickness;
side_sheet_depth   = sheet_pos_y*2 - sheet_thickness;
top_sheet_width    = side_sheet_pos_x*2 - sheet_thickness;

z_rod_pos_x  = max(build_x*0.33);
z_rod_pos_y  = rear*sheet_pos_y + sheet_thickness/2 - z_motor_shaft_len + belt_width/2;
z_rod_pos_z  = bottom_sheet_pos_z - sheet_thickness/2 + z_rod_len/2;

z_belt_bearing_diam      = 10;
z_belt_bearing_inner     = 3;
z_belt_bearing_thickness = 8; // F623ZZ * 2
z_pulley_diam  = (16*2)/approx_pi;
z_motor_pos_x  = z_belt_bearing_diam/2 + belt_thickness + z_pulley_diam/2;
z_motor_pos_y  = rear*sheet_pos_y + sheet_thickness/2;
z_motor_pos_z  = bottom_sheet_pos_z + sheet_thickness/2 + motor_side/2;// - (z_motor_side-z_motor_hole_spacing)/2 + z_motor_screw_diam/2 + 2;
z_idler_pos_z  = top_sheet_pos_z - sheet_thickness/2 - z_pulley_diam/2 - 3;

main_opening_width  = y_rod_x*2 - y_carriage_width*2 - x_carriage_width*.25;
main_opening_depth  = top_sheet_depth - top_rear_brace_depth;

build_pos_y = main_opening_depth - top_sheet_depth/2 - hotend_diam/2 - 5 - build_y/2;

x_pos = -build_x/2+build_x*0.0;
y_pos = (build_pos_y-build_y/2-hotend_y)+build_y*1.0;
z_pos = build_z*0+10;

handle_hole_width        = 125;
handle_hole_height       = 50;
handle_material_width    = 25;
handle_attachment_height = top_of_sheet - top_sheet_pos_z - sheet_thickness;

to_rear_line_z            = y_carriage_belt_bearing_z + belt_bearing_washer_thickness/2 + belt_bearing_thickness/2;
to_front_line_z           = y_carriage_belt_bearing_z - belt_bearing_washer_thickness/2 - belt_bearing_thickness/2;
return_line_z             = to_front_line_z + belt_bearing_effective_diam;
opposite_to_motor_line_z  = to_rear_line_z - belt_bearing_effective_diam*1.5;

top_line_z                = return_line_z;
mid_line_z                = to_rear_line_z;

xy_line_x   = y_carriage_belt_bearing_x+belt_bearing_effective_diam/2;
top_line_z  = y_carriage_belt_bearing_z-belt_bearing_washer_thickness/2-belt_bearing_thickness/2+belt_bearing_effective_diam;
mid_line_z  = y_carriage_belt_bearing_z+belt_bearing_washer_thickness/2+belt_bearing_thickness/2;

endcap_side_screw_hole_pos_x = side_sheet_pos_x-y_rod_x;
endcap_side_screw_hole_pos_z = sheet_pos_z+sheet_height/2-bc_tab_from_end_dist-bc_tab_slot_pair_len/2;
endcap_top_screw_hole_pos_x  = top_sheet_width/2-y_rod_x-bc_tab_from_end_dist-bc_tab_slot_pair_len/2;
endcap_top_screw_hole_pos_z  = top_sheet_pos_z;

bearing_body_thickness = belt_bearing_thickness+spacer*2+wall_thickness*5;
bearing_body_depth     = belt_bearing_diam+spacer+wall_thickness*2;
bearing_body_diam      = belt_bearing_nut_diam+wall_thickness*3;

echo("X/Y/Z ROD LEN: ", x_rod_len, y_rod_len, z_rod_len);
echo("W/D/H: ", front_sheet_width, side_sheet_depth, sheet_height);
