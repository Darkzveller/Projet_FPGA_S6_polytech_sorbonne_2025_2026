puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/banc_registre.vhd
vcom -93 ../src/alu.vhd
vcom -93 ../src/datapath.vhd
vcom -93 tb_datapath.vhd

vsim -t 1ns tb_datapath



# Ajouter les signaux de contrôle
add wave -divider " Controle "
add wave CLK
add wave RST
add wave RegWr

# Ajouter les bus de données
add wave -divider " Donnees "
add wave -radix hexadecimal RA
add wave -radix hexadecimal RB
add wave -radix hexadecimal RW
add wave -radix hexadecimal UUT/BusA
add wave -radix hexadecimal UUT/BusB
add wave -radix hexadecimal UUT/BusW

# --- ALIAS POUR LES REGISTRES ---
# On va chercher directement dans le signal "Banc" à l'intérieur de l'instance
add wave -divider " Registres Internes "
add wave -noupdate -format Literal -radix hexadecimal -label R1  {/UUT/Inst_BANC_REG/Banc(1)}
add wave -noupdate -format Literal -radix hexadecimal -label R2  {/UUT/Inst_BANC_REG/Banc(2)}
add wave -noupdate -format Literal -radix hexadecimal -label R3  {/UUT/Inst_BANC_REG/Banc(3)}
add wave -noupdate -format Literal -radix hexadecimal -label R5  {/UUT/Inst_BANC_REG/Banc(5)}
add wave -noupdate -format Literal -radix hexadecimal -label R15 {/UUT/Inst_BANC_REG/Banc(15)}

run 150 ns