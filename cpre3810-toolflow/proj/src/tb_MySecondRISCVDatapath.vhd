library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
--use std.env.all; -- For hierarchical/external signals
use std.textio.all; --For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_FirstDatapath to reflect the new testbench.
entity tb_MySecondRISCVDatapath is
  generic(gCLK_HPER   : time := 10 ns;
 N  : integer := 32);   -- Generic for half of the clock cycle period
end tb_MySecondRISCVDatapath;

architecture mixed of tb_MySecondRISCVDatapath is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component MySecondRISCVDatapath is

    port (
  iClk : in std_logic;
  iRst : in std_logic;
  iRs1  : in std_logic_vector(4 downto 0);
  iRs2  : in std_logic_vector(4 downto 0);
  iRd  : in std_logic_vector(4 downto 0);
  iImm : in std_logic_vector(11 downto 0);
  iMemReadORWrite   : in std_logic;
  iRegWrite  : in std_logic;
  iALU_Src    : in std_logic;
  iAddOrSub     : in std_logic;
  iMemToReg     : in std_logic;
  oALUResult : out std_logic_vector(31 downto 0);
  oMemData   : out std_logic_vector(31 downto 0);
  oRead1     : out std_logic_vector(31 downto 0);
  oRead2     : out std_logic_vector(31 downto 0));

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.

	signal s_iRst  :  std_logic:= '0';
  signal s_iRs1:  std_logic_vector(4 downto 0):= "00000";
  signal s_iRs2     :  std_logic_vector(4 downto 0):= "00000";
  signal s_iRd     :  std_logic_vector(4 downto 0):= "00000";
  signal s_iImm  :  std_logic_vector(11 downto 0):= x"000";
  signal s_iMemReadORWrite     :  std_logic:= '0';
  signal s_iRegWrite     :  std_logic:= '0';
  signal s_iALU_Src     :  std_logic:= '0';
  signal s_iAddOrSub     :  std_logic:= '0';
  signal s_iMemToReg     :  std_logic:= '0';
  signal s_oALUResult     :  std_logic_vector(31 downto 0):= x"00000000";
  signal s_oMemData     :  std_logic_vector(31 downto 0):= x"00000000";
  signal s_oRead1:  std_logic_vector(31 downto 0):= x"00000000";
  signal s_oRead2:  std_logic_vector(31 downto 0):= x"00000000";

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  dmem: MySecondRISCVDatapath
  
  port map (iClk     => CLK,
  iRst  => s_iRst,
  iRs1=> s_iRs1,
  iRs2     => s_iRs2,
  iRd     => s_iRd,
  iImm  => s_iImm,
  iMemReadORWrite     => s_iMemReadORWrite,
  iRegWrite     => s_iRegWrite,
  iALU_Src     => s_iALU_Src,
  iAddOrSub     => s_iAddOrSub,
  iMemToReg     => s_iMemToReg,
  oALUResult     => s_oALUResult,
  oMemData     => s_oMemData,
  oRead1=> s_oRead1,
  oRead2=> s_oRead2);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';   -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';   -- clock becomes a 0 (negative edge)
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

   

  --Test 1: reset signals
  s_iRst<= '1';
  s_iMemReadORWrite  <= '0';
  s_iRegWrite <= '0'; --Make sure is 0
  s_iALU_Src   <= '0';
  wait for gCLK_HPER*4;

  s_iRst<= '0';
  wait for gCLK_HPER*2;

  --Test 2: addi x25 ,zero ,0
  s_iRs1   <= "00000"; --zero
  s_iRs2   <= (others => '0');
  s_iRd    <= "11001"; --x25
  s_iImm   <= x"000"; --0 decimal
  s_iALU_Src<= '1'; --Immi or data2? (1 for immi, 2 for data2)
  s_iAddOrSub     <= '0'; --Adding or subtractor registers? (0 for add, 1 for sub)
  s_iMemReadORWrite <= '0'; --Reading or writing from memory?
  s_iMemToReg     <= '0'; --Writing from memory to a register?
  s_iRegWrite     <= '1'; --Writing to a register?
  wait for gCLK_HPER*4;
--Load &A into x25 , assuming x25 initially has 0x10010000 and a[0] is at 0x10010000
--Expected: 
--s_oALUResult = 0x0000 0000
--s_oMemdata = DONT CARE
--s_oRead1 = 0x0000 0000
--s_oRead2 = DONT CARE

  --Test 3: addi x26 ,zero ,256
  s_iRs1<= "00000"; --zero
s_iRd <= "11010"; --x26
s_iImm<= x"054"; --84 decimal
s_iALU_Src  <= '1';
s_iAddOrSub <= '0';
s_iMemReadORWrite <= '0';
s_iMemToReg <= '0';
s_iRegWrite <= '1';
  wait for gCLK_HPER*4;
--Load &B into x26 , assuming x26 initially has 0x10010000 and b[0] is at 0x10010100
--Expected:
--s_oALUResult = 0x0000 0054
--s_oMemdata = DONT CARE
--s_oRead1 = 0x0000 0000
--s_oRead2 = DONT CARE

  --Test 4: lw x1 , 0( x25)
  s_iRs1     <= "11001";--x25
  s_iRs2     <= (others=>'0');
  s_iRd<= "00001"; --x1
  s_iImm     <= x"000"; --offset 0
  s_iALU_Src <= '1';
  s_iAddOrSub<= '0';
  s_iMemReadORWrite<= '0';
  s_iMemToReg<= '1';
  s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--Load A[0] into x1
--Expected: s_oALUResult = 0xFFFFFFFF

  --Test 5: lw x2, 4(x25)
  s_iRs1     <= "11001"; --x25
s_iRs2     <= (others=>'0');
s_iRd<= "00010"; --x2
s_iImm     <= x"004"; --offset 4
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '1';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--Load A[1] into x2
--Expected: s_oALUResult = 0x00000003

  --Test 6: add x1, x1, x2
  s_iRs1     <= "00001"; --x1
s_iRs2     <= "00010"; --x2
s_iRd<= "00001"; --x1
s_iImm     <= (others=>'0');
s_iALU_Src <= '0';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--x1 = x1 + x2
--Expected: s_oALUResult = 0x00000002

  --Test 7: sw x1, 0(x26)
  s_iRs1     <= "11010"; --x26
s_iRs2     <= "00001";--x1
s_iRd<= (others=>'0');
s_iImm     <= x"000"; --offset 0
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '0';
s_iMemReadORWrite<= '1';
wait for gCLK_HPER*2;
s_iMemReadORWrite<= '0';
wait for gCLK_HPER*2;
--Store x1 -> B[0]
--Expected: s_oALUResult = 0x0000A000

  --Test 8: lw x2, 8(x25)
  s_iRs1     <= "11001"; --x25
s_iRs2     <= (others=>'0');
s_iRd<= "00010"; --x2
s_iImm     <= x"008"; --offset 8
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '1';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--Load A[2] into x2
--Expected: s_oALUResult = 0x___

  --Test 9: add x1, x1, x2
  s_iRs1     <= "00001"; --x1
s_iRs2     <= "00010"; --x2
s_iRd<= "00001"; --x1
s_iImm     <= (others=>'0');
s_iALU_Src <= '0';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--x1 = x1 + x2
--Expected: s_oALUResult = 0x___

  --Test 10: sw x1, 4(x26)
  s_iRs1     <= "11010"; --x26
s_iRs2     <= "00001";--x1
s_iRd<= (others=>'0');
s_iImm     <= x"004"; --offset 4
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '0';
s_iMemReadORWrite<= '1';
wait for gCLK_HPER*2;
s_iMemReadORWrite<= '0';
wait for gCLK_HPER*2;
--Store x1 -> B[0]
--Expected: s_oALUResult = 0x____

  --Test 11: lw x2, 12(x25)
  s_iRs1     <= "11001"; --x25
s_iRs2     <= (others=>'0');
s_iRd<= "00010"; --x2
s_iImm     <= x"00C"; --offset 12
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '1';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--Load A[2] into x2
--Expected: s_oALUResult = 0x___

  --Test 12: add x1, x1, x2
  s_iRs1     <= "00001"; --x1
s_iRs2     <= "00010"; --x2
s_iRd<= "00001"; --x1
s_iImm     <= (others=>'0');
s_iALU_Src <= '0';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--x1 = x1 + x2
--Expected: s_oALUResult = 0x___

  --Test 13: sw x1, 8(x26)
  s_iRs1     <= "11010"; --x26
s_iRs2     <= "00001";--x1
s_iRd<= (others=>'0');
s_iImm     <= x"008"; --offset 8
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '0';
s_iMemReadORWrite<= '1';
wait for gCLK_HPER*2;
s_iMemReadORWrite<= '0';
wait for gCLK_HPER*2;
--Store x1 -> B[0]
--Expected: s_oALUResult = 0x____

  --Test 14: lw x2, 16(x25)
  s_iRs1     <= "11001"; --x25
s_iRs2     <= (others=>'0');
s_iRd<= "00010"; --x2
s_iImm     <= x"010"; --offset 16
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '1';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--Load A[2] into x2
--Expected: s_oALUResult = 0x___

  --Test 15: add x1, x1, x2
  s_iRs1     <= "00001"; --x1
s_iRs2     <= "00010"; --x2
s_iRd<= "00001"; --x1
s_iImm     <= (others=>'0');
s_iALU_Src <= '0';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--x1 = x1 + x2
--Expected: s_oALUResult = 0x___

  --Test 16: sw x1, 12(x26)
  s_iRs1     <= "11010"; --x26
s_iRs2     <= "00001";--x1
s_iRd<= (others=>'0');
s_iImm     <= x"00C"; --offset 12
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '0';
s_iMemReadORWrite<= '1';
wait for gCLK_HPER*2;
s_iMemReadORWrite<= '0';
wait for gCLK_HPER*2;
--Store x1 -> B[0]
--Expected: s_oALUResult = 0x____

  --Test 17: lw x2, 20(x25)
  s_iRs1     <= "11001"; --x25
s_iRs2     <= (others=>'0');
s_iRd<= "00010"; --x2
s_iImm     <= x"014"; --offset 20
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '1';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--Load A[2] into x2
--Expected: s_oALUResult = 0x___

  --Test 18: add x1, x1, x2
  s_iRs1     <= "00001"; --x1
s_iRs2     <= "00010"; --x2
s_iRd<= "00001"; --x1
s_iImm     <= (others=>'0');
s_iALU_Src <= '0';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--x1 = x1 + x2
--Expected: s_oALUResult = 0x___

  --Test 19: sw x1, 16(x26)
  s_iRs1     <= "11010"; --x26
s_iRs2     <= "00001";--x1
s_iRd<= (others=>'0');
s_iImm     <= x"010"; --offset 16
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '0';
s_iMemReadORWrite<= '1';
wait for gCLK_HPER*2;
s_iMemReadORWrite<= '0';
wait for gCLK_HPER*2;
--Store x1 -> B[0]
--Expected: s_oALUResult = 0x____

  --Test 20: lw x2, 24(x25)
  s_iRs1     <= "11001"; --x25
s_iRs2     <= (others=>'0');
s_iRd<= "00010"; --x2
s_iImm     <= x"018"; --offset 20
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '1';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--Load A[2] into x2
--Expected: s_oALUResult = 0x___

  --Test 21: add x1, x1, x2
  s_iRs1     <= "00001"; --x1
s_iRs2     <= "00010"; --x2
s_iRd<= "00001"; --x1
s_iImm     <= (others=>'0');
s_iALU_Src <= '0';
s_iAddOrSub<= '0';
s_iMemReadORWrite<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '1';
  wait for gCLK_HPER*4;
--x1 = x1 + x2
--Expected: s_oALUResult = 0x___

  --Test 22: addi x27 , zero , 512
  s_iRs1<= "00000"; --zero
s_iRd <= "11011"; --x27
s_iImm<= x"200"; --512 decimal
s_iALU_Src  <= '1';
s_iAddOrSub <= '0';
s_iMemReadORWrite <= '0';
s_iMemToReg <= '0';
s_iRegWrite <= '1';
  wait for gCLK_HPER*4;
--Load &B[64] into x27 , assumuning x27 initially has 0 x10010000 and b[0] is at 0 x10010100
--Expected: s_oALUResult = 0x___

  --Test 23: sw x1 , -4( x27)
  s_iRs1     <= "11011"; --x27
s_iRs2     <= "00001";--x1
s_iRd<= (others=>'0');
s_iImm     <= x"FFD"; --offset -4
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '0';
s_iMemReadORWrite<= '1';
wait for gCLK_HPER*2;
s_iMemReadORWrite<= '0';
wait for gCLK_HPER*2;
--Store x1 into B[63]
--Expected: s_oALUResult = 0x____

  --Test 24: sw x1 , -4( x27)
  s_iRs1     <= "11011"; --x27
s_iRs2     <= "00001";--x1
s_iRd<= (others=>'0');
s_iImm     <= x"FFD"; --offset -4
s_iALU_Src <= '1';
s_iAddOrSub<= '0';
s_iMemToReg<= '0';
s_iRegWrite<= '0';
s_iMemReadORWrite<= '1';
wait for gCLK_HPER*2;
s_iMemReadORWrite<= '0';
wait for gCLK_HPER*2;
--Store x1 into B[63]
--Expected: s_oALUResult = 0x____

    wait;
  end process;

end mixed;
