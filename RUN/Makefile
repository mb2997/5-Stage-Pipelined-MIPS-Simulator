#Makefile
SIMULATOR=../SIMULATOR/mips.sv
MODULE=mips

FILE ?= sample.txt

lib :
	vlib work
	@echo "---------------------------------------------"
	@echo "TRACE_FILE is $(FILE)"
	@echo "---------------------------------------------"
	
cmp :
	vlog -coveropt 3 +acc +cover $(SIMULATOR)

sim :
	vsim -coverage -vopt $(MODULE) +FILE=$(FILE) -sv_seed random -c -do "run -all; exit"

all : lib cmp sim