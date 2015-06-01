use <util.scad>;

bc_tab_len           = 8;
bc_shoulder_width    = 4;
//bc_thickness         = 6.5;
bc_thickness         = sheet_thickness;
bc_tab_from_end_dist = 8;
bc_ziptie_width      = 3.75;
bc_ziptie_thickness  = 1.75;
bc_screw_diam        = 2.8;
bc_screw_len         = 6;
bc_nut_diam          = 5.5;
bc_kerf_width        = 0.01;

bc_tab_slot_pair_space          = 20;
bc_tab_slot_pair_len            = bc_tab_len*2 + bc_tab_slot_pair_space;
bc_space_between_tab_slot_pairs = bc_tab_slot_pair_len*1.25;
bc_pair_and_spacing_len         = bc_tab_slot_pair_len + bc_space_between_tab_slot_pairs;

BC_ZIP_TAB    = 1;
BC_ZIP_SLOT   = 2;
BC_SCREW_TAB  = 3;
BC_SCREW_SLOT = 4;

BC_NO_HOLES         = 0;
BC_WITH_ZIP_HOLES   = 1;
BC_WITH_SCREW_HOLES = 2;

function bc_hole_diam(diam,sides=8) = 1 / cos(180 / sides) / 2;

module bc_screw_nut_hole() {
  nyloc_nut_height = 4;
  std_nut_height = 2;
  bc_nut_height = nyloc_nut_height;
  bc_nut_height = std_nut_height;

  bc_screw_len = bc_thickness + bc_nut_height;

  translate([0,-bc_thickness/2,0]) {
    translate([0,-bc_thickness*0.65-bc_nut_height/2,0])
      square([bc_nut_diam-bc_kerf_width*2,bc_nut_height-bc_kerf_width],center=true);

    translate([0,-bc_screw_len/2+0.05,0])
      square([bc_screw_diam-bc_kerf_width*2,bc_screw_len],center=true);
  }
}

module bc_offset_ziptie_hole() {
  translate([bc_tab_slot_pair_len/2,-bc_shoulder_width*.75-bc_thickness/2,0]) {
    square([bc_ziptie_width,bc_ziptie_thickness],center=true);
  }
}

module bc_offset_screw_hole() {
  translate([bc_tab_slot_pair_len/2,0,0]) {
    bc_screw_nut_hole();
  }
}

module bc_position_along_line(to_fill=0) {
  bc_space_avail = to_fill + bc_space_between_tab_slot_pairs;
  raw_num_fit = floor(bc_space_avail/bc_pair_and_spacing_len);

  function adjust_num_fit()
    = (raw_num_fit > 2)
    ? raw_num_fit
    : (bc_tab_slot_pair_len*2+bc_tab_len < to_fill)
      ? 2
      : 1;

  num_fit = adjust_num_fit();

  bc_space_consumed = bc_tab_slot_pair_len*num_fit;
  bc_space_remaining = to_fill - bc_space_consumed;
  bc_space_between = bc_space_remaining/(num_fit-1);

  if(num_fit ==1) {
    translate([-bc_tab_slot_pair_len/2,0,0])
    children();
  } else {
    translate([-to_fill/2,0,0]) {
      for(i=[0:num_fit-1]) {
        translate([i*(bc_tab_slot_pair_len+bc_space_between),0,0]) {
          children();
        }
      }
    }
  }
}

module bc_tab_pair(with_hole=BC_WITH_ZIP_HOLES) {
  translate([-bc_tab_slot_pair_len/2,0,0]) bc_offset_tab_pair(with_hole);
}

module bc_offset_tab_pair(with_hole=BC_NO_HOLES) {
  module tab() {
    translate([bc_tab_len/2,0,0])
      square([bc_tab_len-bc_kerf_width*2,bc_thickness+0.05],center=true);
  }

  tab();
  translate([bc_tab_len+bc_tab_slot_pair_space,0,0]) tab();

  if(with_hole==BC_WITH_ZIP_HOLES) {
    for(side=[-1,1]) {
      translate([bc_tab_slot_pair_len/2,(bc_thickness/2+bc_shoulder_width*.0+bc_ziptie_thickness*1)*side,0]) {
        square([bc_ziptie_width,bc_ziptie_thickness],center=true);
      }
    }
  }

  if(with_hole==BC_WITH_SCREW_HOLES) {
    translate([bc_tab_slot_pair_len/2,0,0])
      accurate_circle(bc_screw_diam,32);
  }
}

function bc_offset_for_side(side,dimensions)       = dimensions[1-side%2]/2 + bc_thickness/2;
function bc_tab_space_for_side(side,dimensions) = dimensions[side%2]-bc_tab_from_end_dist*2;
function bc_tab_space_for_len(len)              = len-bc_tab_from_end_dist*2;

module box_holes_for_side(len,type) {
  tab_space = bc_tab_space_for_len(len);
  if(type == BC_ZIP_TAB) {
    bc_position_along_line(tab_space) bc_offset_ziptie_hole();
  }

  if(type == BC_SCREW_TAB) {
    bc_position_along_line(tab_space) bc_offset_screw_hole();
  }

  // slots
  if(type == BC_ZIP_SLOT || type == BC_SCREW_SLOT) {
    scale([1,1,1.05])
      bc_position_along_line(tab_space) bc_offset_tab_pair(type/2);
  }
}

colors = ["red","green","blue","yellow"];

module box_holes(dimensions=[0,0],sides=[0,0,0,0]) {
  for(side=[0,1,2,3]) {
    color(colors[side]) {
      rotate([0,0,90*side]) {
        translate([0,bc_offset_for_side(side,dimensions),0]) {
          box_holes_for_side(dimensions[side%2],sides[side]);
        }
      }
    }
  }
}

module box_side(dimensions=[0,0],sides=[0,0,0,0]) {
  // creates a side of a box with tabs or slots that surrounds the provided dimensions

  // dimensions is the internal width/height of the sheet
  // sides is a list of top,right,bottom,left sides
  //   0 == no tabs,no slots
  //   1 == tabs
  //   2 == slots
  // bc_shoulder_width is:
  //   the amount of material that should be on the other side of a slot
  //   used as a basis for the distance of a tab/slot from an edge
  // bc_thickness is the bc_thickness of the material

  function len_for_side(side) = dimensions[side%2];
  function added(type) = (type == BC_ZIP_SLOT || type == BC_SCREW_SLOT)
                       ? (bc_shoulder_width+bc_thickness)
                       : 0
                       ;

  to_top    = added(sides[0]);
  to_bottom = added(sides[2]);
  to_right  = added(sides[1]);
  to_left   = added(sides[3]);

  width  = dimensions[0] + to_right + to_left;
  height = dimensions[1] + to_top + to_bottom;

  difference() {
    union() {
      translate([to_right/2-to_left/2,to_top/2-to_bottom/2,0]) {
        square([width,height],center=true);
      }

      // add material
      for(side=[0,1,2,3]) {
        color(colors[side]) {
          rotate([0,0,90*side]) {
            translate([0,bc_offset_for_side(side,dimensions),0]) {
              // tabs
              if(sides[side] == BC_ZIP_TAB || sides[side] == BC_SCREW_TAB) {
                bc_position_along_line(bc_tab_space_for_side(side,dimensions)) bc_offset_tab_pair();
              }
            }
          }
        }
      }
    }

    box_holes(dimensions,sides);
  }
}
