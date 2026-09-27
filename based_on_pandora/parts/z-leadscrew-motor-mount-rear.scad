include <../main.scad>;

/*
translate([0,extrusion_side,extrusion_side/2]) {
  rotate([0,90,0]) {
    % extrusion_l(extrusion_main_length);
  }
}
translate([0,0,extrusion_main_length/2]) {
  % extrusion_l(extrusion_main_length);
}
rotate([0,0,180]) {
*/
rotate([180,0,0]) {
  rotate([0,0,0]) {
    translate([0,0,0]) {
      z_motor_mount_leadscrew_rear(true);
    }
  }
}
