da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

build_x = 150;
build_y = 150;
build_z = 150;

motor_side = 43;
pulley_diam = 20;
min_material_thickness = 3.5;

bearing_diam = 15;
bearing_len  = 24;
belt_bearing_diam = 16;
belt_bearing_thickness = 5;

rod_diam = 8;
sheet_thickness = 6;
sheet_min_width = 30;
spacer = 4;

x_clamp_len = 10;
y_clamp_len = 20;
threaded_clamp = 10;
x_rod_spacing = 40;
x_rod_spacing_offset = x_rod_spacing/2-(bearing_diam/2+min_material_thickness+rod_diam/2);
x_carriage_width = 40;

clamp_screw_diam = 3;
clamp_screw_nut_diam = 5.5;

// x rod clamp to y
x_rod_clamp_len = bearing_len*2 + spacer + min_material_thickness*2;
x_rod_clamp_width = bearing_diam + min_material_thickness*2;
x_rod_clamp_height = x_rod_clamp_width-min_material_thickness;

x_rod_len = build_x + x_clamp_len * 2 + x_carriage_width;
y_rod_len = build_y + x_rod_clamp_len + y_clamp_len + sheet_thickness*2;

y_rod_x = x_rod_len/2-x_clamp_len;

module motor() {
  translate([0,0,-motor_side/2]) cube([motor_side,motor_side,motor_side],center=true);
  cylinder(r=5/2,h=motor_side,center=true);
  translate([0,0,sheet_thickness+8]) cylinder(r=pulley_diam/2,h=16,center=true);
}

% translate([0,0,-build_z/2-20]) cube([build_x,build_y,build_z],center=true);

// x rods
for(side=[-1,1]) {
  translate([0,0,(side*x_rod_spacing/2)+x_rod_spacing_offset])
    rotate([0,90,0])
      % cylinder(r=rod_diam/2,h=x_rod_len,center=true);
}

module bearing_hole() {
  rotate([0,0,22.5]) cylinder(r=da8*bearing_diam,h=bearing_len,center=true,$fn=8);
}

module x_rod_clamp_body() {
  clamp_x = x_rod_spacing+rod_diam+threaded_clamp*2;
  clamp_y = rod_diam+min_material_thickness*2;

  translate([0,0,-min_material_thickness]) {
    cube([x_rod_clamp_width,x_rod_clamp_len,x_rod_clamp_height],center=true);

    translate([-x_rod_spacing_offset,0,0])
      cube([clamp_x,clamp_y,x_rod_clamp_height],center=true);
  }
}

module x_rod_clamp_holes() {
  // y rod bearing opening
  translate([0,0,bearing_diam/2])
    cube([bearing_diam-1,bearing_len*2+spacer,bearing_diam],center=true);
  for(side=[-1,1]) {
    translate([0,side*(bearing_len/2+spacer/2),0]) rotate([90,0,0]) bearing_hole();
  }

  // y rod clearance
  rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=da8*(rod_diam+1),h=x_rod_clamp_len+1,center=true,$fn=8);
  translate([0,0,rod_diam]) cube([rod_diam+1,x_rod_clamp_len+1,rod_diam*2],center=true);

  // x rod clamp
  for(side=[-1,1],offset=[0,1]) {
    translate([x_rod_spacing/2*side-x_rod_spacing_offset,0,0]) {
      // rod opening
      cylinder(r=da8*rod_diam,h=x_rod_clamp_width*2,center=true,$fn=8);

      translate([threaded_clamp*side*.9,0,-min_material_thickness]) {
        // clamp opening
        cube([threaded_clamp+2,1,x_rod_clamp_width+1],center=true);

        // screw hole
        rotate([90,0,0]) cylinder(r=da6*(clamp_screw_diam+0.1),h=x_rod_clamp_len,center=true,$fn=6);
        // captive nut
        translate([0,rod_diam,0]) rotate([90,0,0]) cylinder(r=da6*(clamp_screw_nut_diam+0.1),h=10,center=true,$fn=6);
      }
    }
  }
}

module x_rod_clamp() {
  difference() {
    x_rod_clamp_body();
    x_rod_clamp_holes();
  }

  bearing_x_pos = -bearing_diam/2-belt_bearing_thickness/2-min_material_thickness-sheet_thickness;
  bearing_y_pos = rod_diam/2+min_material_thickness+belt_bearing_diam/2+1;
  bearing_z_pos = 0;
  for(side=[-1,1]) {
    // line bearing
    % translate([bearing_x_pos,side*bearing_y_pos,bearing_z_pos])
      rotate([0,90,0])
        cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
  }
}

//translate([-50,0,0]) x_rod_clamp();

for(side=[-1,1]) {
  translate([side*y_rod_x,0,0]) rotate([0,-side*90,0]) mirror([side+1,0,0]) x_rod_clamp();
  //translate([side*y_rod_x,0,0]) x_rod_clamp();
}

// y rods
for(side=[-1,1]) {
  translate([side*y_rod_x,0,0]) {
    rotate([90,0,0])
      % cylinder(r=rod_diam/2,h=y_rod_len,center=true);

    // motors
    translate([side*(pulley_diam/2+belt_bearing_diam/2),y_rod_len/2+motor_side/2,bearing_diam-sheet_thickness/2]) motor();
  }
}

top_plate_x = x_rod_len+sheet_min_width*2+spacer*2;
top_plate_y = y_rod_len+sheet_min_width*2-y_clamp_len*2;
top_plate_inner_x = x_rod_len+spacer*2;
top_plate_inner_y = build_y+x_rod_clamp_len;
top_plate_x = top_plate_inner_x+sheet_min_width*2;
top_plate_y = top_plate_inner_y+sheet_min_width*2;

// main plate
color("Khaki",0.8) translate([0,0,bearing_diam]) difference() {
  //cube([top_plate_x,top_plate_y,sheet_thickness],center=true);
  cube([top_plate_inner_x+sheet_min_width*2,top_plate_inner_y+sheet_min_width*2,sheet_thickness],center=true);
  cube([top_plate_inner_x,top_plate_inner_y,sheet_thickness+1],center=true);
  //cube([x_rod_len+spacer*2,y_rod_len-y_clamp_len*2,sheet_thickness*2],center=true);
}

front_plate_z = top_plate_y;

// back plate
color("Khaki",0.8) translate([0,y_rod_len/2,-front_plate_z/2+bearing_diam-sheet_thickness/2]) cube([top_plate_x,sheet_thickness,top_plate_y],center=true);
// front plate
color("Khaki",0.8) translate([0,-y_rod_len/2,-front_plate_z/2+bearing_diam-sheet_thickness/2]) {
  difference() {
    cube([top_plate_x,sheet_thickness,top_plate_y],center=true);
    cube([top_plate_x-sheet_min_width*2,sheet_thickness+1,top_plate_y-sheet_min_width*2],center=true);
  }
}

module idlers() {
  inner_x = y_rod_x;
  inner_y = -y_rod_len/2+belt_bearing_diam/2;
  inner_z = bearing_diam+sheet_thickness/2+belt_bearing_thickness/2 + 1;

  outer_x = y_rod_x+belt_bearing_diam/2+pulley_diam/2;
  outer_y = -y_rod_len/2-belt_bearing_diam/2;
  outer_z = inner_z + 1;

  // inner idlers
  for(side=[-1,1]) {
    translate([inner_x*side,inner_y,inner_z]) cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
  }

  // outer idlers
  for(side=[-1,1]) {
    translate([outer_x*side,outer_y,outer_z]) cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
  }
}
color("red",0.5) idlers();
