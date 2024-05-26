#script to run project
set_db init_power_nets VDD
set_db init_ground_nets VSS

read_mmmc ../INPUTS/mmmc/dtmf.mmmc

read_physical -lef ../INPUTS/lef/all.lef

read_netlist {../INPUTS/verilog/dtmf_chip.v ../INPUTS/verilog/dtmf_chip_ak.v ../INPUTS/verilog/stubs.v} 

init_design

read_io_file ../INPUTS/fp/dtmf.io

#Specify Floorplan
create_floorplan -core_margins_by io -site tsm3site -core_size 842 842 100 100 100 100
set_db floorplan_snap_die_grid manufacturing
set_db floorplan_snap_core_grid manufacturing


write_db -sdc data/dbs/import.db




