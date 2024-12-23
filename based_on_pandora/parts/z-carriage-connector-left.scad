include <../main.scad>;

mirror([1,0,0]) {
  rotate([90,0,0]) {
    translate([0,0,0]) {
      z_carriage_bed_anchor_front(true);
    }
  }
}
