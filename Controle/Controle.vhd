library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity risc_v_control is
    port (
        clk       : in std_logic;
        rst       : in std_logic;
        opcode    : in std_logic_vector(6 downto 0);
        zero_flag : in std_logic;

        -- Saídas de controle
        EscrevePCCond : out std_logic;
        EscrevePC     : out std_logic;
        LouD          : out std_logic;
        EscreveMem    : out std_logic;
        LeMem         : out std_logic;
        EscreveIR     : out std_logic;
        OrigPC        : out std_logic;
        ALUop         : out std_logic_vector(1 downto 0);
        OrigAULA      : out std_logic_vector(1 downto 0);
        OrigBULA      : out std_logic_vector(1 downto 0);
        EscrevePCB    : out std_logic;
        EscreveReg    : out std_logic;
        Mem2Reg       : out std_logic_vector(1 downto 0)
    );
end entity;

architecture fsm of risc_v_control is
    type state_type is (IFetch, Decode, ExLwSw, ExTr, ExTri, ExAuiPC, ExLui, ExBeq, ExJal, ExJalR, MemLw, MemSw, MemTR, WriteBeq);
    signal state, next_state : state_type;

    -- Adicionar contador para o estado IFetch
    signal fetch_counter : integer range 0 to 1 := 0;

    -- Definir os opcodes das instruções RISC-V
    constant LW   : std_logic_vector(6 downto 0) := "0000011";
    constant SW   : std_logic_vector(6 downto 0) := "0100011";
    constant R_TYPE : std_logic_vector(6 downto 0) := "0110011";
    constant I_TYPE : std_logic_vector(6 downto 0) := "0010011";
    constant JAL : std_logic_vector(6 downto 0) := "1101111";
    constant JALR : std_logic_vector(6 downto 0) := "1100111";
    constant BRANCH : std_logic_vector(6 downto 0) := "1100011";
    constant AUIPC : std_logic_vector(6 downto 0) := "0010111";
    constant LUI : std_logic_vector(6 downto 0) := "0110111";

begin
    -- Estado s�ncrono com clock
    process (clk, rst)
    begin
        if rst = '1' then
            state <= IFetch;
            fetch_counter <= 0;
        elsif rising_edge(clk) then
            state <= next_state;
            if state = IFetch then
                if fetch_counter < 1 then
                    fetch_counter <= fetch_counter + 1;
                end if;
            else
                fetch_counter <= 0;
            end if;
        end if;
    end process;

    -- Máquina de estados do controle
    process (state, opcode, zero_flag, fetch_counter)
    begin
        -- Inicialização das saídas de controle
        EscrevePCCond <= '0';
        EscrevePC <= '0';
        LouD <= '0';
        EscreveMem <= '0';
        LeMem <= '0';
        EscreveIR <= '0';
        OrigPC <= '0';
        ALUop <= "00"; -- ADD
        OrigAULA <= "00"; -- PCBack register
        OrigBULA <= "00"; -- rs2
        EscrevePCB <= '0';
        EscreveReg <= '0';
        Mem2Reg <= "00"; -- SaidaULA

        case state is
            -- Instrução Fetch (IFetch)
            when IFetch =>
                LeMem <= '1';
                EscreveIR <= '1';
                OrigAULA <= "10"; -- PC
                OrigBULA <= "01"; -- 4
                EscrevePC <= '1';
                EscrevePCB <= '1';
                if fetch_counter = 1 then
                    next_state <= Decode;
                else
                    next_state <= IFetch;
                end if;

            -- Decodificação
            when Decode =>
                OrigBULA <= "10"; -- GemImm

                case opcode is
                    when LW =>
                        next_state <= ExLwSw;
                    when SW =>
                        next_state <= ExLwSw;
                    when R_TYPE =>
                        next_state <= ExTr;
                    when I_TYPE =>
                        next_state <= ExTri;
                    when AUIPC =>
                        next_state <= ExAuiPC;
                    when LUI =>
                        next_state <= ExLui;
                    when JAL =>
                        next_state <= ExJal;
                    when JALR =>
                        next_state <= ExJalR;
                    when BRANCH =>
                        next_state <= ExBeq;
                    when others =>
                        next_state <= IFetch;
                end case;

            when ExLwSw =>
                OrigAULA <= "01"; -- rs1
                OrigBULA <= "10"; -- -- GemImm
                if opcode = LW then
                    next_state <= MemLw;
                else
                    next_state <= MemSW;
                end if;

            when ExTr =>
                OrigAULA <= "01"; -- rs1
                OrigBULA <= "00"; -- rs2
                ALUop <= "10"; -- LogArit
                next_state <= MemTR;

            when ExTri =>
                OrigAULA <= "01"; -- rs1
                OrigBULA <= "10"; -- GemImm
                ALUop <= "10"; -- LogArit
                next_state <= MemTR;

            when ExBeq =>
                OrigAULA <= "01"; -- rs1
                OrigBULA <= "00"; -- rs2
                ALUop <= "01"; -- rs2
                OrigPC <= '1';
                EscrevePCCond <= '1';
                next_state <= IFetch;

            when ExJal =>
                OrigBULA <= "10"; -- GemImm
                OrigPC <= '1';
                EscrevePC <= '1';
                Mem2Reg <= "01";  -- PC
                EscreveReg <= '1';
                next_state <= IFetch;

            when ExJalR =>
                OrigPC <= '1';
                EscrevePC <= '1';
                Mem2Reg <= "01"; -- PC
                EscreveReg <= '1';
                next_state <= IFetch;

            when ExAuiPC =>
                OrigAULA <= "00"; -- PCBack register
                OrigBULA <= "10"; -- GemImm
                next_state <= MemTR;

            when ExLui =>
                OrigAULA <= "11"; -- zero no mux
                OrigBULA <= "10"; -- GemImm
                next_state <= MemTR;

            when MemLw =>
                LouD <= '1';
                LeMem <= '1';
                next_state <= WriteBeq;

            when MemSw =>
                LouD <= '1';
                EscreveMem <= '1';
                next_state <= IFetch;

            when MemTR =>
                Mem2Reg <= "00"; -- SaidaULA
                EscreveReg <= '1';
                next_state <= IFetch;

            when WriteBeq =>
                Mem2Reg <= "10"; -- Reg Data Memory
                EscreveReg <= '1';
                next_state <= IFetch;

            when others =>
                next_state <= IFetch;
        end case;
    end process;
end architecture;


