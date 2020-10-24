library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sync is
	port (s: in std_logic_vector(9 downto 0);
			CLK: in std_logic;
			sync_out: out std_logic_vector(9 downto 0);
			x: inout std_logic_vector(9 downto 0)
		);	
end sync;


architecture BEHAV of sync is
	begin
		process(CLK)
		begin
			if rising_edge(CLK) then
				x<=s;
				sync_out<=x;
			end if;
		end process;
	end BEHAV;