library ieee;
use ieee.std_logic_1164.all;

entity REGISTER_BUS16 is
    port( D : in std_logic_vector(15 downto 0);
          CLK, RST, ENABLE : in std_logic;
          Q : out std_logic_vector(15 downto 0)
        );
end REGISTER_BUS16;

architecture RTL of REGISTER_BUS16 is
    component my_DFF is
       port ( D, CLK   : in std_logic;
              RST      : in std_logic;
              ENABLE   : in std_logic;
              Q        : out std_logic
            );
    end component;
begin
    DFF0_ins : my_DFF
        port map ( D(0), CLK, RST, ENABLE, Q(0) );
    DFF1_ins : my_DFF
        port map ( D(1), CLK, RST, ENABLE, Q(1) );
    DFF2_ins : my_DFF
        port map ( D(2), CLK, RST, ENABLE, Q(2) );
    DFF3_ins : my_DFF
        port map ( D(3), CLK, RST, ENABLE, Q(3) );
    DFF4_ins : my_DFF
        port map ( D(4), CLK, RST, ENABLE, Q(4) );
    DFF5_ins : my_DFF
        port map ( D(5), CLK, RST, ENABLE, Q(5) );
    DFF6_ins : my_DFF
        port map ( D(6), CLK, RST, ENABLE, Q(6) );
    DFF7_ins : my_DFF
        port map ( D(7), CLK, RST, ENABLE, Q(7) );
    DFF8_ins : my_DFF
        port map ( D(8), CLK, RST, ENABLE, Q(8) );
    DFF9_ins : my_DFF
        port map ( D(9), CLK, RST, ENABLE, Q(9) );
    DFF10_ins : my_DFF
        port map ( D(10), CLK, RST, ENABLE, Q(10) );
    DFF11_ins : my_DFF
        port map ( D(11), CLK, RST, ENABLE, Q(11) );
    DFF12_ins : my_DFF
        port map ( D(12), CLK, RST, ENABLE, Q(12) );
    DFF13_ins : my_DFF
        port map ( D(13), CLK, RST, ENABLE, Q(13) );
    DFF14_ins : my_DFF
        port map ( D(14), CLK, RST, ENABLE, Q(14) );
    DFF15_ins : my_DFF
        port map ( D(15), CLK, RST, ENABLE, Q(15) );
end RTL;
