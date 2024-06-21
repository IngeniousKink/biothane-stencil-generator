// BIOTHANE STENCIL GENERATOR

// https://github.com/IngeniousKink/biothane-stencil-generator

// PARAMETERS

// dimensions
WALL_THICKNESS = 3;                                // Thickness of the walls in mm
INNER_WIDTH = 13;                                  // Inner width of the stencil in mm
DEPTH = 100;                                      // Outer DEPTH in mm
MATERIAL_HEIGHT = 2.5;                             // Height of the material to be stencil in mm
SIDE_PANE_DEPTH = DEPTH - 20;                           // Length of the side pane in mm

// holes
number_of_holes = 5;                               // Total number of holes in one row
holes_grid_length = 60;                            // Total length from first hole to last hole
hole_diameter = 2;                                 // Diameter of each hole
number_of_rows = 3;                                // Number of rows of holes
distance_between_rows = (
  (INNER_WIDTH/(number_of_rows+1))
);                                                 // Vertical distance between rows of holes

// text label
label = "biothane-stencil-generator";
font_size = 3;                                     // Font size for the text
text_height = WALL_THICKNESS;                      // Text extrusion height
outer_width_text = str(INNER_WIDTH, "mm");
combined_text = str(label, " — ", outer_width_text);

// toggle for front and back panes
INCLUDE_FRONT_PANE = false;                        // Include front pane if true
INCLUDE_BACK_PANE = false;                         // Include back pane if true


FRONT_LEFT_CUTOUT = false;
FRONT_RIGHT_CUTOUT = false;
BACK_LEFT_CUTOUT = false;
BACK_RIGHT_CUTOUT = false;


// measuring markers
long_mark_length = INNER_WIDTH;                    // Length of the long marker, e.g., 1cm
short_mark_length = 5;                             // Length of the short marker, e.g. for millimeters
mark_width = 0.5;                                  // Width of the marker lines
mark_depth = 2;                                    // DEPTH the markings cut into the pane

// END OF PARAMETERS

outer_width = INNER_WIDTH + (2 * WALL_THICKNESS);  // Outer outer_width of the panes in mm

module measure_markings() {
    for (pos = [0:(DEPTH/2)-1]) {
        mark_length = (pos % 10 == 0) ? long_mark_length : short_mark_length;
        
        translate([
          0,
          pos,
          (WALL_THICKNESS - MATERIAL_HEIGHT)-mark_depth
        
        ])
        rotate([90,90,0])
        cube([mark_depth, mark_length, 0.5], true);
    }
}

module triangular_cutout(offset_side, offset_end) {
    translate([outer_width/2, -DEPTH/2, -(WALL_THICKNESS + MATERIAL_HEIGHT)/2])
    linear_extrude(height = (WALL_THICKNESS + MATERIAL_HEIGHT * 1.000001)) {
        polygon(points=[
            [0, -WALL_THICKNESS*1.001],
            [(-outer_width/2) + offset_end, -WALL_THICKNESS*1.001],
            [0, ((DEPTH - SIDE_PANE_DEPTH)/2) - offset_side]
        ]);
    }
}

module biothane_stencil() {
    difference() {
        // base model
        cube([outer_width, DEPTH + (2*WALL_THICKNESS), WALL_THICKNESS + MATERIAL_HEIGHT], true);
 
        // inner cutout
        translate([0, 0, MATERIAL_HEIGHT])
        cube([INNER_WIDTH, DEPTH*1.0001, MATERIAL_HEIGHT*1.1], true);

        // front pane cutout
        if (!INCLUDE_FRONT_PANE) {
            translate([0, WALL_THICKNESS/2 + DEPTH/2 , 0])
            cube([outer_width, WALL_THICKNESS, WALL_THICKNESS + MATERIAL_HEIGHT], true);
        }

        // back pane cutout
        if (!INCLUDE_BACK_PANE) {
            translate([0, -WALL_THICKNESS/2 - DEPTH/2 , 0])
            cube([
              outer_width,
              WALL_THICKNESS,
              (WALL_THICKNESS + MATERIAL_HEIGHT)*1.001
            ], true);
        }

        // left side text cutout
        translate([-WALL_THICKNESS/2 + (outer_width/2), 0, 0])
        rotate([90, 0, 90])
        text_module();

        // triangular edges cutout
        if (!FRONT_LEFT_CUTOUT) {
          mirror([1, 0, 0])
          mirror([0, 1, 0])
          triangular_cutout(offset_side = 3, offset_end = 3);
        }
        
        if (!FRONT_RIGHT_CUTOUT) {
           mirror([0, 1, 0])
           triangular_cutout(offset_side = 3, offset_end = 3);
        }
        
        if (!BACK_LEFT_CUTOUT) {
          mirror([1, 0, 0])
          triangular_cutout(offset_side = 3, offset_end = 3);
        }
        
        if (!BACK_RIGHT_CUTOUT) {
          mirror([0, 0, 0])
          triangular_cutout(offset_side = 3, offset_end = 3);
        }
        
        // holes cutout
        holes();

        // bottom pane measure cutout
        measure_markings();
        mirror([0,1,0]) measure_markings();
    }
}

module holes() {
    holes_grid_width = (
        (number_of_rows - 1) * distance_between_rows
    );
    
    hole_spacing = holes_grid_length / (number_of_holes - 1);

    horizontal_offset = holes_grid_width / 2;
    vertical_offset = holes_grid_length / 2;
    
    // Loop through the positions and create holes
    for (i = [0:number_of_holes-1]) {
        for (j = [0:number_of_rows-1]) {
            translate([
                // Adjust x-direction for centering
                -horizontal_offset + distance_between_rows * j,
                
                // Adjust y-direction for centering
                -vertical_offset + hole_spacing * i,
            
                // Center on the z axis
                WALL_THICKNESS/2 
            ])
            cylinder(
              d=hole_diameter,
              h=WALL_THICKNESS * 3,
              $fn=50,
              center=true
            );
        }
    }
}

module text_module() {
    color([0,1,1])
    linear_extrude(height = text_height)
    text(combined_text, size = font_size, halign = "center", valign = "center", $fn = 50);
}

biothane_stencil();
