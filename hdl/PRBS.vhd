library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity PRBS is
	port( clock, reset : in std_logic;
			serial : out std_logic;
			Q : out std_logic_vector (9 downto 0));
end PRBS;



architecture behavior of PRBS is


--define required signals, including those used to represent the latches
signal init_val : std_logic_vector (9 downto 0) := "0001110001";
signal reg_array : std_logic_vector (9 downto 0);
signal con_bus : std_logic_vector (8 downto 0);
signal loop_buf : std_logic;



begin
--connect relevant signals to outputs
Q <= reg_array;
serial <= reg_array(9);
--logic which is present in the loop
loop_buf <= reg_array(9) xor reg_array(6);
	
process(clock, reset) 
begin
	--asynch reset
	if (reset = '0') then
		reg_array <= "0001110001";
		
	--step on falling edge clock
	elsif falling_edge(clock) then
		reg_array(0) <= loop_buf;
		reg_array(1) <= reg_array(0);
		reg_array(2) <= reg_array(1);
		reg_array(3) <= reg_array(2);
		reg_array(4) <= reg_array(3);
		reg_array(5) <= reg_array(4);
		reg_array(6) <= reg_array(5);
		reg_array(7) <= reg_array(6);
		reg_array(8) <= reg_array(7);
		reg_array(9) <= reg_array(8);
	end if;
		
	
end process;
	
	



end behavior;