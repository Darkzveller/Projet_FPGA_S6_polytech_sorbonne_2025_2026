library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_MUL_2_TO_1 is
end TB_MUL_2_TO_1;

architecture Behavioral of TB_MUL_2_TO_1 is

    -- Constante pour la taille des bus
    constant N_bits : integer := 32;

    -- Signaux de test
    signal COM : STD_LOGIC;
    signal A   : STD_LOGIC_VECTOR(N_bits-1 downto 0);
    signal B   : STD_LOGIC_VECTOR(N_bits-1 downto 0);
    signal S   : STD_LOGIC_VECTOR(N_bits-1 downto 0);

begin

    -- Instanciation du composant à tester
    UUT : entity work.MUL_2_TO_1
        generic map(
            N_bits => N_bits
        )
        port map(
            COM => COM,
            A   => A,
            B   => B,
            S   => S
        );

    -- Stimulus
    process
    begin

        -- Test 1 : COM = 0
        A   <= x"AAAAAAAA";
        B   <= x"55555555";
        COM <= '0';

        wait for 10 ns;

        -- Test 2 : COM = 1
        COM <= '1';

        wait for 10 ns;

        -- Test 3 : nouvelles valeurs
        A   <= x"12345678";
        B   <= x"87654321";
        COM <= '0';

        wait for 10 ns;

        -- Test 4
        COM <= '1';

        wait for 10 ns;

        -- Fin simulation
        wait;

    end process;

end Behavioral;