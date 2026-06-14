library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_reg_psr is
end tb_reg_psr;

architecture Behavioral of tb_reg_psr is

    -- Signaux de test
    signal CLK      : std_logic := '0';
    signal Reset    : std_logic := '0';
    signal PSREn    : std_logic := '0';
    signal DATA_IN  : std_logic_vector(31 downto 0) := (others => '0');
    signal DATA_OUT : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- Instanciation du DUT (Device Under Test)
    --------------------------------------------------------------------
    UUT: entity work.REG_PSR
        port map (
            CLK      => CLK,
            Reset    => Reset,
            PSREn    => PSREn,
            DATA_IN  => DATA_IN,
            DATA_OUT => DATA_OUT
        );

    --------------------------------------------------------------------
    -- Génération horloge
    --------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    stim_proc : process
    begin

        ----------------------------------------------------------------
        -- 1. RESET
        ----------------------------------------------------------------
        Reset <= '1';
        DATA_IN <= (others => '0');
        PSREn <= '0';
        wait for 20 ns;

        Reset <= '0';
        wait for CLK_PERIOD;

        ----------------------------------------------------------------
        -- 2. Mettre une valeur sur DATA_IN
        ----------------------------------------------------------------
        DATA_IN <= x"AAAA5555";

        -- laisser 3 cycles sans écriture (PSREn = 0)
        PSREn <= '0';

        wait for 3 * CLK_PERIOD;

        ----------------------------------------------------------------
        -- 3. Vérifier que DATA_OUT n'a PAS changé
        ----------------------------------------------------------------
        assert DATA_OUT = x"00000000"
        report "Erreur : DATA_OUT a change alors que PSREn=0"
        severity warning;

        ----------------------------------------------------------------
        -- 4. Activer écriture
        ----------------------------------------------------------------
        PSREn <= '1';
        wait for CLK_PERIOD;

        ----------------------------------------------------------------
        -- 5. Vérifier que DATA_OUT prend DATA_IN
        ----------------------------------------------------------------
        assert DATA_OUT = x"AAAA5555"
        report "Erreur : DATA_OUT n'a pas capture DATA_IN"
        severity error;

        ----------------------------------------------------------------
        -- 6. Changer DATA_IN mais PSREn = 0 -> doit rester stable
        ----------------------------------------------------------------
        PSREn <= '0';
        DATA_IN <= x"12345678";

        wait for 3 * CLK_PERIOD;

        assert DATA_OUT = x"AAAA5555"
        report "Erreur : DATA_OUT a change sans PSREn"
        severity error;

        ----------------------------------------------------------------
        -- Fin simulation
        ----------------------------------------------------------------
        wait;

    end process;

end Behavioral;