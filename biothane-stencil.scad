// BIOTHANE STENCIL GENERATOR

// https://github.com/IngeniousKink/biothane-stencil-generator

// PARAMETERS

// dimensions
WALL_THICKNESS = 3;                                // Thickness of the walls in mm
INNER_WIDTH = 13;                                  // Inner width of the stencil in mm
DEPTH = 2*13;                                      // Outer DEPTH in mm
MATERIAL_HEIGHT = 2.5;                             // Height of the material to be stencil in mm
SIDE_PANE_DEPTH = DEPTH;                           // Length of the side pane in mm

// holes
number_of_holes = 1;                               // Total number of holes in one row
holes_grid_length = 13;                            // Total length from first hole to last hole
hole_diameter = 5;                                 // Diameter of each hole
number_of_rows = 2;                                // Number of rows of holes
distance_between_rows = (
  (INNER_WIDTH/(number_of_rows+1)) + hole_diameter
);                                                 // Vertical distance between rows of holes

// text label
label = "biothane-stencil-generator";
font_size = 3;                                     // Font size for the text
text_height = WALL_THICKNESS;                      // Text extrusion height
outer_width_text = str(INNER_WIDTH, "mm");
combined_text = str(label, " — ", outer_width_text);

// toggle for front and back panes
include_front_pane = false;                        // Include front pane if true
include_back_pane = false;                         // Include back pane if true

// measuring markers
long_mark_length = INNER_WIDTH;                    // Length of the long marker, e.g., 1cm
short_mark_length = 5;                             // Length of the short marker, e.g. for millimeters
mark_width = 0.5;                                  // Width of the marker lines
mark_depth = 2;                                    // DEPTH the markings cut into the pane

// END OF PARAMETERS

outer_width = INNER_WIDTH + (2 * WALL_THICKNESS);  // Outer outer_width of the panes in mm
height = WALL_THICKNESS + 2.5 + WALL_THICKNESS;    // Outer height in mm

module front_pane() {
    if (include_front_pane) {
        color([1,0,0])
        translate([
          0,
          -DEPTH/2 - WALL_THICKNESS/2,
          height/2
        ])
        cube([
          outer_width,
          WALL_THICKNESS,
          height + WALL_THICKNESS
        ], true);
    }
}

module back_pane() {
    if (include_back_pane) {
        color([1,0,0])
        translate([
            0,
            DEPTH/2 + WALL_THICKNESS/2,
            height/2
        ])
        cube([
            outer_width,
            WALL_THICKNESS,
            height + WALL_THICKNESS
        ], true);
    }
}

module measure_markings() {
    for (pos = [0:(DEPTH/2)-1]) {
        mark_length = (pos % 10 == 0) ? long_mark_length : short_mark_length;
        
        translate([
          0,
          pos,
          WALL_THICKNESS/2
        
        ])
        rotate([90,90,0])
        cube([mark_depth, mark_length, 0.5], true);
    }
}

module bottom_pane() {
    difference() {
        cube([outer_width, DEPTH, WALL_THICKNESS], true);
        
        holes();
        
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
            cylinder(d=hole_diameter, h=WALL_THICKNESS * 3, $fn=50, center=true);
        }
    }
}

module text_module() {
    color([0,1,1])
    linear_extrude(height = text_height)
    text(combined_text, size = font_size, halign = "center", valign = "center", $fn = 50);
}

module left_pane() {
    translate([-outer_width/2 + WALL_THICKNESS/2, 0, height/2 - WALL_THICKNESS/2])
    
    difference() {
        cube([WALL_THICKNESS, SIDE_PANE_DEPTH, height - WALL_THICKNESS], true);
        
        // Subtract text
        translate([WALL_THICKNESS-2, 0, WALL_THICKNESS-2.5])
        rotate([90, 0, 270])
        text_module();
    }
    
}

module right_pane() {
    translate([outer_width/2 - WALL_THICKNESS/2, 0, height/2 - WALL_THICKNESS/2])
    cube([WALL_THICKNESS, SIDE_PANE_DEPTH, height - WALL_THICKNESS], true);
    
}

bottom_pane();
left_pane();
right_pane();
front_pane();
back_pane();