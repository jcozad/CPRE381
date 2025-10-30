library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
--use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_dmem to reflect the new testbench.
entity tb_dmem is
  generic(gCLK_HPER   : time := 10 ns;
		ADDR_WIDTH   : integer := 10;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_dmem;

architecture mixed of tb_dmem is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component mem is
	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);

	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_addr   : std_logic_vector((ADDR_WIDTH-1) downto 0)  := b"0000000000";
signal s_data : std_logic_vector((DATA_WIDTH-1) downto 0)  := x"00000000";
signal s_we   : std_logic := '0';
signal s_q   : std_logic_vector((DATA_WIDTH -1) downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  dmem: mem
  generic map (DATA_WIDTH => DATA_WIDTH, 
		ADDR_WIDTH => ADDR_WIDTH)
  port map(
            clk     => CLK,
            addr       => s_addr,
            data       => s_data,
            we     => s_we,
            q       => s_q);
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

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 1: 
    s_addr   <= "0000000000";  --where its reading from the dmem file
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q; --copy the value from the dmem file (-1)
    s_we <= '1';
    s_addr <= "0001100100"; --go to memory spot 100 and put that value there
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 2: 
    s_addr   <= "0000000001";  
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q;
    s_we <= '1';
    s_addr <= "0001100101"; --Memory starts at 0001100000 + 100
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 3: 
    s_addr   <= "0000000010";  
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q;
    s_we <= '1';
    s_addr <= "0001100110"; --Memory starts at 0001100000 + 100
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 4: 
    s_addr   <= "0000000011";  
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q;
    s_we <= '1';
    s_addr <= "0001100111"; --Memory starts at 0001100000 + 100
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 5: 
    s_addr   <= "0000000100";  
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q;
    s_we <= '1';
    s_addr <= "0001101000"; --Memory starts at 0001100000 + 100
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 6: 
    s_addr   <= "0000000101";  
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q;
    s_we <= '1';
    s_addr <= "0001101001"; --Memory starts at 0001100000 + 100
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 7: 
    s_addr   <= "0000000110";  
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q;
    s_we <= '1';
    s_addr <= "0001101010"; --Memory starts at 0001100000 + 100
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 8: 
    s_addr   <= "0000000111";  
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q;
    s_we <= '1';
    s_addr <= "0001101011"; --Memory starts at 0001100000 + 100
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 9: 
    s_addr   <= "0000001000";  
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q;
    s_we <= '1';
    s_addr <= "0001101100"; --Memory starts at 0001100000 + 100
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 10: 
    s_addr   <= "0000001001";  
    wait for gCLK_HPER*2;

    	-- Save Value
    s_data <= s_q;
    s_we <= '1';
    s_addr <= "0001101101"; --Memory starts at 0001100000 + 100
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;

    -- Test case 11: 
    s_addr   <= "0001100101";   --read test case 2 from earlier and make sure you get 
    wait for gCLK_HPER*2;
    -- Expect: 

s_we <= '0';
wait for gCLK_HPER*2;


    wait;
  end process;

end mixed;
