-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 25.10.2020 01:33:04 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_sync is
end tb_sync;

architecture tb of tb_sync is

    component sync
        port (s        : in std_logic_vector (9 downto 0);
              CLK      : in std_logic;
              sync_out : out std_logic_vector (9 downto 0);
              x        : inout std_logic_vector (9 downto 0));
    end component;

    signal s        : std_logic_vector (9 downto 0);
    signal CLK      : std_logic;
    signal sync_out : std_logic_vector (9 downto 0);
    signal x        : std_logic_vector (9 downto 0);

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : sync
    port map (s        => s,
              CLK      => CLK,
              sync_out => sync_out,
              x        => x);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        s <= (others => '0');

        wait for 100 ns;

        -- EDIT Add stimuli here
		  s<="0000010001";
		  wait for 10 * TbPeriod;
		  s<="0100110011";
		  wait for 10 * TbPeriod;
		  s<="1101110111";
		  wait for 10 * TbPeriod;
		  s<="1000001111";
		  wait for 10 * TbPeriod;
		  s<="0000000000";
		  wait for 50 * TbPeriod;

			

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_sync of tb_sync is
    for tb
    end for;
end cfg_tb_sync;