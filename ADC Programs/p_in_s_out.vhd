LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY p_in_s_out IS
	GENERIC(n	:	integer:=12);
	PORT(
			sclk	:	in std_logic;
			sh	:	in std_logic;
			ld	:	in std_logic;
			rst	:	in std_logic;
			datain	:	in std_logic_vector(n-1 downto 0);
			sout	:	out std_logic
			);
			
END p_in_s_out;

ARCHITECTURE behavior OF p_in_s_out IS

SIGNAL reg	:	std_logic_vector(n-1 downto 0);

BEGIN


Process(sclk, rst, ld, sh)
begin
	
	if ld = '1' then
		reg <= datain;
	elsif rst = '1' then
		reg <= (OTHERS =>'0');
	elsif sh = '1' then
		if rising_edge(sclk) then
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
sout <= reg(15);

end Process;

END ARCHITECTURE;
	
		


