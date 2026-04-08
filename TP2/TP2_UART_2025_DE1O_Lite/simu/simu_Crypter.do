puts "\n=== Simulation Script for ModelSim. - ALSE ===\n"
vlib work

vcom -93 ../src/DES_lib.vhd
vcom -93 ../src/DES_round.vhd
vcom -93 ../src/DES_small.vhd
vcom -93 ../src/crypter.vhd
vcom -93 Crypter_tb.vhd

vsim Crypter_tb(test1)

view structure
view signals

puts "\n=== Simulation starting now ===\n"
run -a

vsim Crypter_tb(test2)

view structure
view signals

add wave rxrdy
add wave -radix ascii sdin
add wave txbusy
add wave ld_sdout
add wave sdout
add wave dut/state
add wave dut/wpointer
add wave dut/rpointer
add wave -noupdate -divider FIFO
add wave -noupdate -format Logic /crypter_tb/dut/fifo_empty
add wave -noupdate -format Literal -radix hexadecimal /crypter_tb/dut/fifo_dout
add wave -noupdate -format Literal -radix unsigned /crypter_tb/dut/fifo_i/usedw

puts "\n=== Simulation starting now ===\n"
run -a
