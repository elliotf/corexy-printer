include <./main.scad>;

y_rail_pos_x = extrusion_vertical_spacing_x/2;
rounded_diam = 2;

module front_idler(side) {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module front_idlers_assembly() {
  front_idler(left);
  front_idler(right);
}
