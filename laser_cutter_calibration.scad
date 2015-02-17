include <config.scad>;
include <positions.scad>;
include <boxcutter.scad>;
use <util.scad>;

box_side_len = bc_tab_from_end_dist * 2 + bc_tab_slot_pair_len;

/*
//projection(cut=true) {
  translate([0,box_side_len,0]) {
    for(side=[left,right]) {
      mirror([1-side,0,0]) {
        translate([box_side_len*2.75,0,0]) {
          difference() {
            box_side([box_side_len*2,box_side_len*1],[3,3,3,3]);

            translate([-box_side_len*1,0,0]) {
              for(x=[1:7]) {
                translate([rod_diam*1+rod_diam*1.35*x,rod_diam,0]) {
                  hole(rod_diam-0.02*x,sheet_thickness+1,resolution);

                }
                translate([rod_diam*1+rod_diam*1.35*x,-rod_diam,0]) {
                  hole(rod_diam-0.02*x,sheet_thickness+1,x*2);
                }
              }
            }
          }
        }
      }
    }
  }
  translate([0,-box_side_len,0]) {
    for(side=[left,right]) {
      translate([box_side_len*2.75*side,0,0]) {
        box_side([box_side_len*2,box_side_len*1],[4,3,4,3]);
      }
    }
  }

  for(side=[left,right]) {
    translate([0,box_side_len*side,0]) {
      box_side([box_side_len*1,box_side_len*1],[4,4,4,4]);
    }
  }
//}
*/

projection(cut=true) {
  for(side=[left,right]) {
    translate([box_side_len*side,0,0]) {
      box_side([box_side_len*1,box_side_len*1],[4,0,0,3]);
    }
  }
}
