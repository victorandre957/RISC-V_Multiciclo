library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_GenImm32 is
end TB_GenImm32;

architecture behavior of TB_GenImm32 is
    component genImm32
        port (
            instr : in std_logic_vector(31 downto 0);
            imm32 : out signed(31 downto 0)
        );
    end component;

    signal instr : std_logic_vector(31 downto 0);
    signal imm32 : signed(31 downto 0);

    signal expected_imm : signed(31 downto 0);

begin
    uut: genImm32 port map (
        instr => instr,
        imm32 => imm32
    );

    process
    begin
        -- Test 1: add t0, zero, zero
        instr <= x"000002b3"; -- R-type, 0
        expected_imm <= x"00000000"; -- Expect 0
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test 1 Failed: add t0, zero, zero"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 1 Pass: add t0, zero, zero"
            severity note;

        -- Test 2: lw t0, 16(zero)
        instr <= x"01002283"; -- I-type0, imm = 16
        expected_imm <= to_signed(16, 32); -- Expect 16
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test 2 Failed: lw t0, 16(zero)"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 2 Pass: lw t0, 16(zero)"
            severity note;

        -- Test 3: addi t1, zero, -100
        instr <= x"f9c00313"; -- I-type1, imm = -100
        expected_imm <= to_signed(-100, 32); -- Expect -100
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test 3 Failed: addi t1, zero, -100"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 3 Pass: addi t1, zero, -100"
            severity note;

        -- Test 4: xori t0, t0, -1
        instr <= x"fff2c293"; -- I-type1, imm = -1
        expected_imm <= to_signed(-1, 32); -- Expect -1
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test 4 Failed: xori t0, t0, -1"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 4 Pass: xori t0, t0, -1"
            severity note;

        -- Test 5: addi t1, zero, 354
        instr <= x"16200313"; -- I-type1, imm = 354
        expected_imm <= to_signed(354, 32); -- Expect 354
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test 5 Failed: addi t1, zero, 354"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 5 Pass: addi t1, zero, 354"
            severity note;

        -- Test 6: jalr zero, zero, 0x18
        instr <= x"01800067"; -- I-type2, imm = 24
        expected_imm <= to_signed(24, 32); -- Expect 24
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test case 6 failed jalr zero, zero, 0x18"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 6 Pass: jalr zero, zero, 0x18"
            severity note;

        -- Test 7: srai t1, t2, 10
        instr <= x"40a3d313"; -- I-type*, imm = 10
        expected_imm <= to_signed(10, 32); -- Expect 10
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test case 7 failed srai t1, t2, 10"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 7 Pass: srai t1, t2, 10"
            severity note;

        -- Test 8: lui s0, 2
        instr <= x"00002437"; -- U-type, imm = 0x2000
        expected_imm <= x"00002000";
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test 8 failed lui s0, 2"
            severity note;
        assert not (imm32 = expected_imm)
            report "Test 8 Pass lui s0, 2"
            severity note;

        -- Test 9: sw t0, 60(s0)
        instr <= x"02542e23"; -- S-type, imm = 60
        expected_imm <= to_signed(60, 32); -- Expect 60
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test 9 Failed: sw t0, 60(s0)"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 9 Pass sw t0, 60(s0)"
            severity note;

        -- Test 10: bne t0, t0, main
        instr <= x"fe5290e3"; -- SB-type, imm = -32C (0xFFFFFFE0)
        expected_imm <= to_signed(-32, 32); -- Expect 0xFFFFFFE0
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test 10 Failed: bne t0, t0, main"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 10 Pass bne t0, t0, main"
            severity note;

        -- Test 11: jal rot
        instr <= x"00c000ef"; -- UJ-type, imm = 12
        expected_imm <= to_signed(12, 32); -- Expect 12
        wait for 10 ns;
        assert imm32 = expected_imm
            report "Test 11 Failed: jal rot"
            severity error;
        assert not (imm32 = expected_imm)
            report "Test 11 Pass jal rot"
            severity note;

        wait;
    end process;
end behavior;

