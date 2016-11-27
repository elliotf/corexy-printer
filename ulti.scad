use     <util.scad>;
include <config.scad>;

resolution = 16;
rod_diam   = 8;

build = 200;

xy_offset = bearing_diam;

xy_overhead = bearing_diam;
rod_len = build + xy_overhead*4 + sheet_thickness*2;
rod_pos = build/2 + xy_overhead;

module motor() {
  difference() {
    translate([0,0,-motor_side/2]) cube([motor_side,motor_side,motor_side],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }

  translate([0,0,motor_shaft_len/2]) cylinder(r=motor_shaft_diam/2,h=motor_shaft_len,center=true);
}

module axis_rod_set() {
  for(x=[left,right]) {
    translate([rod_pos*x,0,0]) {
      rotate([90,0,0]) {
        color("silver") hole(8,rod_len,resolution);
      }
    }
  }
}

translate([0,0,-xy_offset/2]) {
  rotate([0,0,0]) {
    axis_rod_set();
  }
}
translate([0,0,xy_offset/2]) {
  rotate([0,0,90]) {
    axis_rod_set();
  }
}

% cube([build,build,xy_offset],center=true);
for(n=[-1,1]) {
  translate([(rod_len/2-sheet_thickness/2)*n,0,0]) {
    % cube([sheet_thickness,rod_len,xy_offset*4],center=true);
  }
  translate([0,(rod_len/2-sheet_thickness/2)*n,0]) {
    % cube([rod_len,sheet_thickness,xy_offset*4],center=true);
  }
}

belt_idler_height = 8;

/*
translate([rod_pos-xy_overhead/2,rod_len/2-sheet_thickness-motor_side/2,xy_offset/2+motor_side/2+xy_overhead]) {
  translate([0,0,-motor_hole_spacing/2]) {
    for(y=[front]) {
      translate([xy_overhead/2,motor_hole_spacing/2*y,0]) {
        rotate([0,90,0]) {
          hole(10,8,resolution);
        }
      }
    }
  }
  rotate([0,90,0]) {
    % motor();
  }
}
*/
translate([rod_len/2,rod_len/2-sheet_thickness-motor_side/2,xy_offset+motor_side/2]) {
  translate([0,0,-motor_hole_spacing/2]) {
    for(y=[front]) {
      translate([-sheet_thickness-xy_overhead,motor_hole_spacing/2*y,0]) {
        rotate([0,90,0]) {
          hole(10,8,resolution);
        }
      }
    }
  }
  rotate([0,-90,0]) {
    % motor();
  }
}
