library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataPath is
    Port (
        CLK     : IN  STD_LOGIC;
        RST     : IN  STD_LOGIC;
        RegWr   : IN  STD_LOGIC;                     -- WE du banc
        RW      : IN  STD_LOGIC_VECTOR (3 downto 0);
        RA      : IN  STD_LOGIC_VECTOR (3 downto 0);
        RB      : IN  STD_LOGIC_VECTOR (3 downto 0);
        ALUCtr  : IN  STD_LOGIC_VECTOR (1 downto 0); -- OP de l'ALU
        N_flag  : OUT STD_LOGIC;
        Z_flag  : OUT STD_LOGIC;


        ALUSrc  : IN  STD_LOGIC;        -- Commande du Mux ALU
        MemWr   : IN  STD_LOGIC;        -- Write Enable Mémoire
        MemToReg: IN  STD_LOGIC;        -- Commande du Mux sortie
        ImmExtin : IN STD_LOGIC_VECTOR(7 downto 0);
        RegAff_en : IN STD_LOGIC;
        RegAff_out : OUT STD_LOGIC_VECTOR(31 downto 0)
    );
end DataPath;

architecture Structural of DataPath is

    -- Signaux internes (les noms des fils du schÃ©mas)
    signal BusA : STD_LOGIC_VECTOR(31 downto 0) := (others =>'0');
    signal BusB : STD_LOGIC_VECTOR(31 downto 0) := (others =>'0');
    signal BusW : STD_LOGIC_VECTOR(31 downto 0) := (others =>'0');

    signal ALUout : STD_LOGIC_VECTOR(31 downto 0):= (others =>'0');
    signal BusMem : STD_LOGIC_VECTOR(31 downto 0):= (others =>'0');

    signal ImmExtout : STD_LOGIC_VECTOR(31 downto 0):= (others =>'0');
    signal ImmExt_Mux_out : STD_LOGIC_VECTOR(31 downto 0):= (others =>'0');

    signal DataOut : STD_LOGIC_VECTOR(31 downto 0):= (others =>'0');
    signal RegAff_reg : STD_LOGIC_VECTOR(31 downto 0) := (others =>'0');

begin

    --Instanciation du Banc de Registres
    Inst_BANC_REG: entity work.BANC_REGISTRE 
    port map (
        Clk   => CLK,
        Reset => RST,
        WE    => RegWr,
        W     => BusW,  
        RA    => RA,
        RB    => RB,
        RW    => RW,
        A     => BusA,
        B     => BusB
    );

    --Instanciation de l'ALU
    Inst_ALU: entity work.ALU 
    port map (
        OP => ALUCtr,
        A  => BusA,
        B  => ImmExt_Mux_out,
        S  => ALUout,   
        N  => N_flag,
        Z  => Z_flag
    );

    -- Instanciation du Multiplexeur
    Inst_MUL_2_TO_1_1 : entity work.MUL_2_TO_1
    port map (
        COM => MemToReg,                    
        A  => ALUout, 
        B  => DataOut,
        S  =>BusW 
        );
    -- Instanciation du Multiplexeur
    Inst_MUL_2_TO_1_2 : entity work.MUL_2_TO_1
    port map (
        COM => ALUSrc,                    
        A  => BusB, 
        B  => ImmExtout,
        S  =>ImmExt_Mux_out 
        );
    
    Inst_MEM: entity work.DATA_MEMORY
    port map (
        CLK   => CLK,
        Reset => RST,
        WrEn  => MemWr,

        Addr    => ALUout(5 downto 0),
        DataIn  => BusB,
        DataOut => DataOut
        );

    Inst_EXT: entity work.SIGN_EXTENSION
    generic map (N_bits_E => 8)
    port map(
        E  => ImmExtin,
        S  => ImmExtout
    );

    process(CLK, RST)
    begin
        if RST = '1' then
            RegAff_reg <= (others => '0');
        elsif rising_edge(CLK) then
            if RegAff_en = '1' then
                RegAff_reg <= BusB;
            end if;
        end if;
    end process;

    RegAff_out <= RegAff_reg;

end architecture;