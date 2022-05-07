library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div is
	generic( n : integer := 4);
	port( clock, reset : in std_logic;
			div_clock : out std_logic);
end clock_div;


architecture behavior of clock_div is
--count integer used to count clock edges 
signal count : integer range 0 to n-1;
begin 
	process(clock, reset)
	begin
		--asynch reset
		if reset = '0' then
			count <= 0;
		--clock event
		elsif(rising_edge(clock)) then
			--if fourth clock edge then raise output and reset count
			if(count = 3) then
				div_clock <= '1';
				count <= 0;
			--if not forth clock edge, increment count 
			else
				count <= count + 1;
				div_clock <= '0';
			end if;
		end if;
	end process;
end behavior;
			
	