library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity testbench is end;

architecture TB of testbench is
component Risc_V_Multicycle is
port(
    clock : in std_logic;
    reset : in std_logic;
    regInstr: out std_logic_vector(31 downto 0);
    rs1: out std_logic_vector(31 downto 0);
    rs2: out std_logic_vector(31 downto 0);
    imm32: out std_logic_vector(31 downto 0);
    regData: out std_logic_vector(31 downto 0);
    pc: out std_logic_vector(31 downto 0);
);
end component;

signal clk     : std_logic:='1';
signal reset   : std_logic:='0';
signal regInstr: std_logic_vector(31 downto 0);
signal rs1     : signed(31 downto 0);
signal rs2     : signed(31 downto 0);
signal imm32     : signed(31 downto 0);
signal regData : signed(31 downto 0);
signal pc : signed(31 downto 0);

begin
dut: Risc_V_Multicycle port map(
    clock    => clk,
    reset    => reset,
    regInstr => regInstr,
    rs1      => rs1,
    rs2      => rs2,
    imm32    => imm32,
    regData  => regData,
    pc       => pc,
);

clk <= not clk after 1 us;
end TB;


