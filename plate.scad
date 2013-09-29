include <main.scad>

module gantry_plate() {
  plate_y_carriage_x = y_rod_z + clamp_area_width;

  y_end_spacer = bearing_len;
  for(side=[left,right]) {
    translate([(y_rod_z + spacer*2)*-side,0,0]) mirror([1+side,0,0]) {
      translate([0,0,y_clamp_len]) {
        // y end front
        translate([0,-y_end_spacer,0]) rotate([0,0,-90]) rotate([-90,0,0]) y_end_front();

        // y end rear
        translate([0,y_end_spacer,0]) rotate([0,0,90]) rotate([90,0,0]) y_end_rear();
      }

      // y carriage
      translate([plate_y_carriage_x,0,y_carriage_z]) y_carriage();

      // x rod clamps
      translate([0,0,clamp_area_width/2]) {
        translate([0,clamp_area_width,0]) rod_clamp(rod_diam);
        translate([plate_y_carriage_x+y_rod_to_x_clamp_end,0,0]) rod_clamp(rod_diam);
      }
    }
  }
}
