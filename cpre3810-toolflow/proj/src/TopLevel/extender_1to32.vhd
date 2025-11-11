library IEEE;
use IEEE.std_logic_1164.all;

entity extender_1to32 is
    port (
        ivalue : in  STD_LOGIC;
        ovalue : out STD_LOGIC_VECTOR(31 downto 0)
    );
end extender_1to32;

architecture behavioral of extender_1to32 is
begin
    process(ivalue)
    begin
        --Set all bits to '0' EXCEPT the rightmost one so it would be like x"00000001" or x"00000000"
        ovalue <= (31 downto 1 => '0') & ivalue;
    end process;
end behavioral;
