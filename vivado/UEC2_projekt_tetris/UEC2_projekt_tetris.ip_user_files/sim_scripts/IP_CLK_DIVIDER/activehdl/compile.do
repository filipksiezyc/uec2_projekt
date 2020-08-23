vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../UEC2_projekt_tetris.srcs/sources_1/ip/IP_CLK_DIVIDER/IP_CLK_DIVIDER_clk_wiz.v" \
"../../../../UEC2_projekt_tetris.srcs/sources_1/ip/IP_CLK_DIVIDER/IP_CLK_DIVIDER.v" \


vlog -work xil_defaultlib \
"glbl.v"

