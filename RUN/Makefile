#Makefile
PKG=../PKG/mips_pkg.sv
SIMULATOR=../SIMULATOR/mips.sv
MODULE=mips

FILE ?= sample.txt

lib :
	vlib work
	@echo "---------------------------------------------"
	@echo "TRACE_FILE is $(FILE)"
	@echo "---------------------------------------------"
	
cmp :
	vlog -lint -coveropt 3 +acc +cover $(PKG) $(SIMULATOR)

sim :
	vsim -coverage -vopt $(MODULE) +FILE=$(FILE) -sv_seed random -c -do "run -all; exit"

all : lib cmp sim