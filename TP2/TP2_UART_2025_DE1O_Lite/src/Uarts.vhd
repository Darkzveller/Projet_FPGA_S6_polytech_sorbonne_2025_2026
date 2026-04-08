-- UARTS.vhd
-- -----------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- ----------------------------------------------
    Entity UARTS is
-- ----------------------------------------------
  Generic ( Fxtal   : integer  := 50e6;  -- in Hertz
            Parity  : boolean  := false;
            Even    : boolean  := false;
            Baud1   : positive := 115200;
            Baud2   : positive := 19200
          );
  Port (  CLK     : in  std_logic;  -- System Clock at Fxtal
          RST     : in  std_logic;  -- Asynchronous Reset active high

          Din     : in  std_logic_vector (7 downto 0);
          LD      : in  std_logic;  -- Load, must be pulsed high
          Rx      : in  std_logic;

          Baud    : in  std_logic;  -- Baud Rate Select Baud1 (1) / Baud2 (0)

          Dout    : out std_logic_vector(7 downto 0);
          Tx      : out std_logic;
          TxBusy  : out std_logic;  -- '1' when Busy sending
          RxErr   : out std_logic;
          RxRDY   : out std_logic   -- '1' when Data available
       );
end UARTS;


-- ---------------------------------------------------------------
    Architecture RTL of UARTS is
-- ---------------------------------------------------------------

--------
begin
--------


end RTL;
