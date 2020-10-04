-- --- Practice code, totally arbitrary logic 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity some_logic is
    Port ( 
           in0,in1          : in  STD_LOGIC;
           output0, output1 : out STD_LOGIC;
           clk              : in  STD_LOGIC;
           reset            : in  STD_LOGIC  --Notice no semicolon
           );
end some_logic;

architecture Behavioral of some_logic is

signal signal_0, signal_1: STD_LOGIC;

begin

  -- Combinational logic! Note that "<=" is an assignment operator
   output0  <= in0 and in1; 
   signal_1 <= in0 xor in1;
	signal_0 <= signal_1 and in1;
 
  -- Sequential logic! 
  flip_flop: process(clk, reset)
   begin 
       if (reset='1') then -- this is an asynchronous and active-high reset flip flop
          output1 <= '0';
       elsif (rising_edge(clk)) then
          output1 <= signal_0; -- this is a flip flop (in1 is the D-input, output1 is the Q-output)
       end if;
   end process;
	
end Behavioral;

