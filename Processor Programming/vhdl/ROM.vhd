library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is

component ROM_Block is 
PORT
	(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component ROM_Block;

signal s_address : std_logic_vector(9 downto 0);
signal enable : std_logic;
signal s_q : STD_LOGIC_VECTOR (31 DOWNTO 0);


begin

RB : ROM_Block port map(
address => address,
clock => clk,
q => s_q);

transition : process(clk, address, cs, read) is
begin
if (rising_edge(clk)) then
	enable <= cs and read;
end if;
end process transition;

read_process : process(enable, s_address) is
begin
rddata <= (others => 'Z');
if(enable = '1') then
	--rddata <= (others => '0');
	rddata <= s_q;
end if;
end process read_process;

end synth;
