library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity testbench is end;

architecture TB of testbench is
    component Risc_V_Multicycle is
        port (
            clock          : in STD_LOGIC;
            reset          : in STD_LOGIC;
            regInstrOut    : out STD_LOGIC_VECTOR(31 downto 0);
            regSaidaUlaOut : out signed(31 downto 0);
            pcOut          : out unsigned(31 downto 0)
        );
    end component;

    signal clk            : STD_LOGIC := '0';
    signal reset          : STD_LOGIC := '0';
    signal regInstrOut    : STD_LOGIC_VECTOR(31 downto 0);
    signal regSaidaUlaOut : signed(31 downto 0);
    signal pcOut          : unsigned(31 downto 0);

begin
    dut : Risc_V_Multicycle port map(
        clock          => clk,
        reset          => reset,
        regInstrOut    => regInstrOut,
        regSaidaUlaOut => regSaidaUlaOut,
        pcOut          => pcOut
    );

    clk <= not clk after 1 us;
end TB;
