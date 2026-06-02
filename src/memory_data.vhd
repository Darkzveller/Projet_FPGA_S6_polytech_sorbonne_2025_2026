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

  signal MEM : mem_type := (others => (others => '0'));

begin

  process (CLK)
  begin

    if Reset = '1' then
      MEM <= (others => (others => '0'));

    elsif rising_edge(CLK) then

      if WrEn = '1' then
        MEM(to_integer(unsigned(Addr))) <= DataIn;
      end if;

    end if;
  end process;

  DataOut <= MEM(to_integer(unsigned(Addr)));

end Behavioral;