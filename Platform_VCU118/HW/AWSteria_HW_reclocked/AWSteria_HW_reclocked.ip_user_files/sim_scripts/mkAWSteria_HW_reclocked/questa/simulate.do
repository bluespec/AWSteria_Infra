onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib mkAWSteria_HW_reclocked_opt

do {wave.do}

view wave
view structure
view signals

do {mkAWSteria_HW_reclocked.udo}

run -all

quit -force
