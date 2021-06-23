# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog cursor_module.v

#load simulation using mux as the top level simulation module
vsim cursorstate

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave -radix unsigned {/*}


force -deposit {clock} 1 0ns, 0 {2ns} -r 4ns

#Move: left = 1, right = 2, stay still = 0
#reset
force {reset} 0
force {move} 10
force {esc} 0
force {clr} 0
force {wr} 0
run 10ns

#write
force {reset} 1
force {move} 10
force {esc} 0
force {clr} 0
force {wr} 1
run 500ns

#command cursor, move right
force {reset} 1
force {move} 10
force {esc} 1
force {clr} 0
force {wr} 0
run 10ns

#command cursor, move right
force {reset} 1
force {move} 10
force {esc} 0
force {clr} 0
force {wr} 0
run 200ns

#move command cursor left
force {reset} 1
force {move} 1
force {esc} 0
force {clr} 0
force {wr} 0
run 200ns

##clear
#force {reset} 1
#force {move} 0
#force {esc} 0
#force {clr} 1
#force {wr} 0
#run 10ns

#switch to write cursor, move right
force {reset} 1
force {move} 10
force {esc} 0
force {clr} 0
force {wr} 1
run 1000ns



