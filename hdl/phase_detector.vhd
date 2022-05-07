library ieee;
use ieee.std_logic_1164.all;

entity phase_detector is
	port( d_in, clk_early, clk_edge, clk_late : in std_logic;
			up, down : out std_logic);
end phase_detector;

architecture behavior of phase_detector is

component ff is
	port( D, clock : in std_logic;
			Q : out std_logic);
end component;

signal early_out, edge_out, late_out, up_in, down_in : std_logic;
begin
	
	early : ff port map(D => d_in, Q => early_out, clock => clk_early);
	edge : ff port map(D => d_in, Q => edge_out, clock => clk_edge);
	late : ff port map(D => d_in, Q => late_out, clock => clk_late);
	
	up_in <= early_out xor edge_out;
	down_in <= edge_out xor late_out;
	
	up_ff : ff port map(D => up_in, Q => up, clock => not clk_late);
	down_ff : ff port map(D => down_in, Q => down, clock => not clk_late);
	
end behavior;
	
	
	