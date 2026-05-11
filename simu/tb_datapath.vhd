library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_datapath is
end tb_datapath;

architecture Behavioral of tb_datapath is

    -- Signaux de test
    signal CLK     : STD_LOGIC := '0';
    signal RST     : STD_LOGIC := '0';
    signal RegWr   : STD_LOGIC := '0';
    signal RW, RA, RB : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal ALUCtr  : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal N_flag, Z_flag : STD_LOGIC;

    -- Période de l'horloge
    constant period : time := 10 ns;

begin

    -- Instanciation de l'unité de traitement
    UUT: entity work.DataPath
        port map (
            CLK => CLK, RST => RST, RegWr => RegWr,
            RW => RW, RA => RA, RB => RB,
            ALUCtr => ALUCtr, N_flag => N_flag, Z_flag => Z_flag
        );

    -- Génération de l'horloge
    CLK <= not CLK after period/2;

    -- Processus de stimulation
    stim_proc: process
    begin
        -- Initialisation
        RST <= '1';
        wait for period*2;
        RST <= '0';
        wait for period;

        -- 1. R(1) = R(15)  [Note: R(15) initialisé à 0x30 dans ton code]
        -- On passe R(15) à travers l'ALU (OP="01" pour laisser passer B)
        RB <= "1111";      -- Lire R(15) sur BusB
        ALUCtr <= "01";    -- ALU sort B
        RW <= "0001";      -- Destination R(1)
        RegWr <= '1';      -- Autoriser l'écriture
        wait for period;
        
        -- 2. R(1) = R(1) + R(15)  (0x30 + 0x30 = 0x60)
        RA <= "0001";      -- Lire R(1) sur BusA
        RB <= "1111";      -- Lire R(15) sur BusB
        ALUCtr <= "00";    -- ADD
        RW <= "0001";      -- Destination R(1)
        wait for period;

        -- 3. R(2) = R(1) + R(15)  (0x60 + 0x30 = 0x90)
        RA <= "0001";
        RB <= "1111";
        ALUCtr <= "00";    -- ADD
        RW <= "0010";      -- Destination R(2)
        wait for period;

        -- 4. R(3) = R(1) - R(15)  (0x60 - 0x30 = 0x30)
        RA <= "0001";
        RB <= "1111";
        ALUCtr <= "10";    -- SUB
        RW <= "0011";      -- Destination R(3)
        wait for period;

        -- 5. R(5) = R(7) - R(15)  (0 - 0x30 = -0x30)
        RA <= "0111";      -- R(7) est à 0
        RB <= "1111";
        ALUCtr <= "10";    -- SUB
        RW <= "0101";      -- Destination R(5)
        wait for period;

        RegWr <= '0'; -- Fin des écritures
        wait;
    end process;

end Behavioral;