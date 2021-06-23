# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ram+address.v letter_decoder.v ram2048x7.v

#load simulation using mux as the top level simulation module
vsim -L altera_mf_ver ram_rw cursorstate
#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave -radix unsigned {/*}
add wave -radix unsigned -position end  sim:/ram_rw/ramc0/blocki
add wave -radix unsigned -position end  sim:/ram_rw/ramc0/blockj
add wave -radix unsigned -position end  sim:/ram_rw/ramd0/last_ascii_read
add wave -radix unsigned -position end  sim:/ram_rw/ramd0/ascii_write
add wave -radix unsigned -position end  sim:/ram_rw/ramd0/enter_y

force -deposit {clock} 1 0ns, 0 {2ns} -r 4ns
force -deposit {vga_is_done} 1 0ns

#reset
force {reset} 0
force {ascii_in} 100110
force {ps2_result_ready} 0
force {cursor_x} 0
force {cursor_y} 0
force {esc} 0
run 10ns


#cursor position (308,0)
force {reset} 1
force {ascii_in} 100110
force {ps2_result_ready} 1
force {cursor_x} 0
force {cursor_y} 0
force {esc} 0
run 10ns

#cursor position (308,0)
force {reset} 1
force {ascii_in} 100110
force {ps2_result_ready} 0
force {cursor_x} 0
force {cursor_y} 0
force {esc} 0
run 100000ns

#cursor position (00)
force {reset} 1
force {ascii_in} 111
force {ps2_result_ready} 1
force {cursor_x} 0
force {cursor_y} 0
force {esc} 0
run 10ns

#cursor position (00)
force {reset} 1
force {ascii_in} 111
force {ps2_result_ready} 0
force {cursor_x} 0
force {cursor_y} 0
force {esc} 0
run 100000ns