### set dir vars
set step       export
set dbs_dir    "./dbs"
set report_dir "./reports"
set data_dir   "./data"

## Check DRC, Antenna, Connectivity
check_drc -check_only regular
check_connectivity -ignore_dangling_wires

### Filler insertion 
# Find the filler in the library
set fillers [lsort -dictionary -increasing [get_db [get_db base_cells *FILL*] .name]]
puts $fillers

set cell_area [::tcl::mathop::+ {*}[get_db [get_db insts -if {.base_cell.class==core}] .area]]
set row_area  [get_computed_shapes -output area [get_db rows .rect]]
set current_density {expr [::tcl::mathop::+ {*}[get_db [get_db insts -if {.base_cell.class==core}] .area]] / [get_computed_shapes -output area [get_db rows .rect]]}

set density [expr $cell_area/$row_area]

eval $current_density

add_fillers -base_cells $fillers

eval $current_density

### Delete filler, reinsertion
delete_filler

## Via optimization (redundant via)
route_design -via_opt
check_connectivity -ignore_dangling_wires

#### Metal fills
add_metal_fill
check_metal_density

### Save design
write_db -sdc data/dbs/chip_finishing.db


