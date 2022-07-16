LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY Mux is 
	PORT(
			sel	:	in std_logic;
			clk25MHz	:	in std_logic;
			sclk	:	out std_logic
			);
END Mux;


ARCHITECTURE behavior OF Mux IS

BEGIN
	
	sclk <= '1' WHEN sel = '0' 
	else clk25MHz;
	


END ARCHITECTURE; 