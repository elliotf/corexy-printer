use <util.scad>;

left            = -1;
right           = 1;
to_clip_diam    = 7.75; // plus a little bit of slop for 3mm retainer
to_clip_diam    = 6.3; // plus a little bit of slop for 1.75 retainer
clip_rim_diam   = 10.2;   // plus a little bit of slop for 3mm e3d retainer
clip_rim_diam   = 7.3;   // plus a little bit of slop for 1.75 e3d retainer
extrusion_width = 0.5;
resolution      = 128;

module bowden_clip(diam=to_clip_diam,height=1.8) {
  surround_width = extrusion_width*6;
  outer_diam     = diam + surround_width*2;
  opening_angle  = 60;

  around_clip_rim = (outer_diam - clip_rim_diam)/2;

  module body() {
    translate([0,0,0]) {
      hole(outer_diam,height*2,resolution);
      translate([0,outer_diam*.4,0]) {
        cube([outer_diam,outer_diam*.8,height*2],center=true);
      }
    }
  }

  module holes() {
    translate([0,outer_diam/2+1,height]) {
      cube([clip_rim_diam,2,height*2],center=true);
    }

    hole(diam,10,resolution);

    translate([0,0,5]) {
      hole(clip_rim_diam,10,resolution);
    }

    hull() {
      for(side=[left,right]) {
        rotate([0,0,opening_angle*side]) {
          translate([0,-outer_diam/2,0]) {
            cube([0.05,outer_diam,10],center=true);
          }
        }
      }
    }
    hull() {
      for(side=[left,right]) {
        rotate([0,0,(opening_angle+10)*side]) {
          translate([0,-outer_diam/2,5]) {
            cube([0.05,outer_diam,10],center=true);
          }
        }
      }
    }
    /*
    % translate([0,-outer_diam,0]) {
      cube([to_clip_diam-1,outer_diam*2,10],center=true);
      translate([0,0,5]) {
        cube([clip_rim_diam-.6,outer_diam*2,10],center=true);
      }
    }
    */
  }

  module bridges() {
    for(side=[left,right]) {
      rotate([0,0,opening_angle*side]) {
        translate([0,-outer_diam/2+surround_width/2,-height/2]) {
          hole(surround_width,height,resolution);
        }
      }
      rotate([0,0,(opening_angle+10)*side]) {
        translate([0,-outer_diam/2+around_clip_rim/2,0]) {
          hole(around_clip_rim,height*2,resolution);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

bowden_clip();
