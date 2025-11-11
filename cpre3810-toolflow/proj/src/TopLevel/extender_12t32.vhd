library IEEE;
use IEEE.std_logic_1164.all;

--extend type for I "000"


entity extender_12t32 is
  port(
    ivalue : in  std_logic_vector(31 downto 0);  
    immType : in  std_logic_vector(2 downto 0);  
    ovalue : out std_logic_vector(31 downto 0)   --sign-extended
  );
end extender_12t32;

architecture dataflow of extender_12t32 is
begin

  --I-type: imm[11:0] = inst[31:20]; sign bit is inst(31)
  ovalue <= (31 downto 12 => ivalue(31)) & ivalue(31 downto 20)
            when immType = "000"
            else (others => '0');

end dataflow;

