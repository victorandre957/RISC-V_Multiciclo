entity xregsTB is end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

architecture ArchTB of xregsTB is
    component XREGS is
        port (
            clk, wren    : in STD_LOGIC;
            rs1, rs2, rd : in STD_LOGIC_VECTOR (4 downto 0);
            data         : in STD_LOGIC_VECTOR (31 downto 0);
            ro1, ro2     : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    signal clk_in       : STD_LOGIC                      := '0';
    signal wren_in      : STD_LOGIC                      := '0';
    signal rs1_in       : STD_LOGIC_VECTOR (4 downto 0)  := (others => '0');
    signal rs2_in       : STD_LOGIC_VECTOR (4 downto 0)  := (others => '0');
    signal rd_in        : STD_LOGIC_VECTOR (4 downto 0)  := (others => '0');
    signal data_in      : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal ro1_out      : STD_LOGIC_VECTOR (31 downto 0);
    signal ro2_out      : STD_LOGIC_VECTOR (31 downto 0);
    constant CLK_PERIOD : TIME := 10 ns;
begin
    DUT : XREGS port map(
        clk  => clk_in,
        wren => wren_in,
        rs1  => rs1_in,
        rs2  => rs2_in,
        rd   => rd_in,
        data => data_in,
        ro1  => ro1_out,
        ro2  => ro2_out
    );
    clk_in <= not clk_in after CLK_PERIOD / 2;
    process
    begin
        -- Test 1 - Read/Write
        wren_in <= '0';
        wait for CLK_PERIOD;
        rd_in   <= "00001";
        data_in <= x"ABADC0DE";
        wren_in <= '1';
        wait for CLK_PERIOD;
        wren_in <= '0';
        wait for CLK_PERIOD;
        rs1_in <= "00001";
        wait for CLK_PERIOD;
        assert (ro1_out = x"ABADC0DE")
        report "Fail - Test 1" severity error;
        -- Test 2 - Zero Register
        rd_in   <= "00000";
        data_in <= x"C0FFEE00";
        wren_in <= '1';
        wait for CLK_PERIOD;
        wren_in <= '0';
        wait for CLK_PERIOD;
        rs1_in <= "00000";
        wait for CLK_PERIOD;
        assert (ro1_out = x"00000000")
        report "Fail - Test 2" severity error;
        -- Test 3 - Check if unwritten registers are properly initialized to 0
        rs1_in <= "00110";
        rs2_in <= "00111";
        wait for CLK_PERIOD;
        assert (ro1_out = x"00000000" and ro2_out = x"00000000")
        report "Fail - Test 3" severity error;
        -- Test 4 - Multiple read/writes (using 1337 as multiplicative constant)
        for i in 1 to 31 loop
            rd_in   <= STD_LOGIC_VECTOR(to_unsigned(i, 5));
            data_in <= STD_LOGIC_VECTOR(to_unsigned(i * 1337, 32));
            wren_in <= '1';
            wait for CLK_PERIOD;
            wren_in <= '0';
            wait for CLK_PERIOD;
        end loop;
        for i in 1 to 31 loop
            rs1_in <= STD_LOGIC_VECTOR(to_unsigned(i, 5));
            wait for CLK_PERIOD;
            assert (ro1_out = STD_LOGIC_VECTOR(to_unsigned(i * 1337, 32)))
            report "Fail - Test 4" severity error;
        end loop;
        -- Test 5 - Simultaneous read from 2 registers
        rd_in   <= "01000";
        data_in <= x"13371337";
        wren_in <= '1';
        wait for CLK_PERIOD;
        wren_in <= '0';
        wait for CLK_PERIOD;
        wren_in <= '1';
        rd_in   <= "00011";
        data_in <= x"C0FFEE00";
        wait for CLK_PERIOD;
        wren_in <= '0';
        rs1_in  <= "01000";
        rs2_in  <= "00011";
        wait for CLK_PERIOD;
        assert (ro1_out = x"13371337" and ro2_out = x"C0FFEE00")
        report "Fail - Test 5" severity error;
        -- Note informing that all tests were completed
        assert false report "All tests completed." severity note;
        wait;
    end process;
end ArchTB;
