use <biothane-stencil.scad>

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

extra_width = 0;

biothane_stencil(
    stencil_length = stencil_length,
    material_width = material_width,
    side_pane_length = side_pane_length,
    material_height = material_height,
    wall_thickness = wall_thickness,
    auto_side_pane_length = auto_side_pane_length,
    holes1_enabled = holes1_enabled,
    holes1_diameter = holes1_diameter,
    holes1_columns = holes1_columns,
    holes1_rows = holes1_rows,
    holes1_column_spacing = holes1_column_spacing,
    holes1_row_spacing = holes1_row_spacing,
    holes1_horizontal_offset = holes1_horizontal_offset,
    holes1_vertical_offset = holes1_vertical_offset,
    holes1_diameter_top_multiplier = holes1_diameter_top_multiplier,
    holes1_rivet_inner_diameter = holes1_rivet_inner_diameter,
    holes1_anvil_guide = holes1_anvil_guide,
    holes2_enabled = holes2_enabled,
    holes2_diameter = holes2_diameter,
    holes2_columns = holes2_columns,
    holes2_rows = holes2_rows,
    holes2_column_spacing = holes2_column_spacing,
    holes2_row_spacing = holes2_row_spacing,
    holes2_horizontal_offset = holes2_horizontal_offset,
    holes2_vertical_offset = holes2_vertical_offset,
    holes2_diameter_top_multiplier = holes2_diameter_top_multiplier,
    holes2_rivet_inner_diameter = holes2_rivet_inner_diameter,
    holes2_anvil_guide = holes2_anvil_guide,
    text_left = text_left,
    text_right = text_right,
    font_size = font_size,
    auto_text_right_append_material_width = auto_text_right_append_material_width,
    include_front_pane = include_front_pane,
    include_back_pane = include_back_pane,
    front_left_cutout = front_left_cutout,
    front_left_cutout_offset_side = front_left_cutout_offset_side,
    front_left_cutout_offset_end = front_left_cutout_offset_end,
    front_right_cutout = front_right_cutout,
    front_right_cutout_offset_side = front_right_cutout_offset_side,
    front_right_cutout_offset_end = front_right_cutout_offset_end,
    back_left_cutout = back_left_cutout,
    back_left_cutout_offset_side = back_left_cutout_offset_side,
    back_left_cutout_offset_end = back_left_cutout_offset_end,
    back_right_cutout = back_right_cutout,
    back_right_cutout_offset_side = back_right_cutout_offset_side,
    back_right_cutout_offset_end = back_right_cutout_offset_end,
    marker_width = marker_width,
    marker_short_mark_length = marker_short_mark_length,
    extra_width = extra_width
);
