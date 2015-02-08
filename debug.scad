include <config.scad>;
use <main.scad>;

x_carriage();

for(side=[left,right]) {
  mirror([1+side,0,0]) {
    translate([-60,0,0]) {
      y_carriage();
    }
  }
}
