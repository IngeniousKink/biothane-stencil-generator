// BIOTHANE STENCIL GENERATOR

// https://github.com/IngeniousKink/biothane-stencil-generator

// PARAMETERS
/* [general dimensions] */

// Length of the stencil
stencil_length = 70;

// Width of the material in mm
material_width = 13; // .1

// Length of the side pane in mm
side_pane_length = 40;

// Height of the material in mm
material_height = 2.5; // .1

// Thickness of the walls in mm
wall_thickness = 3; // .1


// if set, automatically compute the next value
auto_side_pane_length = false;


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
holes1_diameter_top_multiplier = 1.3; // .1
holes1_rivet_inner_diameter = 4.5; // .01

holes1_anvil_guide = 0;

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
holes2_diameter_top_multiplier = 1.3; // .1
holes2_rivet_inner_diameter = 4.5; // .01

holes2_anvil_guide = 0;

/* [text text_left] */
text_left = "biothane-stencil-generator";
text_right = "";

font_size = 3;
text_height = wall_thickness/2;
auto_text_right_append_material_width = true;


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

EXTRA = 50; // use to prevent z-fighting

__base__ = "not used here";

outer_width = material_width + 2*wall_thickness;

if (auto_side_pane_length) {
  side_pane_length = stencil_length - 20;
}

text_material_width = str(material_width, "mm");

combined_text_right = (
  auto_text_right_append_material_width
  ? str(text_right, text_material_width)
  : text_right
);

module measure_markings() {
    for (pos = [1:stencil_length]) {
        mark_length = (
        
        (pos % 10 == 0)
          ? marker_long_mark_length
          : marker_short_mark_length
        );
        
        translate([
          material_width/2,
          pos,
          (EXTRA/2) - 0.5
        
        ])
        rotate([90,90,0])
        cube([EXTRA, mark_length, 0.5], true);
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

module anvil_guide() {

  if (holes1_anvil_guide > 0 || holes2_anvil_guide > 0) {

  anvil_guide_height = wall_thickness + material_height;
  
  translate([0,0, - anvil_guide_height]) // move it below the base plate

  difference() {
    // anvil guide base plate  + wall
    union() { 
      // extra base plate
      cube([
        outer_width,
        2*wall_thickness + stencil_length,
        anvil_guide_height
      ], false);
    
      // wall around the anvil guides

      if (holes1_enabled && holes1_anvil_guide > 0) {
        holes(
            diameter = holes1_anvil_guide + wall_thickness,
            columns = holes1_columns,
            rows = holes1_rows,
            column_spacing = holes1_column_spacing,
            row_spacing = holes1_row_spacing,
            horizontal_offset = holes1_horizontal_offset,
            vertical_offset = holes1_vertical_offset,
            diameter_top_multiplier = 1,
            h = anvil_guide_height
        );
      }

      if (holes2_enabled && holes2_anvil_guide > 0) {
        holes(
            diameter = holes2_anvil_guide + wall_thickness,
            columns = holes2_columns,
            rows = holes2_rows,
            column_spacing = holes2_column_spacing,
            row_spacing = holes2_row_spacing,
            horizontal_offset = holes2_horizontal_offset,
            vertical_offset = holes2_vertical_offset,
            diameter_top_multiplier = 1,
            h = anvil_guide_height
        );
      }

    }
    
    translate([0,0,anvil_guide_height * -0.5]) {
    // anvil guide cutouts
    if (holes1_enabled && holes1_anvil_guide > 0) {
      holes(
          diameter = holes1_anvil_guide,
          columns = holes1_columns,
          rows = holes1_rows,
          column_spacing = holes1_column_spacing,
          row_spacing = holes1_row_spacing,
          horizontal_offset = holes1_horizontal_offset,
          vertical_offset = holes1_vertical_offset,
          diameter_top_multiplier = 1,
          h = anvil_guide_height * 1.5
      );
    }

    if (holes2_enabled && holes2_anvil_guide > 0) {
      holes(
          diameter = holes2_anvil_guide,
          columns = holes2_columns,
          rows = holes2_rows,
          column_spacing = holes2_column_spacing,
          row_spacing = holes2_row_spacing,
          horizontal_offset = holes2_horizontal_offset,
          vertical_offset = holes2_vertical_offset,
          diameter_top_multiplier = 1,
          h = anvil_guide_height * 1.5
      );
    }
  }
  }
  }
}

module biothane_stencil() {
    difference() {
        union() {
        
          // base model
          cube([
            outer_width,
            2*wall_thickness + stencil_length,
            wall_thickness + material_height
          ], false);
        
          anvil_guide();
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
            measure_markings();        
        }

        // left side text cutout
        translate([
          material_width + wall_thickness*1.5,
          stencil_length/2 + wall_thickness,
          (wall_thickness + material_height)/2
          
        ])
        rotate([90, 0, 90])
        text_module(text_left);
        
        // right side text cutout
        translate([
          wall_thickness/2,
          stencil_length/2 + wall_thickness,
          (wall_thickness + material_height)/2
          
        ])
        rotate([0, -90, 0])
        rotate([0, 0, 90])
        rotate([0, 0, 180])
        text_module(combined_text_right);
        
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
        
        if (holes1_enabled) {
            holes(
                diameter = holes1_diameter,
                columns = holes1_columns,
                rows = holes1_rows,
                column_spacing = holes1_column_spacing,
                row_spacing = holes1_row_spacing,
                horizontal_offset = holes1_horizontal_offset,
                vertical_offset = holes1_vertical_offset,
                diameter_top_multiplier = holes1_diameter_top_multiplier,
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
                vertical_offset = holes2_vertical_offset,
                diameter_top_multiplier = holes2_diameter_top_multiplier,
            );
        }

    }
    
    /*
    if($preview) {
    // visualize material
    
    
    // visualize rivets
    if (holes1_enabled) {
       translate([0,0,-wall_thickness])
       color("silver")
       scale([0,0,3])
       holes(
                diameter = holes1_rivet_inner_diameter,
                columns = holes1_columns,
                rows = holes1_rows,
                column_spacing = holes1_column_spacing,
                row_spacing = holes1_row_spacing,
                horizontal_offset = holes1_horizontal_offset,
                vertical_offset = holes1_vertical_offset,
                diameter_top_multiplier = 1,
            );
       }
       
    if (holes2_enabled) {
       translate([0,0,-wall_thickness])
       color("silver")
       holes(
                diameter = holes2_rivet_inner_diameter,
                columns = holes2_columns,
                rows = holes2_rows,
                column_spacing = holes2_column_spacing,
                row_spacing = holes2_row_spacing,
                horizontal_offset = holes2_horizontal_offset,
                vertical_offset = holes2_vertical_offset,
                diameter_top_multiplier = 1,
            );
       }       
    }
    */
}

module holes(
    diameter = 6.5,
    columns = 3,
    rows = 1,
    column_spacing = 10,
    row_spacing = 20,
    horizontal_offset = 0.0,
    vertical_offset = 0.0,
    diameter_top_multiplier = 1.5,
    h = wall_thickness*1.001,
) {
    grid_width = (
        (rows - 1) * row_spacing
    );

    grid_length = (
        (columns - 1) * column_spacing
    );

    translate([
      // Adjust x-direction for centering
      -((grid_width / 2) + horizontal_offset - material_width / 2 - wall_thickness),

      // Adjust y-direction for centering
      -((grid_length / 2) + vertical_offset - stencil_length / 2 - wall_thickness)
      ]
    )
    
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


module text_module(text) {
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
