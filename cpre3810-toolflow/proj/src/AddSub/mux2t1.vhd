--Dataflow modeling describes the flow of data between components or signals. It defines how --values are computed, typically using signal assignments to represent the flow of data directly

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2t1 is
    Port ( i_D0 : in STD_LOGIC;
           i_D1 : in STD_LOGIC;
	   i_S  : in STD_LOGIC;
           o_O : out STD_LOGIC);
end mux2t1;

architecture Dataflow of mux2t1 is
begin

	o_O <= (i_S and i_D1) or ((not i_S) and i_D0);
  

end Dataflow;

