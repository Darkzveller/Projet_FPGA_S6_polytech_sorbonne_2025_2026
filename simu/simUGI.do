vlib work
vcom -93 ../src/instruction_memory.vhd
vcom -93 ../src/SIGN_EXTENSION.vhd
vcom -93 ../src/UNIT_GESTION_INSTRUCTION.vhd
vcom -93 tb_unit_gestion_intruction.vhd

vsim -t 1ns TB_UNIT_GESTION_INSTRUCTION

add wave -divider " Signaux Horloge & Reset "
add wave CLK
add wave -color "Red" Reset

add wave -divider " Entrees de l'Unite "
add wave nPCsel
add wave -radix hexadecimal Offset

add wave -divider " Signaux Internes "
add wave -radix hexadecimal DUT/PC_reg
add wave -radix hexadecimal DUT/PC_suivant
add wave -radix hexadecimal DUT/PC_plus_1
add wave -radix hexadecimal DUT/Extension_Offset

add wave -divider " Sortie / Instruction Lu "
add wave -radix hexadecimal Instruction

run 160 ns