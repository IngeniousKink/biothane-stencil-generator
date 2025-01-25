use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

function covert_cuff_base_loxx_25mm() = concat(

  h1_chicago_screws(),
  h2_loxx(),

  hole_set(1, rows = 2, row_spacing = 11, vertical_offset = -10),
  hole_set(2, vertical_offset = 7),
    
  [
    "include_back_pane", true,
    "material_width", 25,
    "stencil_length", 35,
    "text_left", "covert cuff base",
    "text_right", "5.0mm · LOXX",
    "text_back", "25mm",
   

  ],
  standard_wall_thickness()
);

biothane_stencil(concat(
    covert_cuff_base_loxx_25mm(),
    get_defaults(),
));
