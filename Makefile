.PHONY: sim wave

sim:
	iverilog -g2012 -o sim/a.out rtl/dac_reg.v tb/dac_reg_tb.v
	vvp sim/a.out

wave:
	gtkwave sim/dac_reg.vcd