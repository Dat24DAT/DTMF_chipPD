#place inst
place_inst DTMF_INST/RAM_256x16_TEST_INST/RAM_256x16_INST {559.83 970.42} r0 -fixed
place_inst DTMF_INST/ARB_INST/ROM_512x16_0_INST {349.68 796.3} r90 -fixed
place_inst DTMF_INST/RAM_128x16_TEST_INST/RAM_128x16_INST {564.71 774.57} r0 -fixed
place_inst DTMF_INST/PLLCLK_INST {335.205 335.2} r0 -fixed

create_place_halo -halo_deltas {30 30 37 30} -insts DTMF_INST/RAM_256x16_TEST_INST/RAM_256x16_INST
create_place_halo -halo_deltas {35 30 32 30} -insts DTMF_INST/ARB_INST/ROM_512x16_0_INST
create_place_halo -halo_deltas {35 30 37 30} -insts DTMF_INST/RAM_128x16_TEST_INST/RAM_128x16_INST
create_place_halo -halo_deltas {0 0 10 10} -insts DTMF_INST/PLLCLK_INST 

write_db -sdc data/dbs/place_macro.db


