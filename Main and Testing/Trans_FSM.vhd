LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY Trans_FSM IS
	PORT(
		doneADC, sclk, rst : in std_logic;
		strtUART : out std_logic
		);
			
END ENTITY;

ARCHITECTURE behavior OF Trans_FSM IS
Signal next_state, current_state : std_logic_vector (1 downto 0);

Begin

-- Current State Register
Process (sclk,rst,next_state)

Begin 
	if rst = '1' then 
		current_state <= (Others => '0');
	elsif rising_edge (sclk) then
		current_state <= next_state;
	end if;
	
End Process;

-- Output and next state logic
Process (current_state, doneADC)
Begin
	CASE current_state is 
--State 0
	WHEN "00" =>
		strtUART <= '0';
		if  doneADC = '1' then
			next_state <= "01";
		else
			next_state <= current_state;
		end if;
		
--State 1
	WHEN "01" =>
		strtUART <= '1';
		next_state <= "00";
		
	when others =>
		strtUART <= '0';
		
End CASE;	
End process;
End Architecture;
