include <config.scad>;
include <positions.scad>;
use <main.scad>

module plate() {
  for(side=[left,right]) {
    mirror([1-side,0,0]) {
      translate([rod_diam+belt_bearing_diam,bearing_body_thickness+rod_diam,0]) {
        rotate([0,0,90]) {
          rotate([-90,0,0]) {
            front_xy_endcap();
          }
        }
      }
      translate([bearing_len/2+spacer*2,150/2-x_rod_spacing/2-rod_diam,y_carriage_width]) {
        rotate([0,0,90]) {
          rotate([0,90,0]) {
            y_carriage(1+side);
          }
        }
      }

      translate([bearing_len+wall_thickness*4+side_sheet_pos_x-y_rod_x,150/2-rod_diam-2,0]) {
        rotate([0,0,180]) {
          rotate([90,0,0]) {
            rear_xy_endcap();
          }
        }
      }
    }
  }

  translate([0,bearing_diam/2,x_carriage_width/2]) {
    rotate([0,0,-90]) {
      rotate([0,90,0]) {
        x_carriage();
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
