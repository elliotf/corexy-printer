include <util.scad>;

module screw_mount() {
  large_diam = 30;
  small_diam = 10;

  module body() {
    hull() {
      cylinder(r=large_diam/2,h=20,center=true);
      cylinder(r=small_diam/2,h=40,center=true);
      translate([large_diam/4,0,0]) {
        cube([large_diam/2,large_diam,20],center=true);
        cube([large_diam/2,small_diam,40],center=true);
      }
    }
  }

  module holes() {
    hole_spacing = 10;
    m3_diam      = 3.1;
    m3_nut_diam  = 5.5;
    m3_nut_thickness = 2;

    for(side=[1,-1]) {
      translate([large_diam/4,0,hole_spacing/2*side]) {
        rotate([90,0,0]) {
          hole(m3_diam,large_diam+1,6);
          translate([0,0,large_diam/2]) {
            hole(m3_nut_diam,m3_nut_thickness,6);
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

rotate([0,90,0]) {
  //screw_mount();
}

/*
diam = 10;
intersection() {
  translate([diam/4,0,0]) {
    hole(diam,10+1,36);
  }
  translate([-diam/4,0,0]) {
    hole(diam,10,36);
  }
}
*/

sphere(r=10,$fn=16);
