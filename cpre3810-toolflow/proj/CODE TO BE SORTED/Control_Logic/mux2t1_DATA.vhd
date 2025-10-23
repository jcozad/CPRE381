--Dataflow modeling describes the flow of data between components or signals. It defines how --values are computed, typically using signal assignments to represent the flow of data directly

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2t1_DATA is
    Port ( ii_D0 : in STD_LOGIC;
           ii_D1 : in STD_LOGIC;
	   ii_S  : in STD_LOGIC;
           oo_O : out STD_LOGIC);
end mux2t1_DATA;

architecture Dataflow of mux2t1_DATA is
begin

	oo_O <= (ii_S and ii_D1) or ((not ii_S) and ii_D0);
  

end Dataflow;

