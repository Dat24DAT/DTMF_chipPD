

connect_global_net VDD -type pg_pin -pin_base_name VDD -all
connect_global_net VSS -type pg_pin -pin_base_name VSS -all
connect_global_net VSS -type tie_lo
connect_global_net VDD -type tie_hi

set_layer_preference pinObj -is_visible 1

#Add a Ring around the Core boundary for the Power and Ground Nets
add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top Metal5 bottom Metal5 left Metal6 right Metal6} -width {top 8 bottom 8 left 8 right 8} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 1 bottom 1 left 1 right 1} -center 0 -extend_corners {} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

#Add a Ring around the DTMF_INST/PLLCLK_INST Macro
select_obj DTMF_CHIP/DTMF_INST/PLLCLK_INST

add_rings -nets {VDD VSS} -type block_rings -around selected -layer {top Metal5 bottom Metal5 left Metal6 right Metal6} -width {top 8 bottom 8 left 8 right 8} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 1 bottom 1 left 1 right 1} -center 0 -extend_corners {rt bl } -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

#Add Power/Ground Straps
add_stripes -nets {VDD VSS} -layer Metal6 -direction vertical -width 8 -spacing 1 -set_to_set_distance 120 -start_from left -start_offset 100 -stop_offset 100 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit Metal6 -pad_core_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal6 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid none
#Route Standard Cell Rails, Macros PG Pin, and IO cells PG Pins to PG Nets
route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { Metal1(1) Metal6(6) } -block_pin_target {nearest_target} -core_pin_target {none} -allow_jogging 1 -crossover_via_layer_range { Metal1(1) Metal6(6) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { Metal1(1) Metal6(6) }
write_db data/dbs/create_power_grid.db
