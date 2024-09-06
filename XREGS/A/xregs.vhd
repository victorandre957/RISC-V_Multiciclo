library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity XREGS is
    port (
        clk, wren    : in STD_LOGIC;
        rs1, rs2, rd : in STD_LOGIC_VECTOR (4 downto 0);
        data         : in STD_LOGIC_VECTOR (31 downto 0);
        ro1, ro2     : out STD_LOGIC_VECTOR (31 downto 0)
    );
end XREGS;

architecture Arch of XREGS is
    type RegisterFile is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal registers : RegisterFile := (others => (others => '0'));
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if wren = '1' and to_integer(unsigned(rd)) > 0 and to_integer(unsigned(rd)) < 32 then
                registers(to_integer(unsigned(rd))) <= data;
            end if;
            ro1 <= registers(to_integer(unsigned(rs1)));
            ro2 <= registers(to_integer(unsigned(rs2)));
        end if;
    end process;
end Arch;
