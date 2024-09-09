library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Memory is
end entity tb_Memory;

architecture test of tb_Memory is
    -- Sinais para conectar à unidade Memory
    signal clock    : std_logic := '0';
    signal we       : std_logic := '0';
    signal re       : std_logic := '0';
    signal address  : std_logic_vector(11 downto 0);
    signal datain   : std_logic_vector(31 downto 0);
    signal dataout  : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 1 ns;

begin
    -- Instância da Memory
    uut: entity work.Memory
        port map (
            clock    => clock,
            we       => we,
            re       => re,
            address  => address,
            datain   => datain,
            dataout  => dataout
        );

    -- Geração do clock
    clock_process : process
    begin
        while true loop
            clock <= '0';
            wait for CLK_PERIOD / 2;
            clock <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Geração de estímulos
    stim_proc: process
    begin
        we <= '1';  -- Habilita escrita
        re <= '0';

        -- 0x2000 (13 downto 0) inicio da memoria de dados
        address <= "001000000000";  -- Endereço de escrita
        datain <= std_logic_vector(to_unsigned(8192, 30)) & "00";  -- Valor a ser escrito
        wait for CLK_PERIOD;

        we <= '0';  -- Desabilita escrita
        re <= '1';  -- Habilita Leitura

        address <= "001000000000"; -- Endereço de leitura
        wait for CLK_PERIOD;  -- Espera 1 ciclo de clock para ler


        we <= '0';  -- Desabilita escrita
        re <= '1';  -- Habilita Leitura

        -- index 1  memoria de instrução
        address <= "000000000001";  -- Endereço de instrução
        wait for CLK_PERIOD;

        we <= '1';  -- Habilita escrita
        we <= '0';  -- Desabilita escrita

         -- index 2  memoria de instrução
        address <= "001000000001";  -- Endereço de escrita (área de código)
        datain <= std_logic_vector(to_unsigned(8 + 500, 30)) & "00";  -- Valor arbitrário para escrita
        wait for CLK_PERIOD;

        we <= '0';  -- Desabilita escrita
        re <= '1';  -- Habilita Leitura

        address <= "001000000001";  -- Endereço de leitura (área de código)
        wait for CLK_PERIOD;

        wait;
    end process;
end architecture;
