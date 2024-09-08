library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_unitary_reg is
-- Testbench não tem portas
end entity tb_unitary_reg;

architecture tb of tb_unitary_reg is
    -- Sinais de estímulo para o DUT (Device Under Test)
    signal clk     : std_logic := '0';          -- Clock
    signal dataIn  : signed(31 downto 0) := (others => '0');  -- Entrada de dados
    signal dataOut : signed(31 downto 0);       -- Saída do DUT

    -- Período do clock
    constant clk_period : time := 10 ns;

    -- Instanciando a unidade de registro unitário (DUT)
    component unitary_reg
        port(
            dataIn  : in signed(31 downto 0);
            clk     : in std_logic;
            dataOut : out signed(31 downto 0)
        );
    end component;

begin
    -- Instancia o DUT
    uut: unitary_reg
        port map (
            dataIn  => dataIn,
            clk     => clk,
            dataOut => dataOut
        );

    -- Geração de clock
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Geração de estímulos
    stimulus_process: process
    begin
        -- Tempo inicial: Aguardar 20ns antes de iniciar a simulação
        wait for 20 ns;

        -- Primeiro valor de entrada
        dataIn <= to_signed(10, 32);
        wait for clk_period;
        assert dataOut = to_signed(10, 32); report "Erro" severity error;

        -- Segundo valor de entrada
        dataIn <= to_signed(20, 32);
        wait for clk_period;
        assert dataOut = to_signed(10, 32); report "Erro" severity error;

        -- Terceiro valor de entrada
        dataIn <= to_signed(30, 32);
        wait for clk_period;
        assert dataOut = to_signed(10, 32); report "Erro" severity error;

        -- Finaliza a simulação
        wait for 30 ns;
        wait;
    end process;

end architecture tb;
