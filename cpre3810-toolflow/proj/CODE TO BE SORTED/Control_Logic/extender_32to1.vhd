library IEEE;
use IEEE.std_logic_1164.all;

entity extender_32to1 is
    port (
        ivalue : in  STD_LOGIC_VECTOR(31 downto 0);
        ovalue : out STD_LOGIC
    );
end extender_32to1;

architecture dataflow of extender_32to1 is
begin
    ovalue <= '1' when ivalue = (31 downto 0 => '1') else
              '0' when ivalue = (31 downto 0 => '0') else
              '0';
end dataflow;

