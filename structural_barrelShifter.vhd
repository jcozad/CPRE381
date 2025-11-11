library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity barrelShifter is
    port (
        shiftAmount    : in  std_logic_vector(4 downto 0);
        leftORright    : in  std_logic;             -- 0 = left, 1 = right
        logicalORarithmatic : in  std_logic;      -- (ignored here; logical only)
        dataIN         : in  std_logic_vector(31 downto 0);
        dataOUT        : out std_logic_vector(31 downto 0)
    );
end barrelShifter;

architecture Structural of barrelShifter is

    component mux2t1_N is
        generic (N : integer := 32);
        port (
            i_S  : in  std_logic;
            i_D0 : in  std_logic_vector(31 downto 0);
            i_D1 : in  std_logic_vector(31 downto 0);
            o_O  : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Intermediate signals
    signal stage0, stage1, stage2, stage3, stage4 : std_logic_vector(31 downto 0);
    signal shift1, shift2, shift4, shift8, shift16 : std_logic_vector(31 downto 0);

begin

    -- Shift by 1
    shift1  <= dataIN(30 downto 0) & '0'                when leftORright = '0' else
               '0' & dataIN(31 downto 1);
    mux0: mux2t1_N
        port map (
            i_S  => shiftAmount(0),
            i_D0 => dataIN,
            i_D1 => shift1,
            o_O  => stage0
        );

    -- Shift by 2
    shift2  <= stage0(29 downto 0) & "00"               when leftORright = '0' else
               "00" & stage0(31 downto 2);
    mux1: mux2t1_N
        port map (
            i_S  => shiftAmount(1),
            i_D0 => stage0,
            i_D1 => shift2,
            o_O  => stage1
        );

    -- Shift by 4
    shift4  <= stage1(27 downto 0) & X"0"               when leftORright = '0' else
               X"0" & stage1(31 downto 4);
    mux2: mux2t1_N
        port map (
            i_S  => shiftAmount(2),
            i_D0 => stage1,
            i_D1 => shift4,
            o_O  => stage2
        );

    -- Shift by 8
    shift8  <= stage2(23 downto 0) & X"00"              when leftORright = '0' else
               X"00" & stage2(31 downto 8);
    mux3: mux2t1_N
        port map (
            i_S  => shiftAmount(3),
            i_D0 => stage2,
            i_D1 => shift8,
            o_O  => stage3
        );

    -- Shift by 16
    shift16 <= stage3(15 downto 0) & X"0000"            when leftORright = '0' else
               X"0000" & stage3(31 downto 16);
    mux4: mux2t1_N
        port map (
            i_S  => shiftAmount(4),
            i_D0 => stage3,
            i_D1 => shift16,
            o_O  => stage4
        );

    -- Final output
    dataOUT <= stage4;

end Structural;library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity barrelShifter is
    port (
        shiftAmount        : in  std_logic_vector(4 downto 0);
        leftORright        : in  std_logic;             -- 0 = left, 1 = right
        logicalORarithmatic     : in  std_logic;             -- 0 = logical, 1 = arithmetic
        dataIN             : in  std_logic_vector(31 downto 0);
        dataOUT            : out std_logic_vector(31 downto 0)
    );
end barrelShifter;

architecture Structural of barrelShifter is

    component mux2t1_N is
        generic (N : integer := 32);
        port (
            i_S  : in  std_logic;
            i_D0 : in  std_logic_vector(31 downto 0);
            i_D1 : in  std_logic_vector(31 downto 0);
            o_O  : out std_logic_vector(31 downto 0)
        );
    end component;

    signal stage0, stage1, stage2, stage3, stage4 : std_logic_vector(31 downto 0);
    signal shift1, shift2, shift4, shift8, shift16 : std_logic_vector(31 downto 0);
    signal signBit : std_logic;

begin

    signBit <= dataIN(31); -- for arithmetic shift right

    -- Shift by 1
    shift1 <=
        dataIN(30 downto 0) & '0' when leftORright = '0' else
        (signBit & dataIN(31 downto 1)) when logicalORarithmatic = '1' else
        ('0' & dataIN(31 downto 1));

    mux0: mux2t1_N
        port map (
            i_S  => shiftAmount(0),
            i_D0 => dataIN,
            i_D1 => shift1,
            o_O  => stage0
        );

    -- Shift by 2
    shift2 <=
        stage0(29 downto 0) & "00" when leftORright = '0' else
        (signBit & signBit & stage0(31 downto 2)) when logicalORarithmatic = '1' else
        ("00" & stage0(31 downto 2));

    mux1: mux2t1_N
        port map (
            i_S  => shiftAmount(1),
            i_D0 => stage0,
            i_D1 => shift2,
            o_O  => stage1
        );

    -- Shift by 4
    shift4 <=
        stage1(27 downto 0) & x"0" when leftORright = '0' else
        (signBit & signBit & signBit & signBit & stage1(31 downto 4)) when logicalORarithmatic = '1' else
        (x"0" & stage1(31 downto 4));

    mux2: mux2t1_N
        port map (
            i_S  => shiftAmount(2),
            i_D0 => stage1,
            i_D1 => shift4,
            o_O  => stage2
        );

    -- Shift by 8
    shift8 <=
        stage2(23 downto 0) & x"00" when leftORright = '0' else
        (x"FF" & stage2(31 downto 8)) when logicalORarithmatic = '1' and signBit = '1' else
        (x"00" & stage2(31 downto 8));

    mux3: mux2t1_N
        port map (
            i_S  => shiftAmount(3),
            i_D0 => stage2,
            i_D1 => shift8,
            o_O  => stage3
        );

    -- Shift by 16
    shift16 <=
        stage3(15 downto 0) & x"0000" when leftORright = '0' else
        (x"FFFF" & stage3(31 downto 16)) when logicalORarithmatic = '1' and signBit = '1' else
        (x"0000" & stage3(31 downto 16));

    mux4: mux2t1_N
        port map (
            i_S  => shiftAmount(4),
            i_D0 => stage3,
            i_D1 => shift16,
            o_O  => stage4
        );

    -- Final output
    dataOUT <= stage4;

end Structural;
