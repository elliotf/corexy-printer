include <../main.scad>;

rotate([0,90,0]) {
  rotate([0,0,0]) {
    mirror([0,0,0]) {
      translate([0,0,0]) {
        skirt_filler(right);
      }
    }
  }
}
