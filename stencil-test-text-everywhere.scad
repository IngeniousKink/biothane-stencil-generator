use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

function test_text_everywhere() = concat(
  [
    "stencil_length", 100,
    "material_width", 13,
    "wall_thickness", 2,
    "extra_width", 10,

    "include_back_pane", true,
    "include_front_pane", true,
    
    "text_left", "left",    
    "text_right", "right",    

    "text_front", "front",
    "text_back", "back",
    
    "text_top", "top",
    "text_bottom", "bottom",

    "text_top_left", "top left",    
    "text_top_right", "top right",    

    "text_top_front", "top front",
    "text_top_back", "top back",
    
    "holes1_columns", 0,
    "holes2_enabled", false,

    ],

);


biothane_stencil(concat(
    test_text_everywhere(),
    get_defaults(),
));
