
use <biothane-stencil.scad>
use <defaults.scad>
use <aspects.scad>

use <stencil-covert-cuff-base-loxx-25mm.scad>

$fn = 200;

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