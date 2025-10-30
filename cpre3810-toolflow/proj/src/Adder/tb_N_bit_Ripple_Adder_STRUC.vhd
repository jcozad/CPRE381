library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
--use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_N_bit_Ripple_Adder_STRUC to reflect the new testbench.
entity tb_N_bit_Ripple_Adder_STRUC is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_N_bit_Ripple_Adder_STRUC;

architecture mixed of tb_N_bit_Ripple_Adder_STRUC is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component N_bit_Ripple_Adder_STRUC is
  
	generic(N : integer := 32);

  port(i_A               : in std_logic_vector(N-1 downto 0);
       i_B               : in std_logic_vector(N-1 downto 0);
       i_Cin               : in std_logic;
       o_Cout               : out std_logic;
       o_S               : out std_logic_vector(N-1 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.

--generic(N : integer := 32);
       signal s_i_A               :  std_logic_vector(DATA_WIDTH-1 downto 0):= x"00000000";
       signal s_i_B               :  std_logic_vector(DATA_WIDTH-1 downto 0):= x"00000000";
       signal s_i_Cin               :  std_logic := '0';
       signal s_o_Cout               :  std_logic;
       signal s_o_S               :  std_logic_vector(DATA_WIDTH-1 downto 0);


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: N_bit_Ripple_Adder_STRUC
  generic map (N => DATA_WIDTH)
  port map(
            i_A     => s_i_A,
            i_B       => s_i_B,
            i_Cin       => s_i_Cin,
            o_Cout     => s_o_Cout,
            o_S       => s_o_S);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Assuming Cout is 0 unless otherwise noted
    -- Test case 1:
    -- Initialize All to 0.
    s_i_A   <= x"00000000";  
    s_i_B   <= x"00000000";  
    s_i_Cin <= '0';  
    wait for gCLK_HPER*2;
    -- Expect: adding 0+0=0

    -- Test case 2:
    -- Initialize adding with overflow.
    s_i_A   <= x"FFFFFFFE";  
    s_i_B   <= x"00000002";  
    s_i_Cin <= '0';  
    wait for gCLK_HPER*2;
    -- Expect: expecting 00000000 and Cout = 1

    -- Test case 3:
    -- Initialize 3+12.
    s_i_A   <= x"00000011";  
    s_i_B   <= x"00001100";  
    s_i_Cin <= '0';  
    wait for gCLK_HPER*2;
    -- Expect: adding to 15

    -- Test case 4:
    -- Initialize 99+12.
    s_i_A   <= x"00110011";  
    s_i_B   <= x"00001100";  
    s_i_Cin <= '0';  
    wait for gCLK_HPER*2;
    -- Expect: adding to 111

    -- Test case 5:
    -- Initialize Testing Cin
    s_i_A   <= x"00000000";  
    s_i_B   <= x"00000000";  
    s_i_Cin <= '1';  
    wait for gCLK_HPER*2;
    -- Expect: adding 0+0= 0 + 1


    wait;
  end process;

end mixed;
