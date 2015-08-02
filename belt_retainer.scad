include <config.scad>;
include <positions.scad>;
use <util.scad>;

echo("BELT CLAMP DIM:", belt_clamp_width, belt_clamp_depth,belt_clamp_height);

module belt_teeth(height=belt_clamp_height) {
  tooth_diam = 1.25;
  cube([1,belt_width*3,height*2],center=true);

  for(i=[0:num_teeth_to_clamp*3]) {
    translate([belt_thickness/2,0,-height+belt_tooth_pitch+belt_tooth_pitch*i]) {
      rotate([90,0,0]) {
        rotate([0,0,0]) {
          hole(tooth_diam,belt_width*3,6);
        }
      }
    }
  }
}

module z_belt_anchor() {
  anchor_depth        = z_belt_to_rear_sheet_dist;
  belt_clamp_depth    = belt_width*2 + 1;
  belt_clamp_y        = belt_width/2-0.5;
  anchor_width        = m3_nut_diam + wall_thickness*3;
  rounded_diam        = 2;

  brace_side_x      = -z_motor_side*(z_belt_clamp_width/2);
  carriage_side_x   = z_motor_side*(anchor_width/2);
  body_sheet_side_y = belt_width/2 + 0.5 + extrusion_width*6;
  body_bed_side_y   = tensioner_belt_dist_y - m3_nut_diam/2 - wall_thickness;

  module body() {
    hull() {
      for(x=[carriage_side_x-z_motor_side*rounded_diam/2,brace_side_x+z_motor_side*rounded_diam/2]) {
        for(y=[body_sheet_side_y-rounded_diam/2,body_bed_side_y+rounded_diam/2]) {
          translate([x,y,-z_belt_anchor_height/2]) {
            hole(rounded_diam-1,z_belt_anchor_height,resolution);
          }
          translate([x,y,-z_belt_anchor_height/2+0.6]) {
            hole(rounded_diam,z_belt_anchor_height-0.6,resolution);
          }
        }
      }
    }
  }

  module holes() {
    translate([0,-belt_width+0.5,-z_belt_anchor_height/2]) {
      belt_teeth(z_belt_anchor_height);
    }

    // flange belt opening in case the first layer is squished
    translate([0,-belt_width/2+0.5,-z_belt_anchor_height-0.5]) {
      hull() {
        cube([belt_thickness+1,belt_width*2+1,1],center=true);
        cube([belt_thickness,belt_width*2,2],center=true);
      }
    }

    // easier to slide belt in
    hull() {
      translate([0,body_bed_side_y-1,-z_belt_anchor_height/2]) {
        cube([1,2*(m3_nut_diam+wall_thickness*2),z_belt_anchor_height+1],center=true);
        cube([3,2*(wall_thickness*2+m3_diam+1),z_belt_anchor_height+1],center=true);
      }
    }

    // mount to z_brace
    for(side=[top,bottom]) {
      translate([carriage_side_x,tensioner_belt_dist_y,-z_belt_anchor_height/2+z_belt_anchor_hole_spacing/2*side]) {
        rotate([0,90,0]) {
          hole(m3_diam, 40, 6);
          hole(m3_nut_diam, 2, 6);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module belt_tensioner_body() {
  anchor_depth        = z_belt_to_rear_sheet_dist;
  tensioner_hole_gap  = 0.3;
  hole_width          = belt_clamp_width + tensioner_hole_gap*2;
  hole_depth          = belt_clamp_depth + tensioner_hole_gap*2;
  hole_rounded        = rounded_diam + tensioner_hole_gap*2;
  body_width          = hole_width + wall_thickness*2;
  body_depth          = hole_depth + wall_thickness*2;
  body_height         = belt_clamp_height;
  body_height         = belt_clamp_height*1.25;
  body_rounded        = wall_thickness*2;

  module body() {
    hull() {
      translate([tensioner_belt_dist_x,0.5+belt_width/2-belt_clamp_depth/2,body_height/2]) {
        for(x=[left,right]) {
          for(z=[top,bottom]) {
            translate([(body_width/2-body_rounded/2)*x,0,(body_height/2-body_rounded/2)*z]) {
              rotate([90,0,0]) {
                hole(body_rounded,body_depth,resolution);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    hull() {
      translate([tensioner_belt_dist_x,0.5+belt_width/2-belt_clamp_depth/2,0]) {
        for(x=[left,right]) {
          for(y=[front,rear]) {
            translate([(hole_width/2-hole_rounded/2)*x,(hole_depth/2-hole_rounded/2)*y,body_height/2]) {
              hole(hole_rounded,body_height+1,8);
            }
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

module belt_clamp_tensioner() {
  module body() {
    hull() {
      translate([tensioner_belt_dist_x,0.5+belt_width/2-belt_clamp_depth/2,0]) {
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
    // belt teeth
    translate([0,0,0]) {
      //% cube([belt_thickness,belt_width,belt_clamp_height+2],center=true);
      translate([0,belt_width-0.5,0]) {
        belt_teeth();
      }

      for(side=[bottom]) {
        translate([0,belt_width-0.5,side*(belt_clamp_height/2+0.5)]) {
          hull() {
            cube([belt_thickness+1,belt_width*3+1,1],center=true);
            cube([belt_thickness,belt_width*3,2],center=true);
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

translate([0,0,belt_clamp_height/2]) {
  belt_clamp_tensioner();
}

belt_tensioner_body();

translate([30,0,0]) {
  z_belt_anchor();
}
