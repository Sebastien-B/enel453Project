
-- In this example, we're going to map distance to LED PWM.
-- 
-- The relevant points we will select are:
-- At 3.22 cm, the duty cycle is 511/511 - the LEDs are fully on.
-- At 40.0 cm, the duty cycle is 0/511 - the LEDs are fully off.
-- 
-- Developing a piecewise linear equation, we find:
--
--              |  511                           : x <= 3.22cm
-- duty_cycle = { -0.138934203 * x + 555.7368135 : 3.22cm < x < 40cm
--              |  0                             : x >= 40cm
--
-- So that it is linearized with respect to distance, we apply it
-- to the voltage LUT determined in Lab 3.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.LED_PWM_LUT.all; -- note that this package stores the look up table, to make this code cleaner

ENTITY distance_to_led_pwm IS
   PORT(
      clk            :  IN    STD_LOGIC;
      reset_n        :  IN    STD_LOGIC;
      voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);
      pwm            :  OUT   STD_LOGIC
       );
END distance_to_led_pwm;

ARCHITECTURE behavior OF distance_to_led_pwm IS

   constant width : integer := 9;
   signal duty_cycle : STD_LOGIC_VECTOR (width-1 downto 0);
   
   component PWM_DAC
      generic ( width : integer := 9
              );
      port    ( reset_n    : in  STD_LOGIC;
                clk        : in  STD_LOGIC;
                duty_cycle : in  STD_LOGIC_VECTOR (width-1 downto 0);
                enable     : in  STD_LOGIC;
                pwm_out    : out STD_LOGIC
              );
   end component;

begin
   -- This statement looks up the converted value of 
	-- the voltage input (in mV) in the V2LED_PWM_LUT look-up table in the package, 
	-- which converts from voltage to distance and from distance to duty cycle.
   
   duty_cycle <= std_logic_vector(to_unsigned(V2LED_PWM_LUT(to_integer(unsigned(voltage))),duty_cycle'length));

   PWM_ins : PWM_DAC
      generic map ( width => width
                  )
      port map ( reset_n => reset_n,
                 clk => clk,
                 duty_cycle => duty_cycle,
                 pwm_out => pwm,
                 enable => '1'
               );

end behavior;
