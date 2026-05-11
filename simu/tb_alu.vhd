library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu is

end tb_alu;

architecture Behavioral of tb_alu is

    -- Signaux pour relier à l'ALU
    signal OP : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal A  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal B  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal S  : STD_LOGIC_VECTOR(31 downto 0);
    signal N  : STD_LOGIC;
    signal Z  : STD_LOGIC;
    

begin

    -- Instanciation de l'ALU
    UUT: entity work.ALU
        port map (
            OP => OP,
            A  => A,
            B  => B,
            S  => S,
            N  => N,
            Z  => Z
        );

    -- Processus de simulation
    stim_proc: process
    begin
        -- 1. Test ADD (OP = "00") : 10 + 5 = 15
        OP <= "00";
        A <= std_logic_vector(to_unsigned(10, 32));
        B <= std_logic_vector(to_unsigned(5, 32));
        wait for 10 ns;
        
        -- 2. Test Passage de B (OP = "01") : S doit valoir B
        OP <= "01";
        wait for 10 ns;

        -- 3. Test SUB (OP = "10") : 10 - 5 = 5
        OP <= "10";
        wait for 10 ns;

        -- 4. Test SUB pour Drapeau Z (10 - 10 = 0)
        A <= std_logic_vector(to_unsigned(10, 32));
        B <= std_logic_vector(to_unsigned(10, 32));
        wait for 10 ns; -- Ici Z doit passer à '1'

        -- 5. Test SUB pour Drapeau N (5 - 10 = -5)
        A <= std_logic_vector(to_unsigned(5, 32));
        B <= std_logic_vector(to_unsigned(10, 32));
        wait for 10 ns; -- Ici N doit passer à '1'

        -- 6. Test Passage de A (OP = "11")
        OP <= "11";
        A <= X"ABCDEFFF";
        wait for 10 ns;

        -- Fin de la simulation
        wait;
    end process;

end Behavioral;