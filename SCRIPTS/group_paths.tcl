reset_path_group -all
reset_path_group_options
group_path -name input -from [all_inputs -no_clocks] -to [all_registers]
group_path -name output -from [all_registers ] -to [all_outputs ]    
group_path -name in2out -from [all_inputs -no_clocks] -to [all_outputs ]
group_path -name reg2reg -from [filter_collection [all_registers] "is_black_box != true"] -to [filter_collection [all_registers] "is_black_box != true"]
group_path -name reg2mem -from [filter_collection [all_registers] "is_black_box != true"] -to [filter_collection [all_registers] "is_black_box == true"]
group_path -name mem2reg -from [filter_collection [all_registers] "is_black_box == true"] -to [filter_collection [all_registers] "is_black_box != true"]
group_path -name reg2icg -from [filter_collection [all_registers] "is_black_box != true"] -to [filter_collection [all_registers] "is_clock_gating_check == true"]
group_path -name in2icg -from [all_inputs -no_clocks] -to [filter_collection [all_registers] "is_clock_gating_check == true"]

# set optimizing effort per path group
set_path_group_options input -effort_level low
set_path_group_options output -effort_level low
set_path_group_options in2out -effort_level low
set_path_group_options default -effort_level high
set_path_group_options reg2reg -effort_level high
set_path_group_options reg2mem -effort_level high
set_path_group_options mem2reg -effort_level high
set_path_group_options mem2reg -effort_level high
set_path_group_options reg2icg -effort_level high
set_path_group_options in2icg -effort_level low

