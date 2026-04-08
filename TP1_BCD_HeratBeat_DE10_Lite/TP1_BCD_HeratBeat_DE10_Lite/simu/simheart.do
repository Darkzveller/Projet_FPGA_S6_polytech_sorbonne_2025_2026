# Simulation script for ModelSim

vlib work
vcom -93 ../src/heartbeat.vhd
vcom -93 tb_heartbeat.vhd
vsim -novopt tb_heartbeat
add wave *
run -a
