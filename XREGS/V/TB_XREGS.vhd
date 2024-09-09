library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_XREGS is
end tb_XREGS;

architecture Behavioral of tb_XREGS is
    signal clk  : STD_LOGIC                     := '0';
    signal wren : STD_LOGIC                     := '0';
    signal rs1  : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');
    signal rs2  : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');
    signal rd   : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');
    signal data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ro1  : STD_LOGIC_VECTOR(31 downto 0);
    signal ro2  : STD_LOGIC_VECTOR(31 downto 0);

    component XREGS
        port (
            clk  : in STD_LOGIC;
            wren : in STD_LOGIC;
            rs1  : in STD_LOGIC_VECTOR(4 downto 0);
            rs2  : in STD_LOGIC_VECTOR(4 downto 0);
            rd   : in STD_LOGIC_VECTOR(4 downto 0);
            data : in STD_LOGIC_VECTOR(31 downto 0);
            ro1  : out STD_LOGIC_VECTOR(31 downto 0);
            ro2  : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

begin
    uut : XREGS port map(
        clk  => clk,
        wren => wren,
        rs1  => rs1,
        rs2  => rs2,
        rd   => rd,
        data => data,
        ro1  => ro1,
        ro2  => ro2
    );

    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    test_process : process
    begin
        wren <= '0';
        rs1  <= "00000";
        rs2  <= "00001";
        rd   <= "00000";
        data <= (others => '0');
        wait for 20 ns;

        for i in 0 to 31 loop
            wren <= '1';
            rd   <= STD_LOGIC_VECTOR(to_unsigned(i, 5));
            data <= STD_LOGIC_VECTOR(to_unsigned(i, 32));
            wait for 20 ns;
        end loop;

        wren <= '0';

        for i in 0 to 31 loop
            rs1 <= STD_LOGIC_VECTOR(to_unsigned(i, 5));
            wait for 20 ns;
            assert (ro1 = STD_LOGIC_VECTOR(to_unsigned(i, 32)))
            report "Error: Value of r1 is not correct for the register" & INTEGER'image(i) severity error;
        end loop;

        for i in 0 to 31 loop
            rs2 <= STD_LOGIC_VECTOR(to_unsigned(i, 5));
            wait for 20 ns;
            assert (ro2 = STD_LOGIC_VECTOR(to_unsigned(i, 32)))
            report "Error: ro2 value is not correct for registrar" & INTEGER'image(i) severity error;
        end loop;

        rd   <= "00000";
        data <= X"12345678";
        wren <= '1';
        wait for 20 ns;
        wren <= '0';
        rs1  <= "00000";
        wait for 20 ns;
        assert (ro1 = X"00000000")
        report "Error: Register zero has been changed!" severity error;

        report "All tests passed successfully!" severity note;

        wait;
    end process;
end Behavioral;
