include <config.scad>;
include <positions.scad>;
use <main.scad>;

//printed_z_portion();

rotate([90,0,0]) {
  //rear_xy_endcap();
}

z_carriage_bearing_support_arm();

//x_carriage();

//for(side=[left,right]) {
for(side=[right]) {
  mirror([1+side,0,0]) {
    translate([-x_carriage_width/2-y_carriage_width-10,0,0]) {
      //y_carriage();
    }
  }
}
/*
*/
