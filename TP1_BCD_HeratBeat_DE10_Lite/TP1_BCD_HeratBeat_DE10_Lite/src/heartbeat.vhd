
library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- -----------------------------------
    Entity HEARTBEAT is
-- -----------------------------------
  port ( CLK      : in  std_logic;    -- 60 MHz in  case of Tornado
         RST      : in  std_logic;    -- Asynchronous Reset active high
         TICK10US : in  std_logic;    -- Tick 10 us (see FDIV)
         LED      : out std_logic );  -- Output LED
end entity HEARTBEAT;


-- -----------------------------------
    Architecture RTL of HEARTBEAT is
-- -----------------------------------

begin

process (CLK, RST)
begin
end process;

end architecture RTL;
