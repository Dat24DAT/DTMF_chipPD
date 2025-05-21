### set dir vars
set step       groute
set dbs_dir    "../dbs"
set report_dir "../report"
set data_dir   "../data"

## Add filler cells
add_fillers -base_cells {FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64} -density 0.7
## running nano route using default settings
route_design -global_detail

report_congestion -overflow > reports/route.congestion.default.rpt
time_design -post_route -setup -report_prefix route_setup_default -report_dir reports
time_design -post_route -hold  -report_prefix route_hold_default -report_dir reports


## running nano route with si and timing
set_db route_with_si_driven true
set_db route_with_timing_driven true

route_design -global_detail

report_congestion -overflow > reports/route.congestion.si_timing_driven.rpt
time_design -post_route -setup -report_prefix route_setup_si_timing_driven -report_dir reports
time_design -post_route -hold  -report_prefix route_hold_si_timing_driven -report_dir reports
