library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_proc_mono_cycle is
-- L'entité d'un banc de test est toujours vide
end tb_proc_mono_cycle;

architecture Behavioral of tb_proc_mono_cycle is

    -- Signaux pour relier au processeur global
    signal CLK : STD_LOGIC := '0';
    signal RST : STD_LOGIC := '0';

    -- Constante pour définir la période de l'horloge (ex: 50 MHz -> 20 ns)
    constant CLK_PERIOD : time := 20 ns;

begin
    UUT: entity work.proc_mono_cycle
        port map (
            CLK => CLK,
            RST => RST
        );

    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stim_proc: process
    begin
        RST <= '1';
        wait for CLK_PERIOD * 2;
        RST <= '0';
        wait for 500 ns;

        wait;
    end process;

end Behavioral;