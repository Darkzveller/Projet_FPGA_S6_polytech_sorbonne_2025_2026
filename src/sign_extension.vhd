library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity SIGN_EXTENSION is
    generic(
        N_bits_E : integer := 32     
        );

    Port (
        E  : in  STD_LOGIC_VECTOR (N_bits_E-1 downto 0); -- Bus de données sur N bits
        S  : out  STD_LOGIC_VECTOR (31 downto 0) -- Bus de données sur N bits
    );
end SIGN_EXTENSION;

architecture Behavioral of SIGN_EXTENSION is

begin
    process(E)
    begin

        -- Copie de l'entree sur les N premier bits
        S(N_bits_E-1 downto 0) <= E;
        -- Extension du signe
        S(31 downto N_bits_E) <= (others => E(N_bits_E-1));
    end process;
end Behavioral;