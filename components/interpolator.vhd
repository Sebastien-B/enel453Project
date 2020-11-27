library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity interpolator is
   generic ( m : integer := 1;
             b : integer := 0;
             in_len : integer := 8;
             out_len : integer := 8
           );
   port (
          x : in std_logic_vector (in_len downto 0);
          y : out std_logic_vector (out_len downto 0)
        );
end interpolator;

architecture structural of interpolator is
begin
   y <= signed(m*x) + signed(b);
end structural;