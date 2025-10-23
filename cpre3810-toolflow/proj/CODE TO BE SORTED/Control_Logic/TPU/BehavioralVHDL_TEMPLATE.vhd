--Behavior describes the functionality of a system without specifying the exact hardware --structure or data flow. It focuses on what the design does rather than how it does it

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Sum : out STD_LOGIC;
           Cout : out STD_LOGIC);
end FullAdder;

architecture Behavioral of FullAdder is
begin
    process (A, B, Cin)
    begin
        Sum <= A xor B xor Cin;  -- Sum is computed as the XOR of inputs
        Cout <= (A and B) or (Cin and (A xor B));  -- Carry-out logic
    end process;
end Behavioral;

