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
	    Ula_in <= "0000"; -- ADD

	when "01" =>
	    case funct3 is
		when "000" =>
		    Ula_in <= "1100"; -- ==

		when "001" =>
		    Ula_in <= "1101"; -- !=

		when "100" =>
		    Ula_in <= "1000"; -- A < B signed

		when "101" =>
		    Ula_in <= "1010"; -- A >= B signed

		when "110" =>
		    Ula_in <= "1001"; -- A < B unsigned

		when "111" =>
		    Ula_in <= "1011"; -- A >= B unsigned

		when others =>
		    Ula_in <= "1111"; -- nop

	    end case;

	when "10" =>
	    case funct3 is
		when "000" =>
		    Ula_in <= "0000";

		when "010" =>
		    Ula_in <= "1000";  -- A < B signed

		when "011" =>
		    Ula_in <= "1001"; -- A < B unsigned

		when "100" =>
		    Ula_in <= "0100"; -- A xor B

		when "110" =>
		    Ula_in <= "0011"; -- A or B

		when "111" =>
		    Ula_in <= "0010"; -- A and B

		when "001" =>
		    Ula_in <= "0101"; -- A deslocado B bits a esquerda

		when "101" =>
		    if funct7 = '0' then
			Ula_in <= "0110"; -- A deslocado B bits a direita unsigned
		    else
			Ula_in <= "0111"; -- A deslocado B bits a direita signed
		    end if;

		when others =>
			Ula_in <= "1111"; -- nop

	    end case;

	when "11" =>
	    case funct3 is
		when "000" =>
		    if funct7 = '0' then
				Ula_in <= "0000";  -- ADD
		    else
				Ula_in <= "0001"; -- SUB
		    end if;

		when "010" =>
		    Ula_in <= "1000";  -- A < B signed

		when "011" =>
		    Ula_in <= "1001"; -- A < B unsigned

		when "100" =>
		    Ula_in <= "0100"; -- A xor B

		when "110" =>
		    Ula_in <= "0011"; -- A or B

		when "111" =>
		    Ula_in <= "0010"; -- A and B

		when "001" =>
		    Ula_in <= "0101"; -- A deslocado B bits a esquerda

		when "101" =>
		    if funct7 = '0' then
			Ula_in <= "0110"; -- A deslocado B bits a direita unsigned
		    else
			Ula_in <= "0111"; -- A deslocado B bits a direita signed
		    end if;

		when others =>
			Ula_in <= "1111"; -- nop

	    end case;

	when others =>
	    Ula_in <= "1111";

    end case;
end process;

UlaSel <= Ula_in;

end rtl;

