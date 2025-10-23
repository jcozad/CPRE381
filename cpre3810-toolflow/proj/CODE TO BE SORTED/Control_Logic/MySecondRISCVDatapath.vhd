library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity MySecondRISCVDatapath is
    port (
        iClk       : in std_logic;
        iRst       : in std_logic;
        iRs1        : in std_logic_vector(4 downto 0);
        iRs2        : in std_logic_vector(4 downto 0);
        iRd        : in std_logic_vector(4 downto 0);
        iImm       : in std_logic_vector(11 downto 0);
        iMemReadORWrite   : in std_logic;
        iRegWrite  : in std_logic;
        iALU_Src    : in std_logic;
        iAddOrSub     : in std_logic;
        iMemToReg     : in std_logic;
        oALUResult : out std_logic_vector(31 downto 0);
        oMemData   : out std_logic_vector(31 downto 0);
        oRead1     : out std_logic_vector(31 downto 0);
        oRead2     : out std_logic_vector(31 downto 0));

end MySecondRISCVDatapath;

architecture Structural of MySecondRISCVDatapath is

    component Adder_Subtractor
	generic(N : integer := 32);
    Port ( A : in std_logic_vector(N-1 downto 0);
           B : in std_logic_vector(N-1 downto 0);
           nAdd_Sub : in STD_LOGIC;
           Sum : out std_logic_vector(N-1 downto 0);
           Cout : out STD_LOGIC);
    end component;

    component mux2t1_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component extender_12t32
  port(
    ivalue : in  std_logic_vector(11 downto 0);  --imm[11:0]
    ovalue : out std_logic_vector(31 downto 0)   --sign-extended
  );
    end component;

    component Register_File
    Port ( rs1 : in STD_LOGIC_VECTOR(4 downto 0); --Register to read
           rs2 : in STD_LOGIC_VECTOR(4 downto 0); --Register to read
           rd : in STD_LOGIC_VECTOR(4 downto 0); --Register to write to
           Clk : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR(31 downto 0); --Data to be written
           We : in STD_LOGIC; --Enable if writing
           Reset : in STD_LOGIC;
           Data1 : out STD_LOGIC_VECTOR(31 downto 0);
           Data2 : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component mem
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

    signal muxsTOAdder_Sub : STD_LOGIC_VECTOR(31 downto 0);
    signal register1TOALU : STD_LOGIC_VECTOR(31 downto 0);
    signal register2TOALU : STD_LOGIC_VECTOR(31 downto 0);
    signal muxTOData : STD_LOGIC_VECTOR(31 downto 0);
    signal AddSuberTOMemory : STD_LOGIC_VECTOR(31 downto 0);
    signal MemoryTO2t1mux : STD_LOGIC_VECTOR(31 downto 0);
    signal extenderTOMUX : STD_LOGIC_VECTOR(31 downto 0);

    signal truncAddr : std_logic_vector(9 downto 0);
    signal dmemAddr  : natural range 0 to 1023;

    constant C_ADDR_WIDTH : natural := 10;

begin

    truncAddr <= AddSuberTOMemory(11 downto 2);

    RegisterFile: Register_File Port map (iRs1, iRs2, iRd, iClk, muxTOData, iRegWrite, iRst, register1TOALU, register2TOALU);

    firstMux: mux2t1_N Port map (iALU_Src, register2TOALU, extenderTOMUX, muxsTOAdder_Sub); --maybe try register1TOALU if this doesn't work

    ALUUnit: Adder_Subtractor Port map (register1TOALU, muxsTOAdder_Sub, iAddOrSub, AddSuberTOMemory); --Cout not linked to anything

    Memory: mem Port map (iClk, truncAddr, register2TOALU, iMemReadORWrite, MemoryTO2t1mux);

    secondMUX: mux2t1_N Port map (iMemToReg, MemoryTO2t1mux, AddSuberTOMemory, muxTOData);

    extender12to32: extender_12t32 Port map (iImm, extenderTOMUX);

    --Signals to observe output from
    oRead1 <= register1TOALU;
    oRead2 <= register2TOALU;
    oALUResult <= AddSuberTOMemory;
    oMemData <= MemoryTO2t1mux;

end Structural;
