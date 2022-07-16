LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ECG_TB IS
end ECG_TB;

ARCHITECTURE arch of ECG_TB IS 

COMPONENT ECG IS
	GENERIC(n : integer:= 12);
	PORT( 
	   dataout	:	in std_logic;
		rst 		: 	in std_logic;
		clk 		:  in std_logic;
		datain	:	out std_logic;
		convst   :  out std_logic;
		sck      :  out std_logic;
		tx       :  out std_logic
			);
		
END COMPONENT;

signal dataout, rst, clk : std_logic;
signal datain, convst, sck, tx : std_logic;

constant n : integer := 12;
constant T : time := 20 ns;
begin

myECG: ECG generic map(n) port map(
																dataout => dataout,
																rst	  => rst, 
																clk 	  => clk, 
																datain  => datain,
															   convst  => convst,
																sck	  => sck,
																tx	     => tx
																				);
							
																	
																	
																																										
	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;
	
	
	
	rst <= '1', '0' after T/2;
	
	
	
end arch;
																	
																	