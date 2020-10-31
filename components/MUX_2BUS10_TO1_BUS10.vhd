library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_2BUS10_TO1_BUS10 is
port ( dist    : in  std_logic_vector(9 downto 0);
         volt   : in  std_logic_vector(9 downto 0);
       s       : in  std_logic;
       mux_out : out std_logic_vector(9 downto 0) -- notice no semi-colon 
      );
end MUX_2BUS10_TO1_BUS10; -- can also be written as "end entity;" or just "end;"

--when switch(8) is 0, distance should be displayed
--when switch(8) is 1, voltage should be displayed

architecture BEHAVIOR of MUX_2BUS10_TO1_BUS10 is
   begin
      with s select
         mux_out <= dist when '0', -- when s is '0' then mux_out becomes in1
                    volt when others;
end BEHAVIOR; -- can also be written as "end;"