LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY UART_TB IS
end UART_TB;

ARCHITECTURE arch of UART_TB IS 

COMPONENT UART IS
	GENERIC(n : integer:= 12);
	PORT(
		data : in std_logic_vector(7 downto 0);
		strt : in std_logic;
		sclk : in std_logic;
		rst : in std_logic;
		done : out std_logic;
		tx : out std_logic
			);
			
END COMPONENT;

signal strt, sclk, rst : std_logic;
signal data : std_logic_vector(7 downto 0);
signal done, tx : std_logic;

constant n : integer := 12;
constant T : time := 20 ns;
begin

myUART: UART generic map(n) port map(
																	data => data,
																	strt => strt,
																	sclk => sclk,
																	rst => rst,
																	done => done,
																	tx => tx
																	);
																	
																	
																																										
	process
	begin
		sclk <= '0';
		wait for T/2;
		sclk <= '1';
		wait for T/2;
	end process;
	
	
	
	rst <= '1', '0' after T/2;
	
	
	
end arch;
																	
																	