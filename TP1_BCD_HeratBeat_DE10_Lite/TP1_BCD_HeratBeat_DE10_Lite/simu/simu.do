puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/bcd_counter.vhd
vcom -93 tb_bcd_counter.vhd

vsim tb_bcd_counter

add wave tick1ms
add wave -divider " Counter outputs (hex) "
add wave -radix hexadecimal thousnds
add wave -radix hexadecimal hundreds
add wave -radix hexadecimal tens
add wave -radix hexadecimal unities

run -a
