library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_4BUS6_TO1_BUS6 is
port ( in1    : in  std_logic_vector(5 downto 0);
         in2   : in  std_logic_vector(5 downto 0);
			in3   : in std_logic_vector(5 downto 0);
			in4   : in std_logic_vector(5 downto 0);
       s       : in  std_logic_vector(1 downto 0);
       mux_out : out std_logic_vector(5 downto 0) -- notice no semi-colon 
      );
end MUX_4BUS6_TO1_BUS6; -- can also be written as "end entity;" or just "end;"

--"00" mux outputs voltage decimal
--"00" mux outputs distance decimal
-- zeros otherwise

architecture BEHAVIOR of MUX_4BUS6_TO1_BUS6 is
   begin
      with s select
         mux_out <= in1 when s<="00", -- when s is '0' then mux_out becomes in1
         mux_out <= in2 when s<="01",
			mux_out <= in3 when s<="10",
			in4 when others;
end BEHAVIOR; -- can also be written as "end;"