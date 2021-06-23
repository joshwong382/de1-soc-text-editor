# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ascii_decoder.v cursor_module.v hex_display.v letter_decoder.v project.v ps2_decoder.v ram+address.v ram2048x7.v includes/*.v

#load simulation using mux as the top level simulation module
vsim -L altera_mf_ver project 

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave -radix unsigned {/*}
add wave -position end -radix unsigned sim:/project/rw0/rampos_x
add wave -position end -radix unsigned sim:/project/rw0/rampos_y
add wave -position end -radix unsigned sim:/project/rw0/ramd0/ascii_read

force -deposit {CLOCK_50} 1 0ns, 0 {2ns} -r 4ns
force -freeze sim:/project/vga_is_done 1 0

#reset
force {reset} 0
force {ascii_in} 1011001
force {ps2_result_ready} 0
force {esc} 0
run 10ns


#1 letter
force {reset} 1
force {ascii_in} 1011001
force {ps2_result_ready} 1
force {esc} 0
run 10ns

#1 letter
force {reset} 1
force {ascii_in} 1011001
force {ps2_result_ready} 0
force {esc} 0
run 50000ns

#left arrow
force {reset} 1
force {ascii_in} 11
force {ps2_result_ready} 1
force {esc} 0
run 10ns

#left arrow
force {reset} 1
force {ascii_in} 11
force {ps2_result_ready} 0
force {esc} 0
run 40000ns

#cursor position (21,20)
force {reset} 1
force {ascii_in} 111
force {ps2_result_ready} 1
force {esc} 0
run 10ns

#cursor position (21,20)
force {reset} 1
force {ascii_in} 111
force {ps2_result_ready} 0
force {esc} 0
run 600000ns

