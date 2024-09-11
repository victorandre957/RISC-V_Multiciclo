library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_unitary_reg is

end entity tb_unitary_reg;

architecture tb of tb_unitary_reg is

    signal clk     : STD_LOGIC           := '0';
    signal dataIn  : signed(31 downto 0) := (others => '0');
    signal dataOut : signed(31 downto 0);

    constant clk_period : TIME := 10 ns;

    component unitary_reg
        port (
            dataIn  : in signed(31 downto 0);
            clk     : in STD_LOGIC;
            dataOut : out signed(31 downto 0)
        );
    end component;

begin

    uut : unitary_reg
    port map(
        dataIn  => dataIn,
        clk     => clk,
        dataOut => dataOut
    );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus_process : process
    begin
        wait for 20 ns;

        dataIn <= to_signed(10, 32);
        wait for clk_period;
        assert dataOut = to_signed(10, 32);
        report "Erro" severity error;

        dataIn <= to_signed(20, 32);
        wait for clk_period;
        assert dataOut = to_signed(10, 32);
        report "Erro" severity error;

        dataIn <= to_signed(30, 32);
        wait for clk_period;
        assert dataOut = to_signed(10, 32);
        report "Erro" severity error;

        wait for 30 ns;
        wait;
    end process;

end architecture tb;
