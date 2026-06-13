library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_datapathV2 is
end entity;

architecture behavior of tb_datapathV2 is

    --------------------------------------------------------------------
    -- Signaux du DUT
    --------------------------------------------------------------------
    signal CLK      : std_logic := '0';
    signal RST      : std_logic := '0';

    signal RegWr    : std_logic := '0';
    signal RW       : std_logic_vector(3 downto 0) := (others=>'0');
    signal RA       : std_logic_vector(3 downto 0) := (others=>'0');
    signal RB       : std_logic_vector(3 downto 0) := (others=>'0');

    signal ALUCtr   : std_logic_vector(1 downto 0) := (others=>'0');

    signal N_flag   : std_logic;
    signal Z_flag   : std_logic;

    signal ALUSrc   : std_logic := '0';
    signal MemWr    : std_logic := '0';
    signal MemToReg : std_logic := '0';

    signal ImmExtin : std_logic_vector(7 downto 0) := (others=>'0');

    --------------------------------------------------------------------
    -- Constante d'horloge
    --------------------------------------------------------------------
    constant clk_period : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- Instanciation du Composant à Tester (DUT)
    --------------------------------------------------------------------
    DUT: entity work.DataPath
    port map(
        CLK      => CLK,
        RST      => RST,
        RegWr    => RegWr,
        RW       => RW,
        RA       => RA,
        RB       => RB,
        ALUCtr   => ALUCtr,
        N_flag   => N_flag,
        Z_flag   => Z_flag,
        ALUSrc   => ALUSrc,
        MemWr    => MemWr,
        MemToReg => MemToReg,
        ImmExtin => ImmExtin,
        RegAff_en => '0',
        RegAff_out => open
    );

    --------------------------------------------------------------------
    -- Générateur d'horloge
    --------------------------------------------------------------------
    CLK_PROC : process
    begin
        while true loop
            CLK <= '0';
            wait for clk_period/2;
            CLK <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- Processus des Stimulis
    --------------------------------------------------------------------
    process
    begin

        ----------------------------------------------------------------
        -- 0) RESET DU SYSTÈME
        ----------------------------------------------------------------
        RST <= '1';
        wait for clk_period;
        RST <= '0';
        wait for 2 ns; -- Léger décalage après le front pour stabiliser la simulation

        ----------------------------------------------------------------
        -- INITIALISATION : R1 = 10, R2 = 20
        ----------------------------------------------------------------
        report "INIT : R1 = 10 (0x0A), R2 = 20 (0x14)";
        
        -- Écriture de 10 dans R1
        RW       <= "0001";       -- Destination R1
        RA       <= "0001";       -- On cible direct R1 pour forcer la lecture asynchrone après l'écriture
        ALUSrc   <= '1';          -- Sélection de l'immédiat
        ImmExtin <= x"0A";        -- Valeur 10
        ALUCtr   <= "00";         -- Mode addition (généralement R0 + Imm ou Imm direct selon l'ALU)
        MemToReg <= '0';          
        RegWr    <= '1';          
        wait for clk_period;      -- Front montant d'écriture

        -- Écriture de 20 dans R2
        RW       <= "0010";       -- Destination R2
        RB       <= "0010";       -- On cible direct R2 pour la lecture asynchrone
        ImmExtin <= x"14";        -- Valeur 20
        wait for clk_period;      -- Front montant d'écriture
        
        RegWr    <= '0';          -- Fin de la phase d'écriture
        wait for clk_period;

        ----------------------------------------------------------------
        -- 1) ADDITION DE 2 REGISTRES : R3 = R1 + R2 (10 + 20 = 30)
        ----------------------------------------------------------------
        report "TEST 1 : ADD R1 + R2";

        RA       <= "0001";       -- Sélectionne R1 (vaut 10) -> BusA doit réagir de suite
        RB       <= "0010";       -- Sélectionne R2 (vaut 20) -> BusB doit réagir de suite
        RW       <= "0011";       -- Cible R3 pour la sauvegarde
        ALUSrc   <= '0';          -- On choisit le BusB (pas l'immédiat)
        ALUCtr   <= "00";         -- Opération : Addition
        MemToReg <= '0';          -- Source : ALUout
        RegWr    <= '1';          -- Autorise l'écriture dans le banc
        wait for clk_period;
        RegWr    <= '0';
        wait for clk_period;

        ----------------------------------------------------------------
        -- 2) ADDITION REGISTRE + IMMÉDIAT : R4 = R1 + 5 (10 + 5 = 15)
        ----------------------------------------------------------------
        report "TEST 2 : ADD R1 + imm";

        RA       <= "0001";       -- Source R1 (10)
        RW       <= "0100";       -- Destination R4
        ImmExtin <= x"05";        -- Valeur immédiate = 5
        ALUSrc   <= '1';          -- On bascule le Mux sur l'immédiat
        ALUCtr   <= "00";         -- Opération : Addition
        RegWr    <= '1';
        wait for clk_period;
        RegWr    <= '0';
        wait for clk_period;

        ----------------------------------------------------------------
        -- 3) SOUSTRACTION 2 REGISTRES : R5 = R2 - R1 (20 - 10 = 10)
        ----------------------------------------------------------------
        report "TEST 3 : SUB R2 - R1";

        RA       <= "0010";       -- Source A = R2 (20)
        RB       <= "0001";       -- Source B = R1 (10)
        RW       <= "0101";       -- Destination R5
        ALUSrc   <= '0';          -- On reprend le BusB
        ALUCtr   <= "01";         -- Opération : Soustraction
        RegWr    <= '1';
        wait for clk_period;
        RegWr    <= '0';
        wait for clk_period;

        ----------------------------------------------------------------
        -- 4) SOUSTRACTION IMMÉDIATE : R6 = R2 - 3 (20 - 3 = 17)
        ----------------------------------------------------------------
        report "TEST 4 : SUB R2 - imm";

        RA       <= "0010";       -- Source A = R2 (20)
        RW       <= "0110";       -- Destination R6
        ImmExtin <= x"03";        -- Valeur immédiate = 3
        ALUSrc   <= '1';          -- On bascule sur l'immédiat
        ALUCtr   <= "01";         -- Opération : Soustraction
        RegWr    <= '1';
        wait for clk_period;
        RegWr    <= '0';
        wait for clk_period;

        ----------------------------------------------------------------
        -- 5) COPIE REGISTRE : R7 = R1 (via ADD avec un immédiat de 0)
        ----------------------------------------------------------------
        report "TEST 5 : COPY R1 -> R7";

        RA       <= "0001";       -- Source A = R1 (10)
        RW       <= "0111";       -- Destination R7
        ImmExtin <= x"00";        -- On ajoute 0
        ALUSrc   <= '1';          -- Mux sur l'immédiat
        ALUCtr   <= "00";         -- Opération : Addition (10 + 0 = 10)
        RegWr    <= '1';
        wait for clk_period;
        RegWr    <= '0';
        wait for clk_period;

        ----------------------------------------------------------------
        -- 6) ÉCRITURE MÉMOIRE : MEM[R1] = R2 (Adresse = 10, Donnée = 20)
        ----------------------------------------------------------------
        report "TEST 6 : STORE MEM[R1] = R2";

        RA       <= "0001";       -- Pointeur d'adresse de base (R1 = 10)
        RB       <= "0010";       -- Donnée à injecter sur DataIn (R2 = 20)
        ImmExtin <= x"00";        -- Pas d'offset d'adresse (0)
        ALUSrc   <= '1';          -- Calcul adresse de la mémoire : R1 + 0
        ALUCtr   <= "00";         -- Addition pour figer l'adresse dans ALUout (10)
        MemWr    <= '1';          -- On déclenche l'écriture dans la RAM
        RegWr    <= '0';          -- Protection contre l'écriture sur le banc de registres
        wait for clk_period;
        MemWr    <= '0';          -- Fermeture de l'écriture RAM
        wait for clk_period;

        ----------------------------------------------------------------
        -- 7) LECTURE MÉMOIRE : R8 = MEM[R1] (R8 doit recevoir 20)
        ----------------------------------------------------------------
        report "TEST 7 : LOAD R8 = MEM[R1]";

        RA       <= "0001";       -- Adresse cible (R1 = 10)
        ImmExtin <= x"00";        
        ALUSrc   <= '1';          
        ALUCtr   <= "00";         -- L'adresse transmise à la RAM reste 10 (via ALUout)
        RW       <= "1000";       -- Destination R8 dans le banc de registres
        MemToReg <= '1';          -- Le Mux de sortie sélectionne DataOut (Mémoire) au lieu de ALUout
        RegWr    <= '1';          -- On valide l'enregistrement dans le registre R8
        wait for clk_period;

        RegWr    <= '0';
        MemToReg <= '0';

        ----------------------------------------------------------------
        -- FIN DE LA SIMULATION
        ----------------------------------------------------------------
        report "SIMULATION DU CHEMIN DE DONNÉES TERMINÉE AVEC SUCCÈS";
        wait;

    end process;

end architecture;