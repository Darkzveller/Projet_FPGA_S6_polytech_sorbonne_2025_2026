-- tb_bcd_counter
-- ---------------------------------------------------
--  Test Bench for BCD Counter entity
-- ---------------------------------------------------
-- Self testing but not exhaustive...
-- Counts at 500 Hz so simulation is fast.
-- Note : must compile in VHDL '93 or 2001.

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity tb_bcd_counter is
end;

architecture TEST of tb_bcd_counter is

constant Period : time := 10 us; -- speed up simulation with a 100kHz clock

signal CLK      : std_logic := '0';
signal RST      : std_logic := '1';
signal TICK1MS  : std_logic := '0';
signal UNITIES, TENS, HUNDREDS, THOUSNDS : std_logic_vector(3 downto 0);
signal Done : boolean;

begin

-- System Inputs
CLK <= '0' when Done else not CLK after Period / 2;
RST <= '1', '0' after Period;
Tick1ms <= '0' when Done else not Tick1ms after 1 ms - Period, Tick1ms after 1 ms;

-- Unit Under Test instanciation
UUT : entity work.BCD_COUNTER
generic map ( N => 2 )  -- division factor for Tick1ms
port map ( CLK      => CLK,
           RST      => RST,
           TICK1MS  => TICK1MS,
           UNITIES  => UNITIES,
           TENS     => TENS,
           HUNDREDS => HUNDREDS,
           THOUSNDS => THOUSNDS );

-- Control Simulation and check outputs
process begin
  wait for 199 ms;
  report "Checking output (should be 99).";
  assert HUNDREDS=x"0" report "Error on HUNDREDS" severity warning;
  assert TENS    =x"9" report "Error on TENS"  severity warning;
  assert UNITIES =x"9" report "Error on UNITS" severity warning;

  wait for 4 ms;  -- 203
  report "Checking output (should be 101)";
  assert THOUSNDS=x"0" report "Error on THOUSNDS" severity warning;
  assert HUNDREDS=x"1" report "Error on HUNDREDS" severity warning;
  assert TENS    =x"0" report "Error on TENS"  severity warning;
  assert UNITIES =x"1" report "Error on UNITS" severity warning;

  wait for 1800 ms;  -- 2003
  report "Checking output (should be 1001)";
  assert THOUSNDS=x"1" report "Error on THOUSNDS" severity warning;
  assert HUNDREDS=x"0" report "Error on HUNDREDS" severity warning;
  assert TENS    =x"0" report "Error on TENS"  severity warning;
  assert UNITIES =x"1" report "Error on UNITS" severity warning;

  report "End of test. Verify that no error was reported.";
  Done <= true;
  wait;
end process;

end;
