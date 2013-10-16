include <main.scad>;
use <lib/boxcutter/main.scad>;

z_axis_smooth_threaded_dist_x = motor_side/2-rod_diam/2;
z_bearing_wrapper_thickness = min_material_thickness*1.5;
z_carriage_width = (z_axis_smooth_threaded_dist_x+z_bearing_diam/2+z_bearing_wrapper_thickness)*2;
z_carriage_depth = m5_nut_thickness+min_material_thickness*2;
z_carriage_height = z_bearing_len*2+min_material_thickness*3;

// need to calculate
top_sheet_to_z_threaded_dist_z = (y_rod_z - z_bearing_diam/2 - spacer)*-1;

z_carriage_bolt_area_depth = z_carriage_depth*2+z_bearing_diam;
z_carriage_bolt_area_thickness = m5_nut_thickness+min_material_thickness*2;

z_threaded_rod_len = build_z+5+z_carriage_height;
z_threaded_rod_z = -top_sheet_to_z_threaded_dist_z - z_threaded_rod_len/2;
z_rod_len = z_threaded_rod_len + sheet_thickness + spacer + motor_shaft_len + top_sheet_to_z_threaded_dist_z;

z_rod_x = (top_sheet_width/2 - spacer*2 - zip_tie_thickness - z_bearing_diam/2);
z_rod_x = y_rod_x+z_bearing_diam/2+rod_diam;
z_rod_z = -z_rod_len/2+sheet_thickness;
z_motor_x = z_rod_x-z_axis_smooth_threaded_dist_x;

z_support_slot_height = z_carriage_height/4;
z_support_slot_len = z_carriage_width/2+sheet_thickness;
z_support_slot_len = z_carriage_width/4+sheet_thickness;
z_support_slots = [z_carriage_height/2-z_carriage_height/8,-z_carriage_height/4+z_carriage_height/8];

// in relation to the motor plate
z_carriage_x = -z_axis_smooth_threaded_dist_x/2;
z_carriage_x = 0;
z_carriage_y = z_bearing_diam/2+z_carriage_depth/2;

// prusa i3 rip-off z axis

z_leadscrew_nut_body_height = m5_nut_thickness+min_material_thickness*2;
z_leadscrew_nut_body_diam = m5_nut_diam+min_material_thickness*2;

x_z_support_y = z_carriage_y+z_carriage_depth/2+sheet_thickness/2;
x_z_support_len = z_motor_x*2-z_carriage_width+z_support_slot_len*2;
y_z_support_x = (x_z_support_len-z_support_slot_len*2)/2+sheet_thickness/2;
y_z_support_x = z_motor_x-z_carriage_width/2-sheet_thickness/2;
y_z_support_len = build_y;

top_z_support_width = y_z_support_x*2+sheet_thickness*2+3*2;
top_z_support_depth = heatbed_depth+3*3;

echo("z_threaded_rod_len: ", z_threaded_rod_len);

module z_carriage() {
  module body() {
    // main body back
    translate([z_carriage_x,z_carriage_y,0])
      cube([z_carriage_width,z_carriage_depth,z_carriage_height],center=true);

    // bolt area
    translate([z_carriage_width/2-z_carriage_bolt_area_thickness/2,0,0])
      cube([z_carriage_bolt_area_thickness,z_carriage_bolt_area_depth,z_carriage_height],center=true);

    // prusa-style bearing holder
    translate([-z_axis_smooth_threaded_dist_x,z_bearing_diam/2,0])
      cube([z_bearing_diam+z_bearing_wrapper_thickness*2,z_bearing_diam,z_carriage_height],center=true);
    translate([-z_axis_smooth_threaded_dist_x,0,0])
      hole(z_bearing_diam+z_bearing_wrapper_thickness*2,z_carriage_height,36);

    // captive nut
    translate([0,0,z_carriage_height/2-z_leadscrew_nut_body_height/2]) {
      hull() {
        translate([z_carriage_width/2-z_carriage_bolt_area_thickness/2,0,0])
          cube([z_carriage_bolt_area_thickness,z_carriage_bolt_area_depth,z_leadscrew_nut_body_height],center=true);
        translate([-z_axis_smooth_threaded_dist_x,z_carriage_bolt_area_depth/4,0])
          cube([1,z_carriage_bolt_area_depth/2,z_leadscrew_nut_body_height],center=true);
      }
    }
  }

  module holes() {
    long = z_carriage_width-z_bearing_wrapper_thickness-z_bearing_diam/2-z_carriage_bolt_area_thickness;
    short = z_carriage_bolt_area_depth/2;
    bearing_holder_gap_angle = atan(short/long);

    // prusa-style bearing holder
    translate([-z_axis_smooth_threaded_dist_x,0,0]) {
      hole(z_bearing_diam,z_carriage_height+1,36);

      rotate([0,0,-bearing_holder_gap_angle])
        translate([z_carriage_width/2,0,0])
          cube([z_carriage_width,spacer,z_carriage_height+1],center=true);
    }

    // z rod captive nut
    translate([0,0,z_carriage_height/2-z_leadscrew_nut_body_height])
      rotate([0,0,90])
        hole(m5_nut_diam,m5_nut_thickness*2,6);

    // z threaded rod
    cylinder(r=m5_nut_diam/2-.5,h=z_carriage_height+1,center=true,$fn=6);

    // x axis support bolts
    translate([z_carriage_width/2-z_carriage_bolt_area_thickness-m5_nut_diam/2,z_carriage_y,0]) {
      for(z=z_support_slots) {
        translate([0,0,z*-1]) {
          rotate([90,0,0]) hole(5,z_carriage_depth+1,6);

          translate([0,-z_carriage_depth/2,0])
            rotate([90,0,0]) hole(m5_nut_diam,m5_nut_thickness*1.5,6);
        }
      }
    }

    // y axis support bolts
    translate([z_carriage_width/2-z_carriage_bolt_area_thickness/2,-z_carriage_bolt_area_depth/4,0]) {
      for(z=z_support_slots) {
        translate([0,0,z*-1]) {
          rotate([0,90,0]) rotate([0,0,90]) hole(5,z_carriage_depth+1,6);

          translate([-z_carriage_bolt_area_thickness/2,0,0])
            rotate([0,90,0]) rotate([0,0,90]) hole(m5_nut_diam,m5_nut_thickness*1.5,6);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module x_support_for_z_axis() {
  difference() {
    cube([x_z_support_len,sheet_thickness,z_carriage_height],center=true);

    for(side=[left,right]) {
      for(z=z_support_slots) {
        translate([x_z_support_len/2*side,0,z]) {
          cube([z_support_slot_len*2,sheet_thickness+1,z_support_slot_height],center=true);
        }

        translate([(y_z_support_x+sheet_thickness/2+z_carriage_bolt_area_thickness+m5_nut_diam/2)*side,0,z*-1]) {
          rotate([90,0,0]) hole(5,sheet_thickness+1,16);
        }
      }
    }
  }
}

module y_support_for_z_axis() {
  difference() {
    cube([sheet_thickness,y_z_support_len,z_carriage_height],center=true);

    for(z=z_support_slots) {
      translate([0,x_z_support_y,z*-1]) {
        cube([sheet_thickness+1,sheet_thickness,z_support_slot_height],center=true);
      }

      translate([0,-z_carriage_bolt_area_depth/4,z*-1]) {
        rotate([0,90,0]) hole(5,sheet_thickness+1,16);
      }
    }
  }
}

module bed_support_for_z_axis() {
  cube([top_z_support_width,top_z_support_depth,sheet_thickness],center=true);
}

z_axis_z = -z_rod_len+z_carriage_height/2+sheet_thickness+spacer;
z_motor_z = -z_threaded_rod_len/2-spacer-motor_shaft_len;
module z_axis() {
  translate([0,0,z_axis_z]) {

    color("khaki") {
      // x support
      translate([0,x_z_support_y,0]) {
        x_support_for_z_axis();
      }

      // y support
      for(side=[left,right]) {
        translate([y_z_support_x*side,0,0]) {
          y_support_for_z_axis();
        }
      }
    }

    translate([0,0,z_carriage_height/2+sheet_thickness/2]) {
      // support plate
      color("khaki") bed_support_for_z_axis();

      color("red") translate([0,0,sheet_thickness/2]) heatbed();
    }
  }



  for(side=[left,right]) {
    translate([z_rod_x*side,0,z_rod_z])
      % cylinder(r=rod_diam/2,h=z_rod_len,center=true);

    translate([z_motor_x*side,0,z_threaded_rod_z]) {
      % cylinder(r=5/2,h=z_threaded_rod_len,center=true);

      translate([0,0,z_motor_z]) {
        % motor();

        mirror([side+1,0,0]) {
          translate([0,0,z_carriage_height/2+spacer]) {
            z_carriage();
          }
        }
      }
    }
  }
}

z_axis();

