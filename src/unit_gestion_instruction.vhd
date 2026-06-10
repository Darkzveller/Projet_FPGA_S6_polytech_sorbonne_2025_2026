library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UNIT_GESTION_INSTRUCTION is
  port (
    CLK         : in std_logic;
    Reset       : in std_logic;
    nPCsel      : in std_logic;
    Offset      : in std_logic_vector(23 downto 0);
    Instruction : out std_logic_vector(31 downto 0) -- correspond a l'instruction lue

  );
end entity;

architecture RTL of UNIT_GESTION_INSTRUCTION is
  signal PC_reg           : std_logic_vector(31 downto 0) := (others => '0'); -- Sortie du registre PC
  signal PC_suivant       : std_logic_vector(31 downto 0) := (others => '0'); -- Entrée du registre PC
  signal Extension_Offset : std_logic_vector(31 downto 0) := (others => '0');
  signal PC_plus_1        : unsigned(31 downto 0)         := (others => '0');
begin

  Inst_INSTRUCTION_MEMORY : entity work.instruction_memory
    port map
    (
      PC          => PC_reg,
      Instruction => Instruction
    );
  Inst_EXT : entity work.SIGN_EXTENSION
    generic map(N_bits_E => 24)
    port map
    (
      E => Offset,
      S => Extension_Offset
    );

  process (CLK, Reset)
  begin
    if Reset = '1' then

      PC_reg <= (others => '0');

    elsif rising_edge(CLK) then
      PC_reg <= PC_suivant;
    end if;
  end process;

-- process (nPCsel, PC_plus_1, Extension_Offset)  begin
--     if nPCsel = '0' then
--       -- Si nPCsel = '0' alors PC = PC +1
--       PC_suivant <= std_logic_vector(PC_plus_1);
--     else
--       -- Si nPCsel = '1' alors PC = PC + 1 + Offset
--       -- PC_suivant <= std_logic_vector(PC_plus_1 + unsigned(Extension_Offset));
    
--     PC_suivant <= std_logic_vector(signed(PC_plus_1) + signed(Extension_Offset));
--   end if;
--   end process;
process (nPCsel, PC_plus_1, Extension_Offset)  
  variable PC_saut : signed(31 downto 0);
begin
  if nPCsel = '0' then
    PC_suivant <= std_logic_vector(PC_plus_1);
  else
    -- Calcul intermédiaire signé
    PC_saut := signed(PC_plus_1) + signed(Extension_Offset);
    
    -- Sécurité anti-crash : on s'assure que le PC ne devienne jamais négatif
    if PC_saut < 0 then
      PC_suivant <= (others => '0');
    else
      PC_suivant <= std_logic_vector(PC_saut);
    end if;
  end if;
end process;  PC_plus_1 <= unsigned(PC_reg) + 1;
end architecture;