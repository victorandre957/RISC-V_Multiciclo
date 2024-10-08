library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity Memory is
    port (
        clock   : in STD_LOGIC;
        we      : in STD_LOGIC;                     -- write enable
        re      : in STD_LOGIC;                     -- read enable
        address : in STD_LOGIC_VECTOR(11 downto 0); 
        datain  : in signed(31 downto 0);           
        dataout : out signed(31 downto 0)           
    );
end entity Memory;

architecture rtl of Memory is
    constant ram_depth : NATURAL := 4096; 
    constant ram_width : NATURAL := 32;
    type ram_type is array (0 to ram_depth - 1) of STD_LOGIC_VECTOR(ram_width - 1 downto 0);

    impure function init_ram_hex return ram_type is
        file text_file       : text open read_mode is "data.txt"; -- Instructions file
        variable text_line   : line;
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

    signal ram  : ram_type := init_ram_hex;
    signal addr : INTEGER;

begin
    addr    <= to_integer(unsigned(address));
    dataout <= signed(ram(addr)) when (we = '0' and re = '1') else (others => '0');
    process (clock)
    begin
        if rising_edge(clock) then
            if we = '1' and re = '0' then
                ram(addr) <= STD_LOGIC_VECTOR(datain);
            end if;
        end if;
    end process;

end architecture rtl;
