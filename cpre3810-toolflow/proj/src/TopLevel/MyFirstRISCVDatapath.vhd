--Structural modeling describes the interconnection of components or entities (like gates, --modules, or other components). It’s like connecting pieces of hardware together. You --instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MyFirstRISCVDatapath is
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
end MyFirstRISCVDatapath;

architecture Structural of MyFirstRISCVDatapath is

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

    signal muxsTOFulladder : STD_LOGIC_VECTOR(31 downto 0);
    signal register1TOALU : STD_LOGIC_VECTOR(31 downto 0);
    signal register2TOALU : STD_LOGIC_VECTOR(31 downto 0);
    signal sTOData : STD_LOGIC_VECTOR(31 downto 0);

begin
    -- Instantiating XOR, AND, and OR gates to build the full adder logic
    --XOR1: XOR_Gate Port map (A, B, temp1);
    RegisterFile: Register_File Port map (rs1, rs2, rd, Clk, sTOData, We, Reset, register1TOALU, register2TOALU);

    Bit_32_Mux: mux2t1_N Port map (ALU_Src, register2TOALU, Immi, muxsTOFulladder); --maybe try register1TOALU if this doesn't work

    ALUUnit: Adder_Subtractor Port map (register1TOALU, muxsTOFulladder, Add_Sub, sTOData, Cout);

    Sum <= sTOData;

end Structural;

