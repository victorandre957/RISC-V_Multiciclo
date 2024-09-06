library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity aluRV is
    port (
        opcode : in STD_LOGIC_VECTOR(3 downto 0);
        A, B   : in STD_LOGIC_VECTOR(31 downto 0);
        Z      : out STD_LOGIC_VECTOR(31 downto 0);
        zero   : out STD_LOGIC
    );
end aluRV;

architecture Arch of aluRV is
    signal set0     : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
    signal set1     : STD_LOGIC_VECTOR(31 downto 0) := x"00000001";
    signal Z_out    : STD_LOGIC_VECTOR(31 downto 0);
    signal A_lt_B   : STD_LOGIC_VECTOR(31 downto 0);
    signal A_lt_B_u : STD_LOGIC_VECTOR(31 downto 0);
    signal A_ge_B   : STD_LOGIC_VECTOR(31 downto 0);
    signal A_ge_B_u : STD_LOGIC_VECTOR(31 downto 0);
    signal A_eq_B   : STD_LOGIC_VECTOR(31 downto 0);
    signal A_neq_B  : STD_LOGIC_VECTOR(31 downto 0);
begin
    A_lt_B   <= set1 when (A(0) or B(0)) /= 'U' and signed(A) < signed(B) else set0;
    A_lt_B_u <= set1 when (A(0) or B(0)) /= 'U' and unsigned(A) < unsigned(B) else set0;
    A_ge_B   <= set1 when (A(0) or B(0)) /= 'U' and signed(A) >= signed(B) else set0;
    A_ge_B_u <= set1 when (A(0) or B(0)) /= 'U' and unsigned(A) >= unsigned(B) else set0;
    A_eq_B   <= set1 when (A(0) or B(0)) /= 'U' and A = B else set0;
    A_neq_B  <= set1 when (A(0) or B(0)) /= 'U' and A /= B else set0;
    with opcode select
        Z_out <=
        STD_LOGIC_VECTOR(signed(A) + signed(B)) when "0000",
        STD_LOGIC_VECTOR(signed(A) - signed(B)) when "0001",
        A and B when "0010",
        A or B when "0011",
        A xor B when "0100",
        STD_LOGIC_VECTOR(shift_left(unsigned(A), to_integer(unsigned(B)))) when "0101",
        STD_LOGIC_VECTOR(shift_right(unsigned(A), to_integer(unsigned(B)))) when "0110",
        STD_LOGIC_VECTOR(shift_right(signed(A), to_integer(unsigned(B)))) when "0111",
        A_lt_B when "1000",
        A_lt_B_u when "1001",
        A_ge_B when "1010",
        A_ge_B_u when "1011",
        A_eq_B when "1100",
        A_neq_B when "1101",
        set0 when others;
    Z    <= Z_out;
    zero <= '1' when Z_out = set0 else '0';
end Arch;
