library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digit_blanker is
    port (NUM_HEX0, NUM_HEX1, NUM_HEX2, NUM_HEX3, NUM_HEX4, NUM_HEX5: in std_logic_vector(3 downto 0);
          DP:     in std_logic_vector(5 downto 0);
          enable: in std_logic;
          blank:  buffer std_logic_vector(5 downto 0)
         );
end digit_blanker;

architecture BEHAV of digit_blanker is
begin
    process (NUM_HEX0, NUM_HEX1, NUM_HEX2, NUM_HEX3, NUM_HEX4, NUM_HEX5, DP, enable)
    begin
        if (enable = '1') then
            if NUM_HEX5 = "0000" and DP(5) = '0' then
                blank(5) <= '1'; 
            else
                blank(5) <= '0';
            end if;
            if NUM_HEX4 = "0000" and blank(5) = '1' and DP(4) = '0' then
                blank(4) <= '1'; 
            else
                blank(4) <= '0';
            end if;
            if NUM_HEX3 = "0000" and blank(4) = '1' and DP(3) = '0' then
                blank(3) <= '1'; 
            else
                blank(3) <= '0';
            end if;
            if NUM_HEX2 = "0000" and blank(3) = '1' and DP(2) = '0' then
                blank(2) <= '1'; 
            else
                blank(2) <= '0';
            end if;
            if NUM_HEX1 = "0000" and blank(2) = '1' and DP(1) = '0' then
                blank(1) <= '1'; 
            else
                blank(1) <= '0';
            end if;
            if NUM_HEX0 = "0000" and blank(1) = '1' and DP(0) = '0' then
                blank(0) <= '1'; 
            else
                blank(0) <= '0';
            end if;
        else
            blank <= "000000";
        end if;
    end process;
end BEHAV;