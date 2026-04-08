

LIBRARY ieee;
USE ieee.std_logic_1164.all; 



ENTITY TP1_BCD is
	PORT
	(
		CLOCK_50 	:  IN  STD_LOGIC;
		KEY			 	:  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		SW 				:  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX1 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX2 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX3 			:  OUT  STD_LOGIC_VECTOR(0 TO 6)
	);
END entity;

ARCHITECTURE RTL OF TP1_BCD IS 

	signal 	rst,clk, pol,tick_1ms  : std_logic;
	
	signal UNITIES, TENS, HUNDREDS, THOUSNDS : std_logic_vector(3 downto 0);

BEGIN 

rst <= not KEY(0);
clk <= CLOCK_50; 
pol <= SW(9);

FDIV_UUT : entity work.FDIV
   port map(
       CLK     => clk,
       RST     => rst,
       Tick1us => open,
       Tick4us => open,
       Tick10us => open,
       Tick1ms => tick_1ms,
       Tick10ms => open
   );


counter_UUT : entity work.BCD_COUNTER
generic map ( N => 2 )  -- division factor for Tick1ms
port map ( clk      => CLK,
           rst      => RST,
           TICK1MS  => tick_1ms,
           UNITIES  => UNITIES,
           TENS     => TENS,
           HUNDREDS => HUNDREDS,
           THOUSNDS => THOUSNDS );

UNITIES_UUT : entity work.SEVEN_SEG
port map(
    Data   => UNITIES,
    Pol    => '0',
    Segout => HEX0);


TENS_UUT : entity work.SEVEN_SEG
port map(
    Data   => TENS,
    Pol    => '0',
    Segout => HEX1);


HUNDREDS_UUT : entity work.SEVEN_SEG
port map(
    Data   => TENS,
    Pol    => '0',
    Segout => HEX2);


THOUSNDS_UUT : entity work.SEVEN_SEG
port map(
    Data   => THOUSNDS,
    Pol    => '0',
    Segout => HEX3);



END architecture;