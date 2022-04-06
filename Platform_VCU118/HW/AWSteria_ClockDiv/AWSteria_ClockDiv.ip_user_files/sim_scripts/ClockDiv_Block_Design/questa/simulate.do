onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ClockDiv_Block_Design_opt

do {wave.do}

view wave
view structure
view signals

do {ClockDiv_Block_Design.udo}

run -all

quit -force
