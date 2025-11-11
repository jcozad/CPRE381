library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
--use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_MyFirstRISCVDatapath to reflect the new testbench.
entity tb_MyFirstRISCVDatapath is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 8);   -- Generic for half of the clock cycle period
end tb_MyFirstRISCVDatapath;

architecture mixed of tb_MyFirstRISCVDatapath is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component MyFirstRISCVDatapath is
    Port ( rs1 : in STD_LOGIC_VECTOR(4 downto 0); --Register to read
           rs2 : in STD_LOGIC_VECTOR(4 downto 0); --Register to read
           rd : in STD_LOGIC_VECTOR(4 downto 0); --Register to write to
           Clk : in STD_LOGIC;
           We : in STD_LOGIC; --Enable if writing
           Reset : in STD_LOGIC;
           ALU_Src : in STD_LOGIC;
           Immi : in STD_LOGIC_VECTOR(31 downto 0);
           Add_Sub : in STD_LOGIC;
           Sum : out STD_LOGIC_VECTOR(31 downto 0);
           Cout : out STD_LOGIC);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_rs1   : std_logic_vector(4 downto 0) := "00000";
signal s_rs2   : std_logic_vector(4 downto 0) := "00000";
signal s_rd : std_logic_vector(4 downto 0) := "00000";
signal s_We : std_logic := '0';
signal s_Reset   : std_logic := '0';
signal s_ALU_Src : std_logic := '0';
signal s_Immi   : std_logic_vector(31 downto 0) := x"00000000";
signal s_Add_Sub : std_logic := '0';
signal s_Sum   : std_logic_vector(31 downto 0);
signal s_Cout  : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: MyFirstRISCVDatapath
  --generic map (WIDTH => DATA_WIDTH)
  port map(
            rs1     => s_rs1,
            rs2       => s_rs2,
            rd       => s_rd,
            We       => s_We,
            Reset       => s_Reset,
            ALU_Src       => s_ALU_Src,
            Immi       => s_Immi,
            Add_Sub       => s_Add_Sub,
            Sum       => s_Sum,
            Cout       => s_Cout,
            Clk       => CLK);
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

    -- Test case 1:
    -- Set all registers to 0.
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_Immi   <= x"00000000";  
    s_Add_Sub   <= '0';
    s_ALU_Src <= '0';
    s_We <= '1';
    wait for gCLK_HPER*2;
    -- Expect: 

    -- Test case 2:
    -- Reset all registers.
    s_Reset <= '1';
    wait for gCLK_HPER*2;
    -- Expect: 

    -- Test case 3:
    -- Turn off reset 
    s_Reset <= '0';
    wait for gCLK_HPER*2;
    -- Expect: 

	--Cut a couple test cases

    -- Test case 6:
    -- addi x1 , zero , 1
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "00001"; 
 
    s_Immi   <= x"00000001"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
    -- Expect: # Place "1" in x1

    -- Test case 7:
    -- addi x2 , zero , 2 # Place "2" in x2
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "00010"; 
 
    s_Immi   <= x"00000002"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--

    -- Test case 8:
    -- addi x3 , zero , 3 # Place "3" in x3
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "00011"; 
 
    s_Immi   <= x"00000003"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--

    -- Test case 9:
    -- addi x4 , zero , 4 # Place "4" in x4
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "00100"; 
 
    s_Immi   <= x"00000004"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--

    -- Test case 10:
    -- addi x5 , zero , 5 # Place "5" in x5
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "00101"; 
 
    s_Immi   <= x"00000005"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--

    -- Test case 11:
    -- addi x6 , zero , 6 # Place "6" in x6
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "00110"; 
 
    s_Immi   <= x"00000006"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--

    -- Test case 12:
    -- addi x7 , zero , 7 # Place "7" in x7
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "00111"; 
 
    s_Immi   <= x"00000007"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--

    -- Test case 13:
    -- addi x8 , zero , 8 # Place "8" in x8
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "01000"; 
 
    s_Immi   <= x"00000008"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--

    -- Test case 14:
    -- addi x9 , zero , 9 # Place "9" in x9
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "01001"; 
 
    s_Immi   <= x"00000009"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--

    -- Test case 15:
    -- addi x10 , zero , 10 # Place "10" in x10
    s_rs1   <= "00000";  
    s_rs2   <= "00000";  
    s_rd   <= "01010"; 
 
    s_Immi   <= x"0000000A"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--

    -- Test case 16:
    -- add x11 , x1 , x2 # x11 = x1 + x2
    s_rs1   <= "00001";  
    s_rs2   <= "00010";  
    s_rd   <= "01011"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	-- Expecting x11 = 3

    -- Test case 17:
    -- sub x12 , x11 , x3 # x12 = x11 - x3
    s_rs1   <= "01011";  
    s_rs2   <= "00011";  
    s_rd   <= "01100"; 


    s_Add_Sub   <= '1';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	--Expecting x12 = 3 - 3 = 0

    -- Test case 18:
    -- add x13 , x12 , x4 # x13 = x12 + x4
    s_rs1   <= "01100";  
    s_rs2   <= "00100";  
    s_rd   <= "01101"; 


    s_Add_Sub   <= '0';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	--Expecting x13 = 4

    -- Test case 19:
    -- sub x14 , x13 , x5 # x14 = x13 - x5
    s_rs1   <= "01101";  
    s_rs2   <= "00101";  
    s_rd   <= "01110"; 


    s_Add_Sub   <= '1';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	--Expecting x14 = 4 - 5 = -1

    -- Test case 20:
    -- add x15 , x14 , x6 # x15 = x14 + x6
    s_rs1   <= "01110";  
    s_rs2   <= "00110";  
    s_rd   <= "01111"; 


    s_Add_Sub   <= '0';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	--Expecting x15 = -1 + 6 = 5

    -- Test case 21:
    -- sub x16 , x15 , x7 # x16 = x15 - x7
    s_rs1   <= "01111";  
    s_rs2   <= "00111";  
    s_rd   <= "10000"; 


    s_Add_Sub   <= '1';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	--Expecting x16 = 5 - 7 = -2

    -- Test case 22:
    -- add x17 , x16 , x8 # x17 = x16 + x8
    s_rs1   <= "10000";  
    s_rs2   <= "01000";  
    s_rd   <= "10001"; 


    s_Add_Sub   <= '0';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	--Expecting x17 = -2 + 8 = 6

    -- Test case 23:
    -- sub x18 , x17 , x9 # x18 = x17 - x9
    s_rs1   <= "10001";  
    s_rs2   <= "01001";  
    s_rd   <= "10010"; 


    s_Add_Sub   <= '1';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	--Expecting x18 = 6 - 9 = -3

    -- Test case 24:
    -- add x19 , x18 , x10 # x19 = x18 + x10
    s_rs1   <= "10010";  
    s_rs2   <= "01010";  
    s_rd   <= "10011"; 


    s_Add_Sub   <= '0';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	--Expecting x19 = -3 + 10 = 7

    -- Test case 25:
    -- addi x20 , zero , -35 # Place " -35" in x20
    s_rs1   <= "00000";  
    --s_rs2   <= "0000A";  
    s_rd   <= "10100"; 

    s_Immi   <= x"FFFFFFDD"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '1';
    wait for gCLK_HPER*2;
	--Expecting x20 = -35

    -- Test case 26:
    -- add x21 , x19 , x20 # x21 = x19 + x20
    s_rs1   <= "10011";  
    s_rs2   <= "10100";  
    s_rd   <= "10101"; 

    s_Add_Sub   <= '0';
    s_ALU_Src <= '0';
    wait for gCLK_HPER*2;
	--Expecting x21 = -28


    wait;
  end process;

end mixed;
