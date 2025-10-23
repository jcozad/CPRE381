--Structural modeling describes the interconnection of components or entities (like gates, --modules, or other components). It’s like connecting pieces of hardware together. You --instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Sum : out STD_LOGIC;
           Cout : out STD_LOGIC);
end FullAdder;

architecture Structural of FullAdder is

    component XOR_Gate
        Port ( A, B : in STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component AND_Gate
        Port ( A, B : in STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    component OR_Gate
        Port ( A, B : in STD_LOGIC;
               Y : out STD_LOGIC);
    end component;

    signal temp1, temp2, temp3 : STD_LOGIC;

begin
    -- Instantiating XOR, AND, and OR gates to build the full adder logic
    XOR1: XOR_Gate Port map (A, B, temp1);
    XOR2: XOR_Gate Port map (temp1, Cin, Sum);
    AND1: AND_Gate Port map (A, B, temp2);
    AND2: AND_Gate Port map (temp1, Cin, temp3);
    OR1: OR_Gate Port map (temp2, temp3, Cout);

end Structural;

