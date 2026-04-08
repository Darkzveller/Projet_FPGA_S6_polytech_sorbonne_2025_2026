-- CRYPTER.vhd
-- ----------------------------------------------------
--   Communication & "Scrambling" Engine
-- ----------------------------------------------------

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;


-- ----------------------------------------------------
    Entity CRYPTER is
-- ----------------------------------------------------
      Port (     Clk : In  std_logic;
                 Rst : In  std_logic;
             Encrypt : in  std_logic;                    -- '1'=Encrypt, '0'=Decrypt
                 RTS : In  std_logic;                    -- from UARTS
               RxRDY : In  std_logic;                    -- from UARTS
                SDin : In  std_logic_vector (7 downto 0);-- from UARTS

              TxBusy : In  std_logic;                    -- from UARTS
            LD_SDout : Out std_logic;                    -- to UARTS
               SDout : Out std_logic_vector (7 downto 0);-- to UARTS
              Failed : out std_logic                     -- indicates an overflow failure
            );
end entity CRYPTER;


-- ----------------------------------------------------
    Architecture RTL of CRYPTER is
-- ----------------------------------------------------



begin


end RTL;

