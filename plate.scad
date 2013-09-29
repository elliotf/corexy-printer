include <main.scad>

module gantry_plate() {
  plate_y_carriage_x = y_rod_z + clamp_area_width - bearing_diam/2;

  y_end_spacer = 15;
  for(side=[left,right]) {
    translate([(y_rod_z + spacer)*-side,0,0]) mirror([1+side,0,0]) {
      translate([0,0,y_clamp_len]) {
        // y end front
        translate([0,-y_end_spacer,0]) rotate([0,0,-90]) rotate([-90,0,0]) y_end_front();

        // y end rear
        translate([0,y_end_spacer,0]) rotate([0,0,90]) rotate([90,0,0]) y_end_rear();
      }

      // y carriage
      translate([plate_y_carriage_x,0,y_carriage_z]) y_carriage();

      // x rod clamps
      for(end=[front,rear]) {
        translate([plate_y_carriage_x+y_rod_to_x_clamp_end,end*clamp_area_width,clamp_area_width/2]) rod_clamp(rod_diam);
      }
    }
  }
}

gantry_plate();

