include <config.scad>;
use <simpler.scad>

module gantry_plate() {
  for(side=[left,right]) {
    mirror([1+side,0,0]) {
      translate([bearing_len/2+spacer*2,0,0]) {
        rotate([0,0,90]) {
          rotate([0,90,0]) {
            y_carriage(1+side);
          }
        }
      }
    }
  }

  % translate([0,0,-.5]) {
    difference() {
      cube([200,200,1],center=true);
      cube([150,150,2],center=true);
    }
  }
}

gantry_plate();
