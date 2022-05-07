library ieee;
use ieee.std_logic_1164.all;

entity mux8to1 is
	port( d_in : in std_logic_vector( 7 downto 0);
			sel : in std_logic_vector (2 downto 0);
			q : out std_logic);
end mux8to1;

architecture behavior of mux8to1 is 

--a basic 8to1 mux with a 3 bit width for each data lane
begin
	process(sel, d_in) 
	begin
		case sel is 
			when "000" =>
				q <= d_in(0);
			when "001" =>
				q <= d_in(1);
			when "010" =>
				q <= d_in(2);
			when "011" =>
				q <= d_in(3);
			when "100" =>
				q <= d_in(4);
			when "101" =>
				q <= d_in(5);
			when "110" =>
				q <= d_in(6);
			when "111" =>
				q <= d_in(7);
			when others =>
				q <= 'U';
		end case;
	end process;
end behavior;