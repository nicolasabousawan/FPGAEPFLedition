library ieee;
use ieee.std_logic_1164.all;

entity extend is
    port(
        imm16  : in  std_logic_vector(15 downto 0);
        signed : in  std_logic;
        imm32  : out std_logic_vector(31 downto 0)
    );
end extend;

architecture synth of extend is
begin
p : process(imm16, signed) is
begin
	if signed = '1' then
		imm32 <= (15 downto 0 => imm16(15)) & imm16;
	else imm32 <= (15 downto 0 => '0') & imm16;
	END IF;
end process p;
end synth;
