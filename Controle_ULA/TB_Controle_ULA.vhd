library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_risc_v_ULA_control is
end tb_risc_v_ULA_control;

architecture behavior of tb_risc_v_ULA_control is
    -- Signals para conectar com o DUT (Device Under Test)
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic;
    signal AluOp  : std_logic_vector(1 downto 0);
    signal UlaSel : std_logic_vector(3 downto 0);

    -- Instância do DUT
    component risc_v_ULA_control
        port (
            funct3  : in std_logic_vector(2 downto 0);
            funct7  : in std_logic;
            AluOp   : in std_logic_vector(1 downto 0);
            UlaSel  : out std_logic_vector(3 downto 0)
        );
    end component;

begin
    -- Instanciar o DUT
    uut: risc_v_ULA_control
        port map (
            funct3  => funct3,
            funct7  => funct7,
            AluOp   => AluOp,
            UlaSel  => UlaSel
        );

    -- Processo para aplicar estímulos e monitorar resultados
    process
    begin
        -- Teste 1: ALUOp = "00" (Soma)
        AluOp  <= "00";
        funct3  <= "000";
        funct7  <= '0';
        wait for 10 ns;
        assert (UlaSel = "0000") report "Erro: Teste 1 falhou" severity error;

        -- Teste 2: ALUOp = "01" (Subtração)
        AluOp  <= "01";
        funct3  <= "000";
        funct7  <= '0';
        wait for 10 ns;
        assert (UlaSel = "1100") report "Erro: Teste 2 falhou" severity error;

        -- Teste 3: ALUOp = "10", funct3 = "000", funct7 = '0' (Add)
        AluOp  <= "10";
        funct3  <= "000";
        funct7  <= '0';
        wait for 10 ns;
        assert (UlaSel = "0000") report "Erro: Teste 3 falhou" severity error;

        -- Teste 4: ALUOp = "10", funct3 = "001" (Shift Logical Left)
        AluOp  <= "10";
        funct3  <= "001";
        funct7  <= '0';
        wait for 10 ns;
        assert (UlaSel = "0101") report "Erro: Teste 4 falhou" severity error;

        -- Teste 5: ALUOp = "11", funct3 = "000", funct7 = '0' (Adição)
        AluOp  <= "11";
        funct3  <= "000";
        funct7  <= '0';
        wait for 10 ns;
        assert (UlaSel = "0000") report "Erro: Teste 5 falhou" severity error;

        -- Teste 6: ALUOp = "11", funct3 = "101", funct7 = '0' (Shift Right Logical)
        AluOp  <= "11";
        funct3  <= "101";
        funct7  <= '0';
        wait for 10 ns;
        assert (UlaSel = "0110") report "Erro: Teste 6 falhou" severity error;

        -- Teste 7: ALUOp = "10", funct3 = "101", funct7 = '1' (Shift Right Arithmetic)
        AluOp  <= "10";
        funct3  <= "101";
        funct7  <= '1';
        wait for 10 ns;
        assert (UlaSel = "0111") report "Erro: Teste 7 falhou" severity error;

        -- Teste 8: ALUOp = "11", funct3 = "100" (XOR)
        AluOp  <= "11";
        funct3  <= "100";
        funct7  <= '0';
        wait for 10 ns;
        assert (UlaSel = "0100") report "Erro: Teste 8 falhou" severity error;

        -- Teste 9: ALUOp = "11", funct3 = "110" (OR)
        AluOp  <= "11";
        funct3  <= "110";
        funct7  <= '0';
        wait for 10 ns;
        assert (UlaSel = "0011") report "Erro: Teste 9 falhou" severity error;

        -- Teste 10: ALUOp = "11", funct3 = "111" (AND)
        AluOp  <= "11";
        funct3  <= "111";
        funct7  <= '0';
        wait for 10 ns;
        assert (UlaSel = "0010") report "Erro: Teste 10 falhou" severity error;

        -- Encerrar simulação
        wait;
    end process;
end behavior;
