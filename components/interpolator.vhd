library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;















































































--entity interpolator is
--   generic ( m : integer := 1;
--             b : integer := 0;
--             in_len : integer := 8;
--             out_len : integer := 10
--           );
--   port (
--          x : in std_logic_vector (in_len - 1 downto 0);
--          y : out std_logic_vector (out_len - 1 downto 0)
--        );
--end interpolator;
--
--architecture structural of interpolator is
--   signal x_signed : signed (in_len downto 0);
--   signal x_resized : signed (out_len - 1 downto 0);
--begin
--   x_signed <= signed('0' & x);
--   x_resized <= resize(x_signed, out_len);
--   y <= std_logic_vector(resize(m*x_resized + b, out_len));
--end structural;

entity interpolator is
   generic ( m : signed (8 downto 0);
             b : signed (17 downto 0)
           );
   port (
          x : in std_logic_vector (7 downto 0);
          y : out std_logic_vector (17 downto 0)
        );
end interpolator;

architecture structural of interpolator is
   signal x_signed : signed (8 downto 0);
   signal mx : signed (17 downto 0);
   signal mxb : signed (17 downto 0);
begin
   x_signed <= signed('0' & x);
   mx <= m*x_signed;
   mxb <= mx + b;
   y <= std_logic_vector(mxb);
end structural;