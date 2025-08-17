include <../main.scad>;

rotate([0,0,-90]) {
  rotate([90,0,0]) {
    front_foot(left);
  }
}
