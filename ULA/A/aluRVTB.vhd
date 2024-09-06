entity aluRVTB is end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

architecture ArchTB of aluRVTB is
    component aluRV is
        port (
            opcode : in STD_LOGIC_VECTOR(3 downto 0);
            A, B   : in STD_LOGIC_VECTOR(31 downto 0);
            Z      : out STD_LOGIC_VECTOR(31 downto 0);
            zero   : out STD_LOGIC
        );
    end component;
    signal opcode_in         : STD_LOGIC_VECTOR(3 downto 0);
    signal A_in, B_in, Z_out : STD_LOGIC_VECTOR(31 downto 0);
    signal zero_out          : STD_LOGIC;
begin
    DUT : aluRV port map(opcode => opcode_in, A => A_in, B => B_in, Z => Z_out, zero => zero_out);
    process
    begin
        A_in <= STD_LOGIC_VECTOR(to_signed(17, 32));
        B_in <= STD_LOGIC_VECTOR(to_signed(3, 32));
        -- Test 1 - add
        opcode_in <= "0000";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(20, 32)) and zero_out = '0')
        report "Fail - Test 1" severity error;
        -- Test 2 - sub
        opcode_in <= "0001";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(14, 32)) and zero_out = '0')
        report "Fail - Test 2" severity error;
        -- Test 3 - and
        opcode_in <= "0010";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(1, 32)) and zero_out = '0')
        report "Fail - Test 3" severity error;
        -- Test 4 - or
        opcode_in <= "0011";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(19, 32)) and zero_out = '0')
        report "Fail - Test 4" severity error;
        -- Test 5 - xor
        opcode_in <= "0100";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(18, 32)) and zero_out = '0')
        report "Fail - Test 5" severity error;
        -- Test 6 - sll
        opcode_in <= "0101";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(136, 32)) and zero_out = '0')
        report "Fail - Test 6" severity error;
        -- Test 7 - srl
        opcode_in <= "0110";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(2, 32)) and zero_out = '0')
        report "Fail - Test 7" severity error;
        -- Test 8 - sra
        opcode_in <= "0111";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(2, 32)) and zero_out = '0')
        report "Fail - Test 8" severity error;
        -- Test 9 - slt
        opcode_in <= "1000";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(0, 32)) and zero_out = '1')
        report "Fail - Test 9" severity error;
        -- Test 10 - sltu
        opcode_in <= "1001";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(0, 32)) and zero_out = '1')
        report "Fail - Test 10" severity error;
        -- Test 11 - sge
        opcode_in <= "1010";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(1, 32)) and zero_out = '0')
        report "Fail - Test 11" severity error;
        -- Test 12 - sgeu
        opcode_in <= "1011";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(1, 32)) and zero_out = '0')
        report "Fail - Test 12" severity error;
        -- Test 13 - seq
        opcode_in <= "1100";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(0, 32)) and zero_out = '1')
        report "Fail - Test 13" severity error;
        -- Test 14 - sne
        opcode_in <= "1101";
        wait for 1 ns;
        assert (Z_out = STD_LOGIC_VECTOR(to_signed(1, 32)) and zero_out = '0')
        report "Fail - Test 14" severity error;
        -- Note informing that all tests were completed
        assert false report "All tests completed." severity note;
        wait;
    end process;
end ArchTB;
