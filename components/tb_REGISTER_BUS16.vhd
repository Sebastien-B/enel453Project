-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 25.10.2020 18:44:42 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_REGISTER_BUS16 is
end tb_REGISTER_BUS16;

architecture tb of tb_REGISTER_BUS16 is

    component REGISTER_BUS16
        port (D   : in std_logic_vector (15 downto 0);
              CLK : in std_logic;
              RST : in std_logic;
              Q   : out std_logic_vector (15 downto 0));
    end component;

    signal D   : std_logic_vector (15 downto 0);
    signal CLK : std_logic;
    signal RST : std_logic;
    signal Q   : std_logic_vector (15 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : REGISTER_BUS16
    port map (D   => D,
              CLK => CLK,
              RST => RST,
              Q   => Q);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        D <= (others => '0');

        -- Reset generation
        -- EDIT: Check that RST is really your reset signal
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
		  wait for 10 * TbPeriod;
		  D<="0000000000010001";
		  wait for 2 * TbPeriod;
		  RST<='1';
		  wait for 2 * TbPeriod;
		  D<="0000000010011001";
		  wait for 2 * TbPeriod;
		  RST<='0';
		  wait for 2 * TbPeriod;
		  D<="1100110000110011";
		  wait for 2 * TbPeriod;
		  RST<='1';
		  wait for 2 * TbPeriod;
		  RST<='0';
		  wait for 10 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_REGISTER_BUS16 of tb_REGISTER_BUS16 is
    for tb
    end for;
end cfg_tb_REGISTER_BUS16;