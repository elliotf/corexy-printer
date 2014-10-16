include <config.scad>;
//include <positions.scad>;

use <util.scad>;

x_carriage_width = bearing_len + min_material_thickness * 2;

x_rod_len     = build_x + x_carriage_width + (spacer + belt_bearing_diam + min_material_thickness + bearing_diam) *2;
x_rod_spacing = bearing_diam + min_material_thickness * 2 + rod_diam;

y_rod_len     = build_y + max(belt_bearing_diam*2) + 2 + sheet_thickness*2;
y_rod_x       = x_rod_len/2 - bearing_diam/2;

x_carriage_height    = x_rod_spacing + bearing_diam + min_material_thickness*2;
x_carriage_thickness = bearing_diam;

// x rods
% for (side=[top,bottom]) {
  translate([0,0,x_rod_spacing/2*side]) {
    rotate([0,90,0]) {
      rotate([0,0,22.5/2]) {
        cylinder(r=rod_diam/2,h=x_rod_len,center=true,$fn=16);
      }
    }
  }
}

// x end idlers
% for (end=[left,right]) {
  for (side=[front,rear]) {
    translate([(y_rod_x - bearing_diam - min_material_thickness)*end,(belt_bearing_diam/2 + .5)*side,0]) {
      cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
    }
  }

  // y bearings
  translate([0,0,0]) {
    translate([y_rod_x*end,0,0]) {
      rotate([90,0,0]) {
        rotate([0,0,22.5/2]) {
          cylinder(r=bearing_diam/2,h=bearing_len,center=true,$fn=16);
          cylinder(r=rod_diam/2,h=y_rod_len,center=true,$fn=16);
        }
      }
    }
  }
}

module x_carriage() {
  res = 16;

  body_side = rear;

  module body() {
    translate([0,(x_carriage_thickness/2-rod_diam/2)*body_side,0]) {
      cube([x_carriage_width,x_carriage_thickness,x_carriage_height],center=true);
    }
  }

  module holes() {
    for(side=[top,bottom]) {
      translate([0,0,x_rod_spacing/2*side]) {
        translate([0,x_carriage_thickness/2*-body_side,0]) {
          cube([bearing_len,x_carriage_thickness,bearing_diam-1],center=true);
          cube([x_carriage_width+1,x_carriage_thickness,rod_diam+1],center=true);
        }
        rotate([0,90,0]) {
          rotate([0,0,22.5/2]) {
            hole(bearing_diam,bearing_len,res);
            hole(rod_diam+1,x_carriage_width+2,res);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

translate([0,0,-x_carriage_height/2-build_z/2-2]) {
  % cube([build_x,build_y,build_z],center=true);
}

translate([-build_x/2,0,0]) {
  x_carriage();
}
