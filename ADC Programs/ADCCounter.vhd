LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ADCCounter IS
	GENERIC(n : integer:=4);
	PORT(
		clk : in std_logic;
		rst : in std_logic;
		EN	 : in std_logic;
		cnt : out std_logic_vector(n-1 downto 0)
			);
END ENTITY;

ARCHITECTURE Behave OF Counter IS
SIGNAL Internal_Count : std_logic_vector(n-1 downto 0);
SIGNAL Add_out			 : std_logic_vector(n-1 downto 0);
Begin

cnt <= Internal_count;

--Adder
Process (EN, Internal_count)
begin
	if EN = '1' then
			Add_out <= std_logic_vector(signed(Internal_count)+1);
	else 
			Add_out <= std_logic_vector(signed(Internal_Count) +0);
	end if;
		
End Process;

--Register
Process(clk,rst,add_out)
begin
	if rst = '1' then
		Internal_count <= (OTHERS => '0');
	elsif rising_edge (clk) then 
		Internal_count <= Add_out;
	end if; 

End process;


END Architecture;
