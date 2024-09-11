library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_risc_v_control is
end entity;

architecture behavior of tb_risc_v_control is
    component risc_v_control
        port (
            clk       : in STD_LOGIC;
            rst       : in STD_LOGIC;
            opcode    : in STD_LOGIC_VECTOR(6 downto 0);
            zero_flag : in STD_LOGIC;

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

    signal clk       : STD_LOGIC := '0';
    signal rst       : STD_LOGIC := '0';
    signal opcode    : STD_LOGIC_VECTOR(6 downto 0);
    signal zero_flag : STD_LOGIC := '0';

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

    constant clk_period : TIME := 1 ns;

begin
    uut : risc_v_control
    port map(
        clk       => clk,
        rst       => rst,
        opcode    => opcode,
        zero_flag => zero_flag,

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

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    test_process_LW : process
    begin

        rst <= '1';
        wait for clk_period;
        rst <= '0';

        wait for clk_period;

        assert (LouD = '0') report "Erro no sinal LouD no Fetch (LW)" severity error;
        assert (LeMem = '1') report "Erro no sinal LeMem no Fetch (LW)" severity error;
        assert (EscreveIR = '1') report "Erro no sinal EscreveIR no Fetch (LW)" severity error;
        assert (OrigAULA = "10") report "Erro no sinal OrigAULA no Fetch (LW)" severity error;
        assert (OrigBULA = "01") report "Erro no sinal OrigBULA no Fetch (LW)" severity error;
        assert (ALUop = "00") report "Erro no sinal ALUop no Fetch (LW)" severity error;
        assert (OrigPC = '0') report "Erro no sinal OrigPC no Fetch (LW)" severity error;
        assert (EscrevePC = '1') report "Erro no sinal EscrevePC no Fetch (LW)" severity error;
        assert (EscrevePCB = '1') report "Erro no sinal EscrevePCB no Fetch (LW)" severity error;

        opcode <= "0000011";

        wait for clk_period;

        assert (OrigAULA = "00") report "Erro no sinal OrigAULA no Fetch (LW)" severity error;
        assert (OrigBULA = "10") report "Erro no sinal OrigBULA no Fetch (LW)" severity error;
        assert (ALUop = "00") report "Erro no sinal ALUop no Fetch (LW)" severity error;
        wait for clk_period;

        assert (OrigAULA = "01") report "Erro no sinal OrigAULA no Fetch (LW)" severity error;
        assert (OrigBULA = "10") report "Erro no sinal OrigBULA no Fetch (LW)" severity error;
        assert (ALUop = "00") report "Erro no sinal ALUop no Fetch (LW)" severity error;
        wait for clk_period;

        assert (LouD = '1') report "Erro no sinal LeMem no MemRead (LW)" severity error;
        assert (LeMem = '1') report "Erro no sinal LeMem no MemRead (LW)" severity error;
        wait for clk_period;

        assert (Mem2Reg = "10") report "Erro no sinal Mem2Reg no WriteBack (LW)" severity error;
        assert (EscreveReg = '1') report "Erro no sinal EscreveReg no WriteBack (LW)" severity error;

        wait for clk_period;
    end process;

end architecture;
