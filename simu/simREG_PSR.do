puts "Simulation script for ModelSim REG_PSR"

vlib work

vcom -93 ../src/REG_PSR.vhd
vcom -93 tb_reg_psr.vhd

vsim -t 1ns tb_reg_psr

add wave -divider " Horloge et Reset "
add wave -color "Yellow" CLK
add wave -color "Red" Reset

add wave -divider " Controle "
add wave -color "Cyan" PSREn

add wave -divider " Donnees "
add wave -radix hexadecimal DATA_IN
add wave -radix hexadecimal DATA_OUT

run 145ns