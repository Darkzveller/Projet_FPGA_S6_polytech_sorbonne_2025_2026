library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_SIGN_EXTENSION is
end TB_SIGN_EXTENSION;

architecture Behavioral of TB_SIGN_EXTENSION is

    -- Paramètre de test
    constant N_bits_E : integer := 8;

    -- Signaux
    signal E : STD_LOGIC_VECTOR(N_bits_E-1 downto 0);
    signal S : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- Instanciation du DUT (Device Under Test)
    DUT : entity work.SIGN_EXTENSION
        generic map(
            N_bits_E => N_bits_E
        )
        port map(
            E => E,
            S => S
        );

    -- Stimuli
    process
    begin

        -- Test 1 : nombre positif (00000101 = 5)
        E <= "00000101";
        wait for 10 ns;

        -- Test 2 : nombre négatif (11111011 = -5)
        E <= "11111011";
        wait for 10 ns;

        -- Test 3 : autre valeur négative
        E <= "10000001";
        wait for 10 ns;

        -- Test 4 : zéro
        E <= "00000000";
        wait for 10 ns;

        wait;
    end process;

end Behavioral;