library IEEE;
use IEEE.std_logic_1164.all;

entity extender_12t32 is
  port(
    ivalue : in  std_logic_vector(11 downto 0);  --imm[11:0]
    ovalue : out std_logic_vector(31 downto 0)   --sign-extended
  );
end extender_12t32;

architecture rtl of extender_12t32 is
begin
  --replicate sign bit (ivalue(11)) into bits 31..12, then append ivalue
  ovalue <= (31 downto 12 => ivalue(11)) & ivalue;
end rtl;

