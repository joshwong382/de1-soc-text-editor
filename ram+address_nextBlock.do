# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ram+address.v

#load simulation using mux as the top level simulation module
vsim nextBlock
#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force -deposit {clock} 1 0ns, 0 {2ns} -r 4ns

#reset
force {reset} 0
force {moveEn} 1
force {writeBlock} 0
force {in_blocki} 0
force {in_blockj} 0
force {reverse} 0
run 10ns

#writeblock
force {reset} 1
force {moveEn} 1
force {writeBlock} 1
force {in_blocki} 0
force {in_blockj} 10100
force {reverse} 0
run 10ns

#reverse
force {reset} 1
force {moveEn} 1
force {writeBlock} 0
force {in_blocki} 0
force {in_blockj} 0
force {reverse} 1
run 100ns

#move forward
force {reset} 1
force {moveEn} 1
force {writeBlock} 0
force {in_blocki} 0
force {in_blockj} 0
force {reverse} 0
run 500ns