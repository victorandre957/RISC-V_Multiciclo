library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Risc_V_Multicycle is
port(
    clock : in std_logic;
    reset : in std_logic;
    regInstrOut: out std_logic_vector(31 downto 0);
    rs1Out: out signed(31 downto 0);
    rs2Out: out signed(31 downto 0);
    imm32Out: out signed(31 downto 0);
    regDataOut: out signed(31 downto 0);
    pcOut: out unsigned(31 downto 0);
    Mem2RegOut: out std_logic_vector(1 downto 0);
    EscreveIROut : out std_logic;
    OrigAULAOut: out std_logic_vector(1 downto 0);
    OrigBULAOut: out std_logic_vector(1 downto 0)
);
end entity Risc_V_Multicycle;

architecture rtl of Risc_V_Multicycle is

-- base
signal pc: signed(31 downto 0);

--genImm
signal imm32 : signed(31 downto 0);

-- control
signal AluOp, OrigAULA, OrigBULA, Mem2Reg : std_logic_vector(1 downto 0);
signal EscrevePCCond, EscrevePC, LouD, EscreveMem, LeMem, EscreveIR, OrigPC, EscrevePCB, EscreveReg : std_logic;

-- Ula control
signal UlaSel  :  std_logic_vector(3 downto 0);

--  ULA
signal comp_flag : std_logic;

--mux(s)
signal MuxOrigPC, MuxOrigAULA, MuxOrigBULA, MuxLouD, MuxMem2Reg : signed(31 downto 0);
--Regs
signal regInstr : signed(31 downto 0);

signal SaidaUla, regSaidaUla, regData, pcBack, memData : signed(31 downto 0);
signal A, regA, B, regB : signed(31 downto 0);

begin

control: entity work.risc_v_control
    port map (
            clk           => clock,
            rst           => reset,
            opcode        => std_logic_vector(resize(unsigned(regInstr(6 downto 0)), 7)),
            zero_flag     => comp_flag,
            EscrevePCCond => EscrevePCCond,
            EscrevePC     => EscrevePC,
            LouD          => LouD,
            EscreveMem    => EscreveMem,
            LeMem         => LeMem,
            EscreveIR     => EscreveIR,
            OrigPC        => OrigPC,
            ALUop         => AluOp,
            OrigAULA      => OrigAULA,
            OrigBULA      => OrigBULA,
            EscrevePCB    => EscrevePCB,
            EscreveReg    => EscreveReg,
            Mem2Reg       => Mem2Reg
        );

controle_ula: entity work.risc_v_ULA_control
    port map (
        funct3  => std_logic_vector(resize(unsigned(regInstr(14 downto 12)), 3)),
        funct7  => std_logic_vector(resize(unsigned(regInstr(31 downto 25)), 7)),
        AluOp   => AluOp,
        UlaSel  => UlaSel
    );

a_reg: entity work.unitary_reg
    port map (
            clk     => clock,
            enable  => '1',
            dataIn  => A,
            dataOut => regA
        );

b_reg: entity work.unitary_reg
    port map (
            clk     => clock,
            enable  => '1',
            dataIn  => B,
            dataOut => regB
        );

pc_reg: entity work.unitary_reg
    port map (
            clk     => clock,
            enable  => EscrevePC or (EscrevePCCond and comp_flag),
            dataIn  => MuxOrigPC,
            dataOut => pc
        );

pc_back: entity work.unitary_reg
    port map (
            clk     => clock,
            enable  => EscrevePCB,
            dataIn  => pc,
            dataOut => pcBack
    );

saida_ula: entity work.unitary_reg
    port map (
            clk     => clock,
            enable  => '1',
            dataIn  => SaidaUla,
            dataOut => regSaidaUla
    );

reg_data: entity work.unitary_reg
    port map (
            clk     => clock,
            enable  => '1',
            dataIn  => memData,
            dataOut => regData
    );

reg_instr: entity work.unitary_reg
    port map (
            clk     => clock,
            enable  => EscreveIR,
            dataIn  => memData,
            dataOut => regInstr
    );

mux_loud: entity work.mux_1_to_2
    port map (
        A   =>   pc,
        B   =>   regSaidaUla,
        sel =>   LouD,
        Y   =>   MuxLouD
    );

memory: entity work.Memory
    port map (
        clock    => clock,
        we       => EscreveMem,
        re       => LeMem,
        address  => std_logic_vector(resize(unsigned(MuxLouD(13 downto 2)), 12)), -- 12 bits sem os 2 menos significativos
        datain   => regB,
        dataout  => memData
    );

mux_mem_2_reg: entity work.Mux_2_to_4
    port map (
        A   =>   regSaidaUla,
        B   =>   pc,
        C   =>   regData,
        D   =>   (others => '0'),
        sel =>   Mem2Reg,
        Y   =>   MuxMem2Reg
    );

xregs:  entity work.XREGS
    port map (
            clk  => clock,
            wren => EscreveReg,
            rs1  => std_logic_vector(resize(unsigned(regInstr(19 downto 15)), 5)),
            rs2  => std_logic_vector(resize(unsigned(regInstr(24 downto 20)), 5)),
            rd   => std_logic_vector(resize(unsigned(regInstr(11 downto 7)), 5)),
            data => MuxMem2Reg,
            ro1  => A,
            ro2  => B
    );

gen_imm: entity work.genImm32
    port map (
        instr => std_logic_vector(unsigned(regInstr)),
        imm32 => imm32
    );

mux_orig_aula: entity work.Mux_2_to_4
    port map (
        A   =>   pcBack,
        B   =>   regA,
        C   =>   pc,
        D   =>   (others => '0'),
        sel =>   OrigAULA,
        Y   =>   MuxOrigAULA
    );

mux_orig_bula: entity work.Mux_2_to_4
    port map (
        A   =>   regB,
        B   =>   x"00000004",
        C   =>   imm32,
        D   =>   (others => '0'),
        sel =>   OrigBULA,
        Y   =>   MuxOrigBULA
    );

ula: entity work.ULA
    port map (
        opcode    =>   UlaSel,
        A         =>   MuxOrigAULA,
        B         =>   MuxOrigBULA,
        result    =>   SaidaUla,
        comp_flag =>   comp_flag
    );

mux_orig_pc: entity work.mux_1_to_2
    port map (
        A   =>   SaidaUla,
        B   =>   regSaidaUla,
        sel =>   OrigPC,
        Y   =>   MuxOrigPC
    );

regInstrOut <= std_logic_vector(unsigned(regInstr));
rs1Out      <= regA;
rs2Out      <= regB;
imm32Out    <= imm32;
regDataOut  <= MuxMem2Reg;
pcOut       <= unsigned(pc);
Mem2RegOut     <= Mem2Reg;
EscreveIROut <= EscreveIR;

OrigAULAOut <= OrigAULA;
OrigBULAOut <= OrigBULA;

end architecture rtl;

