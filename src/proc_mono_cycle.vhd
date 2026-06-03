library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity proc_mono_cycle is 
    Port (
        CLK : in std_logic;
        RST : in std_logic
    );
end proc_mono_cycle;

architecture rtl of proc_mono_cycle is

    -- Signaux d'interconnexion pour les instructions et adresses
    signal s_instruction : std_logic_vector(31 downto 0);
    signal s_Rn          : std_logic_vector(3 downto 0);
    signal s_Rm          : std_logic_vector(3 downto 0);
    signal s_Rd          : std_logic_vector(3 downto 0);
    signal s_Rb_muxed    : std_logic_vector(3 downto 0);

    -- Signaux pour les drapeaux (Flags) de l'ALU
    signal s_N_flag      : std_logic;
    signal s_Z_flag      : std_logic;
    signal s_Flags_NZCV  : std_logic_vector(3 downto 0);

    -- Signaux de contrôle (générés par le Décodeur)
    signal s_nPC_sel     : std_logic;
    signal s_PSREn       : std_logic;
    signal s_RegWr       : std_logic;
    signal s_RegSel      : std_logic;
    signal s_ALUCtrl     : std_logic_vector(2 downto 0); 
    signal s_MemToReg    : std_logic;
    signal s_ALUSrc      : std_logic;
    signal s_WrSrc       : std_logic;
    signal s_MemWr       : std_logic;
    signal s_RegAff      : std_logic;

begin

    -- Extraction des champs d'adresse de l'instruction
    s_Rn <= s_instruction(19 downto 16);
    s_Rm <= s_instruction(3 downto 0);
    s_Rd <= s_instruction(15 downto 12);

    -- Regroupement des drapeaux pour le Décodeur
    s_Flags_NZCV <= s_N_flag & s_Z_flag& "00"; 

    Inst_UNIT_GEST_INSTRUCTION : entity work.UNIT_GESTION_INSTRUCTION 
        port map (
            CLK         => CLK,
            Reset       => RST,
            nPCsel      => s_nPC_sel,
            Offset      => s_instruction(23 downto 0), 
            Instruction => s_instruction
        );

    Inst_DECODEUR : entity work.DECODEUR
        port map(
            instruction => s_instruction, 
            Flags_NZCV  => s_Flags_NZCV, 
            nPC_SEL     => s_nPC_sel,
            PSREn       => s_PSREn,
            RegWr       => s_RegWr,
            RegSel      => s_RegSel,
            ALUCtrl     => s_ALUCtrl,
            MemToReg    => s_MemToReg,
            ALUSrc      => s_ALUSrc,
            WrSrc       => s_WrSrc,
            MemWr       => s_MemWr,
            RegAff      => s_RegAff
        );

    Inst_MUL_2_TO_1_REGB : entity work.MUL_2_TO_1
        generic map (
            N_bits => 4 
        )
        port map (
            COM => s_RegSel,                    
            A   => s_Rm, 
            B   => s_Rd,
            S   => s_Rb_muxed
        );

    Inst_DATA_PATH : entity work.DataPath 
        port map(
            CLK       => CLK,
            RST       => RST,
            RegWr     => s_RegWr,
            RW        => s_Rd,
            RA        => s_Rn,
            RB        => s_Rb_muxed,
            ALUCtr    => s_ALUCtrl(1 downto 0), 
            N_flag    => s_N_flag,
            Z_flag    => s_Z_flag,
            ALUSrc    => s_ALUSrc,
            MemWr     => s_MemWr,
            MemToReg  => s_MemToReg,
            ImmExtin  => s_instruction(7 downto 0) 
        );

end architecture;