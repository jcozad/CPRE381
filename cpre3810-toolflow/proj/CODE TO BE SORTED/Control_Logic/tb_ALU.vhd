library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
--use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_ALU to reflect the new testbench.
entity tb_ALU is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 8);   -- Generic for half of the clock cycle period
end tb_ALU;

architecture mixed of tb_ALU is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component ALU is
    Port ( A : in std_logic_vector(31 downto 0);
           B : in std_logic_vector(31 downto 0);
           ALUControl : in std_logic_vector(3 downto 0);
           Overflow : out STD_LOGIC;
           Zero : out STD_LOGIC;
           ALUOut : out std_logic_vector(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_A   : std_logic_vector(32-1 downto 0) := x"00000000";
signal s_B   : std_logic_vector(32-1 downto 0) := x"00000000";
signal s_ALUControl : std_logic_vector(3 downto 0) := x"0";
signal s_Overflow   : std_logic;
signal s_Zero   : std_logic;
signal s_ALUOut   : std_logic_vector(32-1 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: ALU
  --generic map (WIDTH => DATA_WIDTH)
  port map(
            A       => s_A,
            B       => s_B,
            ALUControl     => s_ALUControl,
            Overflow       => s_Overflow,
            Zero       => s_Zero,
            ALUOut       => s_ALUOut);
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

	
    --ALUControl: add/addi is 0000
    --ALUControl: sub/subi is 0001
    --ALUControl: slt is 1001

    --ALUControl: and is 0010
    --ALUControl: xor is 1010

    --ALUControl: or is 0011
    --ALUControl: nor is 1011

    --ALUControl: sll/slli is 0110
    --ALUControl: srl/srli is 0111
    --ALUControl: sra/srai is 1111


    -- Test case 2: add/addi
    s_A   <= x"00010101";  --
    s_B   <= x"00000010";  --
    s_ALUControl   <= x"0";  --
    wait for gCLK_HPER*2;
    -- Expect: 00010111

    -- Test case 3: sub/subi
    s_A   <= x"00010101";  --
    s_B   <= x"00000010";  --
    s_ALUControl   <= x"1";  --
    wait for gCLK_HPER*2;
    -- Expect: 000100F1

    -- Test case 4: add/addi and check for overflow
    s_A   <= x"FFFFFFFF";  --
    s_B   <= x"00000001";  --
    s_ALUControl   <= x"0";  --
    wait for gCLK_HPER*2;
    -- Expect: 00000000

    -- Test case 5: AND
    s_A   <= x"0000FFFF";  --
    s_B   <= x"00F0F0FF";  --
    s_ALUControl   <= x"2";  --
    wait for gCLK_HPER*2;
    -- Expect: 0000F0FF

    -- Test case 5: OR
    s_A   <= x"0000FFFF";  --
    s_B   <= x"00F0F0FF";  --
    s_ALUControl   <= x"3";  --
    wait for gCLK_HPER*2;
    -- Expect: 00F0FFFF

    -- Test case 6: sll/slli
    s_A   <= x"0000FFFF";  --
    s_B   <= x"00000004";  --during the shift only the first 5 bits matter for the amount
    s_ALUControl   <= x"6";  -- 1000
    wait for gCLK_HPER*2;
    -- Expect: 000FFFF0

    -- Test case 7: srl/srli
    s_A   <= x"0000FFFF";  --
    s_B   <= x"00000004";  --during the shift only the first 5 bits matter for the amount
    s_ALUControl   <= x"7";  -- 1001
    wait for gCLK_HPER*2;
    -- Expect: 00000FFF

    -- Test case 8: sra/srai
    s_A   <= x"F000FFF0";  --
    s_B   <= x"00000004";  --during the shift only the first 5 bits matter for the amount
    s_ALUControl   <= x"F";  -- 1010
    wait for gCLK_HPER*2;
    -- Expect: FF000FFF

    -- Test case 5: slt (positive)
    s_A   <= x"0000FFFF";  --
    s_B   <= x"00000001";  --
    s_ALUControl   <= x"9";  --
    wait for gCLK_HPER*2;
    -- Expect: 00000000

    -- Test case 5: XOR
    s_A   <= x"00F0FFFF";  --
    s_B   <= x"00FF0000";  --
    s_ALUControl   <= x"A";  --
    wait for gCLK_HPER*2;
    -- Expect: 000FFFFF

    -- Test case 5: NOR
    s_A   <= x"0000FF0F";  --
    s_B   <= x"0000F000";  --
    s_ALUControl   <= x"B";  --
    wait for gCLK_HPER*2;
    -- Expect: FFFF00F0

    -- Test case 6: slt (negative)
    s_A   <= x"00000001";  --
    s_B   <= x"0000FFFF";  --
    s_ALUControl   <= x"9";  --
    wait for gCLK_HPER*2;
    -- Expect: 00000001

    wait;
  end process;

end mixed;
