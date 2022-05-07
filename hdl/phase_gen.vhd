library ieee;
use ieee.std_logic_1164.all;

entity phase_gen is
	port( clock, reset : in std_logic;
			phased_clock : out std_logic_vector (7 downto 0));
			
end phase_gen;


architecture behavior of phase_gen is
signal phase_reg : std_logic_vector (7 downto 0);

begin
	--connect register signals to output
	phased_clock <= phase_reg;
	process (clock, reset)
	begin 
		--asynch reset
		if(reset = '0') then
			phase_reg(0) <= '1';
			phase_reg(7 downto 1) <= "0000000";
		--on clock event, shift all regs
		elsif (rising_edge(clock)) then
			phase_reg(0) <= phase_reg(7);
			phase_reg(1) <= phase_reg(0);
			phase_reg(2) <= phase_reg(1);
			phase_reg(3) <= phase_reg(2);
			phase_reg(4) <= phase_reg(3);
			phase_reg(5) <= phase_reg(4);
			phase_reg(6) <= phase_reg(5);
			phase_reg(7) <= phase_reg(6);
		end if;
	end process;
end behavior;