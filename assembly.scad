include <main.scad>;

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

// y carriage
for(side=[left,right]) {
  translate([y_rod_x*side,0,y_rod_z]) mirror([side+1,0,0]) y_carriage();
}

// y end front
for(side=[left,right]) {
  translate([y_rod_x*side,y_rod_len/2*front,y_rod_z]) mirror([side+1,0,0]) y_end_front();
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
