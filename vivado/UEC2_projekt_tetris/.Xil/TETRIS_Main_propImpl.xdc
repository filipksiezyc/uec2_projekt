set_property SRC_FILE_INFO {cfile:c:/Users/Filip/Desktop/uec2_projekt/vivado/UEC2_projekt_tetris/UEC2_projekt_tetris.srcs/sources_1/ip/IP_clk_generator/IP_clk_generator.xdc rfile:../UEC2_projekt_tetris.srcs/sources_1/ip/IP_clk_generator/IP_clk_generator.xdc id:1 order:EARLY scoped_inst:CLK_divider/inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports pclk]] 0.1
