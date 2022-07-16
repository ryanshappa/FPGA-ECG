LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY UART_FSM IS
	PORT(
		comp_out : in std_logic_vector(5 downto 0);
		strt : in std_logic;
		sclk : in std_logic;
		rst : in std_logic;
		ld : out std_logic;
		sh : out std_logic;
		done : out std_logic;
		cntr_rst : out std_logic_vector(5 downto 0);
		cntr_en : out std_logic_vector(5 downto 0);
		sel : out std_logic_vector(1 downto 0)
		);
END ENTITY;

ARCHITECTURE behavior OF UART_FSM IS
Signal next_state, current_state : std_logic_vector (2 downto 0);

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
Process (strt, current_state, comp_out)
Begin
	CASE current_state is 
	
-- State 0
		when "000" =>
			ld <= '0';
			sh <= '0';
			done <= '0';
			cntr_rst <= "000000";
			cntr_en <= "000000";
			sel <= "00";
		if strt = '1' then
			next_state <= "001";
		else
			next_state <= current_state;
		end if;
			
-- State 1
		when "001" =>
			ld <= '1';
			sh <= '0';
			done <= '0';
			cntr_rst <= "000000";
			cntr_en <= "000001";
			sel <= "01";
		if comp_out(0) = '1' then
			next_state <= "010";
		else
			next_state <= current_state;
		end if;
			
			
-- State 2
		when "010" =>
			ld <= '0';
			sh <= '0';
			done <= '0';
			cntr_rst <= "001000";
			cntr_en <= "000010";
			sel <= "10";
		if comp_out(1) = '1' then
			next_state <= "011";
		else
			next_state <= current_state;
		end if;
	
-- State 3
		when "011" =>
			ld <= '0';
			sh <= '1';
			done <= '0';
			cntr_rst <= "000000";
			cntr_en <= "000100";
			sel <= "10";
		if comp_out(2) = '1' then
			next_state <= "100";
		else
			next_state <= "010";
		end if;
		
-- State 4
		when "100" =>
			ld <= '0';
			sh <= '0';
			done <= '0';
			cntr_rst <= "000000";
			cntr_en <= "001000";
			sel <= "11";
		if comp_out(3) = '1' then
			next_state <= "101";
		else
			next_state <= current_state;
		end if;

-- State 5
		when "101" =>
			ld <= '0';
			sh <= '0';
			done <= '0';
			cntr_rst <= "000000";
			cntr_en <= "010000";
			sel <= "00";
		if comp_out(4) = '1' then
			next_state <= "110";
		else
			next_state <= current_state;
		end if;
		
-- State 6
		when "110" =>
			ld <= '0';
			sh <= '0';
			done <= '0';
			cntr_rst <= "000000";
			cntr_en <= "100000";
			sel <= "00";
		if comp_out(5) = '1' then
			next_state <= "111";
		else
			next_state <= current_state;
		end if;

-- State 7
		when "111" =>
			ld <= '0';
			sh <= '0';
			done <= '0';
			cntr_rst <= "111111";
			cntr_en <= "000000";
			sel <= "00";
			next_state <= "000";
		
		
	when others => 
			ld <= '0';
			sh <= '0';
			done <= '0';
			cntr_rst <= "000000";
			cntr_en <= "000000";
			sel <= "00";
			next_state <= "000";
			
		
END CASE;
End PROCESS;
END ARCHITECTURE; 