da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

left  = -1;
right = 1;
front = -1;
rear  = 1;

build_x = 150;
build_y = 150;
build_z = 150;

// lm8uu, M8 rods
bearing_diam = 15;
bearing_len  = 24;
rod_diam = 8;

// lm6uu, M6 rods
bearing_diam = 12;
bearing_len  = 19;
rod_diam = 6;

belt_bearing_diam = 16;
belt_bearing_thickness = 5;

motor_side = 43;
motor_hole_spacing = 31;
pulley_diam = 18;
pulley_height = belt_bearing_diam + 8;
min_material_thickness = 2;

sheet_thickness = 6;
sheet_min_width = 30;
spacer = 4;

x_clamp_len = 10;
y_clamp_len = 20;
x_rod_spacing = 40;
x_carriage_width = bearing_len * 2 + 10;

clamp_screw_diam = 3;
clamp_screw_nut_diam = 5.5;

rod_z = rod_diam/2 + belt_bearing_diam/2 + belt_bearing_thickness/2 + spacer/2;

// X rods
x_rod_clamp_len = bearing_len*2 + spacer + min_material_thickness*2;
x_rod_len = build_x + x_clamp_len * 2 + x_carriage_width;
x_rod_z = rod_z;

// Y rods
y_rod_len = build_y + x_rod_spacing + sheet_min_width*2;
y_rod_x = x_rod_len/2 + bearing_diam/2;
//y_rod_z = x_rod_z + bearing_diam/2 + rod_diam/2 + min_material_thickness;
y_rod_z = rod_z;

module motor() {
  translate([0,0,-motor_side/2]) cube([motor_side,motor_side,motor_side],center=true);
  cylinder(r=5/2,h=motor_side,center=true);

  translate([0,0,sheet_thickness+pulley_height/2]) cylinder(r=pulley_diam/2,h=pulley_height,center=true);
}

module bearing() {
  rotate([90,0,0]) cylinder(r=bearing_diam/2,h=bearing_len,center=true);
}

module idler_bearing() {
  cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
}

y_carriage_len = x_rod_spacing + rod_diam + min_material_thickness*2;
y_carriage_width = bearing_diam;
y_carriage_height = bearing_diam + min_material_thickness*2;

module y_carriage() {
  for(side=[front,rear]) {
    % translate([0,(bearing_len/2 + spacer/2)*side,0]) bearing();
  }

  translate([bearing_diam/2,0,0]) cube([y_carriage_width,y_carriage_len,y_carriage_height],center=true);
}

for(side=[left,right]) {
  translate([y_rod_x*side,0,y_rod_z]) mirror([side+1,0,0]) y_carriage();
}

// rods
color("grey", .5) {
  // X
  for(side=[-1,1]) {
    translate([0,(side*x_rod_spacing/2),x_rod_z]) rotate([0,90,0])
      cylinder(r=rod_diam/2,h=x_rod_len,center=true);
  }

  // Y
  for(side=[-1,1]) {
    translate([side*y_rod_x,0,y_rod_z]) rotate([90,0,0])
      cylinder(r=rod_diam/2,h=y_rod_len,center=true);
  }
}

x_y_idler_x = y_rod_x - rod_diam/2 - belt_bearing_diam/2 - bearing_diam/2;
x_y_idler_y = belt_bearing_diam/2 + spacer/2;
x_y_idler_z = x_rod_z + rod_diam/2 + belt_bearing_thickness/2;

front_idler_x = x_y_idler_x + belt_bearing_diam/2;
front_idler_y = -y_rod_len/2;
front_idler_z = x_y_idler_z - belt_bearing_diam/2;

lower_rear_idler_x = front_idler_x - belt_bearing_diam/2;
lower_rear_idler_y = y_rod_len/2;
lower_rear_idler_z = front_idler_z - belt_bearing_diam/2;

upper_rear_idler_x = lower_rear_idler_x;
upper_rear_idler_y = y_rod_len/2 - spacer;
upper_rear_idler_z = x_y_idler_z;

xy_motor_x = motor_side/2 + spacer/2;
xy_motor_y = lower_rear_idler_y + belt_bearing_diam/2 + pulley_diam/2;
xy_motor_z = lower_rear_idler_z-sheet_thickness-spacer;

module idlers() {

  // carriage anchor front
  translate([x_y_idler_x*left,x_y_idler_y*front,x_y_idler_z]) idler_bearing();

  // front idler
  translate([front_idler_x*left,front_idler_y,front_idler_z]) rotate([0,90,0]) idler_bearing();

  // lower rear idler
  translate([lower_rear_idler_x*left,lower_rear_idler_y,lower_rear_idler_z]) idler_bearing();

  // upper rear idler
  translate([upper_rear_idler_x*right,upper_rear_idler_y,upper_rear_idler_z]) idler_bearing();

  // carriage anchor rear
  translate([x_y_idler_x*right,x_y_idler_y*rear,x_y_idler_z]) idler_bearing();

  // motor
  translate([xy_motor_x*left,xy_motor_y,xy_motor_z]) motor();
}

module line() {
  x_most = (x_y_idler_x + belt_bearing_diam/2);
  front = -1;
  rear = 1;
  left = -1;
  right = 1;

  carriage_x = x_carriage_width/2;
  carriage_y = x_y_idler_y-belt_bearing_diam/2;

  // x carriage front to y carriage front
  hull() {
    translate([carriage_x*left,carriage_y*front,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([x_y_idler_x*left,carriage_y*front,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // y carriage front to front idler
  hull() {
    translate([x_most*left,x_y_idler_y*front,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([x_most*left,front_idler_y,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // front idler to lower rear
  hull() {
    translate([x_most*left,lower_rear_idler_y,lower_rear_idler_z]) cube([1,1,1],center=true);
    translate([x_most*left,front_idler_y,lower_rear_idler_z]) cube([1,1,1],center=true);
  }

  // lower rear to pulley
  hull() {
    translate([lower_rear_idler_x*left,lower_rear_idler_y+belt_bearing_diam/2,lower_rear_idler_z]) cube([1,1,1],center=true);
    translate([xy_motor_x*left,xy_motor_y-pulley_diam/2,lower_rear_idler_z]) cube([1,1,1],center=true);
  }

  // pulley to upper rear
  hull() {
    translate([xy_motor_x*left,xy_motor_y-pulley_diam/2,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([upper_rear_idler_x*right,upper_rear_idler_y+belt_bearing_diam/2,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // upper rear to y carriage rear
  hull() {
    translate([x_most*right,upper_rear_idler_y,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([x_most*right,x_y_idler_y*rear,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // y carriage rear to x carriage rear
  hull() {
    translate([x_y_idler_x*right,carriage_y*rear,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([carriage_x*right,carriage_y*rear,upper_rear_idler_z]) cube([1,1,1],center=true);
  }
}

// shift one line's bearings up or down to avoid rubbing?
color("green",0.5) idlers();
color("green",0.5) line();
color("red",0.5) mirror([1,0,0]) idlers();
color("red",0.5) mirror([1,0,0]) line();

// top plate
translate([0,0,-sheet_thickness/2]) cube([build_x+sheet_min_width,build_y+sheet_min_width,sheet_thickness],center=true);
