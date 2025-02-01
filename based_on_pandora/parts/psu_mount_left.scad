include <../main.scad>;

mirror([0,0,0]) {
  rotate([0,-90,0]) {
    psu_mount_non_terminal_side(left);
  }
}
