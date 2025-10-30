--Structural modeling describes the interconnection of components or entities (like gates, --modules, or other components). It’s like connecting pieces of hardware together. You --instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_xor is
    Port ( A : in std_logic_vector(31 downto 0);
           B : in std_logic_vector(31 downto 0);
           andORxor : in STD_LOGIC;
           outVal : out std_logic_vector(31 downto 0));
end and_xor;

architecture Structural of and_xor is

    component xorg2_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
    end component;

    component andg2_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
    end component;

    component mux2t1_N
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

    end component;

    signal orOut : std_logic_vector(31 downto 0);
    signal andOut : std_logic_vector(31 downto 0);

begin
    -- Instantiating XOR, AND, and OR gates to build the full adder logic
    xorg2: xorg2_N Port map (A, B, orOut);
    andg2: andg2_N Port map (A, B, andOut);
    mux2t1: mux2t1_N Port map (andORxor, andOut, orOut, outVal);

end Structural;

