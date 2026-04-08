library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TX is
    port (
        Clk   : in std_logic;
        Reset : in std_logic;
        LD    : in std_logic;
        Din  : in std_logic_vector(7 downto 0);
        Tick  : in std_logic;
        Tx_Busy  : out std_logic;
        Tx    : out std_logic
    );
end entity;

architecture RTL of UART_TX is

begin


end architecture;