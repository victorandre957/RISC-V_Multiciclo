library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity genImm32 is port (
    instr : in STD_LOGIC_VECTOR(31 downto 0);
    imm32 : out signed(31 downto 0)
);
end entity;

architecture Arch of genImm32 is
    type Instruction is (R, I, S, SB, UJ, U);
    signal currentInstruction                   : Instruction;
    signal opcode                               : unsigned(7 downto 0);
    signal immR, immI, immS, immSB, immUJ, immU : signed(31 downto 0);
    signal bit30                                : STD_LOGIC;
    signal funct3                               : unsigned(2 downto 0);
    signal checkI                               : unsigned(3 downto 0);
begin
    immR   <= to_signed(0, 32);
    immS   <= resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);
    immSB  <= resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32);
    immUJ  <= resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32);
    immU   <= resize(signed(instr(31 downto 12) & x"000"), 32);
    opcode <= resize(unsigned(instr(6 downto 0)), 8);
    bit30  <= instr(30);
    funct3 <= unsigned(instr(14 downto 12));
    checkI <= bit30 & funct3;
    with checkI select
        immI <=
        resize(signed(instr(24 downto 20)), 32) when "1101",
        resize(signed(instr(31 downto 20)), 32) when others;
    with opcode select
        currentInstruction <=
        R when x"33",
        I when x"03" | x"13" | x"67",
        S when x"23",
        SB when x"63",
        U when x"17" | x"37",
        UJ when x"6F",
        UJ when others;
    with currentInstruction select
        imm32 <=
        immI when I,
        immS when S,
        immSB when SB,
        immU when U,
        immUJ when UJ,
        immR when others;
end Arch;
