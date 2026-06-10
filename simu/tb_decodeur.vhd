library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_decodeur is
-- L'entité d'un banc de test est toujours vide
end tb_decodeur;

architecture Behavioral of tb_decodeur is

    -- Signaux pour relier au Décodeur
    signal instruction : std_logic_vector(31 downto 0) := (others => '0');
    signal Flags_NZCV  : std_logic_vector(3 downto 0)  := (others => '0');
    
    signal nPC_SEL     : std_logic;
    signal PSREn       : std_logic;
    signal RegWr       : std_logic;
    signal RegSel      : std_logic;
    signal ALUCtrl     : std_logic_vector(2 downto 0);
    signal MemToReg    : std_logic;
    signal ALUSrc      : std_logic;
    signal WrSrc       : std_logic;
    signal MemWr       : std_logic;
    signal RegAff      : std_logic;

begin

    -- Instanciation du Décodeur (UUT)
    UUT: entity work.DECODEUR
        port map (
            instruction => instruction,
            Flags_NZCV  => Flags_NZCV,
            nPC_SEL     => nPC_SEL,
            PSREn       => PSREn,
            RegWr       => RegWr,
            RegSel      => RegSel,
            ALUCtrl     => ALUCtrl,
            MemToReg    => MemToReg,
            ALUSrc      => ALUSrc,
            WrSrc       => WrSrc,
            MemWr       => MemWr,
            RegAff      => RegAff
        );

    -- Processus de simulation (Stimuli)
    stim_proc: process
    begin
        -- Initialisation
        wait for 10 ns;

        -- 1. Test MOV R1, #0x10 (Instruction: 0xE3A01010)
        -- Attendu : RegWr='1', ALUSrc='1', ALUCtrl="001" (Passage de B)
        instruction <= x"E3A01010";
        Flags_NZCV  <= "0000";
        wait for 20 ns;

        -- 2. Test MOV R2, #0 (Instruction: 0xE3A02000)
        -- Attendu : Même comportement que le MOV précédent
        instruction <= x"E3A02000";
        wait for 20 ns;

        -- 3. Test LDR R0, 0(R1) (Instruction: 0xE4110000)
        -- Attendu : RegWr='1', RegSel='0', ALUSrc='1', ALUCtrl="000" (Add), MemToReg='1'
        instruction <= x"E4110000";
        wait for 20 ns;

        -- 4. Test ADD R2, R2, R0 (Instruction: 0xE0822000) - ADDr (avec registre)
        -- Attendu : RegWr='1', ALUSrc='0' (Bus B), ALUCtrl="000"
        instruction <= x"E0822000";
        wait for 20 ns;

        -- 5. Test CMP R1, 0x1A (Instruction: 0xE351001A)
        -- Attendu : PSREn='1', RegWr='0', ALUSrc='0', ALUCtrl="002" (Soustraction)
        instruction <= x"E351001A";
        wait for 20 ns;

        -- 6. Test BLT loop (Instruction: 0xBAFFFFFB) quand le Flag N = '0' (Faux)
        -- Attendu : nPC_SEL doit être à '0' (pas de saut)
        instruction <= x"BAFFFFFB";
        Flags_NZCV  <= "0000"; -- Le bit N (poids fort) est à 0
        wait for 20 ns;

        -- 7. Test BLT loop (Instruction: 0xBAFFFFFB) quand le Flag N = '1' (Vrai)
        -- Attendu : nPC_SEL doit passer à '1' (Saut activé !)
        instruction <= x"BAFFFFFB";
        Flags_NZCV  <= "1000"; -- Le bit N (poids fort) passe à 1
        wait for 20 ns;

        -- 8. Test STR R2, 0(R1) (Instruction: 0xE4012000)
        -- Attendu : MemWr='1', RegSel='1', ALUSrc='1', ALUCtrl="000"
        instruction <= x"E4012000";
        Flags_NZCV  <= "0000";
        wait for 20 ns;

        -- 9. Test BAL main (Instruction: 0xEAFFFFF7)
        -- Attendu : nPC_SEL doit être à '1' de manière inconditionnelle
        instruction <= x"EAFFFFF7";
        wait for 20 ns;

        -- Fin de la simulation
        wait;
    end process;

end Behavioral;