--Structural modeling describes the interconnection of components or entities (like gates, --modules, or other components). It’s like connecting pieces of hardware together. You --instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity N_bit_Register is

generic(N : integer := 32);
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           WrEnable : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR(N-1 downto 0);
           Q : out STD_LOGIC_VECTOR(N-1 downto 0));
end N_bit_Register;

architecture Structural of N_bit_Register is

    component dffg
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
    end component;

    --signal temp1, temp2, temp3 : STD_LOGIC;

begin
 

  N_Bit_reg: for i in 0 to N-1 generate
    N_Register: dffg Port map (Clk, Rst, WrEnable, Data(i), Q(i));
  end generate N_Bit_reg;

end Structural;

