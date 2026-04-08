library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_RX is
    port (
        Clk          : in std_logic;
        Reset        : in std_logic;
        Rx           : in std_logic;
        Tick_halfbit : in std_logic;
        Clear_fdiv   : out std_logic;
        Err          : out std_logic;
        Data         : out std_logic_vector(7 downto 0)
    );
end UART_RX;

architecture RTL of UART_RX is
    
begin


end RTL;