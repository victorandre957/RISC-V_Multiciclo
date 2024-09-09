library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port (
        opcode    : in STD_LOGIC_VECTOR(3 downto 0);
        A, B      : in signed(31 downto 0);
        result    : out signed(31 downto 0);
        comp_flag : out STD_LOGIC
    );
end ULA;

architecture Behavioral of ULA is
    type Operation_Type is (ADD_OP, SUB_OP, AND_OP, OR_OP, XOR_OP, SLL_OP, SRL_OP, SRA_OP,
        SLT_OP, SLTU_OP, SGE_OP, SGEU_OP, SEQ_OP, SNE_OP, ERROR_OP);
    signal current_operation : Operation_Type;
    signal alu_result        : signed(31 downto 0) := (others => '0');
    signal comparison_flag   : STD_LOGIC           := '0';

begin

    with opcode select
        current_operation <= ADD_OP when "0000",
        SUB_OP when "0001",
        AND_OP when "0010",
        OR_OP when "0011",
        XOR_OP when "0100",
        SLL_OP when "0101",
        SRL_OP when "0110",
        SRA_OP when "0111",
        SLT_OP when "1000",
        SLTU_OP when "1001",
        SGE_OP when "1010",
        SGEU_OP when "1011",
        SEQ_OP when "1100",
        SNE_OP when "1101",
        ERROR_OP when others;

    process (current_operation, A, B)
    begin
        case current_operation is
            when ADD_OP =>
                alu_result      <= A + B;
                comparison_flag <= '0';

            when SUB_OP =>
                alu_result      <= A - B;
                comparison_flag <= '0';

            when AND_OP =>
                alu_result      <= A and B;
                comparison_flag <= '0';

            when OR_OP =>
                alu_result      <= A or B;
                comparison_flag <= '0';

            when XOR_OP =>
                alu_result      <= A xor B;
                comparison_flag <= '0';

            when SLL_OP =>
                alu_result      <= A sll to_integer(B);
                comparison_flag <= '0';

            when SRL_OP =>
                alu_result      <= A srl to_integer(B);
                comparison_flag <= '0';

            when SRA_OP =>
                alu_result      <= shift_right(A, to_integer(B));
                comparison_flag <= '0';

            when SLT_OP =>
                if A < B then
                    alu_result      <= (others => '0');
                    alu_result(0)   <= '1';
                    comparison_flag <= '1';
                else
                    alu_result      <= (others => '0');
                    comparison_flag <= '0';
                end if;

            when SLTU_OP =>
                if unsigned(A) < unsigned(B) then
                    alu_result      <= (others => '0');
                    alu_result(0)   <= '1';
                    comparison_flag <= '1';
                else
                    alu_result      <= (others => '0');
                    comparison_flag <= '0';
                end if;

            when SGE_OP =>
                if A >= B then
                    alu_result      <= (others => '0');
                    alu_result(0)   <= '1';
                    comparison_flag <= '1';
                else
                    alu_result      <= (others => '0');
                    comparison_flag <= '0';
                end if;

            when SGEU_OP =>
                if unsigned(A) >= unsigned(B) then
                    alu_result      <= (others => '0');
                    alu_result(0)   <= '1';
                    comparison_flag <= '1';
                else
                    alu_result      <= (others => '0');
                    comparison_flag <= '0';
                end if;

            when SEQ_OP =>
                if A = B then
                    alu_result      <= (others => '0');
                    alu_result(0)   <= '1';
                    comparison_flag <= '1';
                else
                    alu_result      <= (others => '0');
                    comparison_flag <= '0';
                end if;

            when SNE_OP =>
                if A /= B then
                    alu_result      <= (others => '0');
                    alu_result(0)   <= '1';
                    comparison_flag <= '1';
                else
                    alu_result      <= (others => '0');
                    comparison_flag <= '0';
                end if;

            when ERROR_OP              =>
                alu_result      <= (others => '1');
                comparison_flag <= '0';

            when others                =>
                alu_result      <= (others => '0');
                comparison_flag <= '0';
        end case;
    end process;

    result    <= alu_result;
    comp_flag <= comparison_flag;

end Behavioral;
