library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_risc_v_control is
end entity;

architecture behavior of tb_risc_v_control is
    -- Component instanciado (Unidade de Controle)
    component risc_v_control
        port (
            clk       : in STD_LOGIC;
            rst       : in STD_LOGIC;
            opcode    : in STD_LOGIC_VECTOR(6 downto 0);
            zero_flag : in STD_LOGIC;

            -- Sinais de controle
            EscrevePCCond : out STD_LOGIC;
            EscrevePC     : out STD_LOGIC;
            LouD          : out STD_LOGIC;
            EscreveMem    : out STD_LOGIC;
            LeMem         : out STD_LOGIC;
            EscreveIR     : out STD_LOGIC;
            OrigPC        : out STD_LOGIC;
            ALUop         : out STD_LOGIC_VECTOR(1 downto 0);
            OrigAULA      : out STD_LOGIC_VECTOR(1 downto 0);
            OrigBULA      : out STD_LOGIC_VECTOR(1 downto 0);
            EscrevePCB    : out STD_LOGIC;
            EscreveReg    : out STD_LOGIC;
            Mem2Reg       : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    -- Sinais de entrada
    signal clk       : STD_LOGIC := '0';
    signal rst       : STD_LOGIC := '0';
    signal opcode    : STD_LOGIC_VECTOR(6 downto 0);
    signal zero_flag : STD_LOGIC := '0';

    -- Sinais de saída
    signal EscrevePCCond : STD_LOGIC;
    signal EscrevePC     : STD_LOGIC;
    signal LouD          : STD_LOGIC;
    signal EscreveMem    : STD_LOGIC;
    signal LeMem         : STD_LOGIC;
    signal EscreveIR     : STD_LOGIC;
    signal OrigPC        : STD_LOGIC;
    signal ALUop         : STD_LOGIC_VECTOR(1 downto 0);
    signal OrigAULA      : STD_LOGIC_VECTOR(1 downto 0);
    signal OrigBULA      : STD_LOGIC_VECTOR(1 downto 0);
    signal EscrevePCB    : STD_LOGIC;
    signal EscreveReg    : STD_LOGIC;
    signal Mem2Reg       : STD_LOGIC_VECTOR(1 downto 0);

    -- Clock period definition
    constant clk_period : TIME := 1 ns;

begin
    -- Instância do componente do controle
    uut : risc_v_control
    port map(
        clk       => clk,
        rst       => rst,
        opcode    => opcode,
        zero_flag => zero_flag,

        -- Saídas de controle
        EscrevePCCond => EscrevePCCond,
        EscrevePC     => EscrevePC,
        LouD          => LouD,
        EscreveMem    => EscreveMem,
        LeMem         => LeMem,
        EscreveIR     => EscreveIR,
        OrigPC        => OrigPC,
        ALUop         => ALUop,
        OrigAULA      => OrigAULA,
        OrigBULA      => OrigBULA,
        EscrevePCB    => EscrevePCB,
        EscreveReg    => EscreveReg,
        Mem2Reg       => Mem2Reg
    );

    -- Clock process definitions
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test process for LW passing through all stages
    test_process_LW : process
    begin

        -- Inicialização
        rst <= '1';
        wait for clk_period;
        rst <= '0';

        -- Testando LW (Load Word)
        wait for clk_period;

        -- Estágio 1: Fetch
        assert (LouD = '0') report "Erro no sinal LouD no Fetch (LW)" severity error;
        assert (LeMem = '1') report "Erro no sinal LeMem no Fetch (LW)" severity error;
        assert (EscreveIR = '1') report "Erro no sinal EscreveIR no Fetch (LW)" severity error;
        assert (OrigAULA = "10") report "Erro no sinal OrigAULA no Fetch (LW)" severity error;
        assert (OrigBULA = "01") report "Erro no sinal OrigBULA no Fetch (LW)" severity error;
        assert (ALUop = "00") report "Erro no sinal ALUop no Fetch (LW)" severity error;
        assert (OrigPC = '0') report "Erro no sinal OrigPC no Fetch (LW)" severity error;
        assert (EscrevePC = '1') report "Erro no sinal EscrevePC no Fetch (LW)" severity error;
        assert (EscrevePCB = '1') report "Erro no sinal EscrevePCB no Fetch (LW)" severity error;

        opcode <= "0000011"; -- Opcode para LW

        wait for clk_period;

        -- Estágio 2: Decode
        assert (OrigAULA = "00") report "Erro no sinal OrigAULA no Fetch (LW)" severity error;
        assert (OrigBULA = "10") report "Erro no sinal OrigBULA no Fetch (LW)" severity error;
        assert (ALUop = "00") report "Erro no sinal ALUop no Fetch (LW)" severity error;
        wait for clk_period;

        -- Estágio 3: Execute (Cálculo do endereço de memória)
        assert (OrigAULA = "01") report "Erro no sinal OrigAULA no Fetch (LW)" severity error;
        assert (OrigBULA = "10") report "Erro no sinal OrigBULA no Fetch (LW)" severity error;
        assert (ALUop = "00") report "Erro no sinal ALUop no Fetch (LW)" severity error;
        wait for clk_period;

        -- Estágio 4: MemRead (Leitura da memória)
        assert (LouD = '1') report "Erro no sinal LeMem no MemRead (LW)" severity error;
        assert (LeMem = '1') report "Erro no sinal LeMem no MemRead (LW)" severity error;
        wait for clk_period;

        -- Estágio 5: WriteBack (Escrita no registrador)
        assert (Mem2Reg = "10") report "Erro no sinal Mem2Reg no WriteBack (LW)" severity error;
        assert (EscreveReg = '1') report "Erro no sinal EscreveReg no WriteBack (LW)" severity error;

        wait for clk_period;
    end process;

end architecture;
