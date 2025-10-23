library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
--use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_FirstDatapath to reflect the new testbench.
entity tb_extender_12t32 is
  generic(gCLK_HPER   : time := 10 ns;
          N  : integer := 32);   -- Generic for half of the clock cycle period
end tb_extender_12t32;

architecture mixed of tb_extender_12t32 is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component extender_12t32 is
  
  port(
    ivalue : in  std_logic_vector(11 downto 0);  --imm[11:0]
    ovalue : out std_logic_vector(31 downto 0)   --sign-extended
  );

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.

signal s_ivalue   : std_logic_vector(11 downto 0) := x"000";
signal s_ovalue   : std_logic_vector(31 downto 0);


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DOT0 : extender_12t32
  
        port map (
            ivalue  => s_ivalue,
            ovalue => s_ovalue);

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

    -- Test case 1: Set 0 extender
    s_ivalue <= x"000";
    
    wait for gCLK_HPER*2;
    -- Expect: 0x00000000


     -- Test case 2: Max unsigned value
    s_ivalue <= x"7FF"; 
    
    wait for gCLK_HPER*2;
    -- Expect: 0x000007FF


    -- Test case 3: 
    s_ivalue <= x"800";
    
    wait for gCLK_HPER*2;
    -- Expect: 0xFFFFF800


     -- Test case 4: 
    s_ivalue <= x"819"; 
    
    wait for gCLK_HPER*2;
    -- Expect: 0xFFFFF819


     -- Test case 5: 
    s_ivalue <= x"123"; 
    
    wait for gCLK_HPER*2;
    -- Expect: 0x00000123


    wait;
  end process;

end mixed;
