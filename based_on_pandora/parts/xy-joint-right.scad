include <../main.scad>;

mirror([0,0,0]) {
  rotate([-90,0,0]) {
    translate([0,0,0]) {
      xy_joint_single_piece(right,true);
    }
  }
}
