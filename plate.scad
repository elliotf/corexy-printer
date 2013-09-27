include <main.scad>

module front_ends() {
  for(side=[1,0]) {
    translate([30*-side,0,y_clamp_len]) mirror([side,0,0]) rotate([0,0,-90]) rotate([-90,0,0])
      y_end_front();
  }
}

front_ends();

