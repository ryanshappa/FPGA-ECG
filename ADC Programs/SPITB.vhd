LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;



ENTITY SPITB IS
end SPITB;



ARCHITECTURE arch of SPITB IS 

COMPONENT SPI IS
	GENERIC(n : integer:= 12);
	PORT(
			clk	:	in std_logic;
			rst	:	in std_logic;
			dataout	:	in std_logic;
			ADCoutput : out std_logic_vector(n-1 downto 0);
			cs	:	out std_logic;
			sclk	:	out std_logic;
			done	:	out std_logic;
			rdy	:	out std_logic
			);
END COMPONENT;

SIGNAL clk, rst, cs, sclk, done, rdy, dataout : std_logic;
SIGNAL ADCoutput : std_logic_vector(11 downto 0);
constant n : integer := 12;
constant T : time := 20 ns;
begin

mySPI: SPI generic map(n) port map(
																	clk => clk,
																	rst => rst,
																	dataout => dataout,
																	ADCoutput => ADCoutput,
																	cs => cs,
																	sclk => sclk,
																	done => done, 
																	rdy => rdy
																	);
																	
																	
																	
																	
																	
	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;

	
	
	dataout <= '1';
	rst <= '1', '0' after T/2;

		
end arch;
																	
																	