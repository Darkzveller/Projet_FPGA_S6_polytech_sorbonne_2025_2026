library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DECODEUR is
  port (
    instruction : in std_logic_vector(31 downto 0); 
    Flags_NZCV  : in std_logic_vector(3 downto 0); 
    nPC_SEL  : out std_logic;
    PSREn    : out std_logic;
    RegWr    : out std_logic;
    RegSel   : out std_logic;
    ALUCtrl  : out std_logic_vector(2 downto 0);
    MemToReg : out std_logic;
    ALUSrc   : out std_logic;
    WrSrc    : out std_logic;
    MemWr    : out std_logic;
    RegAff   : out std_logic
  );
end entity;

architecture RTL of DECODEUR is
  type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT);
  signal instr_courante : enum_instruction;
  -- Signaux internes pour faciliter le décodage (champs de l'instruction de type ARM)
  signal cond   : std_logic_vector(3 downto 0);
  signal opcode : std_logic_vector(3 downto 0);
  signal bit_I  : std_logic;
  -- Extraction du Flag N (Généralement bit 3 des flags NZCV) pour la condition Less Than (LT)
  signal flag_N : std_logic;

begin

  -- Découpage de l'instruction selon le format ARM standard
  cond   <= instruction(31 downto 28);
  bit_I  <= instruction(25);
  opcode <= instruction(24 downto 21);

  flag_N <= Flags_NZCV(3);

  ---------------------------------------------------------------------------
  -- Processus 1 : Fixer la valeur du signal instr_courante
  ---------------------------------------------------------------------------
  process (instruction)
  begin

    if cond = "1110" then -- Condition "AL" (Always - Exécution inconditionnelle)
      case opcode is
        when "1101" =>
          instr_courante <= MOV;
        when "0100" =>
          if bit_I = '1' then
            instr_courante <= ADDi; -- ADD avec immédiat
          else
            instr_courante <= ADDr; -- ADD avec registre
          end if;
        when "1010" =>
          instr_courante <= CMP;
        when others =>
          null;
      end case;

      -- Cas des accès mémoires (les opcodes dépendent de la structure de l'instruction)
    elsif instruction(27 downto 26) = "01" then
      if instruction(20) = '1' then
        instr_courante <= LDR;
      else
        instr_courante <= STR;
      end if;

      -- Cas des sauts conditionnels et inconditionnels (Branchements)
    elsif instruction(27 downto 25) = "101" then
      if cond = "1110" then
        instr_courante <= BAL; -- Branch Always
      elsif cond = "1011" then
        instr_courante <= BLT; -- Branch Less Than
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- Processus 2 : Donner la valeur des commandes des registres et opérateurs
  ---------------------------------------------------------------------------
  process (instruction flag_N)
  begin

    case instr_courante is
      when MOV =>
        RegWr   <= '1'; -- On écrit le résultat dans le banc de registres
        ALUSrc  <= '1'; -- On choisit l'immédiat étendu via le multiplexeur ALUSrc
        ALUCtrl <= "011"; -- Code OP de l'ALU pour effectuer un "pass-through" (copie)

      when ADDi =>
        RegWr   <= '1'; -- On écrit dans le registre Rd
        ALUSrc  <= '1'; -- Entrée B de l'ALU = Immédiat étendu
        ALUCtrl <= "000"; -- Code OP de l'ALU pour l'addition

      when ADDr =>
        RegWr   <= '1'; -- On écrit dans le registre Rd
        ALUSrc  <= '0'; -- Entrée B de l'ALU = Bus B (registre Rm)
        ALUCtrl <= "000"; -- Code OP de l'ALU pour l'addition

      when CMP =>
        PSREn   <= '1'; -- On met à jour le registre d'état PSR avec les flags de l'ALU
        ALUSrc  <= '0'; -- Entrée B de l'ALU = Bus B
        ALUCtrl <= "001"; -- Code OP de l'ALU pour la soustraction (A - B) sans écriture

      when LDR =>
        RegWr    <= '1'; -- On charge la donnée dans le registre Rd
        RegSel   <= '0'; -- Sélection de l'adresse du registre
        ALUSrc   <= '1'; -- Calcul d'adresse de base + offset immédiat
        ALUCtrl  <= "000";
        WrSrc    <= '1'; -- Le multiplexeur en sortie choisit la Data Memory
        MemToReg <= '1'; -- Oriente le bus de données vers le banc

      when STR =>
        MemWr   <= '1'; -- Activation du Write Enable de la Data Memory
        RegSel  <= '1'; -- Commande RegSel pour router l'adresse de Rd vers le port d'adresse de lecture du banc
        ALUSrc  <= '1'; -- Calcul d'adresse
        ALUCtrl <= "000";
        RegAff  <= '1'; -- Signal d'affichage demandé par le sujet en cas de STR !

      when BAL =>
        nPC_SEL <= '1'; -- Le multiplexeur du PC choisit la branche du saut (PC + 1 + Offset)

      when BLT =>
        if flag_N = '1' then
          nPC_SEL <= '1'; -- Saut validé si le flag négatif est actif (Résultat CMP < 0)
        else
          nPC_SEL <= '0'; -- Sinon, reste en mode linéaire (PC + 1)
        end if;

    end case;
  end process;
end architecture;