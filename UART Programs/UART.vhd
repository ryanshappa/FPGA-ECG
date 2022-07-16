LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY UART IS
	PORT(
		data : in std_logic_vector(7 downto 0);
		strt : in std_logic;
		sclk : in std_logic;
		rst : in std_logic;
		done : out std_logic;
		tx : out std_logic
			);
			
END ENTITY;

ARCHITECTURE behavior OF UART IS

COMPONENT p_in_s_out IS
	GENERIC(n	:	integer:=8);
	PORT(
			sclk	:	in std_logic;
			sh	:	in std_logic;
			ld	:	in std_logic;
			rst	:	in std_logic;
			input	:	in std_logic_vector(n-1 downto 0);
			sout	:	out std_logic
			);
END COMPONENT;

COMPONENT UART_Mux IS
	PORT(
		sel : in std_logic_vector(1 downto 0);
		data : in std_logic;
		parity : in std_logic;
		tx : out std_logic
			);
			
END COMPONENT;

COMPONENT counter IS
	GENERIC(n : integer:=7);
	PORT(
		clk : in std_logic;
		rst : in std_logic;
		EN : in std_logic;
		cnt: out std_logic_vector(n-1 downto 0)
		);	
END COMPONENT;

COMPONENT comparator IS
	GENERIC(n : integer:=25);
	PORT(
			in_value : 	in std_logic_vector(n-1 downto 0);
			ref		:	in std_logic_vector(n-1 downto 0);
			comp_out	:	out std_logic
		);	
END COMPONENT;	

COMPONENT UART_FSM IS
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
END COMPONENT;

Signal rstSig, comp_outSig, cnt_rst, cnt_en : std_logic_vector(5 downto 0);
Signal cnt_outSig0,cnt_outSig1,cnt_outSig2,cnt_outSig3,cnt_outSig4,cnt_outSig5 : std_logic_vector(11 downto 0);
Signal selSig : std_logic_vector(1 downto 0);
Signal shift, load, dataSig, paritySig : std_logic;

BEGIN

rstSig(0) <= (rst OR cnt_rst(0));
rstSig(1) <= (rst OR cnt_rst(1));
rstSig(2) <= (rst OR cnt_rst(2));
rstSig(3) <= (rst OR cnt_rst(3));
rstSig(4) <= (rst OR cnt_rst(4));
rstSig(5) <= (rst OR cnt_rst(5));

paritySig <= data(0) XOR data(1) XOR data(2) XOR data(3) XOR data(4) XOR data(5) XOR data(6) XOR data(7);

--Port Maps:
P_In_S_Out0 : p_in_s_out GENERIC MAP(8) PORT MAP(sclk => sclk, sh => shift, ld => load, rst => rst, input => data, sout => dataSig);
UART_Mux0 : UART_Mux PORT MAP(sel => selSig, data => dataSig, parity => paritySig, tx => tx);
UART_FSM0 : UART_FSM Port MAP(comp_out => comp_outSig, strt => strt, sclk => sclk, rst => rst, ld => load, sh => shift, done => done, cntr_rst => cnt_rst, cntr_en => cnt_en, sel => selSig);
Counter0 : counter GENERIC MAP(12) PORT MAP(clk => sclk, rst => rstSig(0), EN => cnt_en(0), cnt => cnt_outSig0);
Counter1 : counter GENERIC MAP(12) PORT MAP(clk => sclk, rst => rstSig(1), EN => cnt_en(1), cnt => cnt_outSig1);
Counter2 : counter GENERIC MAP(12) PORT MAP(clk => sclk, rst => rstSig(2), EN => cnt_en(2), cnt => cnt_outSig2);
Counter3 : counter GENERIC MAP(12) PORT MAP(clk => sclk, rst => rstSig(3), EN => cnt_en(3), cnt => cnt_outSig3);
Counter4 : counter GENERIC MAP(12) PORT MAP(clk => sclk, rst => rstSig(4), EN => cnt_en(4), cnt => cnt_outSig4);
Counter5 : counter GENERIC MAP(12) PORT MAP(clk => sclk, rst => rstSig(5), EN => cnt_en(5), cnt => cnt_outSig5);
Comparator0 : comparator GENERIC MAP(12) PORT MAP(Ref => "101000101101", in_value => cnt_outSig0, comp_out => comp_outSig(0));
Comparator1 : comparator GENERIC MAP(12) PORT MAP(Ref => "101000101101", in_value => cnt_outSig1, comp_out => comp_outSig(1));
Comparator2 : comparator GENERIC MAP(12) PORT MAP(Ref => "000000001000", in_value => cnt_outSig2, comp_out => comp_outSig(2));
Comparator3 : comparator GENERIC MAP(12) PORT MAP(Ref => "101000101101", in_value => cnt_outSig3, comp_out => comp_outSig(3));
Comparator4 : comparator GENERIC MAP(12) PORT MAP(Ref => "101000101101", in_value => cnt_outSig4, comp_out => comp_outSig(4));
Comparator5 : comparator GENERIC MAP(12) PORT MAP(Ref => "101000101101", in_value => cnt_outSig5, comp_out => comp_outSig(5));

END ARCHITECTURE; 