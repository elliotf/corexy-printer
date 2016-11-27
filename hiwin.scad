use     <util.scad>;
include <config.scad>;

// MGN9H
hiwin_rail_width          = 9;
hiwin_rail_height         = 6.5;
hiwin_rail_hole_diam      = 3.5;
hiwin_rail_hole_head_diam = 6;
hiwin_rail_hole_from_end  = 7.5;
//hiwin_rail_hole_spacing   = 20;
hiwin_rail_hole_spacing   = 19;
hiwin_block_width         = 20;
hiwin_block_len           = 39.9;
hiwin_block_height        = 10;
hiwin_block_clearance     = 2;
hiwin_block_hole_diam     = 3;
hiwin_block_hole_dist_len = 16;
hiwin_block_hole_dist_wid = 15;

hiwin_block_rail_offset   = (- hiwin_rail_height / 2) + (hiwin_block_height/2) + hiwin_block_clearance;

// MGN12H

resolution = 16;

module hiwin_block() {
  module body() {
    cube([hiwin_block_width,hiwin_block_len,hiwin_block_height],center=true);
  }

  module holes() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([hiwin_block_hole_dist_wid/2*x,hiwin_block_hole_dist_len/2*y,hiwin_block_height/2]) {
          hole(hiwin_block_hole_diam, hiwin_block_height,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module hiwin_rail(len) {
  module body() {
    cube([hiwin_rail_width,len,hiwin_rail_height],center=true);
  }

  module rail_hole() {
    hole(hiwin_rail_hole_diam, hiwin_rail_height + 1, resolution);
    translate([0,0,hiwin_rail_height/2]) {
      hole(hiwin_rail_hole_head_diam, 7, resolution);
    }
  }

  module holes() {
    translate([0,len/2-hiwin_rail_hole_from_end,0]) {
      rail_hole();
    }
    translate([0,-len/2,0]) {
      for(y=[hiwin_rail_hole_from_end:hiwin_rail_hole_spacing:len-hiwin_rail_hole_from_end]) {
        translate([0,y,0]) {
          rail_hole();
        }
      }
    }
  }

  color("silver") difference() {
    body();
    holes();
  }
}

hiwin_rail_len = 300;
x_pos = 0;
y_pos = 0;

for(x=[left,right]) {
  translate([(hiwin_rail_len/2-hiwin_block_width/2)*x,0,hiwin_rail_height/2]) {
    translate([0,-(hiwin_rail_len-hiwin_block_len)/2+y_pos,hiwin_block_rail_offset]) {
      hiwin_block();
    }

    hiwin_rail(hiwin_rail_len);
  }
}

translate([0,-(hiwin_rail_len-hiwin_block_len)/2+y_pos,0]) {
  //translate([0,0,hiwin_block_height/2+hiwin_block_rail_offset+hiwin_rail_height/2+hiwin_rail_width/2]) {
  translate([0,0,hiwin_block_height/2+hiwin_block_rail_offset+hiwin_rail_height/2+hiwin_rail_height/2]) {
    //translate([-(hiwin_rail_len-hiwin_block_len-hiwin_block_width*2)/2+x_pos,-hiwin_block_rail_offset,0]) {
    translate([-(hiwin_rail_len-hiwin_block_len-hiwin_block_width*2)/2+x_pos,0,hiwin_block_rail_offset]) {
      //rotate([90,0,0]) {
        rotate([0,0,90]) {
          hiwin_block();
        }
      //}
    }

    //rotate([90,0,0]) {
      rotate([0,0,90]) {
        hiwin_rail(hiwin_rail_len);
      }
    //}
  }
}
