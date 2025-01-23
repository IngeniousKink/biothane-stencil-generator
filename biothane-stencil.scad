// BIOTHANE STENCIL GENERATOR

// https://github.com/IngeniousKink/biothane-stencil-generator

function get_property(properties, key) =
    let(index = search([key], properties))
    len(index) > 0 ? properties[index[0] + 1] : undef;

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
    material_width,
    material_height, 
    extra_width, 
    outer_width, 
    stencil_length
) {
    if (max([for (i = [0: len(hole_sets)-1]) hole_sets[i][10]]) > 0) {
        anvil_guide_height = 0; // wall_thickness + material_height;
        
        translate([0, 0, -anvil_guide_height]) { // move it below the base plate
            difference() {
                union() { 
                    translate([-extra_width, 0, 0])
                    cube([
                        outer_width,
                        2 * wall_thickness + stencil_length,
                        anvil_guide_height
                    ], false);
                    
                    for (i = [0: len(hole_sets)-1]) {
                        if (hole_sets[i][0] && hole_sets[i][10] > 0) {
                            holes_from_set(
                                hole_sets[i],
                                wall_thickness,
                                material_width,
                                stencil_length,
                                _diameter = hole_sets[i][10] + wall_thickness,
                                _height = anvil_guide_height,
                                _diameter_top_multiplier = 1
                            );
                        }
                    }
                }
                
                translate([0, 0, anvil_guide_height * -0.5]) {
                    for (i = [0: len(hole_sets)-1]) {
                        if (hole_sets[i][0] && hole_sets[i][10] > 0) {
                            holes_from_set(
                                hole_sets[i],
                                wall_thickness,
                                material_width,
                                stencil_length,
                                _diameter = hole_sets[i][10],
                                _height = anvil_guide_height * 1.5,
                                _diameter_top_multiplier = 1
                            );
                        }
                    }
                }
            }
        }
    }
}


module biothane_stencil(properties) {

    stencil_length = get_property(properties, "stencil_length");
    material_width = get_property(properties, "material_width");
    side_pane_length = get_property(properties, "side_pane_length");
    material_height = get_property(properties, "material_height");
    wall_thickness = get_property(properties, "wall_thickness");
    auto_side_pane_length = get_property(properties, "auto_side_pane_length");

    text_left = get_property(properties, "text_left");
    text_right = get_property(properties, "text_right");
    font_size = get_property(properties, "font_size");
    auto_text_right_append_material_width = get_property(properties, "auto_text_right_append_material_width");

    include_front_pane = get_property(properties, "include_front_pane");
    include_back_pane = get_property(properties, "include_back_pane");

    marker_width = get_property(properties, "marker_width");
    marker_short_mark_length = get_property(properties, "marker_short_mark_length");
    extra_width = get_property(properties, "extra_width");

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

    hole_set_count = max(
      [
        for (i = [1:100]) (
          get_property(properties, str("holes", i, "_enabled")) != undef
        )
        ? i 
        : 0
      ]
    );

    hole_sets = [
        for (i = [1:hole_set_count]) [
            get_property(properties, str("holes", i, "_enabled")),
            get_property(properties, str("holes", i, "_diameter")),
            get_property(properties, str("holes", i, "_diameter_top_multiplier")),
            get_property(properties, str("holes", i, "_columns")),
            get_property(properties, str("holes", i, "_rows")),
            get_property(properties, str("holes", i, "_column_spacing")),
            get_property(properties, str("holes", i, "_row_spacing")),
            get_property(properties, str("holes", i, "_horizontal_offset")),
            get_property(properties, str("holes", i, "_vertical_offset")),
            get_property(properties, str("holes", i, "_rivet_inner_diameter")),
            get_property(properties, str("holes", i, "_anvil_guide"))
        ]
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
              material_width,
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

        for (i = [0: len(hole_sets)-1]) {
          if (hole_sets[i][0] /*.enabled*/) {
              holes_from_set(
                  hole_sets[i],
                  wall_thickness,
                  material_width,
                  stencil_length
              );
          }
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
