library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is
TYPE State_type IS (FETCH1, FETCH2, DECODE, R_OP, STORE, BREAK, LOAD1, LOAD2, I_OP, BRANCH, CALL, JMP, RI_OP, UI_OP);
SIGNAL current_state, next_state : State_Type;
begin

dff : process(clk, reset_n) is
begin
if reset_n = '0'
	then current_state <= FETCH1;
elsif rising_edge(clk)
	then current_state <= next_state;
end if;
end process dff;

transition : process(reset_n, op, opx, current_state) is
begin
pc_add_imm <= '0';
pc_sel_a <= '0';
pc_sel_imm <= '0';
sel_mem <= '0';
sel_pc <= '0';
sel_ra <= '0';
branch_op <= '0';
pc_en <= '0';
ir_en <= '0';
read <= '0';
sel_addr <= '0';
sel_b <= '0';
rf_wren <= '0';
sel_rC <= '0';
write <= '0';
imm_signed <= '0';

case(current_state) is
when FETCH1 =>
	read <= '1';
	next_state <= FETCH2;
when FETCH2 =>
	ir_en <= '1';
	pc_en <= '1';
	next_state <= DECODE;

when DECODE =>
	case(op) is
	when "010111" =>
		next_state <= LOAD1;

	when "010101" =>
		next_state <= STORE;
	when "000001" =>
		next_state <= JMP;

	when "111010" =>
		case(opx) is
		when "110100" => next_state <= BREAK;
		when "001101" | "000101" => next_state <= JMP;
		when "011101" => next_state <= CALL;
		--when "001100" | "010100" | "011100" | "101000" | "110000" => next_state <= UI_OP;
		when "010010" | "011010" | "111010" | "000010" => next_state <= RI_OP;
		when others => next_state <= R_OP;
		end case;
	when "000000" => next_state <= CALL;
	when "000110" | "001110" | "010110" | "011110" | "100110" | "101110" | "110110" => next_state <= BRANCH;
	when "001100" | "010100" | "011100" | "101000" | "110000" => next_state <= UI_OP;
	when others => next_state <= I_OP;
	end case;

when LOAD1 =>
	next_state <= LOAD2;
	read <= '1';
	sel_addr <= '1';
	imm_signed <= '1';
when LOAD2 =>
	next_state <= FETCH1;
	rf_wren <= '1';
	sel_mem <= '1';
when STORE =>
	next_state <= FETCH1;
	write <= '1';
	sel_addr <= '1';
	imm_signed <= '1';
when I_OP =>
	next_state <= FETCH1;
	rf_wren <= '1';
	imm_signed <= '1';
when R_OP =>
	next_state <= FETCH1;
	rf_wren <= '1';
	sel_b <= '1';
	sel_rC <= '1';
when BRANCH =>
	next_state <= FETCH1;
	branch_op <= '1';
	sel_b <= '1';
	pc_add_imm <= '1';
when CALL =>
	next_state <= FETCH1;
	rf_wren <= '1';
	sel_pc <= '1';
	sel_ra <= '1';
	pc_en <= '1';
	if opx = "011101" then
		pc_sel_a <= '1';
		pc_sel_imm <= '0';
	else
		pc_sel_imm <= '1';
		pc_sel_a <= '0';
	end if;
when JMP =>
	next_state <= FETCH1;
	pc_en <= '1';
	if op = "000001" then
		pc_sel_a <= '0';
		pc_sel_imm <= '1';
	else
		pc_sel_a <= '1';
		pc_sel_imm <= '0';
	end if;
when UI_OP =>
	--pc_add_imm <= '1';
	rf_wren <= '1';
	next_state <= FETCH1;

when RI_OP =>
	pc_add_imm <= '1';
	rf_wren <= '1';
	sel_rC <= '1';
	next_state <= FETCH1;
	
	--if "001100" | | "011100" then
	--	op_alu <= "011
--elsif "010100"

--	elsif "101000" | "110000"
when BREAK => next_state <= BREAK;
when others => next_state <= FETCH1;
end case;

end process transition;

alu_review : process(op, opx) is
begin
case(op) is
when "111010" =>
    case(opx) is
    --when "001110" =>
    --    op_alu <= "100001";
     --when "011011" =>
    --    op_alu <= "110011";
  -- NEW CODE ENTERED HERE BY NICOLAS
       when "110001" =>  -- add
            op_alu <= "000000";
       when "111001" => -- sub
            op_alu <= "001000";
         when "001000" | "010000" | "011000" | "100000" | "101000" | "110000" => -- compare
            op_alu <= "011" & opx(5 downto 3);
       when "000110" | "001110" | "010110" | "011110" => -- logical
            op_alu <= "100" & opx(5 downto 3);
       when "010011" | "011011" | "111011" | "010010" | "011010" | "111010" | "000011" | "001011" | "000010"  => --shift/rotate
            op_alu <= "110" & opx(5 downto 3);
    --elsif opx = "011101" then
        --op_alu <=
    when others =>
     end case;
when "000110" => op_alu <= "011100";
when "001110" => op_alu <= "011001";
when "010110" => op_alu <= "011010";
when "011110" => op_alu <= "011011";
when "100110" => op_alu <= "011100";
when "101110" => op_alu <= "011101";
when "110110" => op_alu <= "011110";
-- NICOLAS CODE START HERE
when "001100" | "010100" | "011100" => -- logic
  op_alu <= "100" & op(5 downto 3);
when "001000" | "010000" | "011000" | "100000" | "101000" | "110000" =>  -- compare
  op_alu <= "011" & op(5 downto 3);
 --| "011010" | "111010" | "000010"

--when opx = "001000" | "010000" | "011000" | "100000" | "101000" | "110000" then -- compare

when others => op_alu <= "000000";
end case;
--op_alu <= opx when op = "111010" else op;
end process alu_review;

--op_alu <= opx when op = "111010" else op;


end synth;
