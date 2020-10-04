-- I used an online VHDL testbench tool to create the testbench and then
-- edited it. The below 3 lines are from the testbench tool.

-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 14.9.2020 18:22:35 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_some_logic is
end tb_some_logic;

architecture tb of tb_some_logic is

    component some_logic
        port (in0     : in  std_logic;
              in1     : in  std_logic;
              output0 : out std_logic;
              output1 : out std_logic;
              clk     : in  std_logic;
              reset   : in  std_logic
				  );
    end component;

    signal in0     : std_logic;
    signal in1     : std_logic;
    signal output0 : std_logic;
    signal output1 : std_logic;
    signal clk     : std_logic;
    signal reset   : std_logic;

    constant TbPeriod : time      := 20 ns; -- EDIT Put right period here (Denis: 1/50 MHz = 20 ns)
    signal TbClock    : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    ut : some_logic
    port map (in0     => in0,
              in1     => in1,
              output0 => output0,
              output1 => output1,
              clk     => clk,
              reset   => reset
				  );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal (Denis: yes!)
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        in0 <= '0';
        in1 <= '0';

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal (Denis: yes!)
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here (Denis: I added this stimulation part below)
		  -- let's do a truth table like set of inputs
        wait for 100 * TbPeriod;
		  in0 <= '0'; in1 <= '0';
        wait for 100 * TbPeriod;
		  in0 <= '0'; in1 <= '1';
		  wait for 100 * TbPeriod;
		  in0 <= '1'; in1 <= '0';
        wait for 100 * TbPeriod;
		  in0 <= '1'; in1 <= '1';
        wait for 100 * TbPeriod;		  
		  
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.
--(Denis: below not needed)
--configuration cfg_tb_some_logic of tb_some_logic is
--    for tb
--    end for;
--end cfg_tb_some_logic;