onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+ClockDiv_Block_Design -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ClockDiv_Block_Design xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {ClockDiv_Block_Design.udo}

run -all

endsim

quit -force
