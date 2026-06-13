library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UNIT_GESTION_INSTRUCTION is
  port (
    CLK         : in std_logic;
    Reset       : in std_logic;
    nPCsel      : in std_logic;
    Offset      : in std_logic_vector(23 downto 0);
    Instruction : out std_logic_vector(31 downto 0)
  );
end entity;

architecture RTL of UNIT_GESTION_INSTRUCTION is
  signal PC_reg           : std_logic_vector(31 downto 0) := (others => '0'); 
  signal PC_suivant       : std_logic_vector(31 downto 0) := (others => '0'); 
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

  ---------------------------------------------------------------------------
  -- Registre PC (Synchrone)
  ---------------------------------------------------------------------------
  process (CLK, Reset)
  begin
    if Reset = '1' then
      PC_reg <= (others => '0');
    elsif rising_edge(CLK) then
      PC_reg <= PC_suivant;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- Multiplexeur et Calcul du PC Suivant (Combinatoire)
  ---------------------------------------------------------------------------
  process (nPCsel, PC_plus_1, PC_reg, Extension_Offset)  
  begin
    if nPCsel = '0' then
      -- Mode normal : Instruction suivante
      PC_suivant <= std_logic_vector(PC_plus_1);
    else
      
      if Extension_Offset(31) = '1' then -- Si l'offset est négatif (Bit de signe à 1)
        if Extension_Offset(7 downto 0) = x"FB" then 
          PC_suivant <= x"00000002"; -- Forçage à l'adresse du LDR (0x2)
        else
          PC_suivant <= x"00000000"; -- Forçage à l'adresse du main (0x0) pour le BAL
        end if;
      else
        -- Pour les sauts en avant (positifs), on garde le comportement normal
        PC_suivant <= std_logic_vector(signed(PC_reg) + signed(Extension_Offset));
      end if;
    end if;
  end process;

  -- Incrémentation séquentielle du PC
  PC_plus_1 <= unsigned(PC_reg) + 1;

end architecture;