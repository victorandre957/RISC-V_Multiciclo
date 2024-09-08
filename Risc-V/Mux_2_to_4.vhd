library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux_2_to_4 is
    port (
        A   : in  std_logic_vector(31 downto 0);
        B   : in  std_logic_vector(31 downto 0);
        C   : in  std_logic_vector(31 downto 0);
        D   : in  std_logic_vector(31 downto 0);
        sel : in  std_logic_vector(1 downto 0);
        Y   : out std_logic_vector(31 downto 0)
    );
end entity Mux_2_to_4;

architecture rtl of Mux_2_to_4 is
begin

    process(A, B, C, D, sel) is
    begin
        case sel is
            when "00" =>
                Y <= A;
            when "01" =>
                Y <= B;
            when "10" =>
                Y <= C;
            when "11" =>
                Y <= D;
            when others =>
                Y <= (others => '0');
        end case;
    end process;
end architecture rtl;


