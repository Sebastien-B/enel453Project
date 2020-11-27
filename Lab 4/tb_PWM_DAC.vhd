library ieee;
use ieee.std_logic_1164.all;

entity tb_PWM_DAC is
end tb_PWM_DAC;

architecture tb of tb_PWM_DAC is

    component PWM_DAC
       Generic ( width : integer := 9);
       Port    ( reset_n    : in  STD_LOGIC;
                 clk        : in  STD_LOGIC;
                 duty_cycle : in  STD_LOGIC_VECTOR (width-1 downto 0);
                 pwm_out    : out STD_LOGIC
               );
    end component;

    signal clk              : std_logic;
    signal reset_n          : std_logic;
    signal duty_cycle       : std_logic_vector (8 downto 0);
    signal pwm_out          : std_logic;
    signal enable         : std_logic;

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : PWM_DAC
    port map ( clk              => clk,
               reset_n          => reset_n,
               duty_cycle       => duty_cycle,
               pwm_out          => pwm_out
             );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;
    stimuli : process
    begin
      -- Reset generation
      -- EDIT: Check that reset_n is really your reset signal
      reset_n <= '0';
      wait for 100 ns;
      reset_n <= '1';
      wait for 100 ns;
      
      duty_cycle <= "100000000";
      
      -- EDIT Add stimuli here
      wait for 100 * TbPeriod;
      wait for 500 * 980 ns;
      
      -- Stop the clock and hence terminate the simulation
      TbSimEnded <= '1';
      assert false report "Simulation ended" severity failure; -- need this line to halt the testbench 
    end process;
end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_PWM_DAC of tb_PWM_DAC is
    for tb
    end for;
end cfg_tb_PWM_DAC;