library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity barrelShifter_N is
    generic (
        N : integer := 32
    );
    port (
        i_data      : in  std_logic_vector(N-1 downto 0);
        i_shift     : in  std_logic_vector(4 downto 0);
        i_LR        : in  std_logic;  -- 0 = left, 1 = right
        o_result    : out std_logic_vector(N-1 downto 0)
    );
end barrelShifter_N;

architecture Structural of barrelShifter_N is

    -- Declare internal signals for each shift stage
    signal stage0, stage1, stage2, stage3, stage4 : std_logic_vector(N-1 downto 0);
    signal shift1, shift2, shift4, shift8, shift16 : std_logic_vector(N-1 downto 0);

    -- Component declaration for mux2t1_N
    component mux2t1_N is
        generic (N : integer := 32);
        port (
            i_S  : in  std_logic;
            i_D0 : in  std_logic_vector(N-1 downto 0);
            i_D1 : in  std_logic_vector(N-1 downto 0);
            o_O  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Function to shift left or right by a power of 2
    function shift_data(
        data   : std_logic_vector;
        amount : integer;
        dir    : std_logic;  -- '0' = left, '1' = right
        width  : integer
    ) return std_logic_vector is
        variable result : std_logic_vector(width-1 downto 0);
    begin
        if dir = '0' then  -- left shift
            result := data(width - amount - 1 downto 0) & (amount downto 1 => '0') & '0';
        else               -- right shift
            result := (amount downto 1 => '0') & '0' & data(width-1 downto amount);
        end if;
        return result;
    end function;

begin

    -- Shift by 1
    shift1 <= shift_data(i_data, 1, i_LR, N);
    U_MUX0: mux2t1_N
        generic map (N => N)
        port map (
            i_S  => i_shift(0),
            i_D0 => i_data,
            i_D1 => shift1,
            o_O  => stage0
        );

    -- Shift by 2
    shift2 <= shift_data(stage0, 2, i_LR, N);
    U_MUX1: mux2t1_N
        generic map (N => N)
        port map (
            i_S  => i_shift(1),
            i_D0 => stage0,
            i_D1 => shift2,
            o_O  => stage1
        );

    -- Shift by 4
    shift4 <= shift_data(stage1, 4, i_LR, N);
    U_MUX2: mux2t1_N
        generic map (N => N)
        port map (
            i_S  => i_shift(2),
            i_D0 => stage1,
            i_D1 => shift4,
            o_O  => stage2
        );

    -- Shift by 8
    shift8 <= shift_data(stage2, 8, i_LR, N);
    U_MUX3: mux2t1_N
        generic map (N => N)
        port map (
            i_S  => i_shift(3),
            i_D0 => stage2,
            i_D1 => shift8,
            o_O  => stage3
        );

    -- Shift by 16
    shift16 <= shift_data(stage3, 16, i_LR, N);
    U_MUX4: mux2t1_N
        generic map (N => N)
        port map (
            i_S  => i_shift(4),
            i_D0 => stage3,
            i_D1 => shift16,
            o_O  => stage4
        );

    -- Final output
    o_result <= stage4;

end Structural;

