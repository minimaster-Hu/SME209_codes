
iverilog -o testbench.vvp source/control_tb.v source/control.v

vvp testbench.vvp 

gtkwave testbench.wave

