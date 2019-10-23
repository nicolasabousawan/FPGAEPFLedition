library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port(
        address : in  std_logic_vector(15 downto 0);
        cs_LEDS : out std_logic;
        cs_RAM  : out std_logic;
        cs_ROM  : out std_logic;
	cs_buttons : out std_logic
    );
end decoder;
architecture synth of decoder is
begin
assignements : process(address) is
begin
if (to_integer(unsigned(address)) < 4096) then
cs_ROM <= '1';
cs_RAM <= '0';
cs_LEDS <= '0';
cs_buttons <= '0';
elsif (to_integer(unsigned(address)) < 8192) then
cs_ROM <= '0';
cs_RAM <= '1';
cs_LEDS <= '0';
cs_buttons <= '0';
elsif (to_integer(unsigned(address)) < 8208) then
cs_ROM <= '0';
cs_RAM <= '0';
cs_LEDS <= '1';
cs_buttons <= '0';
elsif (to_integer(unsigned(address)) >= 8240) and (to_integer(unsigned(address)) <= 8244) then
cs_ROM <= '0';
cs_RAM <= '0';
cs_LEDS <= '0';
cs_buttons <= '1';
else
cs_ROM <= '0';
cs_RAM <= '0';
cs_LEDS <= '0';
cs_buttons <= '0';
end if;
end process assignements;
end synth;
