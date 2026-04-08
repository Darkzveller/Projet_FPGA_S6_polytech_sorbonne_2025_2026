-- tb_heartbeat.vhd
-- --------------------------
--  Testbench for HeartBeat
-- --------------------------
-- Self-testing test bench (c) ALSE.
-- htp://www.alse-fr.com

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity TB_HEARTBEAT is
end;

architecture TEST of TB_HEARTBEAT is

  signal CLK      :  std_logic := '0';
  signal RST      :  std_logic;
  signal Tick10uS :  std_logic := '0';
  signal LED4     :  std_logic;

  constant Period : time := 1 us; -- 1 MHz
  signal DONE : boolean;

begin

  CLK <= '0' when DONE else not CLK after Period / 2;
  RST <= '1', '0' after Period;
  Tick10uS <= '0' when DONE else not Tick10uS after (10 us - Period), Tick10uS after 10 us;
  DONE <= true after 1.5 sec;

  UUT : entity work.HEARTBEAT
    port map ( CLK      => CLK,
               RST      => RST,
               TICK10US => TICK10uS,
               LED      => LED4 );

end architecture TEST;