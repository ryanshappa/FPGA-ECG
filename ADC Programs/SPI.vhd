LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY SPI IS 
	GENERIC(n : integer:= 12);
	PORT(
			clk	:	in std_logic;
			rst	:	in std_logic;
			datain	:	out std_logic;
			dataout	:	in std_logic;
			ADCoutput : out std_logic_vector(n-1 downto 0);
			cs	:	out std_logic;
			sclk	:	out std_logic;
			done	:	out std_logic;
			rdy	:	out std_logic
			);
END ENTITY;

ARCHITECTURE behave OF SPI IS

COMPONENT Mux IS
	PORT(
			sel	:	in std_logic;
			clk25MHz	:	in std_logic;
			sclk	:	out std_logic
			);
END COMPONENT;

COMPONENT FSM IS 
PORT(
		clk : in std_logic;
		rst : in std_logic;
		str : in std_logic;
		Comp_out0 : in std_logic;
		Comp_out1 : in std_logic;
		ld0 : out std_logic;
		ld1 : out std_logic;
		sh : out std_logic;
		CS : out std_logic;
		Cntr_rst0 : out std_logic;
		En0 : out std_logic;
		Cntr_rst1 : out std_logic;
		En1 : out std_logic;
		sel : out std_logic;
		rdy : out std_logic;
		done : out std_logic
			);
END COMPONENT;
			
COMPONENT counter IS 
	GENERIC(n : integer:=7);
	PORT(
		clk : in std_logic;
		rst : in std_logic;
		EN : in std_logic;
		cnt: out std_logic_vector(n-1 downto 0)
		);	
END COMPONENT;

COMPONENT counter1 IS
	GENERIC(n : integer:=4);
	PORT(
		sclk : in std_logic;
		rst : in std_logic;
		EN : in std_logic;
		cnt: out std_logic_vector(n-1 downto 0)
		);	
END COMPONENT;

COMPONENT comparator IS
	GENERIC(n : integer:=25);
	PORT(
			in_value : 	in std_logic_vector(n-1 downto 0);
			ref		:	in std_logic_vector(n-1 downto 0);
			comp_out	:	out std_logic
		);	
END COMPONENT;

COMPONENT clk25MHz IS
PORT ( 
		
		clk	:	in std_logic;	
		reset	:	in std_logic;
		clk25MHz	:	out std_logic
		
		);
END COMPONENT;

COMPONENT p_in_s_out IS
	GENERIC(n	:	integer:=6);
	PORT(
			sclk	:	in std_logic;
			sh	:	in std_logic;
			ld	:	in std_logic;
			rst	:	in std_logic;
			input	:	in std_logic_vector(n-1 downto 0);
			sout	:	out std_logic
			);
END COMPONENT;

COMPONENT s_in_p_out IS
	GENERIC(n	:	integer:=12);
	PORT(
			sclk	:	in std_logic;
			ld	:	in std_logic;
			rst	:	in std_logic;
			dataout	:	in std_logic;
			output	:	out std_logic_vector(n-1 downto 0)
			);
END COMPONENT;

SIGNAL ld0, ld1, sh, EN0, EN1, comp_out0, comp_out1, comp_out2, cntr_rst0, cntr_rst1, cntr_rst2, internal_sclk : std_logic;
SIGNAL cnt0 : std_logic_vector(6 downto 0);
SIGNAL cnt1 : std_logic_vector(3 downto 0);
SIGNAL cnt2 : std_logic_vector(19 downto 0);
SIGNAL internal_rst0, internal_rst1 : std_logic;
SIGNAL str : std_logic;
SIGNAL sel : std_logic;
SIGNAL clk25 : std_logic;

BEGIN
sclk<=internal_sclk;
internal_rst0 <= rst or cntr_rst0;
internal_rst1 <= rst or cntr_rst1;

myMux: Mux port map(
				sel => sel,
				clk25MHz => clk25,
				sclk => internal_sclk
				);
				
mycounter: counter generic map(7) port map (
															clk => clk,
															rst => internal_rst0,
															EN => EN0,
															cnt => cnt0
															);
mycounter1: counter1 generic map(4) port map (
																sclk => internal_sclk,
																rst => internal_rst1,
																EN => EN1,
																cnt => cnt1
																);

mycomparator: comparator generic map(7) port map (
																	in_value => cnt0,
																	ref => "1100100",
																	comp_out => comp_out0
																	);
																	
mycomparator1: comparator generic map(4) port map (
																	in_value => cnt1,
																	ref => "1100",
																	comp_out => comp_out1
																	);
																	
myclk25MHz: clk25MHz port map (
											clk => clk,
											reset => rst,
											clk25MHz => clk25
											);
											
myp_in_s_out: p_in_s_out generic map(6) port map (
																		sclk => internal_sclk,
																		rst => rst,
																		sh => sh,
																		ld => ld0,
																		input => "100010",
																		sout => datain
																		);

mys_in_p_out: s_in_p_out generic map(12) port map (
																		sclk => internal_sclk,
																		rst => rst,
																		ld => ld1, 
																		dataout => dataout,
																		output => ADCoutput
																		);
																		
myFSM: FSM port map (
								clk => clk,
								rst => rst,
								str => str,
								comp_out0 => comp_out0,
								comp_out1 => comp_out1,
								ld0 => ld0,
								ld1 => ld1,
								sh => sh,
								cs => cs,
								cntr_rst0 => cntr_rst0,
								EN0 => EN0,
								cntr_rst1 => cntr_rst1,
								EN1 => EN1,
								sel => sel,
								rdy => rdy,
								done => done
								);
comparatorstr: comparator generic map(20) port map ( 
																		ref => "11110100001001000000",
																		in_value => cnt2,
																		comp_out => comp_out2);
																		
cntr_rst2 <= rst or str;

counterstr: counter generic map(20) port map (
															  clk => clk,
															  rst => cntr_rst2,
															  EN => '1',
															  cnt => cnt2);
															  
PROCESS(rst, clk) 
begin
					if rst ='1' then
							str <= '0';
				   elsif rising_edge(clk) then
							str <= comp_out2;
					end if;
					
END PROCESS;
							
END ARCHITECTURE;
							
								
																		
																		
											
