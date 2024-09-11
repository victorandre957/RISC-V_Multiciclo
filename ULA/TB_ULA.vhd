library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end ULA_tb;

architecture tb of ULA_tb is
    signal opcode               : STD_LOGIC_VECTOR(3 downto 0);
    signal operand_A, operand_B : signed(31 downto 0);
    signal result               : signed(31 downto 0);
    signal comp_flag            : STD_LOGIC;

    component ULA
        port (
            opcode    : in STD_LOGIC_VECTOR(3 downto 0);
            A, B      : in signed(31 downto 0);
            result    : out signed(31 downto 0);
            comp_flag : out STD_LOGIC
        );
    end component;

begin
    uut : ULA
    port map(
        opcode    => opcode,
        A         => operand_A,
        B         => operand_B,
        result    => result,
        comp_flag => comp_flag
    );

    process
    begin
        opcode    <= "0000"; -- ADD
        operand_A <= x"00000010";
        operand_B <= x"00000005";
        wait for 10 ns;
        assert (result = x"00000015" and comp_flag = '0')
        report "Error in ADD test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "0001"; -- SUB
        operand_A <= x"00000010";
        operand_B <= x"00000005";
        wait for 10 ns;
        assert (result = x"0000000B" and comp_flag = '0')
        report "Error in SUB test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "0010"; -- AND
        operand_A <= x"0000000F";
        operand_B <= x"000000F0";
        wait for 10 ns;
        assert (result = x"00000000" and comp_flag = '0')
        report "Error in AND test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "0011"; -- OR
        operand_A <= x"0000000F";
        operand_B <= x"000000F0";
        wait for 10 ns;
        assert (result = x"000000FF" and comp_flag = '0')
        report "Error in OR test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "0100"; -- XOR
        operand_A <= x"0000000F";
        operand_B <= x"000000F0";
        wait for 10 ns;
        assert (result = x"000000FF" and comp_flag = '0')
        report "Error in XOR test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "0101"; -- SLL
        operand_A <= x"00000001";
        operand_B <= x"00000003";
        wait for 10 ns;
        assert (result = x"00000008" and comp_flag = '0')
        report "Error in SLL test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "0110"; -- SRL
        operand_A <= x"00000008";
        operand_B <= x"00000002";
        wait for 10 ns;
        assert (result = x"00000002" and comp_flag = '0')
        report "Error in SRL test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "0111"; -- SRA
        operand_A <= x"FEFFFFF0";
        operand_B <= x"00000001";
        wait for 10 ns;
        assert (result = x"FF7FFFF8" and comp_flag = '0')
        report "Error in SRA test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "1000"; -- SLT
        operand_A <= x"00000005";
        operand_B <= x"00000010";
        wait for 10 ns;
        assert (result = x"00000001" and comp_flag = '1')
        report "Error in SLT test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "1001"; -- SLTU
        operand_A <= x"00000005";
        operand_B <= x"00000010";
        wait for 10 ns;
        assert (result = x"00000001" and comp_flag = '1')
        report "Error in SLTU test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "1010"; -- SGE
        operand_A <= x"00000010";
        operand_B <= x"00000005";
        wait for 10 ns;
        assert (result = x"00000001" and comp_flag = '1')
        report "Error in SGE test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "1011"; -- SGEU
        operand_A <= x"00000010";
        operand_B <= x"00000005";
        wait for 10 ns;
        assert (result = x"00000001" and comp_flag = '1')
        report "Error in SGEU test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "1100"; -- SEQ
        operand_A <= x"00000010";
        operand_B <= x"00000010";
        wait for 10 ns;
        assert (result = x"00000001" and comp_flag = '1')
        report "Error in SEQ test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "1101"; -- SNE
        operand_A <= x"00000010";
        operand_B <= x"00000005";
        wait for 10 ns;
        assert (result = x"00000001" and comp_flag = '1')
        report "Error in SNE test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        opcode    <= "1111"; -- Error
        operand_A <= x"00000010";
        operand_B <= x"00000005";
        wait for 10 ns;
        assert (result = x"FFFFFFFF" and comp_flag = '0')
        report "Error in Error test: result = " & INTEGER'image(to_integer(result)) &
            " and comp_flag = " & STD_LOGIC'image(comp_flag)
            severity error;

        wait;
    end process;
end tb;
