-- BCD_COUNTER.vhd
-- ---------------------------------------
--   Squelette du compteur BCD
-- ---------------------------------------
--
-- Compter de 0000 � 9999 et repartir de 0000
-- Le comptage doit se faire a chaque N ms, 
-- pour cela, on utilise le signal TICK1MS


library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;


---------------------------------------
entity BCD_COUNTER is
---------------------------------------
generic ( N  : positive := 8 );  -- facteur de division de Tick1ms
  port ( CLK        : in  std_logic;
         RST        : in  std_logic;
         TICK1MS    : in  std_logic;
         UNITIES    : out std_logic_vector(3 downto 0);
         TENS       : out std_logic_vector(3 downto 0);
         HUNDREDS   : out std_logic_vector(3 downto 0);
         THOUSNDS   : out std_logic_vector(3 downto 0));
end entity BCD_COUNTER;


---------------------------------------
architecture RTL of BCD_COUNTER is
---------------------------------------

-- On d�clare les signaux internes ici
signal count : unsigned(13 downto 0);
signal nbr_tick : unsigned(13 downto 0);
signal convert_unsigned_to_integer_calcul : integer;
begin

-- Vous pouvez faire les assignements concurrents ici
-- mod 10 -> donne un integer
-- std_logic_vector(  ) attend un vector, pas un entier
-- Donc on effectue la conversion
UNITIES  <= std_logic_vector(to_unsigned(convert_unsigned_to_integer_calcul mod 10, 4));
TENS     <= std_logic_vector(to_unsigned((convert_unsigned_to_integer_calcul / 10) mod 10, 4));
HUNDREDS <= std_logic_vector(to_unsigned((convert_unsigned_to_integer_calcul / 100) mod 10, 4));
THOUSNDS <= std_logic_vector(to_unsigned((convert_unsigned_to_integer_calcul / 1000) mod 10, 4));

process(RST,CLK)

begin
  if RST = '1' then

    -- initialiser tout vos signaux ici
    count <= (others => '0');
    nbr_tick <= (others => '0');

    elsif rising_edge(CLK) then

    -- Faites toutes vos actions synchrones ici
    if TICK1MS = '1' then 

      if nbr_tick = to_unsigned(N,13) then
        if count >= to_unsigned(9999, 14)  then
          count <= (others => '0');
        else 
          count <= count +1;
          -- Transformation binaire to integer
          convert_unsigned_to_integer_calcul <=to_integer(count);

        end if;

      else 
        nbr_tick <= nbr_tick + 1;
      end if;
    end if;
  
  end if;
end process;

end architecture RTL;

