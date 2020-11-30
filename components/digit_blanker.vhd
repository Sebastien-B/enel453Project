library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digit_blanker is
    port (clk            :  IN    STD_LOGIC;
          reset_n        :  IN    STD_LOGIC;
          NUM_HEX0, NUM_HEX1, NUM_HEX2, NUM_HEX3, NUM_HEX4, NUM_HEX5: in std_logic_vector(3 downto 0);
          DP:     in std_logic_vector(5 downto 0);
          enable: in std_logic_vector(1 downto 0);
          voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);
          distance       :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);
          blank:  out std_logic_vector(5 downto 0)
         );
end digit_blanker;

architecture BEHAV of digit_blanker is

   component distance_to_7seg_pwm IS
      PORT( clk            :  IN    STD_LOGIC;
            reset_n        :  IN    STD_LOGIC;
            voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);
            distance       :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);
            pwm            :  OUT   STD_LOGIC
           );
   end component;
   
   signal pwm : std_logic;
   signal blank_intermediate : std_logic_vector (5 downto 0);

begin

    distance_to_7seg_pwm_ins : distance_to_7seg_pwm
       port map ( clk      => clk,
                  reset_n  => reset_n,
                  voltage  => voltage,
                  distance => distance,
                  pwm      => pwm
                );
    
    input : process (NUM_HEX0, NUM_HEX1, NUM_HEX2, NUM_HEX3, NUM_HEX4, NUM_HEX5, DP, enable)
    begin
        if (enable(0) = '1' or enable(1) = '1') then
            if NUM_HEX5 = "0000" and DP(5) = '0' then
                blank_intermediate(5) <= '1'; 
            else
                blank_intermediate(5) <= '0';
            end if;
            if NUM_HEX4 = "0000" and blank_intermediate(5) = '1' and DP(4) = '0' then
                blank_intermediate(4) <= '1'; 
            else
                blank_intermediate(4) <= '0';
            end if;
            if NUM_HEX3 = "0000" and blank_intermediate(4) = '1' and DP(3) = '0' then
                blank_intermediate(3) <= '1'; 
            else
                blank_intermediate(3) <= '0';
            end if;
            if NUM_HEX2 = "0000" and blank_intermediate(3) = '1' and DP(2) = '0' then
                blank_intermediate(2) <= '1'; 
            else
                blank_intermediate(2) <= '0';
            end if;
            if NUM_HEX1 = "0000" and blank_intermediate(2) = '1' and DP(1) = '0' then
                blank_intermediate(1) <= '1'; 
            else
                blank_intermediate(1) <= '0';
            end if;
            if NUM_HEX0 = "0000" and blank_intermediate(1) = '1' and DP(0) = '0' then
                blank_intermediate(0) <= '1'; 
            else
                blank_intermediate(0) <= '0';
            end if;
        else
            blank_intermediate <= "000000";
        end if;
    end process;
    
    pwmOutput : process (blank_intermediate, pwm)
    begin
        if (pwm = '1') then
            blank <= blank_intermediate;
        else
            blank <= "111111";
        end if;
    end process;
end BEHAV;