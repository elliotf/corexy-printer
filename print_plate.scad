include <config.scad>;
include <positions.scad>;
use <main.scad>

module plate() {
  for(side=[left,right]) {
    mirror([1-side,0,0]) {
      translate([bearing_len/2+spacer*2,x_rod_spacing/2,0]) {
        translate([-2,y_carriage_height+4,0]) {
          rotate([0,0,90]) {
            rotate([-90,0,0]) {
              front_xy_endcap();
            }
          }
        }
        translate([0,0,y_carriage_width]) {
          rotate([0,0,90]) {
            rotate([0,90,0]) {
              y_carriage(1+side);
            }
          }
        }

        translate([bearing_len+belt_bearing_diam+2,-belt_bearing_effective_diam/2,0]) {
          rotate([90,0,0]) {
            rear_xy_endcap();
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

plate();
