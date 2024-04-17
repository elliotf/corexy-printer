include <lumpyscad/lib.scad>; 

module toolhead() {
  translate([0,-16.61-11.2,0]) {
    % color("red") hole(0.4,300,128);
  }
  translate([0,-16.61,21.29]) {
    translate([0,-11.2,0]) {
      translate([0,0,0]) {
        rotate([0,0,0]) {
          translate([-36,-61.2,0.01]) {
            rotate([-90,0,0]) {
              rotate([90,0,0]) {
                rotate([0,0,180]) {
                  import("../chirpy-voron/V0/Dragon_Burner/STLs/v0.2/G2SA_Sherpa_Mount.stl");
                }
              }
            }
          }
        }
      }

      translate([0,0,0]) {
        rotate([0,0,0]) {
          rotate([-90,0,0]) {
            translate([-147.85,162.5,-23.73]) {
              import("../chirpy-voron/V0/Dragon_Burner/STLs/v0.2/Cowl_SlideSwipe.stl");
            }
          }
        }
      }

      translate([0,0,0]) {
        rotate([0,0,0]) {
          rotate([-90,0,0]) {
            translate([-330.05,161.68,-9.7]) {
              import("../chirpy-voron/V0/Dragon_Burner/STLs/v0.2/Dragon_Mount.stl");
            }
          }
        }
      }
    }
  }

  translate([16.5,front*113,-56]) {
    //import("../slideswipe/Experimental/UnklickySlideSwipe\(better\ name\ pending\)/STL/ProbeLoose.stl");
  }
}

toolhead();
