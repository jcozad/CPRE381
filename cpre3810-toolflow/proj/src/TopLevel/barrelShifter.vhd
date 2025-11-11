library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrelShifter is
  Port (
    shiftAmount         : in  std_logic_vector(4 downto 0);
    leftORright         : in  std_logic;        -- '0' = left, '1' = right
    logicalORarithmatic : in  std_logic;        -- when RIGHT: '0' = SRL, '1' = SRA
    dataIN              : in  std_logic_vector(31 downto 0);
    dataOUT             : out std_logic_vector(31 downto 0)
  );
end barrelShifter;

architecture behavioral of barrelShifter is
begin
  process(dataIN, shiftAmount, leftORright, logicalORarithmatic)
    variable n   : natural;
    variable res : std_logic_vector(31 downto 0);
  begin
    n   := to_integer(unsigned(shiftAmount));
    res := (others => '0');  -- default to avoid latches

    if leftORright = '0' and logicalORarithmatic = '0' then
      --LEFT shift (logical; arithmetic-left is identical)
      res := std_logic_vector(shift_left(unsigned(dataIN), n));
    else
      -- RIGHT shift
      if logicalORarithmatic = '1' then
        --SRA: arithmetic right (sign-extend)
        res := std_logic_vector(shift_right(signed(dataIN), n));
      else
        --SRL: logical right (zero-fill)
        res := std_logic_vector(shift_right(unsigned(dataIN), n));
      end if;
    end if;

    dataOUT <= res;
  end process;
end behavioral;