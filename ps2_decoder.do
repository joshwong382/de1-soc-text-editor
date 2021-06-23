# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog ps2_decoder.v hex_display.v

#load simulation using mux as the top level simulation module
vsim ps2decoder

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}
add wave -position end  sim:/ps2decoder/pd/shift
add wave -position end  sim:/ps2decoder/pd/shift_1
add wave -position end  sim:/ps2decoder/pd/shift_2
add wave -position end  sim:/ps2decoder/pd/caps
add wave -position end  sim:/ps2decoder/pd/caps_wait

# Clock needs to be synced with the time per run.
# Disable PS2 Controller.
force -deposit {CLOCK_50} 1 0ns, 0 {2ns} -r 4ns
force -deposit {vga_go} 1 100ns

# Reset
force {reset} 0
force {ps2newdata} 0
run 10ns

# 8'b11100 -> 7'b1100001
force {ps2code} 000011100
force {ps2newdata} 1
force {reset} 1
run 10ns

# Wait
force {ps2newdata} 0
force {reset} 1
run 40ns

# Unpress ie. F0
force {ps2code} 11110000
force {ps2newdata} 1
force {reset} 1
run 10ns

# Unpress 8'b11100 -> 7'b1100001
force {ps2code} 00011100
force {ps2newdata} 1
force {reset} 1
run 10ns

# Wait - Next Character
force {ps2newdata} 0
force {reset} 1
run 40ns

# 8'h58 CAPS
force {ps2code} 01011000
force {ps2newdata} 1
force {reset} 1
run 10ns

# Wait
force {ps2newdata} 0
force {reset} 1
run 40ns

# RELEASE CAPS
force {ps2code} 11110000
force {ps2newdata} 1
force {reset} 1
run 10ns

# Unpress 8'h58
force {ps2code} 01011000
force {ps2newdata} 1
force {reset} 1
run 10ns

# Wait
force {ps2newdata} 0
force {reset} 1
run 40ns

# CAPS
force {ps2code} 01011000
force {ps2newdata} 1
force {reset} 1
run 10ns

# Wait
force {ps2newdata} 0
force {reset} 1
run 40ns

# Unpress CAPS
force {ps2code} 11110000
force {ps2newdata} 1
force {reset} 1
run 10ns

# Unpress 8'h58
force {ps2code} 01011000
force {ps2newdata} 1
force {reset} 1
run 10ns