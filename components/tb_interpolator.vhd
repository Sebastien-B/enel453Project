library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity tb_interpolator is
end tb_interpolator;

architecture tb of tb_interpolator is
   component interpolator is
      generic ( in_width  : integer;
                out_width : integer;
                m         : integer;
                b         : integer
              );
      port (
             x : in  std_logic_vector (in_width - 1 downto 0);
             y : out std_logic_vector (out_width - 1 downto 0)
           );
   end component;

   constant TbPeriod : time := 20 ns;
   constant in_width : integer := 8;
   constant out_width : integer := 10;
   signal x   : std_logic_vector (in_width - 1 downto 0);-- := (others => '0');
   signal y_0 : std_logic_vector (out_width - 1 downto 0);
   signal y_1 : std_logic_vector (out_width - 1 downto 0);
   signal y_2 : std_logic_vector (out_width - 1 downto 0);
   signal y_3 : std_logic_vector (out_width - 1 downto 0);
   signal TbClock : std_logic := '0';
   signal TbSimEnded : std_logic := '0';
   signal reset_n : std_logic := '1';

begin

   dut_0 : interpolator
      generic map ( m => 2,
                    b => 1,
                    in_width => in_width,
                    out_width => out_width
                  )
      port map ( x => x,
                 y => y_0 );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin
      -- Reset generation
      -- EDIT: Check that reset_n is really your reset signal
      reset_n <= '0';
      wait for 100 ns;
      reset_n <= '1';
      wait for 100 ns;

      -- EDIT Add stimuli here

      x <= (others => '0');
      wait for 1000 * TbPeriod;
      -- x = 0x0000_0000
      -- y_1 = y_2 = 1, y_3 = y_4 = -1 = 0xFF_FFFF_FFFF
      
      x <= (0 => '1', others => '0');
      wait for 1000 * TbPeriod;
      -- x = 0x0000_0001
      -- y_1 = 5, y_2 = -3, y_3 = 3, y_4 = -5
      
      x <= (others => '1');
      wait for 1000 * TbPeriod;
      -- x = 0xFFFF_FFFF
      -- y_1 = 0x01_FFFF_FFFF, y_2 = 0xFE_0000_0003
      -- y_3 = 0x01_FFFF_FFFD, y_4 = 0xFE_0000_0001

      -- Stop the clock and hence terminate the simulation
      TbSimEnded <= '1';
      assert false report "Simulation ended" severity failure; -- need this line to halt the testbench 
    end process;
end tb;