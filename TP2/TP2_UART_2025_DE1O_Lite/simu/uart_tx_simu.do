vlib work

vcom -93 ../src/fdiv.vhd
vcom -93 ../src/uart_tx.vhd
vcom -93 uart_tx_tb.vhd

vsim uart_tx_tb(Bench)

view signals
add wave *
add wave -position insertpoint  \
sim:/uart_tx_tb/UART_TX/State
add wave -position insertpoint  \
sim:/uart_tx_tb/UART_TX/i

run -all
wave zoom full