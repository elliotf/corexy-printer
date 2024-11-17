include <lumpyscad/lib.scad>;
use <../z_axis.scad>;

//belt_anchor_top();
//belt_anchor_bottom();
for(x=[left,right]) {
  mirror([x-1,0,0]) {
    translate([-5,0,0]) {
      rotate([0,0,0]) {
        rotate([0,90,0]) {
          z_motor_mount_front();
        }
      }
    }
  }
}
