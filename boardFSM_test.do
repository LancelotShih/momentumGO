# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog gameBoardFSM.v 
vlog addressHandling.v
vlog BRAM.v


#load simulation using mux as the top level simulation module
vsim -L altera_mf_ver topLevel


#log all signals and add some signals to waveform window
log -r {/*}
add wave {/*}
add wave {topLevel/GB1/*}
add wave {topLevel/D1/*}


radix -unsigned
force {CLOCK_50} 0 0ns, 1 10ns -repeat 20ns;
force {KEY[0]} {1}
run 40 ns
force {KEY[0]} {0}
force red_X 0011
force red_Y 0011
force blue_X 0011
force blue_Y 0011

run 200 ns


run 300 ms