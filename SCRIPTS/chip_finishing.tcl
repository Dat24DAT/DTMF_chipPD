### set dir vars
set step       export
set dbs_dir    "../dbs"
set report_dir "../report"
set data_dir   "../data"

## Check DRC, Antenna, Connectivity
check_drc -check_only regular
check_connectivity -ignore_dangling_wires

## Delete filler, reinsertion
#delete_filler

## Via optimization (redundant via)
route_design -via_opt

#### Metal fills
add_metal_fill
check_metal_density

### Save design
write_db -sdc $dbs_dir/chip_finishing.dat


