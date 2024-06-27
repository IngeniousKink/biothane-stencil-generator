// BIOTHANE STENCIL GENERATOR

// https://github.com/IngeniousKink/biothane-stencil-generator

// PARAMETERS
/* [general dimensions] */

// Thickness of the walls in mm
wall_thickness = 3; // .1

// Width of the material in mm
material_width = 13; // .1

// Height of the material in mm
material_height = 2.5; // .1

// Length of the side pane in mm
side_pane_length = 40;

// if set, automatically compute the next value
auto_side_pane_length = false;

// Length of the stencil
stencil_length = 70;

/* [Holes (first set)] */
// enable this set of holes
holes1_enabled = true;

holes1_diameter = 6.5; // .01
holes1_columns = 3;
holes1_rows = 1;
holes1_column_spacing = 10; // .01
holes1_row_spacing = 20; // .01

holes1_horizontal_offset = 0.0; // .01
holes1_vertical_offset = 0.0; // .01

/* [Holes (second set)] */
// enable this set of holes
holes2_enabled = true;

holes2_diameter = 6.5; // .01
holes2_columns = 3;
holes2_rows = 1;
holes2_column_spacing = 10; // .01
holes2_row_spacing = 20; // .01

holes2_horizontal_offset = 0.0; // .01
holes2_vertical_offset = 0.0; // .01

/* [text label] */
label = "biothane-stencil-generator";
font_size = 3;
text_height = wall_thickness;
text_append_material_width = false;


/* [front and back panes] */
include_front_pane = false;
include_back_pane = false;

/* [edge cutouts front left] */
front_left_cutout = false;
front_left_cutout_offset_side = 0;
front_left_cutout_offset_end = 0;

/* [edge cutouts front right] */
front_right_cutout = false;
front_right_cutout_offset_side = 0;
front_right_cutout_offset_end = 0;

/* [edge cutouts back left] */
back_left_cutout = false;
back_left_cutout_offset_side = 0;
back_left_cutout_offset_end = 0;

/* [edge cutouts back right] */
back_right_cutout = false;
back_right_cutout_offset_side = 0;
back_right_cutout_offset_end = 0;

/* [measuring markers] */
marker_width = 0.5;

marker_short_mark_length = 5;
marker_long_mark_length = material_width;

// END OF PARAMETERS

EXTRA = 5 + 5; // use to prevent z-fighting

outer_width = material_width + (2 * wall_thickness);

if (auto_side_pane_length) {
  side_pane_length = stencil_length - 20;
}

text_material_width = str(material_width, "mm");

combined_text = (
  text_append_material_width
  ? str(label, " — ", text_material_width)
  : label
);

module measure_markings() {
    for (pos = [0:(stencil_length/2)-1]) {
        mark_length = (pos % 10 == 0) ? marker_long_mark_length : marker_short_mark_length;
        
        translate([
          0,
          pos,
          (-EXTRA/2) + 0.5
        
        ])
        rotate([90,90,0])
        cube([EXTRA, mark_length, 0.5], true);
    }
}

module triangular_cutout(offset_side, offset_end) {
    translate([outer_width/2, -stencil_length/2, -(wall_thickness + material_height)/2])
    linear_extrude(height = (wall_thickness + material_height)) {
        polygon(points=[
            [0, -wall_thickness],
            [(-outer_width/2) + offset_end, -wall_thickness],
            [0, ((stencil_length - side_pane_length)/2) - offset_side]
        ]);
    }
}

module biothane_stencil() {
    difference() {
        // base model
        cube([
          outer_width,
          stencil_length + (2*wall_thickness),
          wall_thickness + material_height
        ], true);
 
        // inner cutout
        translate([0, 0, (-material_height-EXTRA)/2])
        cube([
          material_width,
          stencil_length,
          material_height + EXTRA
        ], true);

        // front pane cutout
        if (!include_front_pane) {
            translate([
              0,
              (wall_thickness + stencil_length + EXTRA)/2,
              0
            ])
            
            union() {
              // back pane cutout
              cube([
                outer_width + EXTRA,
                wall_thickness + EXTRA,
                wall_thickness + material_height + EXTRA
              ], true);
              
              // inner cutout
              translate([0, 0, (-material_height-EXTRA)/2])
              cube([
                material_width,
                stencil_length,
                material_height + EXTRA
              ], true);
            
            }

            
            
        }

        // back pane cutout
        if (!include_back_pane) {
            translate([
              0,
              -1 * (wall_thickness + stencil_length + EXTRA)/2,
              0
            ])
            union() {
            
              // back pane cutout
              cube([
                outer_width + EXTRA,
                wall_thickness + EXTRA,
                wall_thickness + material_height + EXTRA
              ], true);
              
              // inner cutout
              translate([0, 0, (-material_height-EXTRA)/2])
              cube([
                material_width,
                stencil_length,
                material_height + EXTRA
              ], true);
            
            }
        }

        // left side text cutout
        translate([-wall_thickness/2 + (outer_width/2), 0, 0])
        rotate([90, 0, 90])
        text_module();

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
        
        if (holes1_enabled) {
            holes(
                diameter = holes1_diameter,
                columns = holes1_columns,
                rows = holes1_rows,
                column_spacing = holes1_column_spacing,
                row_spacing = holes1_row_spacing,
                horizontal_offset = holes1_horizontal_offset,
                vertical_offset = holes1_vertical_offset
            );
        }

        if (holes2_enabled) {
            holes(
                diameter = holes2_diameter,
                columns = holes2_columns,
                rows = holes2_rows,
                column_spacing = holes2_column_spacing,
                row_spacing = holes2_row_spacing,
                horizontal_offset = holes2_horizontal_offset,
                vertical_offset = holes2_vertical_offset
            );
        }

        // bottom pane measure cutout
        measure_markings();
        mirror([0,1,0]) measure_markings();
    }
}

module holes(
    diameter = 6.5,
    columns = 3,
    rows = 1,
    column_spacing = 10,
    row_spacing = 20,
    horizontal_offset = 0.0,
    vertical_offset = 0.0
) {
    grid_width = (
        (rows - 1) * row_spacing
    );

    grid_length = (
        (columns - 1) * column_spacing
    );

    horizontal_offset = (grid_width / 2) + horizontal_offset;
    vertical_offset = (grid_length / 2) + vertical_offset;
    
    // Loop through the positions and create holes
    for (i = [0:columns-1]) {
        for (j = [0:rows-1]) {
            translate([
                // Adjust x-direction for centering
                -horizontal_offset + row_spacing * j,
                
                // Adjust y-direction for centering
                -vertical_offset + column_spacing * i,
            
                // Center on the z axis
                wall_thickness/2 
            ])
            cylinder(d=diameter, h=wall_thickness * 3, $fn=50, center=true);
        }
    }
}


module text_module() {
    color([0,1,1])
    linear_extrude(height = text_height)
    text(combined_text, size = font_size, halign = "center", valign = "center", $fn = 50);
}

biothane_stencil();
