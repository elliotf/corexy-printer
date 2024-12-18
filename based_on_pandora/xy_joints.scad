include <./main.scad>;

y_rail_pos_x = extrusion_vertical_spacing_x/2;
mgn_width = carriage_width(y_carriage);
mgn_height = carriage_height(y_carriage);
mgn_length = carriage_length(y_carriage);
center_channel_width = belt_idler_od-1;

rounded_diam = 2;

module countersunk_m2(depth=50) {
  m2_through_hole_diam = 2.4;
  m2_head_diam = 4.8;

  hole(m2_through_hole_diam,depth*2,resolution);
  recess_by = 1;

  head_height = 40;
  hull() {
    translate([0,0,head_height/2]) {
      hole(m2_head_diam,head_height,resolution);
      hole(m2_through_hole_diam,head_height+recess_by*2,resolution);
    }
  }
}

module xy_joint_profile() {
  module body() {
    diam = 2*(xy_front_idler_pos_x-(y_rail_pos_x-mgn_width/2));
    hull() {
      translate([y_rail_pos_x,0,0]) {
        rounded_square(mgn_width,mgn_length,rounded_diam);
      }
      translate([xy_front_idler_pos_x,xy_front_idler_offset_pos_y,0]) {
        accurate_circle(diam,resolution);
      }
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module position_mgn_holes() {
  mgn_hole_spacing_width = 12;
  mgn_hole_spacing_length = 13;

  for(x=[left,right],y=[front,rear]) {
    translate([y_rail_pos_x+x*mgn_hole_spacing_width/2,y*mgn_hole_spacing_length/2,0]) {
      children();
    }
  }
}

module xy_joint_bottom(side) {
  module body() {
    translate([0,0,mgn_height+xy_carriage_base_thickness/2]) {
      linear_extrude(height=xy_carriage_base_thickness,center=true,convexity=2) {
        xy_joint_profile();
      }
    }
  }

  module holes() {
    translate([0,0,mgn_height+xy_carriage_base_thickness]) {
      position_mgn_holes() {
        countersunk_m2();
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module xy_joint_top(side) {
  module body() {
    translate([0,0,mgn_height+xy_carriage_base_thickness+belt_idler_stack_height+xy_carriage_top_thickness/2]) {
      linear_extrude(height=xy_carriage_top_thickness,center=true,convexity=2) {
        xy_joint_profile();
      }
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module position_mgn(side) {
  translate([y_rail_pos_x,0,0]) {
    rotate([0,0,90]) {
      children();
    }
  }
}

module y_carriage_assembly(side) {
  module body() {
    position_mgn() {
      % carriage(y_carriage);
    }
    xy_joint_bottom();
    xy_joint_top();
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

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

module y_axis_assembly(pos_y) {
  for(x=[left,right]) {
    mirror([0,0,0]) {
      translate([0,y_rail_pos_y,gantry_pos_z+extrusion_side/2]) {
        translate([x*extrusion_vertical_spacing_x/2,0,0]) {
          rotate([0,0,90]) {
            % rail(y_rail,y_rail_length);
          }
        }

        translate([0,-y_rail_length/2+carriage_length(y_carriage)/2+pos_y,0]) {
          y_carriage_assembly(x);
        }
      }
    }
  }
}
