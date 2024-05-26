### set dir vars
set step       routeopt
set dbs_dir    "./dbs"
set report_dir "./reports"
set data_dir   "./data"


### Check DRC, Antenna, Connectivity
check_drc
check_antenna
check_connectivity


### Check timing
time_design -post_route
set_db timing_enable_simultaneous_setup_hold_mode true 
time_design -post_route


### Fix open
set_db timing_enable_simultaneous_setup_hold_mode false 
route_eco

check_drc
check_antenna
check_connectivity



### Antenna fixing
get_db route*antenna*

set_db route_antenna_diode_insertion true
route_eco
### Opt post_route
opt_design -post_route -incr
opt_design -post_route -incr -hold
opt_design -post_route -incr -hold -report_prefix pass1

### Create metrics
create_snapshot -name POST_ROUTE
report_metric -file metrics.html -format html

write_db -sdc data/dbs/routeopt.db

