LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY s_in_p_out IS
	GENERIC(n	:	integer:=12);
	PORT(
			sclk	:	in std_logic;
			ld	:	in std_logic;
			rst	:	in std_logic;
			sin	:	in std_logic;
			dataout	:	out std_logic_vector(n-1 downto 0)
			);
			
END s_in_p_out;

ARCHITECTURE behavior OF s_in_p_out IS

SIGNAL reg	: std_logic_vector(n-1 downto 0) := (others => '0');



BEGIN

Process(sclk, rst, ld)
begin
	
	if rst = '1' then
		reg <= (OTHERS =>'0');
	elsif rising_edge(sclk) then 
		if ld = '1' then
			reg(0) <= sin;
			reg(1) <= reg(0);
			reg(2) <= reg(1);
			reg(3) <= reg(2);
			reg(4) <= reg(3);
			reg(5) <= reg(4);
			reg(6) <= reg(5);
			reg(7) <= reg(6);
			reg(8) <= reg(7);
			reg(9) <= reg(8);
			reg(10) <= reg(9);
			reg(11) <= reg(10);
			reg(12) <= reg(11);
			reg(13) <= reg(12);
			reg(14) <= reg(13);
			reg(15) <= reg(14);

		end if;
	end if;	
end Process;
dataout <= reg;
END ARCHITECTURE;
	