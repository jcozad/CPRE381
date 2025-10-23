--Behavior describes the functionality of a system without specifying the exact hardware --structure or data flow. It focuses on what the design does rather than how it does it

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Fetch_Logic is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           InputData : in STD_LOGIC_VECTOR(31 downto 0);
           PRSrc : in STD_LOGIC;
           NextInstAddress : out STD_LOGIC_VECTOR(31 downto 0));
end Fetch_Logic;

architecture Structural of Fetch_Logic is

    component mux2t1_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component N_bit_Register
    	generic(N : integer := 32);
    	Port ( Clk : in STD_LOGIC;
           	Rst : in STD_LOGIC;
           	WrEnable : in STD_LOGIC;
           	Data : in STD_LOGIC_VECTOR(N-1 downto 0);
           	Q : out STD_LOGIC_VECTOR(N-1 downto 0));
    end component;

    component N_bit_Ripple_Adder_STRUC
	generic(N : integer := 32);
  port(i_A               : in std_logic_vector(N-1 downto 0);
       i_B               : in std_logic_vector(N-1 downto 0);
       i_Cin               : in std_logic;
       o_Cout               : out std_logic;
       o_S               : out std_logic_vector(N-1 downto 0));
    end component;

    signal PCIn : STD_LOGIC_VECTOR(31 downto 0);
    signal PCOut : STD_LOGIC_VECTOR(31 downto 0);

    signal Adder4Out : STD_LOGIC_VECTOR(31 downto 0);
    signal AdderImmOut : STD_LOGIC_VECTOR(31 downto 0);

    signal Adder_OVERFLOW : std_logic;

begin

    Program_Counter: N_bit_Register Port map (Clk, Rst, '1', PCIn, PCOut);

    Adder_Plus_4: N_bit_Ripple_Adder_STRUC Port map (PCOut, x"00000004", '0', Adder_OVERFLOW, Adder4Out);
    Adder_Plus_Extended: N_bit_Ripple_Adder_STRUC Port map (Adder4Out, InputData, '0', Adder_OVERFLOW, AdderImmOut);

    Mux2to1_32out: mux2t1_N Port map (PRSrc, Adder4Out, AdderImmOut, PCIn);

    NextInstAddress <= PCOut;

end Structural;

