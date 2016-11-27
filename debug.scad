include <main.scad>;
use <belt_retainer.scad>;
use <assembly.scad>;

x_axis();

idler_diam = 20;

for(side=[left,right]) {
  for(end=[front,rear]) {
    translate([(xy_line_x+belt_thickness/2)*side,y_carriage_line_bearing_y+y_pos+end*50,(belt_width/2+1.25)*side*end]) {
      cube([belt_thickness,100,belt_width],center=true);
    }
  }
  translate([(xy_line_x+idler_diam+belt_thickness*1.5)*side,-y_rod_len/2-idler_diam/2-4+y_rod_len/2+idler_diam,-(belt_width/2+1.25)*side]) {
    cube([belt_thickness,y_rod_len+idler_diam*2,belt_width],center=true);
  }

  translate([side*(xy_line_x+belt_thickness+idler_diam/2),-y_rod_len/2-idler_diam/2-4,-(belt_width/2+1.25)*side]) {
    % hole(idler_diam,line_bearing_thickness,resolution);
  }

  translate([(xy_line_x-line_bearing_diam/2)*side,y_rod_len/2+sheet_thickness+line_bearing_diam/2,(belt_width/2+1.25)*side]) {
    % hole(line_bearing_diam,line_bearing_thickness,resolution);
  }
  translate([side*(xy_line_x+motor_side/2-z_pulley_diam/2-belt_thickness/2),y_rod_len/2+motor_side/2,0]) {
    translate([0,0,-belt_width*2]) {
      % motor();
    }
    translate([0,0,(belt_width/2+1.25)*-side]) {
      % hole(z_pulley_diam,belt_width+2,resolution);
    }
  }
}

//rod_clamp(z_rod_diam);

//belt_clamp_tensioner();

translate([-x_carriage_width-5,0,0]) {
  //x_carriage();
}

//for(side=[right]) {
  //translate([x_carriage_width/2+y_carriage_width+40,0,0]) {
    mirror([1,0,0]) {
      //y_carriage();
    }
  //}
//}

translate([x_carriage_width/2+y_carriage_width+40,60,0]) {
  //rear_xy_endcap();
}

translate([x_carriage_width/2+y_carriage_width+40,-60,0]) {
  //front_xy_endcap();
}

rotate([90,0,0]) {
  //z_carriage_bearing_support_arm();
}
