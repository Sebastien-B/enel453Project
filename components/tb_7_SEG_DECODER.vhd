library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_7_SEG_DECODER is
end tb_7_SEG_DECODER;

architecture tb of tb_7_SEG_DECODER is

    component SEVEN_SEG_DECODER is
        port ( 
               hex_in       : in  STD_LOGIC_VECTOR (7 downto 0);
               segments_out : out STD_LOGIC_VECTOR (7 downto 0) -- notice no semi-colon 
             );
    end component SEVEN_SEG_DECODER;
    -- signal [name] : type;

    constant tb_Period : TIME      := 20 ns; -- EDIT Put right period here(Denis: 1/50 MHz = 20 ns)
   signal tb_input    : INTEGER	  := 0;
   signal tb_output   : STD_LOGIC_VECTOR (7 downto 0) := 0x00;
    signal tb_clock    : STD_LOGIC := '0';
    signal tb_SimEnded : STD_LOGIC := '0';

begin

    uut : SEVEN_SEG_DECODER
    port map (
               hex_in => STD_LOGIC_VECTOR(to_unsigned(tb_input));
               segments_out => tb_output
            );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin
        tb_input + 1;
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;