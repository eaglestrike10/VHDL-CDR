library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;


entity digi_filter is
	port( p_in, n_in, clock : in std_logic;
			p_out, n_out : out std_logic);
end digi_filter;


architecture behavior of digi_filter is
signal p_reg, n_reg : std_logic_vector (3 downto 0);
signal p_sum, n_sum : std_logic;

begin
	
	--read registers and generate output
	p_sum <= p_reg(0) or p_reg(1) or p_reg(2) or p_reg(3); --or_reduce() is not recognized for some reason
	n_sum <= n_reg(0) or n_reg(1) or n_reg(2) or n_reg(3);
	p_out <= p_sum or not n_sum;
	n_out <= n_sum or not p_sum;
	
	process(clock)
	begin
		--update registers on positive clock edge
		if(rising_edge(clock)) then
			p_reg(0) <= p_in;
			p_reg(1) <= p_reg(0);
			p_reg(2) <= p_reg(1);
			p_reg(3) <= p_reg(2);
			
			n_reg(0) <= n_in;
			n_reg(1) <= n_reg(0);
			n_reg(2) <= n_reg(1);
			n_reg(3) <= n_reg(2);
		end if;
	end process;
end behavior;
	