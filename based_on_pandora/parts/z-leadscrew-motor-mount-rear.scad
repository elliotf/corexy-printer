include <../main.scad>;

rotate([180,0,0]) {
  rotate([0,0,0]) {
    translate([0,0,0]) {
      z_motor_mount_leadscrew_rear(true);
    }
  }
}
