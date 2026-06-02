puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/memory_data.vhd
vcom -93 tb_memory_data.vhd

vsim -t 1ns TB_DATA_MEMORY

add wave -radix binary CLK
add wave -radix binary Reset
add wave -radix binary WrEn

add wave -radix binary Addr
add wave -radix hexadecimal DataIn
add wave -radix hexadecimal DataOut

run 81 ns
