LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY UART_Mux IS
	PORT(
		sel : in std_logic_vector(1 downto 0);
		data : in std_logic;
		parity : in std_logic;
		tx : out std_logic
			);
			
END ENTITY;

ARCHITECTURE behavior OF UART_Mux IS

BEGIN
	
Process (sel)
BEGIN
	if sel = "00" THEN 
		tx <= '1'; 
	elsif sel = "01" THEN
		tx <= '0';
	elsif sel = "10" THEN
		tx <= data;
	elsif sel = "11" THEN
		tx <= parity;
	else
		tx <= '1';
	end if;
END PROCESS;	


END ARCHITECTURE; 





