#place inst
place_inst DTMF_INST/RAM_256x16_TEST_INST/RAM_256x16_INST {976.265 342.82} r90 -fixed
place_inst DTMF_INST/ARB_INST/ROM_512x16_0_INST {343.525 802.215} r90 -fixed
place_inst DTMF_INST/RAM_128x16_TEST_INST/RAM_128x16_INST {572.69 991.135} r0 -fixed
place_inst DTMF_INST/PLLCLK_INST {371.77 358.775} mx -fixed

create_place_halo -halo_deltas {15 15 15 15} -all_blocks

