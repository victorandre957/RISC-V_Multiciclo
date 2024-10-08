library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_1_to_2 is
    port (
        A   : in signed(31 downto 0);
        B   : in signed(31 downto 0);
        sel : in STD_LOGIC;
        Y   : out signed(31 downto 0)
    );
end entity mux_1_to_2;

architecture rtl of mux_1_to_2 is
begin
    process (A, B, sel) is
    begin
        if sel = '0' then
            Y <= A;
        else
            Y <= B;
        end if;
    end process;
end architecture rtl;
