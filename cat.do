# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ram+address.v

#load simulation using mux as the top level simulation module
vsim cat

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#35,200 address = 00010110100
force {cursor_x} 000100011
force {cursor_y} 011001000

run 10ns