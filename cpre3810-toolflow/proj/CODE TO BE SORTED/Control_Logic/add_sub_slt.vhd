--Structural modeling describes the interconnection of components or entities (like gates, --modules, or other components). It’s like connecting pieces of hardware together. You --instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_sub_slt is
    Port ( A : in std_logic_vector(31 downto 0);
           B : in std_logic_vector(31 downto 0);
           AddORSub : in STD_LOGIC; --0 is add, 1 is sub
           DoSlt : in STD_LOGIC;
           Cout : out STD_LOGIC;
           Output : out std_logic_vector(31 downto 0));
end add_sub_slt;

architecture Structural of add_sub_slt is

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

    component extender_1to32
    port (
        ivalue : in  STD_LOGIC;
        ovalue : out STD_LOGIC_VECTOR(31 downto 0)
    );
    end component;

    signal AddSubTOExtenderANDmux : std_logic_vector(31 downto 0);
    signal extenderTOMux : std_logic_vector(31 downto 0);

begin
    
    AdderSub: Adder_Subtractor Port map (A, B, AddORSub, AddSubTOExtenderANDmux, Cout);
    extender: extender_1to32 Port map (AddSubTOExtenderANDmux(31), extenderTOMux);
    mux2to1: mux2t1_N Port map (DoSlt, AddSubTOExtenderANDmux, extenderTOMux, Output);

end Structural;

