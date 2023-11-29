# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ps2driver.v

#load simulation using mux as the top level simulation module
#vsim -L altera_mf_ver topLevel
vsim PS2Input

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}
add wave {/PS2Input/u8/*}

force {PS2_CLK} 0 0ns, 1 5ns -repeat 10ns;

force PS2_DAT 0
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 0
run 10 ns

force PS2_DAT 1
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 0
run 10 ns

force PS2_DAT 1
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 0
run 10 ns

force PS2_DAT 0
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 1
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 0
run 10 ns
force PS2_DAT 1
run 10 ns

run 600 ns