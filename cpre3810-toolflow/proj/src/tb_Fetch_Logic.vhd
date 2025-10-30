library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
--use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_Fetch_Logic to reflect the new testbench.
entity tb_Fetch_Logic is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 8);   -- Generic for half of the clock cycle period
end tb_Fetch_Logic;

architecture mixed of tb_Fetch_Logic is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component Fetch_Logic is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           InputData : in STD_LOGIC_VECTOR(31 downto 0);
           PRSrc : in STD_LOGIC;
           NextInstAddress : out STD_LOGIC_VECTOR(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_Rst   : STD_LOGIC := '0';
signal s_PRSrc   : STD_LOGIC := '0';
signal s_InputData   : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
signal s_NextInstAddress   : STD_LOGIC_VECTOR(31 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: Fetch_Logic
  --generic map (WIDTH => DATA_WIDTH)
  port map(
            Clk     => CLK,
            Rst       => s_Rst,
            PRSrc       => s_PRSrc,
            InputData       => s_InputData,
            NextInstAddress       => s_NextInstAddress);
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

    --Assuming we want it to start at address 0x00000000

    -- Test case 1: Reset
    s_Rst   <= '1';
    s_PRSrc   <= '0';
    s_InputData   <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: 0 for all

    -- Test case 2: Let inc by 4 for a while
    s_Rst   <= '0';
    wait for gCLK_HPER*20;
    -- Expect: You should see s_NextInstAddress inc by 4 from here on


    -- Test case 3: use other part of the mux
    s_InputData   <= x"00000005";
    s_PRSrc   <= '1';
    wait for gCLK_HPER*2;
    -- Expect: You should see s_NextInstAddress inc by 4 from here on




    wait;
  end process;

end mixed;
