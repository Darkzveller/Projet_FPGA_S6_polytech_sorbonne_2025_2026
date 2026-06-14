library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity DATA_MEMORY is
  port (
    CLK   : in std_logic;
    Reset : in std_logic;
    WrEn  : in std_logic;

    Addr    : in std_logic_vector(5 downto 0);
    DataIn  : in std_logic_vector(31 downto 0);
    DataOut : out std_logic_vector(31 downto 0)
  );
end DATA_MEMORY;

architecture Behavioral of DATA_MEMORY is

  type mem_type is array (0 to 63)
  of std_logic_vector(31 downto 0);

  -- signal MEM : mem_type := (others => (others => '1'));
signal MEM : mem_type := (
    16     => x"00000001", -- Adresse 0x10
    17     => x"00000002", -- Adresse 0x11
    18     => x"00000003", -- Adresse 0x12
    19     => x"00000004", -- Adresse 0x13
    20     => x"00000005", -- Adresse 0x14
    21     => x"00000006", -- Adresse 0x15
    22     => x"00000007", -- Adresse 0x16
    23     => x"00000008", -- Adresse 0x17
    24     => x"00000009", -- Adresse 0x18
    25     => x"0000000A", -- Adresse 0x19
    26     => x"0000000B", -- Adresse 0x1A (Case de sauvegarde finale pour STR)
    others => x"00000000"
  );
begin

  process (CLK)
  begin

    if Reset = '1' then
      -- MEM <= (others => (others => '1'));
MEM <= (
        16     => x"00000001",
        17     => x"00000002",
        18     => x"00000003",
        19     => x"00000004",
        20     => x"00000005",
        21     => x"00000006",
        22     => x"00000007",
        23     => x"00000008",
        24     => x"00000009",
        25     => x"0000000A",
        26     => x"0000000B",
        others => x"00000000"
      );
    elsif rising_edge(CLK) then

      if WrEn = '1' then
        MEM(to_integer(unsigned(Addr))) <= DataIn;
      end if;

    end if;
  end process;

  DataOut <= MEM(to_integer(unsigned(Addr)));

end Behavioral;