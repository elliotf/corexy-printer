use <lumpyscad/lib.scad>;

module dragon_burner() {
  translate([0,-16.61,5.7]) {
    translate([0,-11.2,0]) {
      translate([0,0,0]) {
        rotate([0,0,0]) {
          translate([-36,-61.2,0.01]) {
            rotate([-90,0,0]) {
              rotate([90,0,0]) {
                rotate([0,0,180]) {
                  color("blue") import("Dragon_Burner/Sherpa_Micro_Mount.stl");
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
              color("red") import("Dragon_Burner/Cowl_SlideSwipe.stl");
            }
          }
        }
      }

      translate([0,0,0]) {
        rotate([0,0,0]) {
          rotate([-90,0,0]) {
            translate([-330.05,162.68,-9.7]) {
              color("green") import("Dragon_Burner/Dragon_Mount.stl");
            }
          }
        }
      }
    }
  }
}

module mini_stealthburner() {
  translate([0,-13.6,9]) {
    translate([0,-13.7,0]) {
      color("red") hole(1.5,300,128);
    }
    rotate([90,0,0]) {
      translate([0,0,0]) {
        rotate([0,0,0]) {
          rotate([0,0,180]) {
            translate([-98.2,-99.7,-59.75]) {
              color("blue") import("voron-zero/STLs/Toolheads/Mini_Stealthburner/[a]_MiniSB_Motor_Plate_x1.stl");
            }
          }
        }
      }

      translate([0,0,0]) {
        rotate([0,0,0]) {
          translate([-78.3,75.2,85.85]) {
            rotate([180,0,0]) {
              color("red") import("voron-zero/STLs/Toolheads/Mini_Stealthburner/[a]_MiniSB_Cowling_x1.STL");
            }
          }
        }
      }
      translate([0,0,0]) {
        rotate([0,0,0]) {
          translate([87.63,-56.03,226.86]) {
            rotate([0,180,0]) {
              color("green") import("voron-zero/STLs/Toolheads/Mini_Stealthburner/[a]_MiniSB_MidBody_x1.STL");
            }
          }
        }
      }
    }
  }
}

module toolhead() {
  // dragon_burner();
  mini_stealthburner();
}

toolhead();
