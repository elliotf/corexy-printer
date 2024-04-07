use <NopSCADlib/lib.scad>;
use <lumpyscad/lib.scad>;
include <config.scad>;

module xy_carriage_left_lower() {
  translate([0,0,0]) {
    rotate([0,0,0]) {
      color("blue") import("voron-zero/STLs/XY_Joint_Left_Lower_x1.stl");
    }
  }
}

module xy_carriage_left_upper() {
  translate([0,0,0]) {
    rotate([0,0,0]) {
      color("green") import("voron-zero/STLs/XY_Joint_Left_Upper_x1.stl");
    }
  }
}

module xy_carriage_right_lower() {

  translate([-305.5,191.5,31.5]) {
    rotate([180,0,0]) {
      color("red") import("voron-zero/STLs/XY_Joint_Right_Lower_x1.stl");
    }
  }
}

module xy_carriage_right_upper() {
  translate([-224,348.5,56.5]) {
    rotate([180,0,0]) {
      color("green") import("voron-zero/STLs/XY_Joint_Right_Upper_x1.stl");
    }
  }
}

rotate([0,-90,0]) {
  rotate([0,0,90]) {
    translate([0,0,-carriage_height(yz_carriage_type)]) {
      % carriage(yz_carriage_type);
    }
  }
}

xy_carriage_right_lower();

xy_carriage_right_upper();
