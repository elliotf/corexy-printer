include <main.scad>

module gantry_plate() {
  plate_y_carriage_x = y_rod_z + clamp_area_width;

  y_end_spacer = bearing_len;
  for(side=[left,right]) translate([0,x_rod_spacing/2,0]) {
    translate([(y_rod_z + spacer*2)*-side,0,0]) mirror([1+side,0,0]) {
      translate([0,0,y_clamp_len]) {
        // y end front
        translate([0,-y_end_spacer+rod_diam,0]) rotate([0,0,-90]) rotate([-90,0,0]) y_end_front(1-side);

        // y end rear
        translate([0,y_end_spacer,0]) rotate([0,0,90]) rotate([90,0,0]) y_end_rear();
      }

      // y carriage
      translate([plate_y_carriage_x,0,y_rod_to_x_clamp_end]) rotate([0,0,180]) rotate([0,90,0])
        y_carriage();
    }
  }

  translate([x_carriage_width/2+bearing_diam,-x_rod_spacing/2-bearing_diam,x_carriage_thickness]) rotate([0,180,0])
    x_carriage();

  % translate([0,0,-.5]) {
    difference() {
      cube([200,200,1],center=true);
      cube([150,150,2],center=true);
    }
  }
}
