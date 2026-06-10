vlib work

# On compile uniquement le décodeur et son testbench
vcom -93 ../src/decodeur.vhd
vcom -93 tb_decodeur.vhd

# Lancement de la simulation
vsim -t 1ns tb_decodeur

# Ajout des signaux aux chronogrammes
add wave -divider " Entrees du Decodeur "
add wave -radix hexadecimal instruction
add wave -radix binary Flags_NZCV

add wave -divider " Sorties de Controle "
add wave nPC_SEL
add wave PSREn
add wave RegWr
add wave RegSel
add wave -radix binary ALUCtrl
add wave MemToReg
add wave ALUSrc
add wave WrSrc
add wave MemWr
add wave RegAff

# Lancement
run 200 ns
wave zoomfull