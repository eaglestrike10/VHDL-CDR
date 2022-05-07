library ieee;
use ieee.std_logic_1164.all;

entity phase_rotator is
	port( p_clock : in std_logic_vector(7 downto 0);
			inc, dec, clock, reset : in std_logic;
			clk_edge, clk_early, clk_late : out std_logic);
end phase_rotator;

architecture behavior of phase_rotator is


--component declarations
component mux8to1 is
	port( d_in : in std_logic_vector( 7 downto 0);
			sel : in std_logic_vector (2 downto 0);
			q : out std_logic);
end component;

component counter is 
	generic(n : integer := 3);
	port( clock, reset, inc, dec : in std_logic;
			c_out : out std_logic_vector(n-1 downto 0));
end component;

--signal declarations
signal count : std_logic_vector(2 downto 0);

begin
	--counter module instantiation
	selector : counter
		generic map(n => 3)
		port map(clock => clock, reset => reset, inc => inc, dec =>dec, c_out =>count);
	
	--early, edge, and late mux instantiation
	early : mux8to1
		port map( d_in => p_clock, sel => count, q => clk_early);
			
	edge : mux8to1
		port map( d_in(5 downto 0) => p_clock(7 downto 2), d_in(7 downto 6) => p_clock(1 downto 0), sel => count, q => clk_edge);
		
	late : mux8to1
		port map( d_in(3 downto 0) => p_clock(7 downto 4), d_in(7 downto 4) => p_clock(3 downto 0), sel => count, q => clk_late);
		
end behavior;
		
