vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../UEC2_projekt_tetris.srcs/sources_1/ip/IP_CLK_DIVIDER/IP_CLK_DIVIDER_clk_wiz.v" \
"../../../../UEC2_projekt_tetris.srcs/sources_1/ip/IP_CLK_DIVIDER/IP_CLK_DIVIDER.v" \


vlog -work xil_defaultlib \
"glbl.v"

