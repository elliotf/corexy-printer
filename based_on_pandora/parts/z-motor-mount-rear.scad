include <../main.scad>;

rotate([0,-90,0]) {
  mirror([0,0,0]) {
    translate([0,0,0]) {
      z_motor_mount_rear(true);
    }
  }
}
