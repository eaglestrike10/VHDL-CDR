library ieee;
use ieee.std_logic_1164.all;

--define entity with all signals of interest as outputs
entity verification_tb is
	port( ref_clock : in std_logic;
			tx_clock : in std_logic;
			prbs_rst : in std_logic;
			cdr_rst : in std_logic;
			d_out : out std_logic;
			rec_clock : out std_logic;
			d_in : out std_logic;
			early : out std_logic;
			edge : out std_logic;
			late :out std_logic;
			up : out std_logic;
			down : out std_logic
			);
end verification_tb;


architecture tb of verification_tb is

--declare components
component CDR is 
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
end component;

component PRBS is
	port( clock, reset : in std_logic;
			serial : out std_logic;
			Q : out std_logic_vector (9 downto 0));
end component;

--declare signals needed including output buffers to avoid inferring a latch
signal ser_data, d_buf, rec_buf, early_buf, edge_buf, late_buf, up_buf, down_buf : std_logic;

begin
	--connect all relevant buffer signals to the respective outputs
	d_out <= d_buf;
	rec_clock <= rec_buf;
	early <= early_buf;
	edge <= edge_buf;
	late <= late_buf;
	up <= up_buf;
	down <= down_buf;

	--instantiate the prbs used to generate test data
	datagen : PRBS port map( clock => tx_clock,
									 reset => prbs_rst,
									 serial => ser_data);
	
	--instantiate the CDR to be tested
	DUT : CDR port map( d_in => ser_data,
							  ref_clock =>ref_clock,
							  reset => cdr_rst,
							  d_out => d_buf,
							  rec_clock => rec_buf,
							  early => early_buf,
							  edge => edge_buf,
							  late => late_buf,
							  up => up_buf,
							  down => down_buf);
	--wire PBRS output to the monitoring output from testbench
	d_in <= ser_data;
	
end tb;
