// BIOTHANE STENCIL GENERATOR

// https://github.com/IngeniousKink/biothane-stencil-generator

module measure_markings(
    stencil_length, 
    marker_long_mark_length, 
    marker_short_mark_length, 
    material_width, 
    extra_width
) {
    for (pos = [1:stencil_length]) {
        mark_length = (
            (pos % 10 == 0)
                ? marker_long_mark_length
                : marker_short_mark_length
        );
        
        translate([
            material_width / 2,
            pos,
            (extra_width / 2) - 0.5
        ])
        rotate([90, 90, 0])
        cube([extra_width, mark_length, 0.5], true);
    }
}


module triangular_cutout(offset_side, offset_end) {
    translate([
      outer_width/2,
      -stencil_length/2,
      0//-(wall_thickness + material_height)/2
    ])
    linear_extrude(height = (wall_thickness + material_height)) {
        polygon(points=[
            [0, -wall_thickness],
            [(-outer_width/2) + offset_end, -wall_thickness],
            [0, ((stencil_length - side_pane_length)/2) - offset_side]
        ]);
    }
}

module anvil_guide(
    hole_sets, 
    wall_thickness, 
    material_height, 
    extra_width, 
    outer_width, 
    stencil_length
) {
    if (hole_sets[0][10 /*.anvil_guide*/] > 0 || hole_sets[1][10 /*.anvil_guide*/] > 0) {
        anvil_guide_height = 0; // wall_thickness + material_height;
        
        translate([0, 0, -anvil_guide_height]) { // move it below the base plate
            difference() {
                // anvil guide base plate + wall
                union() { 
                    // extra base plate
                    translate([-extra_width, 0, 0])
                    cube([
                        outer_width,
                        2 * wall_thickness + stencil_length,
                        anvil_guide_height
                    ], false);
                    
                    // wall around the anvil guides
                    if (hole_sets[0][0 /*.enabled*/] && hole_sets[0][10 /*.anvil_guide*/] > 0) {
                        holes_from_set(
                            hole_sets[0],
                            _diameter = hole_sets[0][10 /*.anvil_guide*/] + wall_thickness,
                            _height = anvil_guide_height,
                            _diameter_top_multiplier = 1
                        );
                    }

                    if (hole_sets[1][0 /*.enabled*/] && hole_sets[1][10 /*.anvil_guide*/] > 0) {
                        holes_from_set(
                            hole_sets[1],
                            _diameter = hole_sets[1][10 /*.anvil_guide*/] + wall_thickness,
                            _height = anvil_guide_height,
                            _diameter_top_multiplier = 1
                        );
                    }
                }

                translate([0, 0, anvil_guide_height * -0.5]) {
                    // anvil guide cutouts
                    if (hole_sets[0][0 /*.enabled*/] && hole_sets[0][10 /*.anvil_guide*/] > 0) {
                        holes_from_set(
                            hole_sets[0],
                            _diameter = hole_sets[0][10 /*.anvil_guide*/],
                            _height = anvil_guide_height * 1.5,
                            _diameter_top_multiplier = 1
                        );
                    }

                    if (hole_sets[1][0 /*.enabled*/] && hole_sets[1][10 /*.anvil_guide*/] > 0) {
                        holes_from_set(
                            hole_sets[1],
                            _diameter = hole_sets[1][10 /*.anvil_guide*/],
                            _height = anvil_guide_height * 1.5,
                            _diameter_top_multiplier = 1
                        );
                    }
                }
            }
        }
    }
}


module biothane_stencil(
    stencil_length = 70,
    material_width = 13,
    side_pane_length = 40,
    material_height = 2.5,
    wall_thickness = 3,
    auto_side_pane_length = false,
    holes1_enabled = true,
    holes1_diameter = 6.5,
    holes1_columns = 3,
    holes1_rows = 1,
    holes1_column_spacing = 10,
    holes1_row_spacing = 20,
    holes1_horizontal_offset = 0.0,
    holes1_vertical_offset = 0.0,
    holes1_diameter_top_multiplier = 1.3,
    holes1_rivet_inner_diameter = 4.5,
    holes1_anvil_guide = 0,
    holes2_enabled = true,
    holes2_diameter = 6.5,
    holes2_columns = 3,
    holes2_rows = 1,
    holes2_column_spacing = 10,
    holes2_row_spacing = 20,
    holes2_horizontal_offset = 0.0,
    holes2_vertical_offset = 0.0,
    holes2_diameter_top_multiplier = 1.3,
    holes2_rivet_inner_diameter = 4.5,
    holes2_anvil_guide = 0,
    text_left = "biothane-stencil-generator",
    text_right = "",
    font_size = 3,
    auto_text_right_append_material_width = true,
    include_front_pane = false,
    include_back_pane = false,
    front_left_cutout = false,
    front_left_cutout_offset_side = 0,
    front_left_cutout_offset_end = 0,
    front_right_cutout = false,
    front_right_cutout_offset_side = 0,
    front_right_cutout_offset_end = 0,
    back_left_cutout = false,
    back_left_cutout_offset_side = 0,
    back_left_cutout_offset_end = 0,
    back_right_cutout = false,
    back_right_cutout_offset_side = 0,
    back_right_cutout_offset_end = 0,
    marker_width = 0.5,
    marker_short_mark_length = 5,
    extra_width = 0
) {

    EXTRA = 50;

    outer_width = material_width + 2*wall_thickness + 2 * extra_width;
    
    if (auto_side_pane_length) {
        side_pane_length = stencil_length - 20;
    }

    text_material_width = str(material_width, "mm");
    combined_text_right = (
        auto_text_right_append_material_width
        ? str(text_right, text_material_width)
        : text_right
    );
    
    marker_long_mark_length = material_width;

    hole_sets = [
    /*
     [
      enabled,
      diameter,
      diameter_top_multiplier,
      columns,
      rows,
      column spacing,
      row spacing,
      horizontal offset,
      vertical offset,
      rivet inner diameter,
      anvil guide
      ]
    */


    // Hole set 1:
    [
        holes1_enabled,                 // [0]
        holes1_diameter,                // [1]
        holes1_diameter_top_multiplier, // [2]
        holes1_columns,                 // [3]
        holes1_rows,                    // [4]
        holes1_column_spacing,          // [5]
        holes1_row_spacing,             // [6]
        holes1_horizontal_offset,       // [7]
        holes1_vertical_offset,         // [8]
        holes1_rivet_inner_diameter,    // [9]
        holes1_anvil_guide              // [10]
    ],
    // Hole set 2:
    [
        holes2_enabled,
        holes2_diameter,
        holes2_diameter_top_multiplier,
        holes2_columns,
        holes2_rows,
        holes2_column_spacing,
        holes2_row_spacing,
        holes2_horizontal_offset,
        holes2_vertical_offset,
        holes2_rivet_inner_diameter,
        holes2_anvil_guide
    ],
    // ... add additional hole sets here ...
];





    difference() {
        union() {
        
          // base model

          translate([-extra_width, 0, 0])
          cube([
            outer_width,
            2*wall_thickness + stencil_length,
            wall_thickness + material_height
          ], false);
        
          anvil_guide(
              hole_sets, 
              wall_thickness, 
              material_height, 
              extra_width, 
              outer_width, 
              stencil_length,
          );
        }
 
        // inner cutout
        translate([wall_thickness, wall_thickness, wall_thickness])
        
        {
        
        cube([
          material_width,
          stencil_length*1.0001,
          material_height + EXTRA
        ], false);

        // front pane cutout
        if (!include_front_pane) {
            translate([
              -(wall_thickness + EXTRA)/2,
              -(wall_thickness + EXTRA),
              -EXTRA/2
            ])
              // front pane cutout
              cube([
                outer_width + EXTRA,
                wall_thickness + EXTRA,
                wall_thickness + material_height + EXTRA
              ], false);
              
              // inner cutout
              translate([0, -stencil_length/2, 0])
              cube([
                material_width,
                stencil_length,
                material_height + EXTRA
              ], false);
            
         
            
        }

        // back pane cutout
        if (!include_back_pane) {
            translate([
              -(wall_thickness + EXTRA)/2,
              (stencil_length),
              -EXTRA/2
            ])            
              // back pane cutout
              cube([
                outer_width + EXTRA,
                wall_thickness + EXTRA,
                wall_thickness + material_height + EXTRA
              ], false);
              
              // inner cutout
              translate([0, stencil_length/2, 0])
              cube([
                material_width,
                stencil_length,
                material_height + EXTRA
              ], false);
            
            }
        
            // bottom pane measure cutout
            measure_markings(
              stencil_length, 
              marker_long_mark_length, 
              marker_short_mark_length, 
              material_width, 
              extra_width
            );        
        }

        // left side text cutout
        translate([
          material_width + wall_thickness*1.5 + extra_width,
          stencil_length/2 + wall_thickness,
          (wall_thickness + material_height)/2
          
        ])
        rotate([90, 0, 90])
        text_module(text_left, wall_thickness, font_size)
        
        // right side text cutout
        translate([
          (wall_thickness/2) - extra_width,
          stencil_length/2 + wall_thickness,
          (wall_thickness + material_height)/2
          
        ])
        rotate([0, -90, 0])
        rotate([0, 0, 90])
        rotate([0, 0, 180])
        text_module(combined_text_right, wall_thickness, font_size)

        translate([
          material_width/2 + wall_thickness,
          stencil_length/2 + wall_thickness
        ]) {
        // triangular edges cutout
        if (front_left_cutout == true) {
          mirror([1, 0, 0])
          mirror([0, 1, 0])
          triangular_cutout(
             offset_side = front_left_cutout_offset_side,
             offset_end = front_left_cutout_offset_end
          );
        }
        
        if (front_right_cutout == true) {
           mirror([0, 1, 0])
           triangular_cutout(
             offset_side = front_right_cutout_offset_side,
             offset_end = front_right_cutout_offset_end
           );
        }
        
        if (back_left_cutout == true) {
          mirror([1, 0, 0])
          triangular_cutout(
            offset_side = back_left_cutout_offset_side,
            offset_end = back_left_cutout_offset_end
          );
        }
        
        if (back_right_cutout == true) {
          mirror([0, 0, 0])
          triangular_cutout(
            offset_side = back_right_cutout_offset_side,
            offset_end = back_right_cutout_offset_end
          );
        }
        }
        
        if (hole_sets[0][0/*.enabled*/]) {
            holes_from_set(
              hole_sets[0], 
              wall_thickness, 
              material_width, 
              stencil_length,
           );
        }

        if (hole_sets[1][0/*.enabled*/]) {
           holes_from_set(
              hole_sets[1], 
              wall_thickness, 
              material_width, 
              stencil_length,
           ); 
        }
    }

}


module holes_from_set(
    hole_set, 
    wall_thickness, 
    material_width, 
    stencil_length,
    _diameter = -1, 
    _height = -1, 
    _diameter_top_multiplier = -1, 

) {
    diameter = (_diameter > -1) ? _diameter : hole_set[1];
    diameter_top_multiplier = (_diameter_top_multiplier > -1) ? _diameter_top_multiplier : hole_set[2];

    columns = hole_set[3];
    rows = hole_set[4];
    column_spacing = hole_set[5];
    row_spacing = hole_set[6];
    horizontal_offset = hole_set[7];
    vertical_offset = hole_set[8];
    h = (_height > -1) ? _height : wall_thickness * 1.001;

    grid_width = (rows - 1) * row_spacing;
    grid_length = (columns - 1) * column_spacing;

    translate([
        // Adjust x-direction for centering
        -((grid_width / 2) + horizontal_offset - material_width / 2 - wall_thickness),

        // Adjust y-direction for centering
        -((grid_length / 2) + vertical_offset - stencil_length / 2 - wall_thickness)
    ])
    
    // Loop through the positions and create holes
    for (i = [0:columns-1]) {
        for (j = [0:rows-1]) {
            translate([
                row_spacing * j,
                column_spacing * i,
            
            ])
            
            cylinder(
                d1=diameter * diameter_top_multiplier,
                d2=diameter,
                h=h,
                $fn=50,
                center=false
            );
        }
    }
}

module text_module(text, wall_thickness, font_size) {
    color([0,1,1])
    linear_extrude(height = wall_thickness)
    text(
        text,
        size = font_size,
        halign = "center",
        valign = "center",
        $fn = 50
    );
}


biothane_stencil();
