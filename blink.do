# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog blink_module.v

#load simulation using mux as the top level simulation module
vsim blink_top

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave -radix unsigned {/*}
add wave -position end  sim:/blink_top/b_d/switch

force -deposit {CLOCK_50} 1 0ns, 0 {2ns} -r 4ns

#reset
force {reset} 0
force {blink} 0
force {block_x} 111 
force {block_y} 0
run 10ns 
	
#start blinking
force {reset} 1
force {blink} 1
force {block_x} 111
force {block_y} 0
run 12000ns

