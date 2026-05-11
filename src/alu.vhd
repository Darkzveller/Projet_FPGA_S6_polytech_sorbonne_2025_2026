library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity ALU is
    Port (
        OP : in  STD_LOGIC_VECTOR (1 downto 0); -- Commande
        A  : in  STD_LOGIC_VECTOR (31 downto 0);
        B  : in  STD_LOGIC_VECTOR (31 downto 0);
        S  : out STD_LOGIC_VECTOR (31 downto 0); -- Résultat
        N  : out STD_LOGIC;                      -- Drapeau Négatif
        Z  : out STD_LOGIC                       -- Drapeau Zéro
    );
end ALU;

architecture Behavioral of ALU is
    -- Signal intermédiaire pour faciliter le calcul des drapeaux
    signal result_internal : STD_LOGIC_VECTOR (31 downto 0);

begin

    -- Processus de calcul de l'UAL
    process(A, B, OP)
    begin
        case OP is
            when "00" => -- ADD
                result_internal <= std_logic_vector(unsigned(A) + unsigned(B));
            
            when "01" => -- B
                result_internal <= B;
            
            when "10" => -- SUB
                result_internal <= std_logic_vector(unsigned(A) - unsigned(B));
            
            when "11" => -- A
                result_internal <= A;
                
            when others =>
                result_internal <= (others => '0');
        end case;
    end process;

    -- Affectation de la sortie S
    S <= result_internal;

    -- Gestion des drapeaux
    -- N = 1 si le bit de poids fort (MSB) est à 1 (définition du complément à 2)
    N <= result_internal(31);

    -- Z = 1 si tous les bits sont à 0
    Z <= '1' when result_internal = x"00000000" else '0';

end Behavioral;