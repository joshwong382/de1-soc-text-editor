# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ascii_decoder.v letter_decoder.v

#load simulation using mux as the top level simulation module
vsim ratedivider

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force -deposit {clock} 1 0ns, 0 {2ns} -r 4ns

force {reset} 0
run 10ns

force {reset} 1
run 1000ns
#
#force	{current_state} 11
#force {ASCII} 1110011
#force {reset} 0
#force {ps2_go} 0
#force {reg_x} 0
#force {reg_y} 0
#run 10ns
#
#force	{current_state} 11
#force {ASCII} 1110011
#force {reset} 1
#force {ps2_go} 0
#force {reg_x} 0
#force {reg_y} 0
#run 400ns
#
#force	{current_state} 11
#force {ASCII} 1110011
#force {reset} 1
#force {ps2_go} 0
#force {reg_x} 0
#force {reg_y} 0
#run 400ns








