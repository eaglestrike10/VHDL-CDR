library ieee;
use ieee.std_logic_1164.all;

--define entity with outputs for all signals of interest
entity CDR is
	port( d_in : in std_logic;
			ref_clock : in std_logic;
			reset : in std_logic;
			d_out : out std_logic;
			rec_clock : out std_logic;
			early : out std_logic;
			edge : out std_logic;
			late : out std_logic;
			up : out std_logic;
			down : out std_logic
			);
end CDR;

architecture structural of CDR is

--declare all components
component phase_rotator is
	port( p_clock : in std_logic_vector(7 downto 0);
			inc, dec, clock, reset : in std_logic;
			clk_edge, clk_early, clk_late : out std_logic);
end component;


component phase_gen is 
	port( clock, reset : in std_logic;
			phased_clock : out std_logic_vector (7 downto 0));
end component;


component phase_detector is
	port( d_in, clk_early, clk_edge, clk_late : in std_logic;
			up, down : out std_logic);
end component;


component digi_filter is
	port( p_in, n_in, clock : in std_logic;
			p_out, n_out : out std_logic);
end component;


component clock_div is
	port( clock, reset : in std_logic;
			div_clock : out std_logic);
end component;


component ff is
	port( D, clock : in std_logic;
			Q : out std_logic);
end component;

--declare useful signals for both intercomponent connection and outputs
signal phs_clock : std_logic_vector (7 downto 0);
signal up_con, down_con, early_con, edge_con, late_con, rec_con, inc_con, dec_con : std_logic;
signal qtr_clock, qtr_ff, late_ff : std_logic;

begin

	--instantiate components
	generator : phase_gen port map( clock => ref_clock, 
											  reset => reset, 
											  phased_clock => phs_clock);
											  
	rotator : phase_rotator port map( p_clock => phs_clock, 
												 clock => qtr_ff, 
												 reset => reset, 
												 inc => inc_con, 
												 dec => dec_con,
												 clk_early => early_con,
												 clk_edge => edge_con,
												 clk_late => late_con);
	
	--instantiate ffs present on several different clock lines
	ff1 : ff port map( D => late_con, 
							 clock => ref_clock,
							 Q => late_ff);
							 
	ff2 : ff port map( D => late_ff,
							 clock => ref_clock,
							 Q => rec_con);
	
	divider : clock_div port map( clock => qtr_ff, 
											reset => reset,
											div_clock => qtr_clock);
											
	ffclk : ff port map( D => qtr_clock,
								clock => ref_clock,
								Q => qtr_ff);
								
	ffrec : ff port map( D => d_in,
								clock => rec_con,
								Q => d_out);
								
								
								
	detector : phase_detector port map( d_in => d_in,
												  clk_early => early_con,
												  clk_edge => edge_con,
												  clk_late => late_con, 
												  up => up_con,
												  down => down_con);
												  
	filter : digi_filter port map( p_in => up_con,
											 n_in => down_con,
											 clock => late_ff,
											 p_out => dec_con,
											 n_out => inc_con);
											 
	--establish required connections for all signals							 
	up <= up_con;
	down <= down_con;
	early <= early_con;
	edge <= edge_con;
	late <= late_con;
	rec_clock <= rec_con;
				

end structural;				
			