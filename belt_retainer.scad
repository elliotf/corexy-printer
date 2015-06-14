include <config.scad>;
include <positions.scad>;
//include <boxcutter.scad>;
use <util.scad>;

belt_tooth_pitch   = 2;
num_teeth_to_clamp = 7;
belt_clamp_depth   = belt_width + m3_nut_diam + wall_thickness*1.5 + 1;
belt_clamp_width   = m3_nut_diam + wall_thickness*2;
belt_clamp_height  = num_teeth_to_clamp*belt_tooth_pitch;

echo("BELT CLAMP DIM:", belt_clamp_width, belt_clamp_depth,belt_clamp_height);

/*
gt2_overall_thickness   = 1.38;
gt2_tooth_depth         = 0.75;
gt2_non_tooth_thickness = gt2_overall_thickness - gt2_tooth_depth;
gt2_center_from_flat    = 0.254;
*/

module vertical_belt_clamp() {
  rounded_diam = 4;
  module body() {
    hull() {
      translate([tensioner_belt_dist_x,-0.5-belt_width/2+belt_clamp_depth/2,0]) {
        for(x=[left,right]) {
          for(y=[front,rear]) {
            translate([(belt_clamp_width/2-rounded_diam/2)*x,(belt_clamp_depth/2-rounded_diam/2)*y,0.25]) {
              hole(rounded_diam,belt_clamp_height-0.5,resolution);
            }
            translate([(belt_clamp_width/2-rounded_diam/2)*x,(belt_clamp_depth/2-rounded_diam/2)*y,0]) {
              hole(rounded_diam-1,belt_clamp_height,resolution);
            }
          }
        }
      }
    }
  }

  module holes() {
    tooth_diam = 1.4;
    // belt teeth
    translate([0,0,0]) {
      % cube([belt_thickness,belt_width,belt_clamp_height+2],center=true);
      translate([0,-belt_width/2+0.5,0]) {
        cube([1,belt_width*2,40],center=true);

        for(i=[0:num_teeth_to_clamp]) {
          translate([belt_thickness/2,0,-belt_clamp_height/2+belt_tooth_pitch/2+belt_tooth_pitch*i]) {
            rotate([90,0,0]) {
              rotate([0,0,0]) {
                hole(tooth_diam,belt_width*2,6);
              }
            }
          }
        }
      }

      for(side=[bottom]) {
        translate([0,-belt_width/2+0.5,side*(belt_clamp_height/2+0.5)]) {
          hull() {
            cube([belt_thickness+1,belt_width*2+1,1],center=true);
            cube([belt_thickness,belt_width*2,2],center=true);
          }
        }
      }
    }

    //translate([0,wall_thickness+3.1/2+0.5,0]) {
    translate([tensioner_belt_dist_x,tensioner_belt_dist_y,0]) {
      rotate([0,0,90]) {
        hole(3.1,100,6);
        translate([0,0,belt_clamp_height/2]) {
          hole(m3_nut_diam,m3_nut_thickness,6);
        }

        translate([0,0,-belt_clamp_height/2-0.5]) {
          hull() {
            hole(3.1+1,1,6);
            hole(3.1,2,6);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

vertical_belt_clamp();
