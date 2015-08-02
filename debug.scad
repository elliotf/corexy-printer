include <main.scad>;
use <belt_retainer.scad>;

//rod_clamp(z_rod_diam);

belt_clamp_tensioner();

translate([-x_carriage_width-5,0,0]) {
  //x_carriage();
}

//for(side=[right]) {
  //translate([x_carriage_width/2+y_carriage_width+40,0,0]) {
    mirror([1,0,0]) {
      //y_carriage();
    }
  //}
//}

translate([x_carriage_width/2+y_carriage_width+40,60,0]) {
  //rear_xy_endcap();
}

translate([x_carriage_width/2+y_carriage_width+40,-60,0]) {
  //front_xy_endcap();
}

rotate([90,0,0]) {
  //z_carriage_bearing_support_arm();
}
