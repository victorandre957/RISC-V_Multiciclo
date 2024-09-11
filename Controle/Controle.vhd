library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity risc_v_control is
    port (
        clk       : in STD_LOGIC;
        rst       : in STD_LOGIC;
        opcode    : in STD_LOGIC_VECTOR(6 downto 0);
        zero_flag : in STD_LOGIC;

        EscrevePCCond : out STD_LOGIC;
        EscrevePC     : out STD_LOGIC;
        LouD          : out STD_LOGIC;
        EscreveMem    : out STD_LOGIC;
        LeMem         : out STD_LOGIC;
        EscreveIR     : out STD_LOGIC;
        OrigPC        : out STD_LOGIC;
        ALUop         : out STD_LOGIC_VECTOR(1 downto 0);
        OrigAULA      : out STD_LOGIC_VECTOR(1 downto 0);
        OrigBULA      : out STD_LOGIC_VECTOR(1 downto 0);
        EscrevePCB    : out STD_LOGIC;
        EscreveReg    : out STD_LOGIC;
        Mem2Reg       : out STD_LOGIC_VECTOR(1 downto 0)
    );
end entity;

architecture fsm of risc_v_control is
    type state_type is (IFetch, Decode, ExLwSw, ExTr, ExTri, ExAuiPC, ExLui, ExBeq, ExJal, ExJalR, MemLw, MemSw, MemTR, WriteBeq);
    signal state      : state_type := IFetch;
    signal next_state : state_type := IFetch;

    constant LW     : STD_LOGIC_VECTOR(6 downto 0) := "0000011";
    constant SW     : STD_LOGIC_VECTOR(6 downto 0) := "0100011";
    constant R_TYPE : STD_LOGIC_VECTOR(6 downto 0) := "0110011";
    constant I_TYPE : STD_LOGIC_VECTOR(6 downto 0) := "0010011";
    constant JAL    : STD_LOGIC_VECTOR(6 downto 0) := "1101111";
    constant JALR   : STD_LOGIC_VECTOR(6 downto 0) := "1100111";
    constant BRANCH : STD_LOGIC_VECTOR(6 downto 0) := "1100011";
    constant AUIPC  : STD_LOGIC_VECTOR(6 downto 0) := "0010111";
    constant LUI    : STD_LOGIC_VECTOR(6 downto 0) := "0110111";

begin
    process (clk, rst)
    begin
        if rst = '1' then
            state <= IFetch;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    process (clk)
    begin
        EscrevePCCond <= '0';
        EscrevePC     <= '0';
        LouD          <= '0';
        EscreveMem    <= '0';
        LeMem         <= '0';
        EscreveIR     <= '0';
        OrigPC        <= '0';
        ALUop         <= "00";
        OrigAULA      <= "00";
        OrigBULA      <= "00";
        EscrevePCB    <= '0';
        EscreveReg    <= '0';
        Mem2Reg       <= "00";

        case state is
            when IFetch =>
                LeMem      <= '1';
                EscreveIR  <= '1';
                OrigAULA   <= "10";
                OrigBULA   <= "01";
                EscrevePC  <= '1';
                EscrevePCB <= '1';

                EscreveReg <= '0';
                EscreveMem <= '0';
                LouD       <= '0';
                OrigPC     <= '0';
                ALUop      <= "00";
                Mem2Reg    <= "00";

                next_state <= Decode;

            when Decode =>
                OrigAULA   <= "00";
                OrigBULA   <= "10";
                EscreveIR  <= '0';
                LeMem      <= '0';
                EscrevePC  <= '0';
                EscrevePCB <= '0';

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
                OrigAULA <= "01";
                OrigBULA <= "10";
                ALUop    <= "00";
                if opcode = LW then
                    next_state <= MemLw;
                else
                    next_state <= MemSW;
                end if;

            when ExTr =>
                OrigAULA   <= "01";
                OrigBULA   <= "00";
                ALUop      <= "11";
                next_state <= MemTR;

            when ExTri =>
                OrigAULA   <= "01";
                OrigBULA   <= "10";
                ALUop      <= "10";
                next_state <= MemTR;

            when ExBeq =>
                OrigAULA      <= "01";
                OrigBULA      <= "00";
                ALUop         <= "01";
                OrigPC        <= '1';
                EscrevePCCond <= '1';
                next_state    <= IFetch;

            when ExJal =>
                OrigAULA   <= "00";
                OrigBULA   <= "10";
                OrigPC     <= '1';
                EscrevePC  <= '1';
                Mem2Reg    <= "01";
                EscreveReg <= '1';
                ALUop      <= "00";
                next_state <= IFetch;

            when ExJalR =>
                OrigPC     <= '0';
                OrigAULA   <= "01";
                OrigBULA   <= "10";
                EscrevePC  <= '1';
                Mem2Reg    <= "01";
                EscreveReg <= '1';
                ALUop      <= "00";
                next_state <= IFetch;

            when ExAuiPC =>
                OrigAULA   <= "00";
                OrigBULA   <= "10";
                ALUop      <= "00";
                next_state <= MemTR;

            when ExLui =>
                OrigAULA   <= "11";
                OrigBULA   <= "10";
                ALUop      <= "00";
                next_state <= MemTR;

            when MemLw =>
                LouD       <= '1';
                LeMem      <= '1';
                next_state <= WriteBeq;

            when MemSw =>
                LouD       <= '1';
                EscreveMem <= '1';
                next_state <= IFetch;

            when MemTR =>
                Mem2Reg    <= "00";
                EscreveReg <= '1';
                next_state <= IFetch;

            when WriteBeq =>
                Mem2Reg    <= "10";
                EscreveReg <= '1';
                next_state <= IFetch;

            when others =>
                next_state <= IFetch;
        end case;
    end process;
end architecture;
