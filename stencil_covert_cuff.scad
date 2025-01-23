
use <biothane-stencil.scad>
use <custom.scad>
use <properties.scad>
use <aspects.scad>
use <stencil_covert_cuff_base_loxx_25mm.scad>

union() {

  biothane_stencil(concat(
    end_13mm(),
    get_defaults(),
  ));

  translate([20, 0, 0])
  biothane_stencil(concat(
    covert_cuff_base_loxx_25mm(),
    get_defaults(),
  ));

}