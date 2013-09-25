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
lm8uu_bearing_diam = 15;
lm8uu_bearing_len  = 24;
lm8uu_rod_diam = 8;

// lm6uu, M6 rods
lm6uu_bearing_diam = 12;
lm6uu_bearing_len  = 19;
lm6uu_rod_diam = 6;

bearing_diam = lm8uu_bearing_diam;
bearing_diam = lm8uu_bearing_len;
rod_diam = lm8uu_rod_diam;

bearing_diam = lm6uu_bearing_diam;
bearing_len = lm6uu_bearing_len;
rod_diam = lm6uu_rod_diam;

belt_bearing_diam = 16;
belt_bearing_inner = 5;
belt_bearing_thickness = 5;

motor_side = 43;
motor_hole_spacing = 31;
pulley_diam = 18;
pulley_height = belt_bearing_diam + 8;
min_material_thickness = 2;

sheet_thickness = 6;
sheet_min_width = 30;
spacer = 2;

x_clamp_len = 10;
y_clamp_len = 20;
x_rod_spacing = 36 + lm8uu_bearing_diam;
x_carriage_width = bearing_len * 2 + 10;

clamp_screw_diam = 3;
clamp_screw_nut_diam = 5.5;

rod_z = belt_bearing_diam/2 + belt_bearing_thickness/2 + spacer;

// X rods
x_rod_clamp_len = bearing_len*2 + spacer + min_material_thickness*2;
x_rod_len = build_x + x_carriage_width + belt_bearing_diam*2 + bearing_diam;
x_rod_z = rod_z;

// Y rods
y_rod_len = build_y + x_rod_spacing + sheet_min_width*2;
y_rod_x = x_rod_len/2 + bearing_diam/2;
//y_rod_z = x_rod_z + bearing_diam/2 + rod_diam/2 + min_material_thickness;
y_rod_z = rod_z + bearing_diam/2 + rod_diam/2;

module motor() {
  translate([0,0,-motor_side/2]) cube([motor_side,motor_side,motor_side],center=true);
  cylinder(r=5/2,h=motor_side,center=true);

  translate([0,0,sheet_thickness+spacer+pulley_height/2]) cylinder(r=pulley_diam/2,h=pulley_height,center=true);
}

module bearing() {
  rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=da8*bearing_diam,h=bearing_len,center=true,$fn=8);
}

module idler_bearing() {
  difference() {
    cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
    cylinder(r=belt_bearing_inner/2,h=belt_bearing_thickness+1,center=true);
  }
}

// y carriage
y_carriage_len = x_rod_spacing + rod_diam + min_material_thickness*2;

module y_carriage() {
  bearing_clamp_width = bearing_diam+min_material_thickness*2;
  module y_carriage_body() {
    // y bearing clamp
    rotate([90,0,0]) rotate([0,0,22.5])
      cylinder(r=da8*bearing_clamp_width,h=y_carriage_len,center=true,$fn=8);
  }

  module y_carriage_holes() {
    bearing_y = y_carriage_len/2-bearing_len/2-min_material_thickness;

    // bearing holes
    rotate([0,45,0]) {
      // material trim
      translate([-bearing_clamp_width/2-rod_diam+1,0,0])
        cube([bearing_clamp_width+0.5,y_carriage_len+1,bearing_clamp_width+0.5],center=true);

      // bearing holes
      for(side=[front,rear]) {
        translate([0,bearing_y*side,0]) {
          translate([-bearing_diam/2,0,0])
            cube([bearing_diam,bearing_len,bearing_diam],center=true);
          # bearing();
        }
      }

      // y rod holes
      translate([-rod_diam/2,0,0]) cube([rod_diam+1,y_carriage_len+1,rod_diam+1],center=true);
      rotate([90,0,0]) rotate([0,0,22.5])
        cylinder(r=(rod_diam+1)*da8,h=y_carriage_len+1,center=true,$fn=8);
    }
  }

  difference() {
    y_carriage_body();
    y_carriage_holes();
  }
}

for(side=[left,right]) {
  translate([y_rod_x*side,0,y_rod_z]) mirror([side+1,0,0]) y_carriage();
}

// rods
color("grey", .5) {
  // X
  for(side=[-1,1]) {
    translate([0,(side*x_rod_spacing/2),x_rod_z]) rotate([0,90,0]) rotate([0,0,22.5])
      cylinder(r=da8*rod_diam,h=x_rod_len,center=true,$fn=8);
  }

  // Y
  for(side=[-1,1]) {
    translate([side*y_rod_x,0,y_rod_z]) rotate([90,0,0]) rotate([0,0,22.5])
      cylinder(r=da8*rod_diam,h=y_rod_len,center=true,$fn=8);
  }
}

xy_idler_x = y_rod_x - bearing_diam/2 - belt_bearing_diam/2 - min_material_thickness - spacer;
xy_idler_y = x_rod_spacing/2 - rod_diam/2 - belt_bearing_inner/2 - min_material_thickness;
xy_idler_z = x_rod_z + belt_bearing_diam/2;

front_idler_x = xy_idler_x + belt_bearing_diam/2;
front_idler_y = -y_rod_len/2;
front_idler_z = xy_idler_z - belt_bearing_diam/2;

lower_rear_idler_x = front_idler_x - belt_bearing_diam/2;
lower_rear_idler_y = y_rod_len/2;
lower_rear_idler_z = front_idler_z - belt_bearing_diam/2;

upper_rear_idler_x = lower_rear_idler_x;
upper_rear_idler_y = y_rod_len/2 - spacer;
upper_rear_idler_z = xy_idler_z;

xy_motor_x = motor_side/2 + spacer/2;
xy_motor_y = lower_rear_idler_y + belt_bearing_diam/2 + pulley_diam/2;
xy_motor_z = -sheet_thickness;

module idlers() {

  // carriage anchor front
  translate([xy_idler_x*left,xy_idler_y*front,xy_idler_z]) idler_bearing();

  // front idler
  translate([front_idler_x*left,front_idler_y,front_idler_z]) rotate([0,90,0]) idler_bearing();

  // lower rear idler
  translate([lower_rear_idler_x*left,lower_rear_idler_y,lower_rear_idler_z]) idler_bearing();

  // upper rear idler
  translate([upper_rear_idler_x*right,upper_rear_idler_y,upper_rear_idler_z]) idler_bearing();

  // carriage anchor rear
  translate([xy_idler_x*right,xy_idler_y*rear,xy_idler_z]) idler_bearing();

  // motor
  translate([xy_motor_x*left,xy_motor_y,xy_motor_z]) motor();
}

module line() {
  x_most = (xy_idler_x + belt_bearing_diam/2);
  front = -1;
  rear = 1;
  left = -1;
  right = 1;

  carriage_x = x_carriage_width/2;
  carriage_y = xy_idler_y-belt_bearing_diam/2;

  // x carriage front to y carriage front
  hull() {
    translate([carriage_x*left,carriage_y*front,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([xy_idler_x*left,carriage_y*front,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // y carriage front to front idler
  hull() {
    translate([x_most*left,xy_idler_y*front,upper_rear_idler_z]) cube([1,1,1],center=true);
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
    translate([x_most*right,xy_idler_y*rear,upper_rear_idler_z]) cube([1,1,1],center=true);
  }

  // y carriage rear to x carriage rear
  hull() {
    translate([xy_idler_x*right,carriage_y*rear,upper_rear_idler_z]) cube([1,1,1],center=true);
    translate([carriage_x*right,carriage_y*rear,upper_rear_idler_z]) cube([1,1,1],center=true);
  }
}

// shift one line's bearings up or down to avoid rubbing?
color("green",0.5) idlers();
color("green",0.5) line();
color("red",0.5) mirror([1,0,0]) idlers();
color("red",0.5) mirror([1,0,0]) line();

// top plate
color("Khaki", 0.5) translate([0,0,-sheet_thickness/2]) {
  difference() {
    translate([0,motor_side/4,0]) cube([y_rod_x*2+sheet_min_width*2,y_rod_len+sheet_min_width*2,sheet_thickness],center=true);
    cube([build_x+x_carriage_width,build_y+x_rod_spacing,sheet_thickness+1],center=true);
  }

}
% translate([0,0,-build_z/2]) cube([build_x,build_y,build_z],center=true);
