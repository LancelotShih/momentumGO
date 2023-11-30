# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog november28printtest.v

#load simulation using mux as the top level simulation module
vsim draw

#log all signals and add some signals to waveform window
log {/*}
add wave {/*} 
#add wave {display/clkHalved/*}

radix -unsigned
force {clock} 0 0ns, 1 10ns -repeat 20ns;
force reset 1
run 30 ns 
force reset 0

force initial_xPosition 0
force initial_yPosition 0
force enable_draw 1
run 2500 ns
force enable_draw 0
run 1000 ns

force enable_draw 1
force initial_xPosition 10
force initial_yPosition 10

run 2200 ns
force enable_draw 0
run 1000 ns