iverilog:
	iverilog -g2012 -s tb_top_mac_accelerator -o sim/mac_accelerator tb/tb_top_mac_accelerator.v rtl/*.v

run:
	vvp sim/mac_accelerator

clean:
	rm -f sim/mac_accelerator

.PHONY: iverilog run clean
