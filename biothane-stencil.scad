// BIOTHANE STENCIL GENERATOR

// https://github.com/IngeniousKink/biothane-stencil-generator

function get_property(properties, key) =
    let(index = search([key], properties))
    len(index) > 0 ? properties[index[0] + 1] : undef;

function hole_set(
  index,
  diameter,
  columns=1,
  rows=1, 
  column_spacing=10,
  row_spacing=20,
  horizontal_offset=0,
  vertical_offset=0, 
  diameter_top_multiplier=1
  ) = [
        str("holes", index, "_enabled"), true,
        str("holes", index, "_diameter"), diameter,
        str("holes", index, "_columns"), columns,
        str("holes", index, "_rows"), rows,
        str("holes", index, "_column_spacing"), column_spacing,
        str("holes", index, "_row_spacing"), row_spacing,
        str("holes", index, "_horizontal_offset"), horizontal_offset,
        str("holes", index, "_vertical_offset"), vertical_offset,
        str("holes", index, "_diameter_top_multiplier"), diameter_top_multiplier,
    ];

module measure_markings(
    stencil_length, 
    marker_long_mark_length, 
    marker_short_mark_length, 
    material_width, 
    marker_width
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
            (marker_width / 2) - 0.5
        ])
        rotate([90, 90, 0])
        cube([marker_width, mark_length, 0.5], true);
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

module cutout_pane(properties, pane) {
    wall_thickness = get_property(properties, "wall_thickness");
    material_width = get_property(properties, "material_width");
    material_height = get_property(properties, "material_height");
    stencil_length = get_property(properties, "stencil_length");
    extra_width = get_property(properties, "extra_width");
    EXTRA = 50;

    y_offset = (pane == "front") 
        ? -(wall_thickness + EXTRA) 
        : stencil_length;

    translate([
        -(wall_thickness + EXTRA) / 2,
        y_offset,
        -EXTRA / 2
    ])
    cube([
        material_width + 2 * wall_thickness + 2 * extra_width + EXTRA,
        wall_thickness + EXTRA,
        wall_thickness + material_height + EXTRA
    ], false);

    translate([
        0,
        (pane == "front") ? -stencil_length / 2 : stencil_length / 2,
        0
    ])
    cube([
        material_width,
        stencil_length,
        material_height + EXTRA
    ], false);
}

function compute_hole_sets(properties) = [
    for (i = [1:100]) 
        let(enabled = get_property(properties, str("holes", i, "_enabled")))
        if (enabled != undef)
        [
            enabled,
            get_property(properties, str("holes", i, "_diameter")),
            get_property(properties, str("holes", i, "_diameter_top_multiplier")),
            get_property(properties, str("holes", i, "_columns")),
            get_property(properties, str("holes", i, "_rows")),
            get_property(properties, str("holes", i, "_column_spacing")),
            get_property(properties, str("holes", i, "_row_spacing")),
            get_property(properties, str("holes", i, "_horizontal_offset")),
            get_property(properties, str("holes", i, "_vertical_offset")),
        ]
];


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

    marker_long_mark_length = material_width;

    hole_sets = compute_hole_sets(properties);
    
    difference() {
        union() {
        
          // base model

          translate([-extra_width, 0, 0])
          cube([
            outer_width,
            2*wall_thickness + stencil_length,
            wall_thickness + material_height
          ], false);
        }
 
        // inner cutout
        translate([wall_thickness, wall_thickness, wall_thickness])
        
        {
        
        cube([
          material_width,
          stencil_length*1.0001,
          material_height + EXTRA
        ], false);

            if (!include_front_pane) {
              cutout_pane(properties, "front");
            }

            if (!include_back_pane) {
             cutout_pane(properties, "back");
            }
        
            // bottom pane measure cutout
            measure_markings(
              stencil_length, 
              marker_long_mark_length, 
              marker_short_mark_length, 
              material_width, 
              marker_width,
            );        
        }

        text_cutout(properties, "left");
        text_cutout(properties, "right");
        text_cutout(properties, "front");
        text_cutout(properties, "back");

        text_cutout(properties, "top");
        text_cutout(properties, "bottom");

        #text_cutout(properties, "top_left");
        #text_cutout(properties, "top_right");
        #text_cutout(properties, "top_front");
        #text_cutout(properties, "top_back");

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
// Function to calculate translation based on position
function calculate_text_translation(position, wall_thickness, material_width, material_height, stencil_length, extra_width) =
    (position == "left") ? [material_width + wall_thickness * 1.5 + extra_width, stencil_length / 2 + wall_thickness, (wall_thickness + material_height) / 2] :
    (position == "right") ? [wall_thickness / 2 - extra_width, stencil_length / 2 + wall_thickness, (wall_thickness + material_height) / 2] :
    (position == "front") ? [material_width / 2, wall_thickness / 2, (wall_thickness + material_height) / 2] :
    (position == "back") ? [material_width / 2, stencil_length + wall_thickness, (wall_thickness + material_height) / 2] :
    (position == "top") ? [material_width / 2, stencil_length / 2, material_height - wall_thickness] :
    (position == "bottom") ? [material_width / 2, stencil_length / 2, wall_thickness / 2] :
    (position == "top_left") ? [wall_thickness / 2 - extra_width / 2, stencil_length / 2, material_height + wall_thickness/2] :
    (position == "top_right") ? [+material_width + wall_thickness + extra_width/2, stencil_length / 2, material_height + wall_thickness/2] :
    (position == "top_front") ? [material_width / 2, wall_thickness / 2, material_height + wall_thickness] :
    (position == "top_back") ? [material_width / 2, stencil_length + wall_thickness, material_height + wall_thickness/2] :
    [0, 0, 0]; // Default if no match

// Function to calculate rotation based on position
function calculate_text_rotation(position) =
    (position == "left") ? [90, 0, 90] :
    (position == "right") ? [90, 0, 270] :
    (position == "front") ? [90, 0, 0] :
    (position == "back") ? [90, 0, 180] :
    (position == "top") ? [0, 0, 0] :
    (position == "bottom") ? [0, 180, 0] :
    (position == "top_left") ? [0, 0, 90] :
    (position == "top_right") ? [0, 0, 90] :
    (position == "top_front") ? [0, 0, 0] :
    (position == "top_back") ? [0, 0, 180] :
    [0, 0, 0]; // Default if no match

// Main module
module text_cutout(properties, position = "left") {
    wall_thickness = get_property(properties, "wall_thickness");
    material_width = get_property(properties, "material_width");
    material_height = get_property(properties, "material_height");
    stencil_length = get_property(properties, "stencil_length");
    extra_width = get_property(properties, "extra_width");
    font_size = get_property(properties, "font_size");

    // Dynamically generate the property key for text by concatenating "text_" and position
    text_value = get_property(properties, str("text_", position));

    // Get translation and rotation using the functions
    translation = calculate_text_translation(
        position,
        wall_thickness,
        material_width,
        material_height,
        stencil_length,
        extra_width
    );

    rotation = calculate_text_rotation(position);

    // Apply translation and rotation
    translate(translation)
    rotate(rotation)
    text_module(text_value, wall_thickness, font_size);
}

module text_module(text, wall_thickness, font_size) {
    color([0,1,1])
    linear_extrude(height = wall_thickness)
    text(
        text,
        size = font_size,
        halign = "center",
        valign = "center",
        $fn = 200
    );
}
