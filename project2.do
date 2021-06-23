# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ascii_decoder.v cursor_module.v ram+address.v hex_display.v letter_decoder.v project.v ps2_decoder.v ram2048x7.v includes/*.v

#load simulation using mux as the top level simulation module
vsim -L altera_mf_ver project 

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave -radix unsigned {/*}
 

force -deposit {CLOCK_50} 1 0ns, 0 {2ns} -r 4ns

#reset
force {reset} 0
force {ascii_in} 1011001
force {asciidisplay_x} 0
force {asciidisplay_y} 0
force {ram_to_vga_go} 1
run 10ns

#cursor position (21,20)
force {reset} 1
force {ascii_in} 1011001
force {asciidisplay_x} 0
force {asciidisplay_y} 0
force {ram_to_vga_go} 1
run 1000ns

#cursor position (21,20)
force {reset} 1
force {ascii_in} 1011001
force {asciidisplay_x} 0
force {asciidisplay_y} 0
force {ram_to_vga_go} 0
run 50ns

#cursor position (21,20)
force {reset} 1
force {ascii_in} 1011001
force {asciidisplay_x} 7
force {asciidisplay_y} 0
force {ram_to_vga_go} 1
run 1000ns

#cursor position (21,20)
force {reset} 1
force {ascii_in} 1011001
force {asciidisplay_x} 7
force {asciidisplay_y} 0
force {ram_to_vga_go} 0
run 50ns

