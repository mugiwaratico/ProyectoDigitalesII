proyecto:
	iverilog -o tb.vvp testbench.v
	vvp tb.vvp 
	gtkwave tb.vcd


clean:
	rm -rf *.vcd *.vvp