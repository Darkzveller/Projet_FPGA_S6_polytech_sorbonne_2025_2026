library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BANC_REGISTRE is
    Port (
        Clk   : in  STD_LOGIC;
        Reset : in  STD_LOGIC;
        W     : in  STD_LOGIC_VECTOR (31 downto 0); -- Données à écrire
        RA    : in  STD_LOGIC_VECTOR (3 downto 0);  -- Adresse lecture Port A
        RB    : in  STD_LOGIC_VECTOR (3 downto 0);  -- Adresse lecture Port B
        RW    : in  STD_LOGIC_VECTOR (3 downto 0);  -- Adresse écriture
        WE    : in  STD_LOGIC;                      -- Write Enable
        A     : out STD_LOGIC_VECTOR (31 downto 0); -- Sortie Port A
        B     : out STD_LOGIC_VECTOR (31 downto 0)  -- Sortie Port B
    );
end BANC_REGISTRE;

architecture Behavioral of BANC_REGISTRE is

    -- Déclaration du type Tableau Mémoire (16 registres de 32 bits)
    type table is array(15 downto 0) of std_logic_vector(31 downto 0);

    -- Fonction d'initialisation fournie dans l'énoncé
    function init_banc return table is
        variable result : table;
    begin
        for i in 14 downto 0 loop
            result(i) := (others => '0');
        end loop;
        result(15) := X"00000030"; 
        return result;
    end init_banc;

    -- Déclaration et Initialisation du Banc de Registres
    signal Banc : table := init_banc;

begin

    -- Lecture asynchrone
    -- Les sorties A et B répondent immédiatement aux changements de RA et RB
    A <= Banc(to_integer(unsigned(RA)));
    B <= Banc(to_integer(unsigned(RB)));

    -- Ecriture synchrone
    -- S'effectue sur front montant de l'horloge si WE = 1
    process(Clk, Reset)
    begin
        if Reset = '1' then
            -- On réinitialise le banc
            Banc <= init_banc;
        elsif rising_edge(Clk) then
            if WE = '1' then
                Banc(to_integer(unsigned(RW))) <= W;
            end if;
        end if;
    end process;

end Behavioral;