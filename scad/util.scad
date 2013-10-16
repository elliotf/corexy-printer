
module hole(diam,len,sides=8) {
  da = 1 / cos(180 / sides) / 2;
  cylinder(r=da*diam,h=len,center=true,$fn=sides);
}

