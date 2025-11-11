--Structural modeling describes the interconnection of components or entities (like gates, 
--modules, or other components). It’s like connecting pieces of hardware together. You 
--instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2t1_STR is
    Port ( i_D0 : in STD_LOGIC;
           i_D1 : in STD_LOGIC;
	   i_S  : in STD_LOGIC;
           o_O : out STD_LOGIC);
end mux2t1_STR;

architecture Structural of mux2t1_STR is

    component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
    end component;

    component invg
  port(i_A          : in std_logic;
       o_F          : out std_logic);
    end component;

    component andg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
    end component;

    signal signal1, signal2, signal3 : STD_LOGIC;

begin
    

	NOT1: invg Port map (i_S, signal1);

	AND1: andg2 Port map (signal1, i_D0, signal2);
	AND2: andg2 Port map (i_D1, i_S, signal3);

	OR1: org2 Port map (signal2, signal3, o_O);

end Structural;

