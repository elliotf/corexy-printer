module box_side(dimensions=[0,0],sides=[0,0,0,0],tab_len=10,screw_diam=3,nut_diam=5.5,shoulder_width=3,thickness=6) {
  // creates a side of a box with tabs or slots that surrounds the provided dimensions

  IS_TAB = 1;
  IS_SLOT = 2;
  WITH_HOLES = 1;
  NO_HOLES = 0;

  // TODO: have top of box overlap sides

  // dimensions is the internal width/height of the sheet
  // sides is a list of top,right,bottom,left sides
  //   0 == no tabs,no slots
  //   1 == tabs
  //   2 == slots
  // screw_diam is the diameter of the screw that will be used with the nut to clamp
  // nut_diam is the diameter of the nut that will be used with the screw to clamp
  // shoulder_width is:
  //   the amount of material that should be on the other side of a slot
  //   used as a basis for the distance of a tab/slot from an edge
  // thickness is the thickness of the material

  colors = ["red","green","blue","yellow"];

  nyloc_nut_height = 4;
  std_nut_height = 2.5;
  nut_height = nyloc_nut_height;

  tab_slot_pair_space = tab_len * 2.0;
  tab_slot_pair_len = tab_len*2 + tab_slot_pair_space;
  space_between_tab_slot_pairs = 35;
  space_between_tab_slot_pairs = tab_slot_pair_len*2;
  pair_and_spacing_len = tab_slot_pair_len + space_between_tab_slot_pairs;
  tab_from_end_dist = shoulder_width*2;

  function hole_diam(diam,sides=8) = 1 / cos(180 / sides) / 2;

  function offset_for_side(side) = dimensions[1-side%2]/2 + thickness/2;
  function len_for_side(side) = dimensions[side%2];

  module tab() {
    translate([tab_len/2,0,0])
      cube([tab_len,thickness,thickness],center=true);
  }

  module tab_pair(with_hole=NO_HOLES) {
    tab();
    translate([tab_len+tab_slot_pair_space,0,0]) tab();

    if(with_hole==WITH_HOLES) {
      translate([tab_slot_pair_len/2,0,0])
        cylinder(r=screw_diam*hole_diam(12),h=thickness+0.05,center=true,$fn=12);
    }
  }

  module screw_nut_hole() {
    thick = thickness+0.05;
    screw_len = shoulder_width*2 + nut_height;

    translate([tab_slot_pair_len/2,-thickness/2,0]) {
      translate([0,-shoulder_width*1.5-nut_height/2,0])
        cube([nut_diam,nut_height,thick],center=true);

      translate([0,-screw_len/2+0.05,0])
        cube([screw_diam,screw_len,thick],center=true);
    }
  }

  module position_along_line(to_fill=0) {
    space_avail = to_fill + space_between_tab_slot_pairs;
    //echo("to_fill: ", to_fill);
    //echo("space_avail: ", space_avail);
    //echo("tab_slot_pair_len: ", tab_slot_pair_len);

    raw_num_fit = floor(space_avail/pair_and_spacing_len);

    //echo("raw_num_fit: ", raw_num_fit);

    function adjust_num_fit()
      = (raw_num_fit > 2)
      ? raw_num_fit
      : (tab_slot_pair_len*2+tab_len < to_fill)
        ? 2
        : 1;

    num_fit = adjust_num_fit();

    space_consumed = tab_slot_pair_len*num_fit;
    space_remaining = to_fill - space_consumed;
    space_between = space_remaining/(num_fit-1);
    //echo("new space between tab sets: ", space_between);

    //echo("WILL FIT ", num_fit, " TAB SETS WITH ", space_between, "mm BETWEEN THEM");

    if(num_fit ==1) {
      translate([-tab_slot_pair_len/2,0,0])
      child(0);
    } else {
      translate([-to_fill/2,0,0]) {
        for(i=[0:num_fit-1]) {
          translate([i*(tab_slot_pair_len+space_between),0,0]) {
            child(0);
          }
        }
      }
    }
  }

  module add_material_for_slot_side(side) {
    slots_to_right = floor(sides[(side+3)%4]/IS_SLOT);
    slots_to_left  = floor(sides[(side+1)%4]/IS_SLOT);

    len_to_add = shoulder_width+thickness;

    len = len_to_add*(slots_to_right+slots_to_left) + len_for_side(side);

    trans_dist = 0 + len_to_add/2*slots_to_right + len_to_add/2*-slots_to_left;
    translate([trans_dist,(shoulder_width)/2,0])
      cube([len,thickness+shoulder_width,thickness],center=true);
  }

  function tab_space_for_side(side) = dimensions[side%2]-tab_from_end_dist*2;

  difference() {
    union() {
      cube([dimensions[0],dimensions[1],thickness],center=true);

      for(side=[0,1,2,3]) {
        color(colors[side])
          rotate([0,0,90*side])
            translate([0,offset_for_side(side),0]) {
              // tabs?
              if(sides[side] == IS_TAB) {
                //echo("add tabs for side ", side);
                position_along_line(tab_space_for_side(side)) tab_pair();
              }

              // slots?
              if(sides[side] == IS_SLOT) {
                //echo("add material for slots on side ", side);
                add_material_for_slot_side(side);
              }
            }
      }
    }

    for(side=[0,1,2,3]) {
      for(side=[0,1,2,3]) {
        color(colors[side])
          rotate([0,0,90*side])
            translate([0,offset_for_side(side),0]) {
              // tabs?
              if(sides[side] == IS_TAB) {
                //echo("add screw/nut slots between tabs!");
                position_along_line(tab_space_for_side(side)) screw_nut_hole();
              }

              // slots?
              if(sides[side] == IS_SLOT) {
                //echo("add slots!");
                scale([1,1,1.05])
                  position_along_line(tab_space_for_side(side)) tab_pair(WITH_HOLES);
              }
            }
      }
    }
  }
}

vol = [250,200,73];

width = vol[0];
depth = vol[1];
height = vol[2];

thickness = 6;
top = 1;
bottom = -1;
left = -1;
right = 1;
front = -1;
rear = 1;

% cube(vol,center=true);

shoulder_width = 40;
overhead = thickness+3;
opening_width = width-shoulder_width*2;
opening_depth = depth-shoulder_width+overhead;
opening_height = height-shoulder_width+overhead;

// top
translate([0,0,(height/2+thickness/2+thickness*2)*top]) {
  difference() {
    box_side([width,depth],[2,2,2,2]);

    translate([0,shoulder_width/-2-overhead/2-0.05,0]) {
      cube([opening_width,opening_depth,thickness+1],center=true);
    }
  }
}

// bottom
translate([0,0,(height/2+thickness/2+thickness*2)*bottom])
  box_side([width,depth],[1,1,1,1]);

// sides
for(side=[-1,1]) {
  translate([(width/2+thickness/2+thickness*2)*side,0,0]) rotate([0,0,90]) rotate([90,0,0])
    box_side([depth,height],[1,1,2,2]);
}

// front
translate([0,(depth/2+thickness/2+thickness*2)*front,0]) rotate([90,0,0])
  difference() {
    box_side([width,height],[1,2,2,2]);

    hull() {
      translate([0,height/2+thickness/2+0.05,0]) {
        cube([opening_width,thickness,thickness+1],center=true);
      }

      translate([0,-height/2+(height-opening_height),0]) {
        cube([opening_width-25,1,thickness+1],center=true);
      }
    }
  }

// rear
translate([0,(depth/2+thickness/2+thickness*2)*rear,0]) rotate([90,0,0])
  box_side([width,height],[1,1,2,1]);
