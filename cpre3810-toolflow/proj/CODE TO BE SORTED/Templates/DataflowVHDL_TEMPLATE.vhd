--Dataflow modeling describes the flow of data between components or signals. It defines how --values are computed, typically using signal assignments to represent the flow of data directly

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Sum : out STD_LOGIC;
           Cout : out STD_LOGIC);
end FullAdder;

architecture Dataflow of FullAdder is
begin
    Sum <= (A xor B) xor Cin;  -- Sum is the result of the XOR operations
    Cout <= (A and B) or ((A xor B) and Cin);  -- Cout is the carry-out

end Dataflow;

