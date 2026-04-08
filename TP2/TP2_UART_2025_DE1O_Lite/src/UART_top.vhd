-- UART_top.vhd
-- -----------------------------
--   RS232 Encrypter top level -
-- -----------------------------
--

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- -----------------------------------------------------------------
    Entity UART_top is
-- -----------------------------------------------------------------
  port (sysclk 	:  IN  STD_LOGIC;
		UART_TXD  :  OUT  STD_LOGIC;
		UART_RXD  :  IN STD_LOGIC;
		BTN			 	:  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		SW 				:  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		LED             :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0));
end entity ;

-- -----------------------------------------------------------------
    Architecture RTL of DE_top is
-- -----------------------------------------------------------------

  signal rst,clk      : std_logic;
  signal Tx,Rx : std_logic;

---------
begin
---------

rst <= not KEY(0);
clk <= sysclk; 
UART_TXD <= Tx;

Rx <= UART_RXD;

----------------------------------



-- Insert your code below ... 


end architecture;
