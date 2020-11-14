-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 8.10.2020 02:10:21 UTC

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;


entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (clk     : in std_logic;
              reset_n : in std_logic;
              save    : in std_logic;
              SW      : in std_logic_vector (9 downto 0);
              LEDR    : out std_logic_vector (9 downto 0);
              HEX0    : out std_logic_vector (7 downto 0);
              HEX1    : out std_logic_vector (7 downto 0);
              HEX2    : out std_logic_vector (7 downto 0);
              HEX3    : out std_logic_vector (7 downto 0);
              HEX4    : out std_logic_vector (7 downto 0);
              HEX5    : out std_logic_vector (7 downto 0));
    end component;

    signal clk     : std_logic;
    signal reset_n : std_logic;
    signal KEY     : std_logic;
    signal SW      : std_logic_vector (9 downto 0);
    signal LEDR    : std_logic_vector (9 downto 0);
    signal HEX0    : std_logic_vector (7 downto 0);
    signal HEX1    : std_logic_vector (7 downto 0);
    signal HEX2    : std_logic_vector (7 downto 0);
    signal HEX3    : std_logic_vector (7 downto 0);
    signal HEX4    : std_logic_vector (7 downto 0);
    signal HEX5    : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here
    signal TbClock    : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    signal TbSwInput  : unsigned (9 downto 0);
    signal Mode       : unsigned (9 downto 0);

begin

    dut : top_level
    port map (clk     => clk,
              save    => KEY,
              reset_n => reset_n,
              SW      => SW,
              LEDR    => LEDR,
              HEX0    => HEX0,
              HEX1    => HEX1,
              HEX2    => HEX2,
              HEX3    => HEX3,
              HEX4    => HEX4,
              HEX5    => HEX5);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        SW <= (others => '0');
        TbSwInput <= (others => '0');
        Mode <= (others => '0');
        KEY <= '1';

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '1';
        wait for 100 ns;
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;
        
        -- Legacy test mode
--        stimloop2 : for j in 0 to 1 loop
--           stimloop1 : for i in 0 to 255 loop
--              SW <= DecimalFlag OR std_logic_vector(TbSwInput);
--              wait for 100 ns;
--              TbSwInput <= TbSwInput + "1";
--              wait for 100 * TbPeriod;
--           end loop stimloop1;
--           wait for 900 * TbPeriod;
--           TbSwInput <= (others => '0');
--           wait for 100 ns;
--           DecimalFlag <= "1100000000"; -- Hex conversion flag still doesn't work.
--           wait for 100 ns;
--        end loop stimloop2;

        -- Test voltage in decimal mode
        stimloop1 : for i in 0 to 255 loop
           SW <= std_logic_vector(shift_left(Mode, 8))
                 OR std_logic_vector(TbSwInput);
           wait for 100 * TbPeriod;
           TbSwInput <= TbSwInput + "1";
           -- Test freezing input.
           -- We expect only even numbers to show up on the input.
           if (TbSwInput(2) = '1') then
               KEY <= '1';
           else
               KEY <= '0';
           end if;
           wait for 100 * TbPeriod;
        end loop stimloop1;
        TbSwInput <= (others => '0');
        wait for 2000 * TbPeriod;

        -- Test distance in decimal mode
        Mode <= "0000000001";
        stimloop2 : for i in 0 to 255 loop
           SW <= std_logic_vector(shift_left(Mode, 8))
                 OR std_logic_vector(TbSwInput);
           wait for 100 * TbPeriod;
           TbSwInput <= TbSwInput + "1";
           -- Test freezing input.
           -- We expect only even numbers to show up on the input.
           if (TbSwInput(2) = '1') then
               KEY <= '1';
           else
               KEY <= '0';
           end if;
           wait for 100 * TbPeriod;
        end loop stimloop2;
        TbSwInput <= (others => '0');
        wait for 2000 * TbPeriod;

        -- Test raw ADC 256 sample moving average
        Mode <= "0000000010";
        stimloop3 : for i in 0 to 255 loop
           SW <= std_logic_vector(shift_left(Mode, 8))
                 OR std_logic_vector(TbSwInput);
           wait for 100 * TbPeriod;
           TbSwInput <= TbSwInput + "1";
           -- Test freezing input.
           -- We expect only even numbers to show up on the input.
           if (TbSwInput(2) = '1') then
               KEY <= '1';
           else
               KEY <= '0';
           end if;
           wait for 100 * TbPeriod;
        end loop stimloop3;
        TbSwInput <= (others => '0');
        wait for 2000 * TbPeriod;

        -- Test switch input
        stimloop4 : for i in 0 to 255 loop
           -- Update switch input
           SW <= std_logic_vector(shift_left(Mode, 8))
                 OR std_logic_vector(TbSwInput);
           wait for 100 * TbPeriod;
           -- Increment switch input
           TbSwInput <= TbSwInput + "1";
           -- Test freezing input.
           -- We expect only even numbers to show up on the input.
           if (TbSwInput(0) = '1') then
               KEY <= '1';
           else
               KEY <= '0';
           end if;
           wait for 100 * TbPeriod;
        end loop stimloop4;
        TbSwInput <= (others => '0');
        wait for 2000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;