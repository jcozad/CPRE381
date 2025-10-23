library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
--use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_barrelShifter to reflect the new testbench.
entity tb_barrelShifter is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 8);   -- Generic for half of the clock cycle period
end tb_barrelShifter;

architecture mixed of tb_barrelShifter is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component barrelShifter is
    Port ( shiftAmount : in std_logic_vector(4 downto 0);
           leftORright : in std_logic; --left is 0, right is 1
           logicalORarithmatic : in std_logic; --logical is 0, arithmatic is 1
           dataIN : in std_logic_vector(31 downto 0);
           dataOUT : out std_logic_vector(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_shiftAmount   : std_logic_vector(4 downto 0) := "00000";
signal s_leftORright   : std_logic := '0';
signal s_logicalORarithmatic : std_logic := '0';
signal s_dataIN   : std_logic_vector(31 downto 0) := x"00000000";
signal s_dataOUT   : std_logic_vector(31 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: barrelShifter
  --generic map (WIDTH => DATA_WIDTH)
  port map(
            --iCLK     => CLK,
            shiftAmount       => s_shiftAmount,
            leftORright       => s_leftORright,
            logicalORarithmatic     => s_logicalORarithmatic,
            dataIN       => s_dataIN,
            dataOUT       => s_dataOUT);
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

--LOGICAL NOW
    -- Test case 1:
    -- 
    s_shiftAmount   <= "00000";  
    s_leftORright   <= '0';
    s_logicalORarithmatic <= '0';
    s_dataIN   <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: dataOUT: x"00000000"

    -- Test case 2:
    -- 
    s_shiftAmount   <= "00001";  
    s_leftORright   <= '0';
    s_logicalORarithmatic <= '0';
    s_dataIN   <= x"00011110";
    wait for gCLK_HPER*2;
    -- Expect: dataOUT: x"00022220"

    -- Test case 3:
    -- 
    s_shiftAmount   <= "11111";  
    s_leftORright   <= '0';
    s_logicalORarithmatic <= '0';
    s_dataIN   <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: dataOUT: x"80000000"

    -- Test case 4:
    -- 
    s_shiftAmount   <= "11111";  
    s_leftORright   <= '1';
    s_logicalORarithmatic <= '0';
    s_dataIN   <= x"F0000000";
    wait for gCLK_HPER*2;
    -- Expect: dataOUT: x"00000001"

    -- Test case 5:
    -- 
    s_shiftAmount   <= "00001";  
    s_leftORright   <= '1';
    s_logicalORarithmatic <= '0';
    s_dataIN   <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: dataOUT: x"00000000"

    -- Test case 6:
    -- 
    s_shiftAmount   <= "00011";  
    s_leftORright   <= '0';
    s_logicalORarithmatic <= '0';
    s_dataIN   <= x"F0000000";
    wait for gCLK_HPER*2;
    -- Expect: dataOUT: x"80000000"

--ARITHMATIC

    -- Test case 7:
    -- 
    s_shiftAmount   <= "00010";  
    s_leftORright   <= '0';
    s_logicalORarithmatic <= '1';
    s_dataIN   <= x"11110000";
    wait for gCLK_HPER*2;
    -- Expect: dataOUT: x"44440000"

    -- Test case 8:
    -- 
    s_shiftAmount   <= "00010";  
    s_leftORright   <= '1';
    s_logicalORarithmatic <= '1';
    s_dataIN   <= x"FFFF0000";
    wait for gCLK_HPER*2;
    -- Expect: dataOUT: x"FFFFC000"

    -- Test case 9:
    -- 
    s_shiftAmount   <= "00010";  
    s_leftORright   <= '1';
    s_logicalORarithmatic <= '1';
    s_dataIN   <= x"FFCC0000";
    wait for gCLK_HPER*2;
    -- Expect: dataOUT: x"FFF30000"


    -- TODO: add test cases as needed (at least 3 more for this lab)


    wait;
  end process;

end mixed;
