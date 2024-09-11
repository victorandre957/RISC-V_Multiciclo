library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity testbench is end;

architecture TB of testbench is
    component Risc_V_Multicycle is
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
    end component;

    signal clk                                                                                                                     : STD_LOGIC := '0';
    signal reset                                                                                                                   : STD_LOGIC := '0';
    signal regInstrOut                                                                                                             : STD_LOGIC_VECTOR(31 downto 0);
    signal regSaidaUlaOut                                                                                                          : signed(31 downto 0);
    signal regDataUlaOut                                                                                                           : signed(31 downto 0);
    signal imm32Out                                                                                                                : signed(31 downto 0);
    signal AluOpOut, OrigAULAOut, OrigBULAOut, Mem2RegOut                                                                          : STD_LOGIC_VECTOR(1 downto 0);
    signal EscrevePCCondOut, EscrevePCOut, LouDOut, EscreveMemOut, LeMemOut, EscreveIROut, OrigPCOut, EscrevePCBOut, EscreveRegOut : STD_LOGIC;
    signal UlaSelOut                                                                                                               : STD_LOGIC_VECTOR(3 downto 0);
    signal comp_flagOut                                                                                                            : STD_LOGIC;
    signal MuxOrigPCOut, MuxOrigAULAOut, MuxOrigBULAOut, MuxLouDOut, MuxMem2RegOut                                                 : signed(31 downto 0);
    signal SaidaUlaOut, pcBackOut, memDataOut                                                                                      : signed(31 downto 0);
    signal AOut, regAOut, BOut, regBOut                                                                                            : signed(31 downto 0);
    signal pcOut                                                                                                                   : unsigned(31 downto 0);

    constant CLK_PERIOD : TIME := 1 ns;

begin
    dut : Risc_V_Multicycle port map(
        clock            => clk,
        reset            => reset,
        regInstrOut      => regInstrOut,
        regSaidaUlaOut   => regSaidaUlaOut,
        regDataUlaOut    => regDataUlaOut,
        Mem2RegOut       => Mem2RegOut,
        imm32Out         => imm32Out,
        AluOpOut         => AluOpOut,
        OrigAULAOut      => OrigAULAOut,
        OrigBULAOut      => OrigBULAOut,
        EscrevePCCondOut => EscrevePCCondOut,
        EscrevePCOut     => EscrevePCOut,
        LouDOut          => LouDOut,
        EscreveMemOut    => EscreveMemOut,
        LeMemOut         => LeMemOut,
        EscreveIROut     => EscreveIROut,
        OrigPCOut        => OrigPCOut,
        EscrevePCBOut    => EscrevePCBOut,
        EscreveRegOut    => EscreveRegOut,
        UlaSelOut        => UlaSelOut,
        comp_flagOut     => comp_flagOut,
        MuxOrigPCOut     => MuxOrigPCOut,
        MuxOrigAULAOut   => MuxOrigAULAOut,
        MuxOrigBULAOut   => MuxOrigBULAOut,
        MuxLouDOut       => MuxLouDOut,
        MuxMem2RegOut    => MuxMem2RegOut,
        SaidaUlaOut      => SaidaUlaOut,
        pcBackOut        => pcBackOut,
        memDataOut       => memDataOut,
        AOut             => AOut,
        regAOut          => regAOut,
        BOut             => BOut,
        regBOut          => regBOut,
        pcOut            => pcOut
    );

    clock_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stim_proc : process
    begin

        wait for CLK_PERIOD * 3.4; -- check result before instruction ends in 4 cycles
        assert (regInstrOut = x"000022b7" and MuxMem2RegOut = x"00002000")
        report "Test 1 Failed: lui x5, 2"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        -- test write in xregs
        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00028293" and MuxMem2RegOut = x"00002000")
        report "Test 1.5 Failed: addi x5, x5, 0"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00002217" and MuxMem2RegOut = x"00002008")
        report "Test 2 Failed: auipc x7, 2"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"00a00313" and regSaidaUlaOut = x"0000000a")
        -- report "Test 3 Failed: addi x6, x0, 10"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"0062a023" and regSaidaUlaOut = x"00002000")
        -- report "Test 4 Failed: sw x6, 0(x5)"
        --     severity error;

        -- wait for CLK_PERIOD * 5;
        -- assert (regInstrOut = x"0002a383" and regSaidaUlaOut = x"00002000")
        -- report "Test 5 Failed: lw x7, 0(x5)"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"00730433" and regSaidaUlaOut = x"00000014")
        -- report "Test 6 Failed: add x8, x6, x7"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"407404b3" and regSaidaUlaOut = x"0000000a")
        -- report "Test 7 Failed: sub x9, x8, x7"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"00747533" and regSaidaUlaOut = x"00000000")
        -- report "Test 8 Failed: and x10, x8, x7"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"007465b3" and regSaidaUlaOut = x"00000001e")
        -- report "Test 9 Failed: or x11, x8, x7"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"00744633" and regSaidaUlaOut = x"00000001e")
        -- report "Test 10 Failed: xor x12, x8, x7"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"0083a6b3" and regSaidaUlaOut = x"00000001")
        -- report "Test 11 Failed: slt x13, x7, x8"
        --     severity error;

        -- wait for CLK_PERIOD * 3;
        -- assert (regInstrOut = x"00050263" and regSaidaUlaOut = x"00000000")
        -- report "Test 12 Failed: beq x10, x0, 0x00000004"
        --     severity error;

        -- wait for CLK_PERIOD * 3;
        -- assert (regInstrOut = x"0083c263" and regSaidaUlaOut = x"00000001")
        -- report "Test 13 Failed: blt x7, x8, 0x00000004 "
        --     severity error;

        -- wait for CLK_PERIOD * 3;
        -- assert (regInstrOut = x"00745263" and regSaidaUlaOut = x"00000001")
        -- report "Test 14 Failed: bge x8, x7, 0x00000004"
        --     severity error;

        -- wait for CLK_PERIOD * 3;
        -- assert (regInstrOut = x"0083e263" and regSaidaUlaOut = x"00000001")
        -- report "Test 15 Failed: bltu x7, x8, 0x00000004"
        --     severity error;

        -- wait for CLK_PERIOD * 3;
        -- assert (regInstrOut = x"00747263" and regSaidaUlaOut = x"00000001")
        -- report "Test 16 Failed: bgeu x8, x7, 0x00000004"
        --     severity error;

        -- wait for CLK_PERIOD * 3;
        -- assert (regInstrOut = x"00051263" and regSaidaUlaOut = x"00000001")
        -- report "Test 17 Failed: bne x10, x0, bne_label"
        --     severity error;

        -- wait for CLK_PERIOD * 3;
        -- assert (regInstrOut = x"0040076f" and regSaidaUlaOut = x"00000048")
        -- report "Test 18 Failed: jal x14, jump_label "
        --     severity error;

        -- wait for CLK_PERIOD * 3;
        -- assert (regInstrOut = x"004707e7" and regSaidaUlaOut = x"0000004c")
        -- report "Test 19 Failed: jalr x15, 4(x14)"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"0ff36813" and regSaidaUlaOut = x"000000ff")
        -- report "Test 20 Failed: ori x16, x6, 0xFF"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"00f37893" and regSaidaUlaOut = x"0000000a")
        -- report "Test 21 Failed: andi x17, x6, 0xF"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"0f034913" and regSaidaUlaOut = x"000000fa")
        -- report "Test 22 Failed: xori x18, x6, 0xF0"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"06432993" and regSaidaUlaOut = x"00000001")
        -- report "Test 23 Failed: slti x19, x6, 100"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"06433a13" and regSaidaUlaOut = x"00000001")
        -- report "Test 24 Failed: sltiu x20, x6, 100"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"00539ab3" and regSaidaUlaOut = x"0000000a")
        -- report "Test 25 Failed: sll x21, x7, x5"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"0053db33" and regSaidaUlaOut = x"0000000a")
        -- report "Test 26 Failed: srl x22, x7, x5"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"4053dbb3" and regSaidaUlaOut = x"0000000a")
        -- report "Test 27 Failed: sra x23, x7, x5"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"00239c13" and regSaidaUlaOut = x"00000028")
        -- report "Test 28 Failed: slli x24, x7, 2"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"0023dc93" and regSaidaUlaOut = x"00000002")
        -- report "Test 29 Failed: srli x25, x7, 2"
        --     severity error;

        -- wait for CLK_PERIOD * 4;
        -- assert (regInstrOut = x"4023dd13" and regSaidaUlaOut = x"00000002")
        -- report "Test 30 Failed: srai x26, x7, 2"
        --     severity error;

    end process;
end TB;
