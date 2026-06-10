library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DECODEUR is
  port (
    instruction : in std_logic_vector(31 downto 0); 
    Flags_NZCV  : in std_logic_vector(3 downto 0); 
    nPC_SEL     : out std_logic;
    PSREn       : out std_logic;
    RegWr       : out std_logic;
    RegSel      : out std_logic;
    ALUCtrl     : out std_logic_vector(2 downto 0);
    MemToReg    : out std_logic;
    ALUSrc      : out std_logic;
    WrSrc       : out std_logic;
    MemWr       : out std_logic;
    RegAff      : out std_logic
  );
end entity;

architecture RTL of DECODEUR is
  type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT, UNKNOWN);
  signal instr_courante : enum_instruction;
  
  signal cond   : std_logic_vector(3 downto 0);
  signal opcode : std_logic_vector(3 downto 0);
  signal bit_I  : std_logic;
  signal flag_N : std_logic;

begin

  cond   <= instruction(31 downto 28);
  bit_I  <= instruction(25);
  opcode <= instruction(24 downto 21);
  flag_N <= Flags_NZCV(3); -- Le bit N (Negative) est bien le bit 3

  ---------------------------------------------------------------------------
  -- Processus 1 : Identification de l'instruction courante
  ---------------------------------------------------------------------------
  process (instruction, cond, opcode, bit_I)
  begin
    -- Valeur par défaut pour éviter les blocages du simulateur
    instr_courante <= UNKNOWN; 

    -- Cas des sauts (Branchements) : prioritaires sur la condition "AL" générale
    if instruction(27 downto 25) = "101" then
      if cond = "1110" then
        instr_courante <= BAL; 
      elsif cond = "1011" then
        instr_courante <= BLT; 
      end if;

    -- Cas des accès mémoires LDR / STR
    elsif instruction(27 downto 26) = "01" then
      if instruction(20) = '1' then
        instr_courante <= LDR;
      else
        instr_courante <= STR;
      end if;

    -- Cas des instructions de traitement de données (Condition AL = "1110")
    elsif cond = "1110" then 
      case opcode is
        when "1101" => instr_courante <= MOV;
        when "1010" => instr_courante <= CMP;
        when "0100" =>
          if bit_I = '1' then
            instr_courante <= ADDi; 
          else
            instr_courante <= ADDr; 
          end if;
        when others => instr_courante <= UNKNOWN;
      end case;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- Processus 2 : Génération des signaux de contrôle (SÉCURISÉ)
  ---------------------------------------------------------------------------
  process (instr_courante, flag_N)
  begin
    -- CORRECTION : Initialisation systématique de TOUTES les sorties à '0'
    -- pour éviter la création de Latchs (mémoires parasites).
    nPC_SEL  <= '0';
    PSREn    <= '0';
    RegWr    <= '0';
    RegSel   <= '0';
    ALUCtrl  <= "000";
    MemToReg <= '0';
    ALUSrc   <= '0';
    WrSrc    <= '0';
    MemWr    <= '0';
    RegAff   <= '0';

    case instr_courante is
      when MOV =>
        RegWr   <= '1'; 
        ALUSrc  <= '1'; -- Sélectionne l'immédiat étendu
        ALUCtrl <= "001"; -- CORRECTION : "01" sur les bits faibles = Passage de B (l'immédiat)

      when ADDi =>
        RegWr   <= '1'; 
        ALUSrc  <= '1'; -- Entrée B de l'ALU = Immédiat
        ALUCtrl <= "000"; -- "00" = Addition

      when ADDr =>
        RegWr   <= '1'; 
        ALUSrc  <= '0'; -- Entrée B de l'ALU = Registre Rm
        ALUCtrl <= "000"; -- "00" = Addition

      when CMP =>
        PSREn   <= '1'; -- On autorise la mise à jour des drapeaux (PSR)
        ALUSrc  <= '0'; -- Entrée B de l'ALU = Registre Rm
        ALUCtrl <= "010"; -- CORRECTION : "10" sur les bits faibles = Soustraction (A - B)

      when LDR =>
        RegWr    <= '1'; 
        RegSel   <= '0'; 
        ALUSrc   <= '1'; -- Calcul d'adresse : Base + Offset immédiat
        ALUCtrl  <= "000"; -- L'adresse est calculée par une Addition
        WrSrc    <= '1'; 
        MemToReg <= '1'; 

      when STR =>
        MemWr   <= '1'; -- Écriture active dans la mémoire
        RegSel  <= '1'; -- Rd devient la source lue sur le port RB du banc
        ALUSrc  <= '1'; -- Calcul d'adresse via Immédiat
        ALUCtrl <= "000"; -- Addition
        RegAff  <= '1'; 

      when BAL =>
        nPC_SEL <= '1'; -- Saut inconditionnel forcé

      when BLT =>
        if flag_N = '1' then
          nPC_SEL <= '1'; -- Saut si le résultat précédent était négatif
        else
          nPC_SEL <= '0';
        end if;

      when others =>
        null; -- Reste aux valeurs par défaut sécurisées
    end case;
  end process;

end architecture;