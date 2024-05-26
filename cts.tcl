### set dir vars
set step cts
set dbs_dir "./dbs"
set report_dir "./reports"
set data_dir "./data"


## Generate the CCOpt spec file and source it:
create_clock_tree_spec -out_file ccopt.spec
# open ccopt.spec to review generated cts spec

### apply cts spec
source ccopt.spec


## Build clock tree and optimize data path (setup and hold) concurrently
## and preroute all clock nets
ccopt_design 

### report density 
check_floorplan -report_density 

# check placement
check_place 

# review check_place result, if there are placement violations
# run increment placement to fix
place_detail -eco true

# check placement again to make sure there is no more violations.
check_place 

# propagate all clocks
set_interactive_constraint_modes [ get_db [get_db constraint_modes -if {.is_active}] .name]
set_propagated_clock [all_clocks]
set_interactive_constraint_modes {}

### review clock tree results
# report clocks info
report_clocks > ./reports/clocktree.rpt

# report clock skew
report_skew_group > ./reports/clocktree.skew-group.rpt

# report post CTS setup timing 
time_design -post_cts -report_prefix $step -report_dir reports
# report post CTS setup timing 
time_design -post_cts -hold -report_prefix ${step}_hold -report_dir reports

write_db -sdc data/dbs/cts.db



