LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY Comparator is 
	Generic (n : integer:=25);
	PORT(
		In_value : in std_logic_vector(n-1 downto 0);
		Ref	 : in std_logic_vector(n-1 downto 0);
		Comp_out : out std_logic
		
		  );
		  
END ENTITY;

Architecture Behave OF Comparator is

Begin

process(In_value, Ref)
begin
	if In_value = ref then
			Comp_out <= '1';
	else
			Comp_out <='0';
	end if;
		
end process;

End Architecture;

