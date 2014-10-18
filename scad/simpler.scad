include <config.scad>;
//include <positions.scad>;

use <util.scad>;

min_material_thickness = 1;

/*
// stacked 623 bearings
belt_bearing_diam  = 10;
belt_bearing_inner = 3;
belt_bearing_thickness = 8;
*/

y_carriage_width = min_material_thickness*2 + bearing_diam + min_material_thickness + spacer + belt_bearing_diam;
x_rod_len     = build_x + x_carriage_width + (spacer + belt_bearing_diam + min_material_thickness + bearing_diam) *2;
x_carriage_width = bearing_len + min_material_thickness * 2;

x_rod_len     = build_x + x_carriage_width + y_carriage_width*2;
x_rod_spacing = bearing_diam + min_material_thickness * 2 + rod_diam;

y_rod_len     = build_y + max(belt_bearing_diam*2) + 2 + sheet_thickness*2;
y_rod_x       = x_rod_len/2 - bearing_diam/2 - min_material_thickness*2;

x_carriage_height    = x_rod_spacing + bearing_diam + min_material_thickness*2;
x_carriage_thickness = bearing_diam;

echo("X/Y ROD LEN: ", x_rod_len, y_rod_len);

// x rods
% for (side=[top,bottom]) {
  translate([0,0,x_rod_spacing/2*side]) {
    rotate([0,90,0]) {
      rotate([0,0,22.5/2]) {
        cylinder(r=rod_diam/2,h=x_rod_len,center=true,$fn=16);
      }
    }
  }
}

// x end idlers
% for (end=[left,right]) {
  /*
  for (side=[front,rear]) {
    translate([(y_rod_x - bearing_diam/2 - min_material_thickness - belt_bearing_diam/2)*end,(belt_bearing_diam/2 + .5)*side,0]) {
      difference() {
        cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
        cylinder(r=belt_bearing_inner/2,h=belt_bearing_thickness+1,center=true,$fn=8);
      }
    }
  }
  */

  // y bearings
  translate([0,0,0]) {
    translate([y_rod_x*end,0,0]) {
      rotate([90,0,0]) {
        rotate([0,0,22.5/2]) {
          cylinder(r=bearing_diam/2,h=bearing_len,center=true,$fn=16);
          cylinder(r=rod_diam/2,h=y_rod_len,center=true,$fn=16);
        }
      }
    }
  }
}

module x_carriage() {
  res = 16;

  body_side = rear;

  module body() {
    translate([0,(x_carriage_thickness/2-rod_diam/2)*body_side,0]) {
      cube([x_carriage_width,x_carriage_thickness,x_carriage_height],center=true);
    }
  }

  module holes() {
    for(side=[top,bottom]) {
      translate([0,0,x_rod_spacing/2*side]) {
        translate([0,x_carriage_thickness/2*-body_side,0]) {
          cube([bearing_len,x_carriage_thickness,bearing_diam-1],center=true);
          cube([x_carriage_width+1,x_carriage_thickness,rod_diam+1],center=true);
        }
        rotate([0,90,0]) {
          rotate([0,0,22.5/2]) {
            hole(bearing_diam,bearing_len,res);
            hole(rod_diam+1,x_carriage_width+2,res);
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

module y_carriage() {
  res = 24;

  rod_bearing_x = min_material_thickness*2 + bearing_diam/2;
  belt_bearing_x = rod_bearing_x + bearing_diam/2 + min_material_thickness + spacer + belt_bearing_diam/2;
  belt_bearing_y = rod_diam/2+belt_bearing_inner/2 + min_material_thickness*2;

  x_rod_clamp_len = belt_bearing_x + belt_bearing_inner/2 + min_material_thickness*3;
  carriage_depth  = (belt_bearing_y + belt_bearing_inner/2 + min_material_thickness*2)*2;

  module body() {

    // main body, hold x rods
    hull() {
      for(side=[top,bottom]) {
        translate([x_rod_clamp_len/2,0,x_rod_spacing/2*side]) {
          rotate([0,90,0]) {
            hole(rod_diam+min_material_thickness*4,x_rod_clamp_len,res);
          }
        }
      }
    }

    // rod bearing body
    hull() {
      translate([x_rod_clamp_len/2,0,0]) {
        //cube([rod_bearing_x*2,bearing_len+min_material_thickness*2,bearing_diam+min_material_thickness*3],center=true);
        cube([x_rod_clamp_len,carriage_depth,bearing_diam+min_material_thickness*3],center=true);
      }
      /*
      translate([min_material_thickness/2,0,0]) {
        cube([min_material_thickness,bearing_len+min_material_thickness*2,bearing_diam+min_material_thickness*3],center=true);
      }
      translate([min_material_thickness+bearing_diam/2,0,0]) {
        rotate([90,0,0]) {
          hole(bearing_diam+min_material_thickness*2,bearing_len+min_material_thickness*2,res);
        }
      }
      */
    }
  }

  module holes() {
    for(side=[top,bottom]) {
      translate([x_rod_clamp_len/2,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          hole(rod_diam,x_rod_clamp_len+4,res);
        }
      }
    }

    translate([rod_bearing_x,0,0]) {
      // overhang bearing opening
      intersection() {
        rotate([90,0,0]) {
          rotate([0,0,22.5]) {
            hole(bearing_diam,bearing_len*2,8);
          }
        }
        translate([bearing_diam*.85,0,0]) {
          cube([bearing_diam,bearing_len*2,bearing_diam*2],center=true);
        }
      }
      // non-overhang bearing opening
      rotate([90,0,0]) {
        rotate([0,0,22.5/4]) {
          hole(bearing_diam,bearing_len*2,32);
        }
      }

      // rod opening
      rotate([90,0,0]) {
        rotate([0,0,22.5]) {
          //hole(bearing_diam-min_material_thickness*2,build_y,8);
        }
      }
    }

    // room for belt/filament
    translate([belt_bearing_x+belt_bearing_diam/2,0,0]) {
      cube([belt_bearing_diam,belt_bearing_diam*2,belt_bearing_thickness+1],center=true);
    }

    for (side=[front,rear]) {
      translate([belt_bearing_x,belt_bearing_y*side,0]) {
        rotate([0,0,22.5/2]) {
          hole(belt_bearing_diam + spacer*2,belt_bearing_thickness+1,16);
        }

        rotate([0,0,22.5]) {
          hole(belt_bearing_inner,50,8);
        }

        // room for belt/filament
        translate([0,belt_bearing_diam/2*side,0]) {
          cube([belt_bearing_diam+spacer*2,belt_bearing_diam+spacer*2,belt_bearing_thickness+1],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }

  % for (side=[front,rear]) {
    translate([belt_bearing_x,belt_bearing_y*side,0]) {
      difference() {
        cylinder(r=belt_bearing_diam/2,h=belt_bearing_thickness,center=true);
        cylinder(r=belt_bearing_inner/2,h=belt_bearing_thickness+1,center=true,$fn=16);
      }
    }
  }
}

translate([0,0,-x_carriage_height/2-build_z/2-2]) {
  % cube([build_x,build_y,build_z],center=true);
}

translate([-build_x/2,0,0]) {
  x_carriage();
}

for(side=[left,right]) {
  mirror([1+side,0,0]) {
    translate([-x_rod_len/2,0,0]) {
      y_carriage();
    }
  }
}
