### set dir vars
set step place
set dbs_dir "./dbs"
set report_dir "./reports"
set data_dir "./data"

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

### check previous optimization settings
get_db timing_analysis_type
get_db timing_analysis_cppr
get_db design_process_node


# report density 
check_floorplan -report_density 

# write out netlist before tiecells insertion
write_netlist -exclude_leaf_cells place_opt_b4_tiecells.v

# add tiecells
set_db add_tieoffs_max_fanout 10
set_db add_tieoffs_max_distance 20
set_db add_tieoffs_cells {TIEHI TIELO}
add_tieoffs

# check placement
check_place 

# incremental placement to fix overlaping instances if your run has overlapping cells
if {0} {
  place_detail -eco true
}

#select tie_cells spare cells
gui_deselect -all
select_obj [get_db insts -if {.name == *LTIELO*}]
select_obj [get_db insts -if {.name == *LTIEHI*}]

# get total number of tiecells added
llength [get_db insts -if {.name == *LTIELO* || .name == *LTIEHI*}]

# write out netlist before tiecells insertion
write_netlist -exclude_leaf_cells place_opt_after_tiecells.v



# add spare cells
create_spare_module -module_name spare_1 -cells {ADDFX2 1 AND2X4 1 AOI32X2 1 BUFX2 1 CLKBUFX2 1 \
         INVX2 1 INVX4 1 NOR3X2 1 OR2X1 1 SDFFQX1 1} -tieoffs {TIEHI TIELO} -use_cell_as_prefix

place_spare_modules -module_name spare_1 -step_x 50 -step_y 50 -offset_x 10 -offset_y 10

# incremental placement to fix overlaping instances
place_detail -eco true

# select all spare cells
gui_deselect -all
select_obj [get_db insts -if {.name == *spr_gate*}]

# turn off nets and false violations
set_layer_preference node_net -is_visible 0
set_layer_preference violation -is_visible 0

# get total number of sparecells added
llength [get_db insts -if {.name == *spr_gate*}]

# check placement
check_place


# power opt
set_db opt_leakage_to_dynamic_ratio 0.5
set_default_switching_activity -global_activity 0.2 -sequential_activity 0.8
opt_power -pre_cts

### congestion analysis
# report overflow
report_congestion -overflow
# report hotspot
report_congestion -hotspot

# run global route
set_db route_early_global_bottom_routing_layer 1 
set_db route_early_global_top_routing_layer 3
route_early_global

# report overflow
report_congestion -overflow
# report hotspot
report_congestion -hotspot



### MBFF optimization
# enable MBFF optimization/mapping
set_db opt_multi_bit_flop_opt true
# set MBFF instance prefix
set_db opt_multi_bit_flop_name_prefix MBIT_
# report MBFF in design
report_multibit


# reset global route to use all 6 metal layers for signal routings
set_db route_early_global_bottom_routing_layer 1 
set_db route_early_global_top_routing_layer 6
route_early_global

### extract rc
# set rc extract mode
set_db extract_rc_engine pre_route
# run rc extraction
extract_rc
# save rc extraction result file (spef)
#write_parasitics -spef_file $data_dir/place_opt.spef -rc_corner rc_worst

### Save place_opt DB and netlist
write_netlist  -exclude_leaf_cells place_opt.v
write_db -sdc data/dbs/placeopt.db



