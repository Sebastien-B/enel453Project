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
    Signal mux_adc_avg_input: STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal bcd:               STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal mode_mux_out:      STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal ADC_Data_avg_out_16_wide: STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal mode_mux_sel:      STD_LOGIC_VECTOR (1 DOWNTO 0);
    Signal save_debounced:    STD_LOGIC;
    Signal save_mux_out:      STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal saved_7seg_input:  STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal ADC_Data_voltage_out:  STD_LOGIC_VECTOR (12 downto 0); -- Voltage in milli-volts
    Signal ADC_Data_distance_out: STD_LOGIC_VECTOR (12 downto 0); -- distance in 10^-4 cm (e.g. if distance = 33 cm, then 3300 is the value)
    Signal ADC_Data_raw_out:      STD_LOGIC_VECTOR (11 downto 0); -- the latest 12-bit ADC value
    Signal ADC_Data_avg_out:      STD_LOGIC_VECTOR (11 downto 0); -- moving average of ADC value, over 256 samples
    Signal distance_bcd_out:      STD_LOGIC_VECTOR (15 DOWNTO 0);
    Signal voltage_bcd_out:       STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- Component declaration

    Component ADC_Data is
        Port( clk      : in STD_LOGIC;
              reset_n  : in STD_LOGIC; -- active-low
              voltage  : out STD_LOGIC_VECTOR (12 downto 0); -- Voltage in milli-volts
              distance : out STD_LOGIC_VECTOR (12 downto 0); -- distance in 10^-4 cm (e.g. if distance = 33 cm, then 3300 is the value)
              ADC_raw  : out STD_LOGIC_VECTOR (11 downto 0); -- the latest 12-bit ADC value
              ADC_out  : out STD_LOGIC_VECTOR (11 downto 0)  -- moving average of ADC value, over 256 samples
            );
    End Component;

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

    Component MUX_4TO1 is
        port ( in1, in2, in3, in4   : in  std_logic_vector(15 downto 0);
                             s      : in  std_logic_vector(1 downto 0);
                            mux_out : out std_logic_vector(15 downto 0) -- notice no semi-colon 
             );
    end Component;

    Component MUX_4TO1_BUS6 is
        port ( in1, in2, in3, in4   : in  std_logic_vector(5 downto 0);
                             s      : in  std_logic_vector(1 downto 0);
                            mux_out : out std_logic_vector(5 downto 0) -- notice no semi-colon 
             );
    end Component;

    Component REGISTER_BUS16 is
        port ( D : in std_logic_vector(15 downto 0);
               CLK, RST, ENABLE : in std_logic;
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
    
    Component digit_blanker is
        port ( NUM_HEX0, NUM_HEX1, NUM_HEX2, NUM_HEX3, NUM_HEX4, NUM_HEX5: in std_logic_vector(3 downto 0);
               DP:     in std_logic_vector(5 downto 0);
               enable: in std_logic_vector(1 downto 0);
               blank:  buffer std_logic_vector(5 downto 0)
             );
    end Component;

    -- Logic
    begin
        Num_Hex0 <= saved_7seg_input(3  downto  0); 
        Num_Hex1 <= saved_7seg_input(7  downto  4);
        Num_Hex2 <= saved_7seg_input(11 downto  8);
        Num_Hex3 <= saved_7seg_input(15 downto 12);
        Num_Hex4 <= "0000";
        Num_Hex5 <= "0000";   
        --Blank    <= "110000"; -- blank the 2 MSB 7-segment displays (1=7-seg display off, 0=7-seg display on)

        digit_blanker_ins: digit_blanker
        PORT MAP ( NUM_HEX0 => NUM_HEX0,
                   NUM_HEX1 => NUM_HEX1,
                   NUM_HEX2 => NUM_HEX2,
                   NUM_HEX3 => NUM_HEX3,
                   NUM_HEX4 => NUM_HEX4,
                   NUM_HEX5 => NUM_HEX5,
                   DP => DP_in,
                   enable => switch_synced(9 downto 8),
                   blank => Blank
                 );

        ADC_Data_ins: ADC_Data
        PORT MAP ( clk => clk,
                   reset_n => reset_n, -- active low
                   voltage => ADC_Data_voltage_out, -- Voltage in milli-volts
                   distance => ADC_Data_distance_out, -- distance in 10^-4 cm (e.g. if distance = 33 cm, then 3300 is the value)
                   ADC_raw => ADC_Data_raw_out, -- the latest 12-bit ADC value
                   ADC_out => ADC_Data_avg_out  -- moving average of ADC value, over 256 samples
                 );

    debounce_ins: debounce
        PORT MAP( clk => clk,
                  reset_n => reset_n,
                  button => save,
                  result => save_debounced
                );

    mode_mux_ins : MUX_4TO1
        PORT MAP( in1     => mux_switch_inputs,
                  -- in2     => "0000" & ADC_Data_avg_out,
                  in2     => ADC_Data_avg_out_16_wide,
                  in3     => voltage_bcd_out,
                  in4     => distance_bcd_out,
                  s       => mode_mux_sel,
                  mux_out => mode_mux_out
                );

    ADC_Data_avg_out_16_wide <= "0000" & ADC_Data_avg_out;

    REGISTER_BUS16_ins: REGISTER_BUS16
        PORT MAP( D   => mode_mux_out,
                  CLK => clk,
                  RST => reset_n,
                  ENABLE => save_debounced,
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

    DP_mux_ins : MUX_4TO1_BUS6
        PORT MAP( in1     => "000000",-- mux_switch_inputs,
                  in2     => "000000", -- "0000" & ADC_Data_avg_out,
                  in3     => "001000",-- adc_avg_bcd_out,
                  in4     => "000100",-- distance_bcd_out,
                  s       => mode_mux_sel,
                  mux_out => DP_in
                );

    sync_ins: sync
       PORT MAP( s        => SW(9 downto 0),
                 CLK      => clk,
                 sync_out => switch_synced
               );

    LEDR(9 downto 0) <= switch_synced(9 downto 0); -- gives visual display of the switch inputs to the LEDs on board
    mux_switch_inputs <= "00000000" & switch_synced(7 downto 0);
    mode_mux_sel <= switch_synced(9 downto 8);

    adc_avg_binary_bcd_ins: binary_bcd
        PORT MAP(
                  clk      => clk,
                  reset_n  => reset_n,
                  binary   => ADC_Data_voltage_out,
                  bcd      => voltage_bcd_out
                );

    distance_binary_bcd_ins: binary_bcd
        PORT MAP(
                  clk      => clk,
                  reset_n  => reset_n,
                  binary   => ADC_Data_distance_out,
                  bcd      => distance_bcd_out
                );

end Behavioral;