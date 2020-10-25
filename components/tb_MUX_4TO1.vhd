-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 24.10.2020 21:25:34 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_MUX_4TO1 is
end tb_MUX_4TO1;

architecture tb of tb_MUX_4TO1 is

    component MUX_4TO1
        port (in1     : in std_logic_vector (15 downto 0);
              in2     : in std_logic_vector (15 downto 0);
              in3     : in std_logic_vector (15 downto 0);
              in4     : in std_logic_vector (15 downto 0);
              s       : in std_logic_vector (1 downto 0);
              mux_out : out std_logic_vector (15 downto 0));
    end component;

    signal in1     : std_logic_vector (15 downto 0);
    signal in2     : std_logic_vector (15 downto 0);
    signal in3     : std_logic_vector (15 downto 0);
    signal in4     : std_logic_vector (15 downto 0);
    signal s       : std_logic_vector (1 downto 0);
    signal mux_out : std_logic_vector (15 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : MUX_4TO1
    port map (in1     => in1,
              in2     => in2,
              in3     => in3,
              in4     => in4,
              s       => s,
              mux_out => mux_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        in1 <= (others => '0');
        in2 <= (others => '0');
        in3 <= (others => '0');
        in4 <= (others => '0');
        s <= (others => '0');


        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;
		  in1<="0000000000010001";
		  wait for 100 * TbPeriod;
		  in2<="0000000000110011";
		  wait for 100 * TbPeriod;
		  in3<="0000000001110111";
		  wait for 100 * TbPeriod;
		  in4<="0000000000001111";
		  wait for 100 * TbPeriod;
		  in1<="0000000011101110";
		  wait for 100 * TbPeriod;
		  in2<="0000000011001100";
		  wait for 100 * TbPeriod;
		  in3<="0000000010001000";
		  wait for 100 * TbPeriod;
		  in4<="0000000011110000";
		  wait for 1000*TbPeriod;
		  
		  
		  s<="01";
        wait for 100 * TbPeriod;
		  in1<="0000000000010001";
		  wait for 100 * TbPeriod;
		  in2<="0000000000110011";
		  wait for 100 * TbPeriod;
		  in3<="0000000001110111";
		  wait for 100 * TbPeriod;
		  in4<="0000000000001111";
		  wait for 100 * TbPeriod;
		  in1<="0000000011101110";
		  wait for 100 * TbPeriod;
		  in2<="0000000011001100";
		  wait for 100 * TbPeriod;
		  in3<="0000000010001000";
		  wait for 100 * TbPeriod;
		  in4<="0000000011110000";
		  wait for 1000*TbPeriod;
		  
		  s<="10";
        wait for 100 * TbPeriod;
		  in1<="0000000000010001";
		  wait for 100 * TbPeriod;
		  in2<="0000000000110011";
		  wait for 100 * TbPeriod;
		  in3<="0000000001110111";
		  wait for 100 * TbPeriod;
		  in4<="0000000000001111";
		  wait for 100 * TbPeriod;
		  in1<="0000000011101110";
		  wait for 100 * TbPeriod;
		  in2<="0000000011001100";
		  wait for 100 * TbPeriod;
		  in3<="0000000010001000";
		  wait for 100 * TbPeriod;
		  in4<="0000000011110000";
		  wait for 1000*TbPeriod;
		  
		  s<="11";
        wait for 100 * TbPeriod;
		  in1<="0000000000010001";
		  wait for 100 * TbPeriod;
		  in2<="0000000000110011";
		  wait for 100 * TbPeriod;
		  in3<="0000000001110111";
		  wait for 100 * TbPeriod;
		  in4<="0000000000001111";
		  wait for 100 * TbPeriod;
		  in1<="0000000011101110";
		  wait for 100 * TbPeriod;
		  in2<="0000000011001100";
		  wait for 100 * TbPeriod;
		  in3<="0000000010001000";
		  wait for 100 * TbPeriod;
		  in4<="0000000011110000";
		  wait for 1000*TbPeriod;
		  

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_MUX_4TO1 of tb_MUX_4TO1 is
    for tb
    end for;
end cfg_tb_MUX_4TO1;