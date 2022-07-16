LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ADC_Fsm IS
	PORT(
		clk : in std_logic;
		rst : in std_logic;
		str : in std_logic;
		Comp_out0 : in std_logic;
		Comp_out1 : in std_logic;
		ld0 : out std_logic;
		ld1 : out std_logic;
		sh : out std_logic;
		CS : out std_logic;
		Cntr_rst0 : out std_logic;
		En0 : out std_logic;
		Cntr_rst1 : out std_logic;
		En1 : out std_logic;
		rdy : out std_logic;
		done : out std_logic
			);
			
END ENTITY;

ARCHITECTURE Behave OF ADC_Fsm IS
Signal next_state, current_state : std_logic_vector (1 downto 0);

Begin

-- Current State Register
Process (clk,rst,next_state)

Begin 
	if rst = '1' then 
		current_state <= (Others => '0');
	elsif rising_edge (clk) then
		current_state <= next_state;
	end if;
	
End Process;

-- Output and next state logic
Process (current_state, Comp_out0, Comp_out1)
Begin
	CASE current_state is 
-- State 0
		when "00" =>
			ld0 <= '1';
			ld1 <= '0'; 
			sh <= '0';
			CS <= '0';
			Cntr_rst0 <= '0';
			En0 <= '0';
			Cntr_rst1 <= '0';
			En1 <= '0';
			rdy <= '1';
		if str = '1' then
			next_state <= "01";
		else 
			next_state <= current_state;
		end if;
			
-- State 1
	when "01" =>
		ld0 <= '0';
		ld1 <= '0'; 
		sh <= '0';
		CS <= '1';
		Cntr_rst0 <= '0';
		En0 <= '0';
		Cntr_rst1 <= '1';
		En1 <= '0';
		rdy <= '0';
		done <= '0';
	if Comp_out0 = '1' then
		next_state <= "10";
	else 
		next_state <= current_state;
	end if;
			
--State 2
	when "10" => 
		ld0 <= '0';
		ld1 <= '1'; 
		sh <= '1';
		CS <= '0';
		Cntr_rst0 <= '1';
		En0 <= '0';
		Cntr_rst1 <= '0';
		En1 <= '1';
		rdy <= '0';
		done <= '0';
	if Comp_out1 = '1' then
		next_state <= "11";
	else 
		next_state <= current_state;
	end if;
	
--State 3
	when "11" =>
		ld0 <= '0';
		ld1 <= '0'; 
		sh <= '0';
		CS <= '0';
		Cntr_rst0 <= '0';
		En0 <= '0';
		Cntr_rst1 <= '1';
		En1 <= '0';
		rdy <= '1';
		done <= '1';
	next_state <= "00";
	
		
	when others => 
		ld0 <= '0';
		ld1 <= '0';
		sh <= '0';
		CS <= '0';
		Cntr_rst0 <= '0';
		En0 <= '0';
		Cntr_rst1 <= '0';
		En1 <= '0';
		rdy <= '0';
		done <= '0';
			next_state <= "00";
			
		
END CASE;

End Process;

End Architecture;