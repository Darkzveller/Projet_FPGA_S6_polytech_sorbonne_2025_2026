-- SevenSeg.vhd
-- ------------------------------
--   squelette de l'encodeur sept segment
-- ------------------------------

--
-- Notes :
--  * We don't ask for an hexadecimal decoder, only 0..9
--  * outputs are active high if Pol='1'
--    else active low (Pol='0')
--  * Order is : Segout(1)=Seg_A, ... Segout(7)=Seg_G
--
--  * Display Layout :
--
--       A=Seg(1)
--      -----
--    F|     |B=Seg(2)
--     |  G  |
--      -----
--     |     |C=Seg(3)
--    E|     |
--      -----
--        D=Seg(4)


library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- ------------------------------
    Entity SEVEN_SEG is
-- ------------------------------
  port ( Data   : in  std_logic_vector(3 downto 0); -- Expected within 0 .. 9
         Pol    : in  std_logic;                    -- '0' if active LOW
         Segout : out std_logic_vector(0 to 6) );   -- Segments A, B, C, D, E, F, G
end entity SEVEN_SEG;

-- -----------------------------------------------
    Architecture COMB of SEVEN_SEG is
-- ------------------------------------------------

signal segments : std_logic_vector(0 to 6);
begin

    with Data select
        segments <= "1111110" when "0000", -- 0 (Tout sauf G)
                    "0110000" when "0001", -- 1 (B et C)
                    "1101101" when "0010", -- 2
                    "1111001" when "0011", -- 3
                    "0110011" when "0100", -- 4
                    "1011011" when "0101", -- 5
                    "1011111" when "0110", -- 6
                    "1110000" when "0111", -- 7
                    "1111111" when "1000", -- 8
                    "1111011" when "1001", -- 9
                    "0000000" when others; -- Éteint
    process(segments, Pol)
    begin
        if Pol='1' then
            Segout <= segments;
        else
            Segout <= not segments;
        end if;
    end process;

end architecture COMB;
