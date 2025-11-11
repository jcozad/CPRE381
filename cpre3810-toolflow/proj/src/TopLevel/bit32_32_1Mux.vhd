--Dataflow modeling describes the flow of data between components or signals. It defines how 
--values are computed, typically using signal assignments to represent the flow of data directly

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit32_32_1Mux is

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

end bit32_32_1Mux;

architecture Dataflow of bit32_32_1Mux is
begin

    with sclt select
    data_OUT <= datainput0  when "00000",
               datainput1  when "00001",
               datainput2  when "00010",
               datainput3  when "00011",
               datainput4  when "00100",
               datainput5  when "00101",
               datainput6  when "00110",
               datainput7  when "00111",
               datainput8  when "01000",
               datainput9  when "01001",
               datainput10 when "01010",
               datainput11 when "01011",
               datainput12 when "01100",
               datainput13 when "01101",
               datainput14 when "01110",
               datainput15 when "01111",
               datainput16 when "10000",
               datainput17 when "10001",
               datainput18 when "10010",
               datainput19 when "10011",
               datainput20 when "10100",
               datainput21 when "10101",
               datainput22 when "10110",
               datainput23 when "10111",
               datainput24 when "11000",
               datainput25 when "11001",
               datainput26 when "11010",
               datainput27 when "11011",
               datainput28 when "11100",
               datainput29 when "11101",
               datainput30 when "11110",
               datainput31 when "11111",
	       datainput0 when others; --Default to register 1 if select not found

end Dataflow;

