onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+mkAWSteria_HW_reclocked -L xil_defaultlib -L xpm -L axi_infrastructure_v1_1_0 -L fifo_generator_v13_2_4 -L axi_clock_converter_v2_1_18 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.mkAWSteria_HW_reclocked xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {mkAWSteria_HW_reclocked.udo}

run -all

endsim

quit -force
