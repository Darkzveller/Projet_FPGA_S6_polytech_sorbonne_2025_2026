# =====================================================================
# SCRIPT DE SIMULATION MODELSIM POUR LE PROCESSEUR MONOCYCLE (DATAPATH)
# =====================================================================

# 1. Création de la bibliothèque de travail
vlib work

# 2. Compilation de tous les composants du projet (dans l'ordre des dépendances)
vcom -93 ../src/instruction_memory.vhd
vcom -93 ../src/SIGN_EXTENSION.vhd
vcom -93 ../src/UNIT_GESTION_INSTRUCTION.vhd

vcom -93 ../src/ALU.vhd
vcom -93 ../src/banc_registre.vhd             
vcom -93 ../src/memory_data.vhd               
vcom -93 ../src/MUL_2_TO_1.vhd
vcom -93 ../src/DataPath.vhd
vcom -93 ../src/DECODEUR.vhd
vcom -93 ../src/SEVEN_SEG.vhd

# Compilation du Top-Level et du Testbench
vcom -93 ../src/proc_mono_cycle.vhd
vcom -93 tb_proc_mono_cycle.vhd

# 3. Lancement de la simulation
vsim -t 1ns tb_proc_mono_cycle

# 4. Configuration de l'affichage des vagues (Chronogrammes)

add wave -divider " Pilotes Globaux "
add wave -color "Yellow" CLK
add wave -color "Red"    RST

add wave -divider " Unité d'Instruction & Décodeur "
add wave -radix hexadecimal -label "PC"           UUT/Inst_UNIT_GEST_INSTRUCTION/PC_reg
add wave -radix hexadecimal -label "Instruction"  UUT/s_instruction
add wave -color "Orange"    -label "ALUCtrl(2:0)" UUT/s_ALUCtrl

add wave -divider " Entrées de Contrôle du DataPath "
add wave -label "RegWr (WE Banc)" UUT/Inst_DATA_PATH/RegWr
add wave -label "ALUSrc (Mux ALU)" UUT/Inst_DATA_PATH/ALUSrc
add wave -label "MemWr (WE Mémoire)" UUT/Inst_DATA_PATH/MemWr
add wave -label "MemToReg (Mux Sortie)" UUT/Inst_DATA_PATH/MemToReg

add wave -divider " Bus d'Adresses (Banc de Reg) "
add wave -radix hexadecimal -label "RA" UUT/Inst_DATA_PATH/RA
add wave -radix hexadecimal -label "RB" UUT/Inst_DATA_PATH/RB
add wave -radix hexadecimal -label "RW" UUT/Inst_DATA_PATH/RW

add wave -divider " Signaux Internes du DataPath "
add wave -radix hexadecimal -label "Bus A (Sortie Reg A)"   UUT/Inst_DATA_PATH/BusA
add wave -radix hexadecimal -label "Bus B (Sortie Reg B)"   UUT/Inst_DATA_PATH/BusB
# =====================================================================
# AJOUT DES SIGNAUX D'EXTENSION ICI :
add wave -radix hexadecimal -label "ImmExtin (Entrée 8 bits)" UUT/Inst_DATA_PATH/ImmExtin
# =====================================================================
add wave -radix hexadecimal -label "ImmExtout (Signe Ext)" UUT/Inst_DATA_PATH/ImmExtout
add wave -radix hexadecimal -label "Entrée B de l'ALU"      UUT/Inst_DATA_PATH/ImmExt_Mux_out
add wave -radix hexadecimal -label "ALUout (Sortie ALU)"   UUT/Inst_DATA_PATH/ALUout
add wave -radix hexadecimal -label "DataOut (Sortie Mem)"   UUT/Inst_DATA_PATH/DataOut
add wave -radix hexadecimal -label "Bus W (Donnée à écrire)" UUT/Inst_DATA_PATH/BusW

add wave -divider " Drapeaux d'état (Flags) "
add wave -color "Cyan" -label "Flag N (Négatif)" UUT/s_N_flag
add wave -color "Cyan" -label "Flag Z (Zéro)"    UUT/s_Z_flag

add wave -divider " Suivi des Registres de Travail "
# CORRECTION : Utilisation du signal "Banc" conformément à votre fichier BANC_REGISTRE
add wave -radix hexadecimal -label "R0 (Donnée LDR)"   UUT/Inst_DATA_PATH/Inst_BANC_REG/Banc(0)
add wave -radix hexadecimal -label "R1 (Pointeur)"     UUT/Inst_DATA_PATH/Inst_BANC_REG/Banc(1)
add wave -radix hexadecimal -label "R2 (Accumulateur)" UUT/Inst_DATA_PATH/Inst_BANC_REG/Banc(2)
add wave -radix hexadecimal   UUT/s_RegAff_val

add wave -divider " Affichage HEX "
add wave -radix binary -label "s_RegAff_val" UUT/s_RegAff_val
add wave -radix binary -label "HEX0" UUT/HEX0
add wave -radix binary -label "HEX1" UUT/HEX1
add wave -radix binary -label "HEX2" UUT/HEX2
add wave -radix binary -label "HEX3" UUT/HEX3

# 5. Lancement de l'exécution
run 3000 ns

# Ajustement de la fenêtre de visualisation
wave zoomfull