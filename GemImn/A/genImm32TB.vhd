entity genImm32TB is end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

architecture ArchTB of genImm32TB is
    component genImm32 is
        port (
            instr : in STD_LOGIC_VECTOR(31 downto 0);
            imm32 : out signed(31 downto 0)
        );
    end component;
    signal instr_in  : STD_LOGIC_VECTOR(31 downto 0);
    signal imm32_out : signed(31 downto 0);
begin
    DUT : genImm32 port map(instr => instr_in, imm32 => imm32_out);
    process
    begin
        -- Test 1: add t0, zero, zero
        instr_in <= x"000002b3";
        wait for 1 ns;
        assert (imm32_out = x"00000000") report "FAIL - Test 1" severity error;
        -- Test 2: lw t0, 16(zero)
        instr_in <= x"01002283";
        wait for 1 ns;
        assert (imm32_out = x"00000010") report "FAIL - Test 2" severity error;
        -- Test 3: addi t1, zero, -100
        instr_in <= x"f9c00313";
        wait for 1 ns;
        assert (imm32_out = x"FFFFFF9C") report "FAIL - Test 3" severity error;
        -- Test 4: xori t0, t0, -1
        instr_in <= x"fff2c293";
        wait for 1 ns;
        assert (imm32_out = x"FFFFFFFF") report "FAIL - Test 4" severity error;
        -- Test 5: addi t1, zero, 354
        instr_in <= x"16200313";
        wait for 1 ns;
        assert (imm32_out = x"00000162") report "FAIL - Test 5" severity error;
        -- Test 6: jalr zero, zero, 0x18
        instr_in <= x"01800067";
        wait for 1 ns;
        assert (imm32_out = x"00000018") report "FAIL - Test 6" severity error;
        -- Test 7: srai t1, t2, 10
        instr_in <= x"40a3d313";
        wait for 1 ns;
        assert (imm32_out = x"0000000A") report "FAIL - Test 7" severity error;
        -- Test 8: lui s0, 2
        instr_in <= x"00002437";
        wait for 1 ns;
        assert (imm32_out = x"00002000") report "FAIL - Test 8" severity error;
        -- Test 9: sw t0, 60(s0)
        instr_in <= x"02542e23";
        wait for 1 ns;
        assert (imm32_out = x"0000003C") report "FAIL - Test 9" severity error;
        -- Test 10: bne t0, t0, main
        instr_in <= x"fe5290e3";
        wait for 1 ns;
        assert (imm32_out = x"FFFFFFE0") report "FAIL - Test 10" severity error;
        -- Test 11: jal rot
        instr_in <= x"00c000ef";
        wait for 1 ns;
        assert (imm32_out = x"0000000C") report "FAIL - Test 11" severity error;
        -- Note informing that all tests were completed
        assert false report "All tests completed." severity note;
        wait;
    end process;
end ArchTB;
