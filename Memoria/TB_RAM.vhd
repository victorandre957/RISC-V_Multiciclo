library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RAM is
end entity tb_RAM;

architecture test of tb_RAM is
    -- Sinais para conectar à unidade RAM
    signal clock    : std_logic := '0';
    signal we       : std_logic := '0';
    signal address  : std_logic_vector(11 downto 0);
    signal datain   : std_logic_vector(31 downto 0);
    signal dataout  : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instância da RAM
    uut: entity work.RAM
        port map (
            clock    => clock,
            we       => we,
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
        -- 1. Testar escrita na RAM (endereços de dados 2048 a 2055)
          -- Habilita escrita
        for i in 2048 to 2055 loop  -- Pequena faixa de endereços para teste
            address <= std_logic_vector(to_unsigned(i, 12));  -- Endereço de escrita
            datain <= std_logic_vector(to_unsigned(i + 1000, 30)) & "00";  -- Valor a ser escrito
            wait for CLK_PERIOD;
        end loop;

        -- 2. Testar leitura da RAM (endereços de dados 2048 a 2055)
        we <= '0';  -- Desabilita escrita (para ler os dados)
        for i in 2048 to 2055 loop
            address <= std_logic_vector(to_unsigned(i, 12));  -- Endereço de leitura
            wait for CLK_PERIOD;  -- Espera 1 ciclo de clock para ler
        end loop;

        -- 3. Testar leitura da área de código (endereços 0 a 10) -- Instruções carregadas de arquivo
        we <= '0';  -- Modo leitura
        for i in 0 to 10 loop  -- Leitura de algumas instruções
            address <= std_logic_vector(to_unsigned(i, 12));  -- Endereço de instrução
            wait for CLK_PERIOD;
        end loop;

         -- 4. Escrever na área de instruções (endereços 90 a 100)
        we <= '1';  -- Habilita escrita na memória de instruções
        for i in 90 to 100 loop
            address <= std_logic_vector(to_unsigned(i, 12));  -- Endereço de escrita (área de código)
            datain <= std_logic_vector(to_unsigned(i + 500, 30)) & "00";  -- Valor arbitrário para escrita
            wait for CLK_PERIOD;
        end loop;

        -- 5. Testar leitura da área de instruções (endereços 90 a 100)
        we <= '0';  -- Desabilita escrita para testar leitura
        for i in 90 to 100 loop
            address <= std_logic_vector(to_unsigned(i, 12));  -- Endereço de leitura (área de código)
            wait for CLK_PERIOD;
        end loop;

        wait;
    end process;
end architecture;
