include <../main.scad>;

rotate([0,90,0]) {
  mirror([1,0,0]) {
    translate([0,0,0]) {
      z_motor_mount_front(true,1);
    }
  }
}
