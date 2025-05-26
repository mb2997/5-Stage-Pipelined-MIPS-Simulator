vlog -coveropt 3 +acc +cover ../PKG/mips_pkg.sv ../SIMULATOR/mips.sv
vsim -coverage -vopt mips +FILE=sample.txt -sv_seed random
run 0ps
add wave -r sim:/mips_pkg/*
do wave.do
run -all