--Behavior describes the functionality of a system without specifying the exact hardware --structure or data flow. It focuses on what the design does rather than how it does it

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Logic is
    Port ( Opcode : in std_logic_vector(6 downto 0);
           ALUSrc : out STD_LOGIC;
           ALUControl : out STD_LOGIC;
           ImmType : out std_logic_vector(2 downto 0);
           ResultSrc : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end Control_Logic;

architecture Behavioral of Control_Logic is
begin
    process (Opcode)
    begin

	   ALUSrc <= '0';
           ALUControl <= '0';
           ImmType <= "000"; 
           ResultSrc <= '0';
           MemWrite <= '0';
           RegWrite <= '0';

        if Opcode = "0110011" then --R-Type Opcode
	   ALUSrc <= '0';
           ALUControl <= '0';
           --ImmType <= "XXX"; 
           ResultSrc <= '0';
           MemWrite <= '0';
           RegWrite <= '1';
        --elsif Opcode = "0000000" then --TYPE
	   
	end if;

    end process;
end Behavioral;

