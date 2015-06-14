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
  anchor_depth        = sheet_pos_y - sheet_thickness/2 - z_rod_pos_y;
  belt_clamp_depth    = belt_width + 1 + wall_thickness*2;
  belt_clamp_x        = 0;
  belt_clamp_y        = -belt_width/2-0.5+belt_clamp_depth/2;
  anchor_width        = m3_nut_diam + wall_thickness*3;
  rear_sheet_anchor_x = m3_nut_diam*1.5;

  module tooth_body() {
    translate([0,belt_clamp_y,-z_belt_anchor_height/2]) {
      hull() {
        for(x=[left,right]) {
          for(y=[front,rear]) {
            translate([(belt_clamp_width/2-rounded_diam/2)*x,(belt_clamp_depth/2-rounded_diam/2)*y,0]) {
              hole(rounded_diam,z_belt_anchor_height,resolution);
            }
          }
        }
      }

      translate([belt_clamp_width/2,belt_clamp_depth/2,0]) {
        cube([belt_clamp_width*1.5,belt_clamp_depth,z_belt_anchor_height],center=true);
      }
    }
  }

  module back_plate_anchor(height=z_belt_anchor_height) {
    translate([rear_sheet_anchor_x,anchor_depth-belt_clamp_depth/2,-height/2]) {
      for(x=[left,right]) {
        for(y=[front,rear]) {
          translate([(anchor_width/2-rounded_diam/2)*x,(belt_clamp_depth/2-rounded_diam/2)*y,0]) {
            hole(rounded_diam,height,resolution);
          }
        }
      }
    }
  }

  module body() {
    tooth_body();

    hull() {
      back_plate_anchor();
    }
  }

  module holes() {
    //% cube([belt_thickness,belt_width,z_belt_anchor_height+2],center=true);

    translate([0,-belt_width+0.5,-z_belt_anchor_height/2]) {
      belt_teeth(z_belt_anchor_height);
    }

    // z idler clearance
    translate([0,0,0]) {
      hull() {
        for(x=[rear_sheet_anchor_x-anchor_width/2-rounded_diam,-20]) {
          for(y=[belt_clamp_y+belt_clamp_depth/2+rounded_diam,anchor_depth*2]) {
            translate([x,y,-z_belt_anchor_height/2]) {
              hole(rounded_diam*2,z_belt_anchor_height+1,resolution);
            }
          }
        }
      }
    }

    // fancy roundedness
    translate([0,0,0]) {
      hull() {
        for(x=[belt_clamp_width/2+rounded_diam/2,20]) {
          for(y=[anchor_depth-belt_clamp_depth-rounded_diam/2,-20]) {
            translate([x,y,-z_belt_anchor_height/2]) {
              hole(rounded_diam,z_belt_anchor_height+1,resolution);
            }
          }
        }
      }
    }

    // zip tie hole
    translate([belt_clamp_x,belt_clamp_y,-z_belt_anchor_height/2]) {
      translate([belt_clamp_width/2+zip_tie_thickness/2,0,0]) {
        cube([zip_tie_thickness,belt_clamp_depth-rounded_diam+0.05,zip_tie_width],center=true);
      }
      translate([0,belt_clamp_depth/2+zip_tie_thickness/2,0]) {
        cube([belt_clamp_width-rounded_diam+0.05,zip_tie_thickness,zip_tie_width],center=true);
      }
      translate([belt_clamp_width/2-rounded_diam/2,belt_clamp_depth/2-rounded_diam/2,0]) {
        intersection() {
          rotate_extrude() {
            translate([rounded_diam/2+zip_tie_thickness/2,0,0]) {
              square([zip_tie_thickness,zip_tie_width],center=true);
            }
          }

          translate([10,10,0]) {
            cube([20,20,20],center=true);
          }
        }
      }
    }

    // rear sheet mounting holes
    for(side=[top,bottom]) {
      translate([rear_sheet_anchor_x,0,-z_belt_anchor_height/2+z_belt_anchor_hole_spacing/2*side]) {
        rotate([90,0,0]) {
          rotate([0,0,90]) {
            hole(m3_diam,anchor_depth*2+1,6);

            translate([0,0,extrusion_width*4]) {
              hole(m3_nut_diam,anchor_depth*2,6);
            }
          }
        }
      }
    }

    // flange in case the first layer is squished
    translate([0,-belt_width/2+0.5,-z_belt_anchor_height-0.5]) {
      hull() {
        cube([belt_thickness+1,belt_width*2+1,1],center=true);
        cube([belt_thickness,belt_width*2,2],center=true);
      }
    }

    // flange the corner to avoid interference with sheet corner
    translate([0,anchor_depth,0]) {
      rotate([-50,0,0]) {
        cube([40,10,extrusion_width*3],center=true);
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

translate([-20,0,0]) {
  //belt_clamp_tensioner();
}

z_belt_anchor();
