use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

function double_rivet_end_25mm() = concat(
  [
    "stencil_length", 90,
    "holes1_columns", 1,
    "holes1_diameter", 25.6,
    "holes1_row_spacing", 12.5,
    "holes1_rows", 2,
    "holes1_vertical_offset", 28,
    "holes1_anvil_guide", 25.6,
    "holes1_diameter_top_multiplier", 1,
    "holes2_columns", 1,
    "holes2_diameter", 25.6,
    "holes2_row_spacing", 12.5,
    "holes2_rows", 2,
    "holes2_vertical_offset", -15,
    "holes2_diameter_top_multiplier", 1,
    "holes2_anvil_guide", 25.6,
    "include_back_pane", true,
    "material_width", 25,
    "text_left", "double rivet end",
    "wall_thickness", 2,
    "extra_width", 10
  ],
  standard_wall_thickness(),
  h1_chicago_screws(),
  h2_chicago_screws()
);


biothane_stencil(concat(
    double_rivet_end_25mm(),
    get_defaults(),
));
