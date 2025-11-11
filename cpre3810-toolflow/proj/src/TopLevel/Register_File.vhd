--Structural modeling describes the interconnection of components or entities (like gates, --modules, or other components). It’s like connecting pieces of hardware together. You --instantiate entities and wire them together to form a larger system.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_File is

    Port ( rs1 : in STD_LOGIC_VECTOR(4 downto 0); --Register to read
           rs2 : in STD_LOGIC_VECTOR(4 downto 0); --Register to read
           rd : in STD_LOGIC_VECTOR(4 downto 0); --Register to write to
           Clk : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR(31 downto 0); --Data to be written
           We : in STD_LOGIC; --Enable if writing
           Reset : in STD_LOGIC;
           Data1 : out STD_LOGIC_VECTOR(31 downto 0);
           Data2 : out STD_LOGIC_VECTOR(31 downto 0));
end Register_File;

architecture Structural of Register_File is

    component DF_5to32_Decoder
    Port ( D_IN : in STD_LOGIC_VECTOR(4 downto 0);
           F_OUT : out STD_LOGIC_VECTOR(31 downto 0);
           enable : in std_logic);
    end component;

    component bit32_32_1Mux
    Port (sclt : in STD_LOGIC_VECTOR(4 downto 0);
	datainput0 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput1 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput2 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput3 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput4 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput5 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput6 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput7 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput8 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput9 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput10 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput11 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput12 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput13 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput14 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput15 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput16 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput17 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput18 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput19 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput20 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput21 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput22 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput23 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput24 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput25 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput26 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput27 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput28 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput29 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput30 : in STD_LOGIC_VECTOR(31 downto 0);
	datainput31 : in STD_LOGIC_VECTOR(31 downto 0);
	data_OUT : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component N_bit_Register
	generic(N : integer := 32);
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           WrEnable : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR(N-1 downto 0);
           Q : out STD_LOGIC_VECTOR(N-1 downto 0));
    end component;

    signal decoderTORegister: STD_LOGIC_VECTOR(31 downto 0);

    --Create 32 * 32-Bit signals
    subtype word_t is STD_LOGIC_VECTOR(31 downto 0);
    type reg_array_t is array (0 to 31) of word_t;

    signal registerTOMUX : reg_array_t;
    constant ZERO_32 : std_logic_vector(31 downto 0) := (others => '0');

begin

    Decoder_5_32: DF_5to32_Decoder Port map (rd, decoderTORegister, We);

N_Register_ZERO: N_bit_Register Port map (Clk, Reset, decoderTORegister(0), ZERO_32, registerTOMUX(0));

  N_Bit_reg: for i in 1 to 31 generate

    N_Register: N_bit_Register Port map (Clk, Reset, decoderTORegister(i), Data, registerTOMUX(i));
  end generate N_Bit_reg;

u_mux1 : bit32_32_1Mux
Port map (
    sclt      => rs1,
    datainput0  => registerTOMUX(0), 
    datainput1  => registerTOMUX(1),
    datainput2  => registerTOMUX(2),
    datainput3  => registerTOMUX(3),
    datainput4  => registerTOMUX(4),
    datainput5  => registerTOMUX(5),
    datainput6  => registerTOMUX(6),
    datainput7  => registerTOMUX(7),
    datainput8  => registerTOMUX(8),
    datainput9  => registerTOMUX(9),
    datainput10 => registerTOMUX(10),
    datainput11 => registerTOMUX(11),
    datainput12 => registerTOMUX(12),
    datainput13 => registerTOMUX(13),
    datainput14 => registerTOMUX(14),
    datainput15 => registerTOMUX(15),
    datainput16 => registerTOMUX(16),
    datainput17 => registerTOMUX(17),
    datainput18 => registerTOMUX(18),
    datainput19 => registerTOMUX(19),
    datainput20 => registerTOMUX(20),
    datainput21 => registerTOMUX(21),
    datainput22 => registerTOMUX(22),
    datainput23 => registerTOMUX(23),
    datainput24 => registerTOMUX(24),
    datainput25 => registerTOMUX(25),
    datainput26 => registerTOMUX(26),
    datainput27 => registerTOMUX(27),
    datainput28 => registerTOMUX(28),
    datainput29 => registerTOMUX(29),
    datainput30 => registerTOMUX(30),
    datainput31 => registerTOMUX(31),
    data_OUT    => data1
);

u_mux2 : bit32_32_1Mux
Port map (
    sclt      => rs2,
    datainput0  => registerTOMUX(0), 
    datainput1  => registerTOMUX(1),
    datainput2  => registerTOMUX(2),
    datainput3  => registerTOMUX(3),
    datainput4  => registerTOMUX(4),
    datainput5  => registerTOMUX(5),
    datainput6  => registerTOMUX(6),
    datainput7  => registerTOMUX(7),
    datainput8  => registerTOMUX(8),
    datainput9  => registerTOMUX(9),
    datainput10 => registerTOMUX(10),
    datainput11 => registerTOMUX(11),
    datainput12 => registerTOMUX(12),
    datainput13 => registerTOMUX(13),
    datainput14 => registerTOMUX(14),
    datainput15 => registerTOMUX(15),
    datainput16 => registerTOMUX(16),
    datainput17 => registerTOMUX(17),
    datainput18 => registerTOMUX(18),
    datainput19 => registerTOMUX(19),
    datainput20 => registerTOMUX(20),
    datainput21 => registerTOMUX(21),
    datainput22 => registerTOMUX(22),
    datainput23 => registerTOMUX(23),
    datainput24 => registerTOMUX(24),
    datainput25 => registerTOMUX(25),
    datainput26 => registerTOMUX(26),
    datainput27 => registerTOMUX(27),
    datainput28 => registerTOMUX(28),
    datainput29 => registerTOMUX(29),
    datainput30 => registerTOMUX(30),
    datainput31 => registerTOMUX(31),
    data_OUT    => data2
);



end Structural;

