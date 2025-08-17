include <../main.scad>;

mirror([0,0,0]) {
  rotate([0,0,0]) {
    translate([0,0,0]) {
      z_carrier_rear_leadscrew(leadscrew_rear_motor_offset_x,leadscrew_rear_motor_offset_y,true);
    }
  }
}
