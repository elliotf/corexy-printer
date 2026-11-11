include <../main.scad>;

mirror([1,0,0]) {
  rotate([0,90,0]) {
    z_stepper_foot();
  }
}
