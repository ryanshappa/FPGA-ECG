LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;


ENTITY counter1 IS
	GENERIC(n : integer:=4);
	PORT(
		sclk : in std_logic;
		rst : in std_logic;
		EN : in std_logic;
		cnt: out std_logic_vector(n-1 downto 0)
		);	
	END ENTITY;			
ARCHITECTURE behave OF counter1 IS
SIGNAL internal_count : std_logic_vector (n-1 downto 0);
SIGNAL add_out 		 : std_logic_vector (n-1 downto 0);
BEGIN

cnt <= internal_count;

--Adder
Process(EN, internal_count)
begin
	if EN = '1' then
		add_out <= std_logic_vector(signed(internal_count) + 1);
	else
		add_out <= std_logic_vector(signed(internal_count) + 0);
	end if;

END Process;


--Register
Process(sclk,rst,add_out)
begin
	if rst = '1' then
		internal_count <= (OTHERS=>'0');
	elsif rising_edge(sclk) then 
		internal_count <= add_out;
	end if;

END Process;



	
END ARCHITECTURE;	
