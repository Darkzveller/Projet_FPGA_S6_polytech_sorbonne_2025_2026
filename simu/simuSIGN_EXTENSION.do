puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/sign_extension.vhd
vcom -93 tb_sign_extension.vhd

vsim -t 1ns TB_SIGN_EXTENSION

add wave -radix binary N_bits_E
add wave -radix binary -color red -label "Bit extension"  E(N_bits_E-1)

add wave -radix binary E
add wave -radix binary S

run -a
