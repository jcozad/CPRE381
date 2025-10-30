--Structural modeling describes the interconnection of components or entities (like gates, --modules, or other components). It’s like connecting pieces of hardware together. You --instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder_Subtractor is

generic(N : integer := 32);
    Port ( A : in std_logic_vector(N-1 downto 0);
           B : in std_logic_vector(N-1 downto 0);
           nAdd_Sub : in STD_LOGIC;
           Sum : out std_logic_vector(N-1 downto 0);
           Cout : out STD_LOGIC);
end Adder_Subtractor;

architecture Structural of Adder_Subtractor is

    component onescomp_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Input         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component N_bit_Ripple_Adder_STRUC

	generic(N : integer := 32);
  port(i_A               : in std_logic_vector(N-1 downto 0);
       i_B               : in std_logic_vector(N-1 downto 0);
       i_Cin               : in std_logic;
       o_Cout               : out std_logic;
       o_S               : out std_logic_vector(N-1 downto 0));
    end component;

    component mux2t1_N

  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

    end component;

    signal mySignal : std_logic_vector(N-1 downto 0);
    signal mySignal2 : std_logic_vector(N-1 downto 0);

begin
    
    NBIT_NOT: onescomp_N Port map (B, mySignal);

    NBIT_2T1MUX: mux2t1_N Port map (nAdd_Sub, B, mySignal, mySignal2);

    NBIT_ADDER: N_bit_Ripple_Adder_STRUC Port map (mySignal2, A, nAdd_Sub, Cout, Sum);

end Structural;

