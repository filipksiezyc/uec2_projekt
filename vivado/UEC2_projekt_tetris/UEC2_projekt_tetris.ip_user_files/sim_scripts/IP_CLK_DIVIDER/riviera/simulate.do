onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+IP_CLK_DIVIDER -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.IP_CLK_DIVIDER xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {IP_CLK_DIVIDER.udo}

run -all

endsim

quit -force
