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
        report "Test 2 Failed: addi x5, x5, 0"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00002217" and MuxMem2RegOut = x"00002008")
        report "Test 3 Failed: auipc x7, 2"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00a00313" and MuxMem2RegOut = x"0000000a")
        report "Test 4 Failed: addi x6, x0, 10"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00630433" and MuxMem2RegOut = x"00000014")
        report "Test 5 Failed: add x8, x6, x6"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"406404b3" and MuxMem2RegOut = x"0000000a")
        report "Test 6 Failed: sub x9, x8, x6"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00647533" and MuxMem2RegOut = x"00000000")
        report "Test 7 Failed: and x10, x8, x6"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"006465b3" and MuxMem2RegOut = x"0000001e")
        report "Test 8 Failed: or x11, x8, x6"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00644633" and MuxMem2RegOut = x"0000001e")
        report "Test 9 Failed: xor x12, x8, x6"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"008326b3" and MuxMem2RegOut = x"00000001")
        report "Test 10 Failed: slt x13, x6, x8"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 2.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"0080076f" and MuxOrigPCOut = x"00000030" and MuxMem2RegOut = x"0000002c")
        report "Test 11 Failed: jal x14, 0x00000008"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 2.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00c707e7" and MuxOrigPCOut = x"00000038" and MuxMem2RegOut = x"00000034")
        report "Test 12 Failed: jalr x15, 12(x14)"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"0ff36813" and MuxMem2RegOut = x"000000ff")
        report "Test 13 Failed: ori x16, x6, 0XFF"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00f37893" and MuxMem2RegOut = x"0000000a")
        report "Test 14 Failed: and x17, x6, 0XF"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"0f034913" and MuxMem2RegOut = x"000000fa")
        report "Test 15 Failed: xori x18, x6, 0XF0"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"06432993" and MuxMem2RegOut = x"00000001")
        report "Test 16 Failed: slti x19, x6, 100"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"06433a13" and MuxMem2RegOut = x"00000001")
        report "Test 17 Failed: sltiu x20, x6, 100"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00531ab3" and MuxMem2RegOut = x"0000000a")
        report "Test 18 Failed: sll x21, x6, x5"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00535b33" and MuxMem2RegOut = x"0000000a")
        report "Test 19 Failed: srl x22, x6, x5"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"40535bb3" and MuxMem2RegOut = x"0000000a")
        report "Test 20 Failed: sra x23, x6, x5"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00231c13" and MuxMem2RegOut = x"00000028")
        report "Test 21 Failed: slli x24, x6, 2"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00235c93" and MuxMem2RegOut = x"00000002")
        report "Test 22 Failed: srli x25, x6, 2"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"40235d13" and MuxMem2RegOut = x"00000002")
        report "Test 23 Failed: srai x26, x6, 2"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 2.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00930463" and MuxOrigPCOut = x"0000006c")
        report "Test 24 Failed: beq x6, x9, 0x00000008"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 2.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00834463" and MuxOrigPCOut = x"00000074")
        report "Test 25 Failed: blt x6, x9, 0x00000008"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 2.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00645463" and MuxOrigPCOut = x"0000007c")
        report "Test 26 Failed: bge x8, x6, 0x00000008"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 2.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00836463" and MuxOrigPCOut = x"00000084")
        report "Test 27 Failed: bltu x6, x8, 0x00000008"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 2.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00647463" and MuxOrigPCOut = x"0000008c")
        report "Test 28 Failed: bgeu x8, x0 0x00000008"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 2.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00041463" and MuxOrigPCOut = x"00000094")
        report "Test 29 Failed: bne x8, x0 0x00000008"
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"00002eb7" and MuxMem2RegOut = x"00002000")
        report "Test 30 Failed: lui x9, 2" -- address to save
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"006ea023" and MuxLouDOut = x"00002000")
        report "Test 31 Failed: sw x6, 0(x29)" 
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 4.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"000eaf03" and MuxMem2RegOut = x"0000000a")
        report "Test 32 Failed: lw x30, 0(x29)" 
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end

        wait for CLK_PERIOD * 3.4; --check result before instruction ends in 4 cycles
        assert (regInstrOut = x"01e00f33" and MuxMem2RegOut = x"0000000a")
        report "Test 33 Failed: add x30, x0, x30" -- ensure the load worked
            severity error;
        wait for CLK_PERIOD * 0.6; -- wait instruction end
        
        wait;
    end process;
end TB;
