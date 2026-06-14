
-- Non utiliser dans ce projet
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REG_PSR is
    port (
        CLK   : in std_logic;
        Reset : in std_logic;
		PSREn : in std_logic;
		DATA_IN : in std_logic_vector (31 downto 0) := (others => '0');
		DATA_OUT : out std_logic_vector (31 downto 0)
    );
end entity;

architecture Behavioral of REG_PSR is

begin
	process(CLK, Reset)
	begin
		if Reset= '1' then
			DATA_OUT <= (others => '0');
		elsif rising_edge(CLK) then
			if PSREn = '1' then
				DATA_OUT <= DATA_IN;
			end if;
		end if;
	end process;
end architecture;
