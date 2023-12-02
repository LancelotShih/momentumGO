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
#add wave {/*}
add wave {topLevel/GB1/loadColour}
add wave {topLevel/GB1/BS1/*}
add wave {topLevel/GB1/current_state}

add wave {topLevel/D1/*}


radix -unsigned
force {CLOCK_50} 0 0ns, 1 10ns -repeat 20ns;

force red_X 0010
force red_Y 0010
force blue_X 0011
force blue_Y 0011

force {KEY[0]} {0}
run 40 ns
force {KEY[0]} {1}

force {KEY[3]} {1}
run 30 ns
force {KEY[3]} {0}
run 400 ns
force {KEY[3]} {1}


run 20 ms

force red_X 0111
force red_Y 0111

run 5000 ms