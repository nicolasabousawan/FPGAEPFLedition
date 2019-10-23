library ieee;
use ieee.std_logic_1164.all;

entity IR is
    port(
        clk    : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic_vector(31 downto 0);
        Q      : out std_logic_vector(31 downto 0)
    );
end IR;

architecture synth of IR is
begin
p : process(clk, enable, D) is
begin
 if enable = '1' then
 	if rising_edge(clk) then
   		Q <= D;
  END IF;
 END IF;
end process p;
end synth;
