-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- RISCV_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a RISCV_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-- 04/10/2025 by AP::Coverted to RISC-V.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity RISCV_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  RISCV_Processor;


architecture structure of RISCV_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Use WFI with Opcode: 111 0011)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

    component mux2t1_N --N-bit 2:1 mux
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component extender_12t32 --DONT FORGET REWORK THE EXTENDER ITS WRONG
  port(
    ivalue : in  std_logic_vector(31 downto 0);  
    immType : in  std_logic_vector(2 downto 0);  
    ovalue : out std_logic_vector(31 downto 0)   --sign-extended
  );
    end component;

    component Register_File --Register file
    Port ( rs1 : in STD_LOGIC_VECTOR(4 downto 0); --Register to read
           rs2 : in STD_LOGIC_VECTOR(4 downto 0); --Register to read
           rd : in STD_LOGIC_VECTOR(4 downto 0); --Register to write to
           Clk : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR(31 downto 0); --Data to be written
           We : in STD_LOGIC; --Enable if writing
           Reset : in STD_LOGIC;
           Data1 : out STD_LOGIC_VECTOR(31 downto 0);
           Data2 : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component Fetch_Logic --Fetch logic
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           InputData : in STD_LOGIC_VECTOR(31 downto 0);
           PRSrc : in STD_LOGIC;
           NextInstAddress : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component ALU
    Port ( A : in std_logic_vector(31 downto 0);
           B : in std_logic_vector(31 downto 0);
           ALUControl : in std_logic_vector(3 downto 0);
           Overflow : out STD_LOGIC;
           Zero : out STD_LOGIC;
           ALUOut : out std_logic_vector(31 downto 0));
    end component;

    component Control_Logic --Control logic
    Port ( Opcode : in std_logic_vector(6 downto 0);
           ALUSrc : out STD_LOGIC;
           ALUControl : out std_logic_vector(3 downto 0);
           ImmType : out std_logic_vector(2 downto 0);
           ResultSrc : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           PCSrc : out STD_LOGIC; -- if 0 do normal, if 1 branch
           RegDst : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
    end component;

    --Control Signals
    signal Wire_Opcode : std_logic_vector(6 downto 0);
    signal Wire_ALUSrc : STD_LOGIC;
    signal Wire_ALUControl : std_logic_vector(3 downto 0);
    signal Wire_ImmType : std_logic_vector(2 downto 0);
    signal Wire_ResultSrc : STD_LOGIC;
    signal Wire_MemWrite : STD_LOGIC;
    signal Wire_RegWrite : STD_LOGIC;
    signal Wire_RegDst : STD_LOGIC; 
    signal Wire_PCSrc : STD_LOGIC;

    signal s_Inst_24to20 : std_logic_vector(4 downto 0);
    signal s_Inst_19to15 : std_logic_vector(4 downto 0);
    signal s_Inst_11to7 : std_logic_vector(4 downto 0);

    signal register1TOALU : std_logic_vector(31 downto 0);
    signal register2TOALU : std_logic_vector(31 downto 0);
    signal extenderTOMUX : std_logic_vector(31 downto 0);
    signal mux2t1TOALU : std_logic_vector(31 downto 0);

    signal wireZero : STD_LOGIC;
    signal s_ALUOut : std_logic_vector(31 downto 0);

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

    Wire_Opcode(0) <= s_Inst(0);
    Wire_Opcode(1) <= s_Inst(1);
    Wire_Opcode(2) <= s_Inst(2);
    Wire_Opcode(3) <= s_Inst(3);
    Wire_Opcode(4) <= s_Inst(4);
    Wire_Opcode(5) <= s_Inst(5);
    Wire_Opcode(6) <= s_Inst(6);

    Control: Control_Logic Port map (Wire_Opcode, Wire_ALUSrc, Wire_ALUControl, Wire_ImmType, Wire_ResultSrc, Wire_MemWrite, Wire_PCSrc, Wire_RegDst, Wire_RegWrite);

    s_Inst_24to20(0) <= s_Inst(20);
    s_Inst_24to20(1) <= s_Inst(21);
    s_Inst_24to20(2) <= s_Inst(22);
    s_Inst_24to20(3) <= s_Inst(23);
    s_Inst_24to20(4) <= s_Inst(24);

    s_Inst_11to7(0) <= s_Inst(7);
    s_Inst_11to7(1) <= s_Inst(8);
    s_Inst_11to7(2) <= s_Inst(9);
    s_Inst_11to7(3) <= s_Inst(10);
    s_Inst_11to7(4) <= s_Inst(11);

    s_Inst_19to15(0) <= s_Inst(15);
    s_Inst_19to15(1) <= s_Inst(16);
    s_Inst_19to15(2) <= s_Inst(17);
    s_Inst_19to15(3) <= s_Inst(18);
    s_Inst_19to15(4) <= s_Inst(19);

  mux2T1_4b: mux2t1_N
    generic map(N => 5)
    port map(i_S  => Wire_RegDst,
             i_D0 => s_Inst_24to20,
             i_D1 => s_Inst_11to7,
             o_O   => s_RegWrAddr);

    s_RegWr <= Wire_RegWrite;

    RegisterFile: Register_File Port map (s_Inst_19to15, s_Inst_24to20, s_RegWrAddr, iCLK, s_RegWrData, Wire_RegWrite, iRST, register1TOALU, register2TOALU);

    extender: extender_12t32 Port map (s_Inst, Wire_ImmType, extenderTOMUX);

  mux2T1_32b: mux2t1_N
    generic map(N => 32)
    port map(i_S  => Wire_ALUSrc,
             i_D0 => register2TOALU,
             i_D1 => extenderTOMUX,
             o_O   => mux2t1TOALU);

    Alufile: ALU Port map (register1TOALU, mux2t1TOALU, Wire_ALUControl, s_Ovfl, wireZero, s_ALUOut);

    oALUOut <= s_ALUOut;
    s_DMemAddr <= s_ALUOut;
    s_DMemData <= register2TOALU;
    s_DMemWr <= Wire_MemWrite;

  mux2T1_32b_2: mux2t1_N
    generic map(N => 32)
    port map(i_S  => Wire_ResultSrc,
             i_D0 => s_DMemAddr,
             i_D1 => s_DMemOut,
             o_O   => s_RegWrData);

end structure;

