puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/mul_2_to_1.vhd
vcom -93 tb_mul_2_to_1.vhd

vsim -t 1ns TB_MUL_2_TO_1

add wave -radix hexadecimal COM
add wave -radix hexadecimal A
add wave -radix hexadecimal B
add wave -radix hexadecimal S

run -a
