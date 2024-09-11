library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity risc_v_ULA_control is
	port (
		funct3 : in STD_LOGIC_VECTOR(2 downto 0);
		funct7 : in STD_LOGIC_VECTOR(6 downto 0);
		AluOp  : in STD_LOGIC_VECTOR(1 downto 0);
		UlaSel : out STD_LOGIC_VECTOR(3 downto 0)
	);
end entity risc_v_ULA_control;

architecture rtl of risc_v_ULA_control is
	signal Ula_in : STD_LOGIC_VECTOR(3 downto 0);
begin
	process (AluOp, funct3, funct7)
	begin
		case AluOp is
			when "00" =>
				Ula_in <= "0000"; -- ADD

			when "01" =>
				case funct3 is
					when "000" =>
						Ula_in <= "1100"; -- Equal (==)
					when "001" =>
						Ula_in <= "1101"; -- Not Equal (!=)
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
						Ula_in <= "0000"; -- ADD
					when "010" =>
						Ula_in <= "1000"; -- A < B signed
					when "011" =>
						Ula_in <= "1001"; -- A < B unsigned
					when "100" =>
						Ula_in <= "0100"; -- A XOR B
					when "110" =>
						Ula_in <= "0011"; -- A OR B
					when "111" =>
						Ula_in <= "0010"; -- A AND B
					when "001" =>
						Ula_in <= "0101"; -- A << B (left shift)
					when "101" =>
						if funct7(5) = '0' then
							Ula_in <= "0110"; -- SRL (logical right shift)
						else
							Ula_in <= "0111"; -- SRA (arithmetic right shift)
						end if;
					when others =>
						Ula_in <= "1111"; -- nop
				end case;

			when "11" =>
				case funct3 is
					when "000" =>
						if funct7(5) = '0' then
							Ula_in <= "0000"; -- ADD
						else
							Ula_in <= "0001"; -- SUB
						end if;
					when "010" =>
						Ula_in <= "1000"; -- A < B signed
					when "011" =>
						Ula_in <= "1001"; -- A < B unsigned
					when "100" =>
						Ula_in <= "0100"; -- A XOR B
					when "110" =>
						Ula_in <= "0011"; -- A OR B
					when "111" =>
						Ula_in <= "0010"; -- A AND B
					when "001" =>
						Ula_in <= "0101"; -- A << B (left shift)
					when "101" =>
						if funct7(5) = '0' then
							Ula_in <= "0110"; -- SRL (logical right shift)
						else
							Ula_in <= "0111"; -- SRA (arithmetic right shift)
						end if;
					when others =>
						Ula_in <= "1111"; -- nop
				end case;

			when others =>
				Ula_in <= "1111"; -- nop
		end case;
	end process;

	UlaSel <= Ula_in;
end rtl;
