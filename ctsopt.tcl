### set dir vars
set step cts
set dbs_dir "./dbs"
set report_dir "./reports"
set data_dir "./data"

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

write_db -sdc data/dbs/ctsopt.db
