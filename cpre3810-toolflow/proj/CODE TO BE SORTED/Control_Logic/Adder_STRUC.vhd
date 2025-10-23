--Structural modeling describes the interconnection of components or entities (like gates, --modules, or other components). It’s like connecting pieces of hardware together. You --instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder_STRUC is

  port(i_A               : in std_logic;
       i_B               : in std_logic;
       i_Cin               : in std_logic;
       o_Cout               : out std_logic;
       o_S               : out std_logic);

end Adder_STRUC;

architecture Structural of Adder_STRUC is

    component andg2
          port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
    end component;

    component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
    end component;

    component xorg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
    end component;

    signal signal1, signal2, signal3, signal4  : STD_LOGIC;

begin
 
    XOR1: xorg2 Port map (i_B, i_Cin, signal1);

    XOR2: xorg2 Port map (signal1, i_A, o_S);
    XOR3: xorg2 Port map (i_B, i_A, signal2);

    AND1: andg2 Port map (signal2, i_Cin, signal3);
    AND2: andg2 Port map (i_B, i_A, signal4);

    OR1: org2 Port map (signal3, signal4, o_Cout);

end Structural;

