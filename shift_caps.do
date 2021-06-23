# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ps2_decoder.v

#load simulation using mux as the top level simulation module
vsim outputkey

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# 8'h1C -> 7'd97
force {ps2code} 00011100
force {shift} 0
force {caps} 0
run 10ns

#8'h45 ->7'd41/48
force {ps2code} 1000101
force {shift} 1
force {caps} 1
run 10ns