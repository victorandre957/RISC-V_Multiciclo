library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity Memory is
    port (
        clock    : in std_logic;
        we       : in std_logic; -- write enable
        re       : in std_logic; -- read enable
        address  : in std_logic_vector(11 downto 0); -- 12 bits de endereço
        datain   : in std_logic_vector(31 downto 0); -- 32 bits de entrada
        dataout  : out std_logic_vector(31 downto 0) -- 32 bits de saída
    );
end entity Memory;

architecture rtl of Memory is
    constant ram_depth : natural := 4096;  -- A memória tem 4096 palavras
    constant ram_width : natural := 32;
    type ram_type is array (0 to ram_depth - 1) of std_logic_vector(ram_width - 1 downto 0);

    impure function init_ram_hex return ram_type is
        file text_file : text open read_mode is "data.txt";  -- Arquivo de instruções
        variable text_line : line;
        variable ram_content : ram_type;
    begin
        for i in 0 to ram_depth - 1 loop
            if (not endfile(text_file)) then
                readline(text_file, text_line);
                hread(text_line, ram_content(i));
            end if;
        end loop;

        return ram_content;
    end function;

    signal ram : ram_type := init_ram_hex;

begin
    dataout <= ram(to_integer(unsigned(address))) when (we = '0' and re = '1') else X"00000000";
    process(clock)
    begin
        if rising_edge(clock) then
            if we = '1' and re = '0' then
		ram(to_integer(unsigned(address))) <= datain;
            end if;
        end if;
    end process;

end architecture rtl;
