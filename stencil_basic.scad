
use <biothane-stencil.scad>
use <custom.scad>
use <aspects.scad>

union() {

  biothane_stencil_from_properties(concat(

    ["stencil_length", 150],
    ["material_width", 25],
    ["holes1_columns", 10],
    ["holes2_enabled", false],
    
    get_defaults(),
  ));

}