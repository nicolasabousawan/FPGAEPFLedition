library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);
        rddata  : out std_logic_vector(31 downto 0));
end RAM;

architecture synth of RAM is

type reg_type is array(0 to 1023) of std_logic_vector(31 downto 0);
signal reg: reg_type;
signal s_adress : std_logic_vector(9 downto 0);
signal read_enable : std_logic;

begin

transition : process(clk, address, cs, read) is
begin
if (rising_edge(clk)) then
	s_adress <= address;
	read_enable <= cs and read;

	if ((write ='1') and (cs = '1')) then
	reg(to_integer(unsigned(address))) <= wrdata;
	end if;
end if;
end process transition;

read_process : process(read_enable, s_adress) is
begin
rddata <= (others => 'Z');
if(read_enable = '1') then
	--rddata <= (others => '0');
	rddata <= reg(to_integer(unsigned(s_adress)));
end if;
end process read_process;
end synth;
