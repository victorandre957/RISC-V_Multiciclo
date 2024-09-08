library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity risc_v_ULA_control is
port(
    funct3  : in std_logic_vector(2 downto 0);
    funct7  : in std_logic;
    AluOp   : in std_logic_vector(1 downto 0);
    UlaSel  : out std_logic_vector(3 downto 0)
);

end entity risc_v_ULA_control;

architecture rtl of risc_v_ULA_control is
signal Ula_in : std_logic_vector(3 downto 0);

begin
process(Aluop, funct3, funct7) is
    begin
    case Aluop is
	when "00" =>
	    Ula_in <= "0000";

	when "01" =>
	    case funct3 is
		when "000" =>
		    Ula_in <= "1100";

		when "001" =>
		    Ula_in <= "1101";

		when "100" =>
		    Ula_in <= "1000";

		when "101" =>
		    Ula_in <= "1010";

		when "110" =>
		    Ula_in <= "1001";

		when "111" =>
		    Ula_in <= "1011";

		when others =>
		    Ula_in <= "1111";

	    end case;

	when "10" =>
	    case funct3 is
		when "000" =>
		    Ula_in <= "0000";

		when "010" =>
		    Ula_in <= "1000";

		when "011" =>
		    Ula_in <= "1001";

		when "100" =>
		    Ula_in <= "0100";

		when "110" =>
		    Ula_in <= "0011";

		when "111" =>
		    Ula_in <= "0010";

		when "001" =>
		    Ula_in <= "0101";

		when "101" =>
		    if funct7 = '0' then
			Ula_in <= "0110";
		    else
			Ula_in <= "0111";
		    end if;

		when others =>
			Ula_in <= "1111";

	    end case;
	when "11" =>
	    case funct3 is
		when "000" =>
		    if funct7 = '0' then
			Ula_in <= "0000";
		    else
			Ula_in <= "0001";
		    end if;

		when "001" =>
		    Ula_in <= "0101";

		when "010" =>
		    Ula_in <= "1000";

		when "011" =>
		    Ula_in <= "1001";

		when "100" =>
		    Ula_in <= "0100";

		when "101" =>
		    if funct7 = '0' then
			Ula_in <= "0110";
		    else
			Ula_in <= "0111";
		    end if;

		when "110" =>
		    Ula_in <= "0011";

		when "111" =>
		    Ula_in <= "0010";

		when others =>
		    Ula_in <= "1111";

	end case;

	when others =>
	    Ula_in <= "1111";

    end case;
end process;

UlaSel <= Ula_in;

end rtl;

