library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genImm32 is
    port (
        instr  : in std_logic_vector(31 downto 0);
        imm32  : out signed(31 downto 0)
    );
end genImm32;

architecture a of genImm32 is
    signal OPC : std_logic_vector(7 downto 0) :=  x"00";
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic;
    signal Immediate : std_logic_vector (31 downto 0) := x"00000000";

begin
    OPC  <= std_logic_vector(resize(signed('0' & instr(6 downto 0)), 8));
    funct3 <= instr(14 downto 12);
    funct7 <= instr(30);

    process(instr, OPC, funct3, funct7)
    begin
        case OPC is
            when x"33" =>
                Immediate <= std_logic_vector(resize(signed(instr(3 downto 2)), 32));

            when x"13" =>
                if funct3 = "101" then
                    if funct7 = '1' then
                        Immediate <= std_logic_vector(resize(signed(X"000000" & "000" & instr(24 downto 20)), 32));

                    else
                        Immediate <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));
                    end if;
                else
                    Immediate <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));
                end if;

            when x"03" =>
                Immediate <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));

            when x"67" =>
                Immediate <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));

            when x"23" =>
                Immediate <= std_logic_vector(resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32));

            when x"63" =>
                Immediate <= std_logic_vector(resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32));

            when x"37" =>
                Immediate <= std_logic_vector(signed(instr(31 downto 12) & x"000"));

            when  x"17" =>
                Immediate <= std_logic_vector(signed(instr(31 downto 12) & x"000"));

            when x"6F" =>
                Immediate <= std_logic_vector(resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32));

            when others =>
                Immediate <= x"00000000";
        end case;
    end process;

    imm32 <= signed(Immediate);

end a;

