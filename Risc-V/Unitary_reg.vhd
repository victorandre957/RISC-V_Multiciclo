library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unitary_reg is
    port (
        dataIn  : in signed(31 downto 0);
        clk     : in STD_LOGIC;
        enable  : in STD_LOGIC;
        dataOut : out signed(31 downto 0)
    );
end entity unitary_reg;

architecture rtl of unitary_reg is
    signal address : signed(31 downto 0) := X"00000000";

begin
    process (clk) is
    begin
        if rising_edge(clk) and enable = '1' then
            address <= dataIn;
        end if;
    end process;

    dataOut <= address;
end rtl;
