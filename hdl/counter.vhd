library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is 
	generic(n : integer := 3);
	port( clock, reset, inc, dec : in std_logic;
			c_out : out std_logic_vector(n-1 downto 0));
end counter;

architecture behavior of counter is 
signal count : integer range 0 to n-1 := 0;
begin
--convert and ouput current count value 
c_out <= std_logic_vector(to_unsigned(count, 3));

	process(clock, reset)
	begin
		-- asynch reset
		if(reset = '0') then
			count<= 0;
		--change value on clock event
		elsif(rising_edge(clock)) then 
			if(inc = '1') then
				count <= count + 1;
			elsif(dec = '1') then
				count <= count - 1;
			end if;
		end if;
	end process;
end behavior;