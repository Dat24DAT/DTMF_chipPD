### set dir vars
set step cts
set dbs_dir "../dbs"
set report_dir "../report"
set data_dir "../data"


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
report_clocks > report_clocks.rpt

# report clock skew
report_skew_group > clock_skews.rpt

### Follow lab instruction to use clock tree debugger

# report post CTS setup timing 
time_design -post_cts -report_prefix $step -report_dir report
# report post CTS setup timing 
time_design -post_cts -hold -report_prefix ${step}_hold -report_dir report

write_db -sdc $dbs_dir/${step}.dat

# review all timing reports in "report" directory. Did design meeting both setup and hold timning?
# If there are still SETUP violations, run postCTS setup optimization (set if to true {1})
if {0} {
 opt_design -post_cts -setup -report_prefix ${step}_opt -report_dir report
}

# If there are still HOLD violations, run postCTS optimization
opt_design -post_cts -hold -report_prefix ${step}_opt_hold -report_dir report

write_db -sdc $dbs_dir/${step}_opt.dat

### run incremental if needed
if {0} {
   # incremental setup fix
   opt_design -incremental -post_cts -setup -report_prefix ${step}_opt_incr -report_dir report

   # incremental hold fix
   opt_design -incremental -post_cts -hold -report_prefix ${step}_opt_incr -report_dir report

   write_db -sdc $dbs_dir/${step}_opt_incr.dat

}

### check power and congestion numbers
# report power
report_power
# report overflow
report_congestion -overflow
# report hotspot
report_congestion -hotspot

