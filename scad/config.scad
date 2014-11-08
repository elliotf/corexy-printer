// All hail whosawhatsis
da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

approx_pi = 3.14159;
approx_pi = 3.14159265359;

// make coordinates more communicative
left  = -1;
right = 1;
front = -1;
rear  = 1;
top = 1;
bottom  = -1;

x = 0;
y = 1;
z = 2;

// material dimensions
zip_tie_width = 3;
zip_tie_thickness = 2;
line_diam = .5;
line_cube = [line_diam,line_diam,line_diam];

// Printer size
build_x = 600;
build_y = 600;
build_z = 600;

build_x = 200;
build_y = 200;
build_z = 200;

/*
build_x = 150;
build_y = 150;
build_z = 150;
*/

build_x = 100;
build_y = 100;
build_z = 100;

build_x = 50;
build_y = 50;
build_z = 50;

//build_z = -40; // minimal box size for testing

hotend_len = 51;
hotend_diam = 16;

// Linear bearings and rods
// should record bearing groove offset, depth, width

// lm10uu, M10 rods
lm10uu_bearing_diam = 19;
lm10uu_bearing_len  = 29;
lm10uu_bearing_groove_spacing = 0;
lm10uu_bearing_groove_width = 0;
lm10uu_bearing_groove_depth = 0;
lm10uu_rod_diam = 10;

// lm8uu, M8 rods
lm8uu_bearing_diam = 15;
lm8uu_bearing_len  = 24;
lm8uu_bearing_groove_spacing = 0;
lm8uu_bearing_groove_width = 0;
lm8uu_bearing_groove_depth = 0;
lm8uu_rod_diam = 8;

// lm6uu, M6 rods
lm6uu_bearing_diam = 12;
lm6uu_bearing_len  = 19;
lm6uu_bearing_groove_spacing = 12.25;
lm6uu_bearing_groove_width = .5;
lm6uu_bearing_groove_depth = .2;
lm6uu_rod_diam = 6;

bearing_diam           = lm10uu_bearing_diam;
bearing_len            = lm10uu_bearing_len;
bearing_groove_spacing = lm10uu_bearing_groove_spacing;
bearing_groove_width   = lm10uu_bearing_groove_width;
bearing_groove_depth   = lm10uu_bearing_groove_depth;
rod_diam               = lm10uu_rod_diam;

bearing_diam           = lm8uu_bearing_diam;
bearing_len            = lm8uu_bearing_len;
bearing_groove_spacing = lm8uu_bearing_groove_spacing;
bearing_groove_width   = lm8uu_bearing_groove_width;
bearing_groove_depth   = lm8uu_bearing_groove_depth;
rod_diam               = lm8uu_rod_diam;

bearing_diam           = lm6uu_bearing_diam;
bearing_len            = lm6uu_bearing_len;
bearing_groove_spacing = lm6uu_bearing_groove_spacing;
bearing_groove_width   = lm6uu_bearing_groove_width;
bearing_groove_depth   = lm6uu_bearing_groove_depth;
rod_diam               = lm6uu_rod_diam;
/*
*/

// if you'd like the z axis to use different rods/bearings
z_bearing_diam           = bearing_diam;
z_bearing_len            = bearing_len;
z_bearing_groove_spacing = bearing_groove_spacing;
z_bearing_groove_width   = bearing_groove_width;
z_bearing_groove_depth   = bearing_groove_depth;
z_rod_diam               = rod_diam;

// endstop dimensions
endstop_len = 20;
endstop_width = 6;
endstop_height = 8;
endstop_hole_spacing = 10;
endstop_hole_diam = 2;
endstop_hole_from_top = 5;

// Screws, nuts
m3_diam = 3;
m3_nut_diam  = 5.5;
m3_nut_thickness  = 3;
m5_diam = 5;
m5_nut_diam = 8;
m5_nut_thickness = 5;

// Groove bearings
belt_bearing_diam = 15;
belt_bearing_groove_depth = .5;
belt_bearing_inner = m5_diam;
belt_bearing_thickness = 5;
belt_bearing_nut_diam = m5_nut_diam;
belt_bearing_nut_thickness = m5_nut_thickness;

pulley_idler_bearing_diam = 16;
pulley_idler_bearing_inner = 5;
pulley_idler_bearing_thickness = 5;

// Motor
nema17_side = 43;
nema17_len = nema17_side;
nema17_hole_spacing = 31;
nema17_screw_diam = m3_diam;
nema17_shaft_diam = 5;
nema17_shaft_len = 22;

nema14_side = 35.3;
nema14_len = nema14_side;
nema14_hole_spacing = 26;
nema14_screw_diam = m3_diam;
nema14_shaft_diam = 5;
nema14_shaft_len = 20;

motor_side = nema17_side;
motor_len = motor_side;
motor_hole_spacing = nema17_hole_spacing;
motor_screw_diam = nema17_screw_diam;
motor_shaft_diam = nema17_shaft_diam;
motor_shaft_len = nema17_shaft_len;
motor_wire_hole_width = 9;
motor_wire_hole_height = 6;

z_motor_side = nema14_side;
z_motor_len = z_motor_side;
z_motor_hole_spacing = nema14_hole_spacing;
z_motor_screw_diam = nema14_screw_diam;
z_motor_shaft_diam = nema14_shaft_diam;
z_motor_shaft_len = nema14_shaft_len;

z_motor_side = nema17_side;
z_motor_len = z_motor_side;
z_motor_hole_spacing = nema17_hole_spacing;
z_motor_screw_diam = nema17_screw_diam;
z_motor_shaft_diam = nema17_shaft_diam;
z_motor_shaft_len = nema17_shaft_len;

// Frame sheet
sheet_thickness = 6;
sheet_min_width = 30;
sheet_shoulder_width = 3; // material to have on the far side of a slot
sheet_screw_diam = m3_diam;
sheet_screw_nut_diam = m3_nut_diam;
sheet_screw_nut_thickness = m3_nut_thickness;
sheet_hole_resolution = 36;
sheet_hole_resolution = 8;

top_plate_screw_diam = sheet_screw_diam;

// Misc settings
min_material_thickness = 2;
spacer = 1;
clamp_gap_width = spacer;
screw_pad_height = min_material_thickness*2;
screw_pad_outer_diam = top_plate_screw_diam+min_material_thickness*3;
screw_pad_hole_spacing = (rod_diam/2 + min_material_thickness*3 + top_plate_screw_diam/2) * 2;
screw_pad_width = screw_pad_hole_spacing + (top_plate_screw_diam/2 + min_material_thickness*2) * 2;

// Screws
clamp_screw_diam = m3_diam;
clamp_screw_nut_diam = m3_nut_diam;
clamp_screw_nut_thickness = m3_nut_thickness;
clamp_area_width = clamp_screw_diam+min_material_thickness*2;

// Printer settings
y_clamp_len = 10; // amount of bar to clamp onto
x_rod_spacing = 40 + rod_diam;
x_rod_spacing = bearing_len * 2 + min_material_thickness * 2;
x_carriage_width = bearing_len * 2 + 10 + min_material_thickness*4;
x_carriage_width = bearing_len * 2 + min_material_thickness*3;
x_carriage_depth = x_rod_spacing + bearing_diam;

// calculated rod lengths
x_rod_len = build_x + x_carriage_width + belt_bearing_diam*2 + min_material_thickness;
y_rod_len = build_y + x_rod_spacing + rod_diam + min_material_thickness*2 + y_clamp_len*2;
//x_rod_len = 270; // have avail
//y_rod_len = 265; // have avail

echo("X/Y rod len: ", x_rod_len, y_rod_len);

// tuner dimensions (pull out into a different file)
tuner_shoulder_width = 10;
tuner_shoulder_diam  = 10;
tuner_shaft_diam     = 6;
tuner_hole_to_shoulder = 22.5;
tensioner_angle = 45;

// Power supply
psu_length = 215;
psu_width = 114;
psu_height = 50;

// Pulley
pulley_diam = 20;
pulley_diam = 64/approx_pi; // 32 =~ 16T GT2, 40 =~ 20T GT2
pulley_height = belt_bearing_diam;
pulley_height = 13;

pulley_idler_height = pulley_height;
pulley_idler_diam = pulley_idler_bearing_diam + min_material_thickness*4;
pulley_idler_shaft_diam = m5_diam;
pulley_idler_shaft_nut_diam = m5_nut_diam;
pulley_idler_shaft_nut_thickness = m5_nut_thickness;
pulley_idler_shaft_support_len = pulley_height;

// heated bed / build plate
heatbed_thickness = 1;
heatbed_hole_spacing_x = build_x+9;
heatbed_hole_spacing_y = build_y+9;
heatbed_hole_diam = 3;
heatbed_width = build_x+14;
heatbed_depth = build_y+14;
