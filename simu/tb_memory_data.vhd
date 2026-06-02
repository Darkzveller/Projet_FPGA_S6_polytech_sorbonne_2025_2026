library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_DATA_MEMORY is
end TB_DATA_MEMORY;

architecture Behavioral of TB_DATA_MEMORY is

    signal CLK     : STD_LOGIC := '0';
    signal Reset   : STD_LOGIC := '0';
    signal WrEn    : STD_LOGIC := '0';

    signal Addr    : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal DataIn  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal DataOut : STD_LOGIC_VECTOR(31 downto 0);

    constant T : time := 10 ns;

begin

    -- DUT
    DUT : entity work.DATA_MEMORY
        port map(
            CLK     => CLK,
            Reset   => Reset,
            WrEn    => WrEn,
            Addr    => Addr,
            DataIn  => DataIn,
            DataOut => DataOut
        );

    -- Clock
    process
    begin
        while true loop
            CLK <= '0';
            wait for T/2;
            CLK <= '1';
            wait for T/2;
        end loop;
    end process;

    -- Stimulus
    process
    begin

        --------------------------------------------------
        -- RESET
        --------------------------------------------------
        Reset <= '1';
        wait for T;
        Reset <= '0';

        --------------------------------------------------
        -- WRITE adresse 0
        --------------------------------------------------
        Addr   <= "000000";
        DataIn <= x"AAAAAAAA";
        WrEn   <= '1';
        wait for T;

        WrEn <= '0';
        wait for T;

        --------------------------------------------------
        -- WRITE adresse 10
        --------------------------------------------------
        Addr   <= "001010";
        DataIn <= x"12345678";
        WrEn   <= '1';
        wait for T;

        WrEn <= '0';
        wait for T;

        --------------------------------------------------
        -- FIN
        --------------------------------------------------
        wait;

    end process;

end Behavioral;