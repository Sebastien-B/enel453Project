library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
------------------------------------------------------------------------------------------------------------------
entity top_level is
    Port ( clk                           : in  STD_LOGIC;
           reset_n                       : in  STD_LOGIC;
           save                          : in  STD_LOGIC;
           SW                            : in  STD_LOGIC_VECTOR (9 downto 0);
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
         );
end top_level;
------------------------------------------------------------------------------------------------------------------
architecture Behavioral of top_level is
    -- Signal declaration
    Signal Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 : STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
    Signal DP_in, Blank:      STD_LOGIC_VECTOR (5 downto 0);
    Signal switch_synced:     STD_LOGIC_VECTOR (9 downto 0);
    Signal switch_inputs:     STD_LOGIC_VECTOR (12 downto 0);
    Signal mux_switch_inputs: STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal bcd:               STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal mode_mux_out:      STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal mode_mux_sel:      STD_LOGIC_VECTOR (1 DOWNTO 0);
    Signal save_debounced:    STD_LOGIC;
    Signal save_mux_out:      STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal saved_7seg_input:  STD_LOGIC_VECTOR (15 DOWNTO 0);



    -- Component declaration
    Component SevenSegment is
        Port ( Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
               Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
               DP_in,Blank                                           : in  STD_LOGIC_VECTOR (5 downto 0)
             );
    End Component ;

    Component binary_bcd IS
        PORT ( clk     : IN  STD_LOGIC;                      --system clock
               reset_n : IN  STD_LOGIC;                      --active low asynchronus reset_n
               binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
               bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
             );
    END Component;

    Component debounce is
        PORT( clk     : IN  STD_LOGIC;  --input clock
              reset_n : IN  STD_LOGIC;  --asynchronous active low reset
              button  : IN  STD_LOGIC;  --input signal to be debounced
              result  : OUT STD_LOGIC); --debounced signal
    END Component;

    Component MUX_2BUS16_TO1_BUS16 is
        port ( in1     : in  std_logic_vector(15 downto 0);
               in2     : in  std_logic_vector(15 downto 0);
               s       : in  std_logic;
               mux_out : out std_logic_vector(15 downto 0) -- notice no semi-colon 
             );
    end Component;

    Component MUX_4TO1 is
        port ( in1, in2, in3, in4   : in  std_logic_vector(15 downto 0);
                             s      : in  std_logic_vector(1 downto 0);
                            mux_out : out std_logic_vector(15 downto 0) -- notice no semi-colon 
             );
    end Component;

    Component REGISTER_BUS16 is
        port ( D : in std_logic_vector(15 downto 0);
               CLK, RST : in std_logic;
               Q : out std_logic_vector(15 downto 0)
             );
    end Component;

    Component sync is
        port ( s: in std_logic_vector(9 downto 0);
               CLK: in std_logic;
               sync_out: out std_logic_vector(9 downto 0);
               x: inout std_logic_vector(9 downto 0)
             );
    end Component;

    -- Logic
    begin
        Num_Hex0 <= mode_mux_out(3  downto  0); 
        Num_Hex1 <= mode_mux_out(7  downto  4);
        Num_Hex2 <= mode_mux_out(11 downto  8);
        Num_Hex3 <= mode_mux_out(15 downto 12);
        Num_Hex4 <= "0000";
        Num_Hex5 <= "0000";   
        DP_in(5 downto 0) <= "000000"; -- position of the decimal point in the display (1=LED on,0=LED off)
        Blank    <= "110000"; -- blank the 2 MSB 7-segment displays (1=7-seg display off, 0=7-seg display on)

    debounce_ins: debounce
        PORT MAP( clk => clk,
                  reset_n => reset_n,
                  button => save,
                  result => save_debounced
                );

    MUX_4TO1_ins : MUX_4TO1
        PORT MAP( in1     => bcd,
                  in2     => mux_switch_inputs,
                  in3     => "0101101001011010",
                  in4     => saved_7seg_input,
                  s       => mode_mux_sel,
                  mux_out => mode_mux_out
                );
    
    MUX_2BUS16_TO1_BUS16_ins: MUX_2BUS16_TO1_BUS16
        PORT MAP( in1     => mode_mux_out,
                  in2     => saved_7seg_input,
                  s       => save_debounced,
                  mux_out => save_mux_out
                );
    
    REGISTER_BUS16_ins: REGISTER_BUS16
        PORT MAP( D   => save_mux_out,
                  CLK => clk,
                  RST => reset_n,
                  Q   => saved_7seg_input
                );

    SevenSegment_ins: SevenSegment
        PORT MAP( Num_Hex0 => Num_Hex0,
                  Num_Hex1 => Num_Hex1,
                  Num_Hex2 => Num_Hex2,
                  Num_Hex3 => Num_Hex3,
                  Num_Hex4 => Num_Hex4,
                  Num_Hex5 => Num_Hex5,
                  Hex0     => Hex0,
                  Hex1     => Hex1,
                  Hex2     => Hex2,
                  Hex3     => Hex3,
                  Hex4     => Hex4,
                  Hex5     => Hex5,
                  DP_in    => DP_in,
                  Blank    => Blank
                );

    sync_ins: sync
       PORT MAP( s        => SW(9 downto 0),
                 CLK      => clk,
                 sync_out => switch_synced
                -- x        => 
               );

    LEDR(9 downto 0) <= switch_synced(9 downto 0); -- gives visual display of the switch inputs to the LEDs on board
    switch_inputs <= "00000" & switch_synced(7 downto 0);
    mux_switch_inputs <= "00000000" & switch_synced(7 downto 0);
    mode_mux_sel <= switch_synced(9 downto 8);

    binary_bcd_ins: binary_bcd                               
        PORT MAP(
                  clk      => clk,                          
                  reset_n  => reset_n,                                 
                  binary   => switch_inputs,    
                  bcd      => bcd         
                );
end Behavioral;