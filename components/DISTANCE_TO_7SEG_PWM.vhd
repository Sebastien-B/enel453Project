LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.SEVEN_SEG_PWM_LUT.all; -- note that this package stores the look up table, to make this code cleaner

ENTITY distance_to_7seg_pwm IS
   PORT(
      clk            :  IN    STD_LOGIC;
      reset_n        :  IN    STD_LOGIC;
      voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);
      distance       :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);
      pwm            :  OUT   STD_LOGIC
       );
END distance_to_7seg_pwm;

ARCHITECTURE behavior OF distance_to_7seg_pwm IS

   constant width : integer := 9;
   constant duty_cycle : STD_LOGIC_VECTOR (width-1 downto 0) := std_logic_vector(to_unsigned(256, width));
   constant max_distance : integer := 4000; -- 10^-4 m or mm/10
   signal zero : std_logic;
   signal period : natural;
   signal downcounter_enable : std_logic;
   signal pwm_intermediate : std_logic;
   
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
   
   component downcounter is
    PORT    ( clk     : in  STD_LOGIC; -- clock to be divided
              reset_n : in  STD_LOGIC; -- active-high reset
              enable  : in  STD_LOGIC; -- active-high enable
              zero    : out STD_LOGIC; -- creates a positive pulse every time current_count hits zero
                                       -- useful to enable another device, like to slow down a counter
              period  : in natural -- number to count
              -- value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0) -- outputs the current_count value, if needed
         );
    end component;
    
begin

   period <= V2SEVEN_SEG_PERIOD_LUT(to_integer(unsigned(voltage)));

   downcounter_ins : downcounter
      port map ( reset_n => reset_n,
                 clk => clk,
                 enable => downcounter_enable,
                 zero => zero,
                 period => period
               );
   
   PWM_ins : PWM_DAC
      generic map ( width => width
                  )
      port map ( reset_n => reset_n,
                 clk => clk,
                 duty_cycle => duty_cycle,
                 pwm_out => pwm_intermediate,
                 enable => zero
               );
   
   stopAtMaxDistance : process (pwm_intermediate, distance)
   begin
      if (unsigned(distance) > max_distance) then
         downcounter_enable <= '0';
         pwm <= '1';
      else
         downcounter_enable <= '1';
         pwm <= pwm_intermediate;
      end if;
   end process;

end behavior;
