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
    regInstrOut: out std_logic_vector(31 downto 0);
    rs1Out: out signed(31 downto 0);
    rs2Out: out signed(31 downto 0);
    imm32Out: out signed(31 downto 0);
    regDataOut: out signed(31 downto 0);
    pcOut: out unsigned(31 downto 0);
    Mem2RegOut: out std_logic_vector(1 downto 0);
    EscreveIROut : out std_logic;
    OrigAULAOut: out std_logic_vector(1 downto 0);
    OrigBULAOut: out std_logic_vector(1 downto 0)
);
end component;

signal clk     : std_logic:='0';
signal reset   : std_logic:='0';
signal regInstrOut: std_logic_vector(31 downto 0);
signal rs1Out     : signed(31 downto 0);
signal rs2Out     : signed(31 downto 0);
signal imm32Out   : signed(31 downto 0);
signal regDataOut : signed(31 downto 0);
signal pcOut      : unsigned(31 downto 0);
signal Mem2RegOut   : std_logic_vector(1 downto 0);
signal EscreveIROut   : std_logic:='0';
signal OrigAULAOut   : std_logic_vector(1 downto 0);
signal OrigBULAOut   : std_logic_vector(1 downto 0);

begin
dut: Risc_V_Multicycle port map(
    clock       => clk,
    reset       => reset,
    regInstrOut => regInstrOut,
    rs1Out      => rs1Out,
    rs2Out      => rs2Out,
    imm32Out    => imm32Out,
    regDataOut  => regDataOut,
    pcOut       => pcOut,
    Mem2RegOut  => Mem2RegOut,
    EscreveIROut => EscreveIROut,
    OrigAULAOut => OrigAULAOut,
    OrigBULAOut => OrigBULAOut
);

clk <= not clk after 1 us;
end TB;


