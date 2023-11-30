# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog november28printtest.v

#load simulation using mux as the top level simulation module
vsim simpleBoardFSM

#log all signals and add some signals to waveform window
log {/*}
add wave {/*} 
add wave{/simpleBoardFSM/b1/*}
#add wave {display/clkHalved/*}

radix -unsigned
force {clock} 0 0ns, 1 10ns -repeat 20ns;
force reset 1
force finished 1
run 30 ns
force reset 0
force trigger 1
run 50 ns
force trigger 0

run 3000 ms
