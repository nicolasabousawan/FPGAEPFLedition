library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is
signal s_b : std_logic_vector(31 downto 0);
--signal sum1 : unsigned(32 downto 0);
signal sum : std_logic_vector(32 downto 0);
signal s_sub_mode : std_logic_vector(32 downto 0);

begin

s_sub_mode <= (31 downto 0 => '0') & sub_mode;
s_b <= (b xor (31 downto 0 => sub_mode));
sum <= std_logic_vector(unsigned('0' & a) + unsigned('0' & s_b) + unsigned(s_sub_mode));

carry <= sum(32);

r <= sum(31 downto 0);
zero <= '1' when sum(31 downto 0) = (31 downto 0 => '0') else '0';



end synth;
