include <./main.scad>;

carriage_hole_diam = 3.4;
cowl_hole_diam = 3.4;
carriage_hole_spacing = 30.8;
cowl_hole_spacing = 41.826; // a wacky number but from the dragonburner 8 step file
dist_carriage_bottom_cowl_rear_z = 0;
dist_carriage_bottom_cowl_rear_y = 0;

module carriage_cowl_bottom_anchor() {
  module position_carriage_mounting_holes() {
  }
  module position_cowl_mounting_holes() {
  }

  module body() {
  }

  module holes() {
    position_carriage_mounting_holes() {
    }

    position_cowl_mounting_holes() {
    }
  }

  difference() {
    body();
    holes();
  }
}
