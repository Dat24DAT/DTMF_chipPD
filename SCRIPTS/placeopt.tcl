set step place
set dbs_dir "../dbs"
set report_dir "../report"
set data_dir "../data"

### sanity checks
# check macro placement, row, site and blockage                   
check_floorplan 

# check drc on PG grids (spacing and width violations.. etc)
check_drc 

# check pg shorts
check_drc -check_short_only

### load scan def
read_def ../INPUTS/def/scan_chain.def

### optimization settings
source ../SCRIPTS/opt_settings.tcl

### set group paths
source ../SCRIPTS/group_paths.tcl

### set congestion driven
# tool defaut is timing driven
set_db place_global_cong_effort high

### set global module padding for all modules to spread out cells
set_db place_global_module_padding {leon 2.0}
set_db opt_fix_fanout_load true
### run placement
place_design

time_design -pre_cts -report_prefix place -report_dir $report_dir
write_db -sdc $dbs_dir/place.dat


