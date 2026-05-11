puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/alu.vhd
vcom -93 tb_alu.vhd

vsim -t 1ns tb_alu



add wave -divider " Entrees ALU "
add wave -radix hexadecimal OP
add wave -radix hexadecimal A
add wave -radix hexadecimal B

add wave -divider " Resultats "
add wave -radix hexadecimal S

add wave -divider " Flags "
add wave -color "Yellow" N
add wave -color "Yellow" Z



run -a
