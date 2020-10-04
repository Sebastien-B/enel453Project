library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SEVEN_SEG_DECODER is
   port ( 
          hex_in       : in  std_logic_vector(3 downto 0);
          segments_out : buffer std_logic_vector(7 downto 0) -- notice no semi-colon 
        );
end SEVEN_SEG_DECODER; -- can also be written as "end entity;" or just "end;"

architecture BEHAVIOR of SEVEN_SEG_DECODER is
begin
   process (hex_in, segments_out) begin
	   case hex_in is
			when X"0" => segments_out <= X"C0";
			when X"1" => segments_out <= X"F9";
			when X"2" => segments_out <= X"A4";
			when X"3" => segments_out <= X"B0";
			when X"4" => segments_out <= X"99";
			when X"5" => segments_out <= X"92";
			when X"6" => segments_out <= X"82";
			when X"7" => segments_out <= X"F8";
			when X"8" => segments_out <= X"80";
			when X"9" => segments_out <= X"90";
			when X"A" => segments_out <= X"88";
			when X"B" => segments_out <= X"83";
			when X"C" => segments_out <= X"C6";
			when X"D" => segments_out <= X"A1";
			when X"E" => segments_out <= X"86";
			when X"F" => segments_out <= X"8E";
			when others => segments_out <= X"FF";
			
		--	when 16#0# => segments_out <= 16#C0#;
		--	when 16#1# => segments_out <= 16#F9#;
		--	when 16#2# => segments_out <= 16#A4#;
		--	when 16#3# => segments_out <= 16#B0#;
		--	when 16#4# => segments_out <= 16#99#;
		--	when 16#5# => segments_out <= 16#92#;
		--	when 16#6# => segments_out <= 16#82#;
		--	when 16#7# => segments_out <= 16#F8#;
		--	when 16#8# => segments_out <= 16#80#;
		--	when 16#9# => segments_out <= 16#90#;
		--	when 16#A# => segments_out <= 16#88#;
		--	when 16#B# => segments_out <= 16#83#;
		--	when 16#C# => segments_out <= 16#C6#;
		--	when 16#D# => segments_out <= 16#A1#;
		--	when 16#E# => segments_out <= 16#86#;
		--	when 16#F# => segments_out <= 16#8E#;
		--	when others => segments_out <= 16#FF#;
      end case;
	end process;
end BEHAVIOR; -- can also be written as "end;"