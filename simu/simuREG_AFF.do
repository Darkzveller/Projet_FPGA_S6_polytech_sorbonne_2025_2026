puts "Simulation script for ModelSim"

vlib work

# Compilation des fichiers sources
vcom -93 ../src/banc_registre.vhd
vcom -93 ../src/alu.vhd
vcom -93 ../src/memory_data.vhd
vcom -93 ../src/mul_2_to_1.vhd
vcom -93 ../src/sign_extension.vhd
vcom -93 ../src/datapath.vhd

# Compilation du banc de test
vcom -93 tb_reg_aff.vhd

# Lancement du simulateur
vsim -t 1ns tb_datapathV2

# ------------------------------------------------------------------
# CONFIGURATION DES SIGNAL WAVE
# ------------------------------------------------------------------

# Configuration Générale de Contrôle
add wave -divider " Controle "
add wave -color "Green" /tb_datapathV2/CLK
add wave -color "Red"   /tb_datapathV2/RST
add wave                /tb_datapathV2/RegWr
add wave                /tb_datapathV2/ALUSrc
add wave                /tb_datapathV2/ALUCtr
add wave                /tb_datapathV2/MemWr
add wave                /tb_datapathV2/MemToReg

# Adresses du Banc de Registres
add wave -divider " Adresses REG "
add wave -radix unsigned /tb_datapathV2/RA
add wave -radix unsigned /tb_datapathV2/RB
add wave -radix unsigned /tb_datapathV2/RW

# Données Internes du Chemin de Données (DUT)
add wave -divider " Interne Datapath (Bus) "
add wave -radix unsigned -color "Cyan" /tb_datapathV2/DUT/BusA
add wave -radix unsigned -color "Cyan" /tb_datapathV2/DUT/BusB
add wave -radix unsigned -color "Orange" /tb_datapathV2/DUT/ImmExt_Mux_out
add wave -radix unsigned -color "Yellow" /tb_datapathV2/DUT/ALUout
add wave -radix unsigned -color "Pink"   /tb_datapathV2/DUT/DataOut
add wave -radix unsigned -color "Gold"   /tb_datapathV2/DUT/BusW

# Drapeaux d'état (Flags)
add wave -divider " Flags "
add wave /tb_datapathV2/N_flag
add wave /tb_datapathV2/Z_flag

add wave -divider "Reg AFF "
add wave -radix binary /tb_datapathV2/RegAff_en
add wave -radix unsigned /tb_datapathV2/RegAff_out

# Lancement temporel étendu pour couvrir tous les stimuli (environ 20 cycles)
run 250 ns