library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity MUL_2_TO_1 is
    generic(
        N_bits : integer := 32);

    Port (
        COM : in  STD_LOGIC;                    -- Commande
        A  : in  STD_LOGIC_VECTOR (N_bits-1 downto 0); -- Bus de données sur N bits
        B  : in  STD_LOGIC_VECTOR (N_bits-1 downto 0); -- Bus de données sur N bits
        S  : out  STD_LOGIC_VECTOR (N_bits-1 downto 0)  -- Bus de sortie du multiplexeur sur N bits
    );
end MUL_2_TO_1;

architecture Behavioral of MUL_2_TO_1 is

begin
    -- Sélectionne le bus de données sur N bits
    S <= A when COM='0' else B;

end Behavioral;