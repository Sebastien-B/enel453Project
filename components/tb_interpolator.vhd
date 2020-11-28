library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity tb_interpolator is
end tb_interpolator;

architecture tb of tb_interpolator is
   component interpolator is
      generic ( m : signed (8 downto 0);-- := 1;
                b : signed (17 downto 0)--;-- := 0;
--                in_len : integer := 8;
--                out_len : integer := 10
              );
      port ( x : in std_logic_vector (7 downto 0);--(in_len - 1 downto 0);
             y : out std_logic_vector (17 downto 0)--(out_len - 1 downto 0)
           );
   end component;

   constant TbPeriod : time := 20 ns; -- EDIT Put right period here
   --constant in_len : integer := 8;
   --constant out_len : integer := 10;
   signal x : std_logic_vector (7 downto 0);-- := (others => '0');
   signal y_0 : std_logic_vector (17 downto 0);
   signal y_1 : std_logic_vector (9 downto 0);
   signal y_2 : std_logic_vector (9 downto 0);
   signal y_3 : std_logic_vector (9 downto 0);
   signal TbClock : std_logic := '0';
   signal TbSimEnded : std_logic := '0';
   signal reset_n : std_logic := '1';

begin

   dut_0 : interpolator
      generic map ( m => to_signed(2, 9),
                    b => to_signed(1, 18)--,
                    --in_len => in_len,
                    --out_len => out_len
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