library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Risc_V_Multicycle is
    port (
        clock                                                                                                                   : in STD_LOGIC;
        reset                                                                                                                   : in STD_LOGIC;
        regInstrOut                                                                                                             : out STD_LOGIC_VECTOR(31 downto 0);
        regSaidaUlaOut                                                                                                          : out signed(31 downto 0);
        regDataUlaOut                                                                                                           : out signed(31 downto 0);
        imm32Out                                                                                                                : out signed(31 downto 0);
        AluOpOut, OrigAULAOut, OrigBULAOut, Mem2RegOut                                                                          : out STD_LOGIC_VECTOR(1 downto 0);
        EscrevePCCondOut, EscrevePCOut, LouDOut, EscreveMemOut, LeMemOut, EscreveIROut, OrigPCOut, EscrevePCBOut, EscreveRegOut : out STD_LOGIC;
        UlaSelOut                                                                                                               : out STD_LOGIC_VECTOR(3 downto 0);
        comp_flagOut                                                                                                            : out STD_LOGIC;
        MuxOrigPCOut, MuxOrigAULAOut, MuxOrigBULAOut, MuxLouDOut, MuxMem2RegOut                                                 : out signed(31 downto 0);
        SaidaUlaOut, pcBackOut, memDataOut                                                                                      : out signed(31 downto 0);
        AOut, regAOut, BOut, regBOut                                                                                            : out signed(31 downto 0);
        pcOut                                                                                                                   : out unsigned(31 downto 0)
    );
end entity Risc_V_Multicycle;

architecture rtl of Risc_V_Multicycle is

    -- base
    signal pc : signed(31 downto 0);

    --genImm
    signal imm32 : signed(31 downto 0);

    -- control
    signal AluOp, OrigAULA, OrigBULA, Mem2Reg                                                           : STD_LOGIC_VECTOR(1 downto 0);
    signal EscrevePCCond, EscrevePC, LouD, EscreveMem, LeMem, EscreveIR, OrigPC, EscrevePCB, EscreveReg : STD_LOGIC;

    -- Ula control
    signal UlaSel : STD_LOGIC_VECTOR(3 downto 0);

    --  ULA
    signal comp_flag : STD_LOGIC;

    --mux(s)
    signal MuxOrigPC, MuxOrigAULA, MuxOrigBULA, MuxLouD, MuxMem2Reg : signed(31 downto 0);
    --Regs
    signal regInstr : signed(31 downto 0);

    signal SaidaUla, regSaidaUla, regData, pcBack, memData : signed(31 downto 0);
    signal A, regA, B, regB                                : signed(31 downto 0);

begin
    control : entity work.risc_v_control
        port map(
            clk           => clock,
            rst           => reset,
            opcode        => STD_LOGIC_VECTOR(resize(unsigned(regInstr(6 downto 0)), 7)),
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

    pc_reg : entity work.unitary_reg
        port map(
            clk     => clock,
            enable  => EscrevePC or (EscrevePCCond and comp_flag),
            dataIn  => MuxOrigPC,
            dataOut => pc
        );

    mux_loud : entity work.mux_1_to_2
        port map(
            A   => pc,
            B   => regSaidaUla,
            sel => LouD,
            Y   => MuxLouD
        );

    memory : entity work.Memory
        port map(
            clock   => clock,
            we      => EscreveMem,
            re      => LeMem,
            address => STD_LOGIC_VECTOR(resize(unsigned(MuxLouD(13 downto 2)), 12)), -- 12 bits sem os 2 menos significativos
            datain  => regB,
            dataout => memData
        );

    reg_data : entity work.unitary_reg
        port map(
            clk     => clock,
            enable  => clock,
            dataIn  => memData,
            dataOut => regData
        );

    reg_instr : entity work.unitary_reg
        port map(
            clk     => clock,
            enable  => EscreveIR,
            dataIn  => memData,
            dataOut => regInstr
        );

    mux_mem_2_reg : entity work.Mux_2_to_4
        port map(
            A   => regSaidaUla,
            B   => pc,
            C   => regData,
            D => (others => '0'),
            sel => Mem2Reg,
            Y   => MuxMem2Reg
        );

    xregs : entity work.XREGS
        port map(
            clk  => clock,
            wren => EscreveReg,
            rs1  => STD_LOGIC_VECTOR(resize(unsigned(regInstr(19 downto 15)), 5)),
            rs2  => STD_LOGIC_VECTOR(resize(unsigned(regInstr(24 downto 20)), 5)),
            rd   => STD_LOGIC_VECTOR(resize(unsigned(regInstr(11 downto 7)), 5)),
            data => MuxMem2Reg,
            ro1  => A,
            ro2  => B
        );

    gen_imm : entity work.genImm32
        port map(
            instr => STD_LOGIC_VECTOR(unsigned(regInstr)),
            imm32 => imm32
        );

    a_reg : entity work.unitary_reg
        port map(
            clk     => clock,
            enable  => clock,
            dataIn  => A,
            dataOut => regA
        );

    b_reg : entity work.unitary_reg
        port map(
            clk     => clock,
            enable  => clock,
            dataIn  => B,
            dataOut => regB
        );

    pc_back : entity work.unitary_reg
        port map(
            clk     => clock,
            enable  => EscrevePCB,
            dataIn  => pc,
            dataOut => pcBack
        );

    mux_orig_aula : entity work.Mux_2_to_4
        port map(
            A   => pcBack,
            B   => regA,
            C   => pc,
            D => (others => '0'),
            sel => OrigAULA,
            Y   => MuxOrigAULA
        );

    mux_orig_bula : entity work.Mux_2_to_4
        port map(
            A   => regB,
            B   => x"00000004",
            C   => imm32,
            D => (others => '0'),
            sel => OrigBULA,
            Y   => MuxOrigBULA
        );

    controle_ula : entity work.risc_v_ULA_control
        port map(
            funct3 => STD_LOGIC_VECTOR(resize(unsigned(regInstr(14 downto 12)), 3)),
            funct7 => STD_LOGIC_VECTOR(resize(unsigned(regInstr(31 downto 25)), 7)),
            AluOp  => AluOp,
            UlaSel => UlaSel
        );

    ula : entity work.ULA
        port map(
            opcode    => UlaSel,
            A         => MuxOrigAULA,
            B         => MuxOrigBULA,
            result    => SaidaUla,
            comp_flag => comp_flag
        );

    saida_ula : entity work.unitary_reg
        port map(
            clk     => clock,
            enable  => clock,
            dataIn  => SaidaUla,
            dataOut => regSaidaUla
        );

    mux_orig_pc : entity work.mux_1_to_2
        port map(
            A   => SaidaUla,
            B   => regSaidaUla,
            sel => OrigPC,
            Y   => MuxOrigPC
        );

    regInstrOut      <= STD_LOGIC_VECTOR(unsigned(regInstr));
    regSaidaUlaOut   <= regSaidaUla; 
    pcOut            <= unsigned(pc);
    regDataUlaOut    <= MuxMem2Reg;
    Mem2RegOut       <= Mem2Reg;
    imm32Out         <= imm32;
    AluOpOut         <= AluOp;
    OrigAULAOut      <= OrigAULA;
    OrigBULAOut      <= OrigBULA;
    EscrevePCCondOut <= EscrevePCCond;
    EscrevePCOut     <= EscrevePC;
    LouDOut          <= LouD;
    EscreveMemOut    <= EscreveMem;
    LeMemOut         <= LeMem;
    EscreveIROut     <= EscreveIR;
    OrigPCOut        <= OrigPC;
    EscrevePCBOut    <= EscrevePCB;
    EscreveRegOut    <= EscreveReg;
    UlaSelOut        <= UlaSel;
    comp_flagOut     <= comp_flag;
    MuxOrigPCOut     <= MuxOrigPC;
    MuxOrigAULAOut   <= MuxOrigAULA;
    MuxOrigBULAOut   <= MuxOrigBULA;
    MuxLouDOut       <= MuxLouD;
    MuxMem2RegOut    <= MuxMem2Reg;
    SaidaUlaOut      <= SaidaUla;
    pcBackOut        <= pcBack;
    memDataOut       <= memData;
    AOut             <= A;
    regAOut          <= regA;
    BOut             <= B;
    regBOut          <= regB;

    end architecture rtl;
