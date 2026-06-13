library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_UNIT_GESTION_INSTRUCTION is
end TB_UNIT_GESTION_INSTRUCTION;

architecture Behavioral of TB_UNIT_GESTION_INSTRUCTION is
    signal CLK         : STD_LOGIC := '0';
    signal Reset       : STD_LOGIC := '0';
    signal nPCsel      : STD_LOGIC := '0';
    signal Offset      : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
    signal Instruction : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    constant T : time := 10 ns;

begin

    DUT : entity work.UNIT_GESTION_INSTRUCTION
        port map(
            CLK         => CLK,
            Reset       => Reset,
            nPCsel      => nPCsel,
            Offset      => Offset,
            Instruction => Instruction
        );

    process
    begin
        while true loop
            CLK <= '0';
            wait for T/2;
            CLK <= '1';
            wait for T/2;
        end loop;
    end process;

    process
    begin

        Reset <= '1';
        nPCsel <= '0';
        Offset <= (others => '0');
        wait for T;
        
        Reset <= '0';
        wait for T; -- Laisse passer un cycle pour observer l'adresse 0 (MOV R1,#0x10)

        --------------------------------------------------
        -- 2. MODE LINEAIRE (nPCsel = '0' -> PC = PC + 1)
        --------------------------------------------------
        -- On laisse le PC s'incrémenter naturellement pendant quelques cycles.
        -- Le PC va passer successivement à 1, 2, 3...
        nPCsel <= '0';
        wait for 3 * T; 

        --------------------------------------------------
        -- 3. MODE SAUT AVANT (nPCsel = '1' avec Offset Positif)
        --------------------------------------------------
        -- Supposons qu'on lise une instruction de saut. 
        -- On applique un offset de +2. 
        -- La formule donne : PC_suivant = PC + 1 + Offset
        Offset <= x"000002"; 
        nPCsel <= '1';
        wait for T; -- Au front montant, le saut est effectué

        -- On désactive le saut pour voir si le PC reprend sa marche linéaire (+1)
        -- à partir de sa nouvelle adresse.
        nPCsel <= '0';
        wait for 2 * T;

        --------------------------------------------------
        -- 5. MODE SAUT ARRIÈRE (Offset Négatif, ex: une boucle)
        --------------------------------------------------
        -- On simule un saut en arrière (en complément à 2).
        -- x"FFFFFF" correspond à -1.
        -- PC_suivant = PC + 1 + (-1) = PC. Le PC devrait "stagner".
        Offset <= x"FFFFFF"; 
        nPCsel <= '1';
        wait for T;

        --------------------------------------------------
        -- FIN DE LA SIMULATION
        --------------------------------------------------
        nPCsel <= '0';
        wait;

    end process;

end Behavioral;