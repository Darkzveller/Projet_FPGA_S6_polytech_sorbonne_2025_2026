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
        Z_flag  : OUT STD_LOGIC
    );
end DataPath;

architecture Structural of DataPath is

    -- Signaux internes (les noms des fils du schémas)
    signal BusA : STD_LOGIC_VECTOR(31 downto 0);
    signal BusB : STD_LOGIC_VECTOR(31 downto 0);
    signal BusW : STD_LOGIC_VECTOR(31 downto 0);


begin

    --Instanciation du Banc de Registres
    Inst_BANC_REG: entity work.BANC_REGISTRE port map (
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
    Inst_ALU: entity work.ALU port map (
        OP => ALUCtr,
        A  => BusA,
        B  => BusB,
        S  => BusW,   
        N  => N_flag,
        Z  => Z_flag
    );

end architecture;