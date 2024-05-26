### optimization settings

# enable multi-threading
set_multi_cpu_usage -local_cpu 2

# set analysis type
set_db timing_analysis_type ocv

# enable cppr removal for both setup and hold
set_db timing_analysis_cppr both

### Set process node to 180 for parasitic extraction accuracy (TSMC18_6LM is the target process)
set_db design_process_node 180



