library ieee;
use ieee.std_logic_1164.all;

entity my_DFF is 
    port (D, CLK   : in std_logic;
          RST     : in std_logic;
          ENABLE : in std_logic;
          Q       : out std_logic
          );
end my_DFF;

architecture BEHAV of my_DFF is 
begin
    process(CLK,RST)
        begin 
                if RST = '0' then
                    Q <= '0';
                elseif rising_edge(CLK) then
                    if ENABLE = '0' then
                        Q <= D;
                    end if;
                end if;
    end process;
end BEHAV;
