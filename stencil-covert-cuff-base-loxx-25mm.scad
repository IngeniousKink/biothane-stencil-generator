use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

function covert_cuff_base_loxx_25mm() = concat(
  [
    "holes1_row_spacing", 11,
    "holes1_rows", 2,
    "holes1_columns", 1,
    "holes1_vertical_offset", -10,
    "holes2_vertical_offset", 7,
    "holes2_columns", 1,
    "include_back_pane", true,
    "material_width", 25,
    "stencil_length", 35,
    "text_left", "covert cuff base LOXX"
  ],
  h1_chicago_screws(),
  h2_loxx(),
  standard_wall_thickness()
);

biothane_stencil(concat(
    covert_cuff_base_loxx_25mm(),
    get_defaults(),
));
