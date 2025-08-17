include <../main.scad>;

mirror([0,0,0]) {
  rotate([180,0,0]) {
    translate([-motor_xy_pos_x,-motor_xy_pos_y,-motor_xy_pos_z]) {
      ab_pod_lower(right,true);
    }
  }
}
