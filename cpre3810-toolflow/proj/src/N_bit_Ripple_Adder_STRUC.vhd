--Structural modeling describes the interconnection of components or entities (like gates, --modules, or other components). It’s like connecting pieces of hardware together. You --instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity N_bit_Ripple_Adder_STRUC is

	generic(N : integer := 32);

  port(i_A               : in std_logic_vector(N-1 downto 0);
       i_B               : in std_logic_vector(N-1 downto 0);
       i_Cin               : in std_logic;
       o_Cout               : out std_logic;
       o_S               : out std_logic_vector(N-1 downto 0));

end N_bit_Ripple_Adder_STRUC;

architecture Structural of N_bit_Ripple_Adder_STRUC is

    component Adder_STRUC
  port(i_A               : in std_logic;
       i_B               : in std_logic;
       i_Cin               : in std_logic;
       o_Cout               : out std_logic;
       o_S               : out std_logic);
    end component;

    signal mySignal : std_logic_vector(N-1 downto 0);

begin

AdderRippleStart: Adder_STRUC port map(
              i_A      => i_A(0),      
              i_B     => i_B(0),  
              i_Cin     => i_Cin, 
              o_Cout      => mySignal(0),  
              o_S      => o_S(0));

  G_NBit_Adder: for i in 1 to N-2 generate
    AdderRipple_N_bits: Adder_STRUC port map(
              i_A      => i_A(i),      
              i_B     => i_B(i),  
              i_Cin     => mySignal(i-1), 
              o_Cout      => mySignal(i),  
              o_S      => o_S(i)); 
  end generate G_NBit_Adder;

AdderRippleEnd: Adder_STRUC port map(
              i_A      => i_A(N-1),      
              i_B     => i_B(N-1),  
              i_Cin     => mySignal(N-2), 
              o_Cout      => o_Cout,  
              o_S      => o_S(N-1));

end Structural;

