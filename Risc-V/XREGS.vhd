library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XREGS is
    generic (WSIZE : natural := 32);
    port (
        clk  : in std_logic;
        wren : in std_logic;
        rs1, rs2, rd : in std_logic_vector(4 downto 0);
        data : in signed(WSIZE-1 downto 0);
        ro1, ro2 : out signed(WSIZE-1 downto 0)  -- Alterado para signed
    );
end XREGS;

architecture Reg of XREGS is
    type REGISTERS is array(0 to 31) of signed(WSIZE-1 downto 0);  -- Registradores são signed
    signal breg : REGISTERS := (others => (others => '0'));  -- Inicializa os registradores com 0
begin

    process(rs1, rs2, breg)
    begin
        ro1 <= breg(to_integer(unsigned(rs1)));  -- Saída ro1 como signed
        ro2 <= breg(to_integer(unsigned(rs2)));  -- Saída ro2 como signed
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if wren = '1' and to_integer(unsigned(rd)) /= 0 then
                breg(to_integer(unsigned(rd))) <= data;  -- Escreve dado signed
            end if;
            breg(0) <= (others => '0');  -- O registrador 0 sempre contém zero
        end if;
    end process;

end Reg;
