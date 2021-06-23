# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ascii_decoder.v letter_decoder.v

#load simulation using mux as the top level simulation module
vsim asciidisplay
#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave -radix unsigned {/*}
add wave -position end  sim:/asciidisplay/d0/mux_ascii
add wave -position end  sim:/asciidisplay/d0/ascii_reg
add wave -position end  sim:/asciidisplay/d0/ascii_color
add wave -position end  sim:/asciidisplay/d0/letter_color

force -deposit {CLOCK_50} 1 0ns, 0 {2ns} -r 4ns

force {reset} 0
force {go} 1
force {ASCII} 1010111
force {reg_x} 0
force {reg_y} 0
run 10ns

force {reset} 1
force {go} 1
force {ASCII} 1011001
force {reg_x} 0
force {reg_y} 0
run 2000ns

force {reset} 1
force {go} 0
force {ASCII} 1011001
force {reg_x} 0
force {reg_y} 0
run 200ns

force {reset} 1
force {go} 1
force {ASCII} 1011001
force {reg_x} 0
force {reg_y} 0
run 2000ns

force {reset} 1
force {go} 0
force {ASCII} 1011001
force {reg_x} 0
force {reg_y} 0
run 2000ns