LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ECG IS
	PORT(
		dataout	:	in std_logic;
		rst 		: 	in std_logic;
		clk 		:  in std_logic;
		dataUART : in std_logic_vector(7 downto 0);
		datain	:	out std_logic;
		convst   :  out std_logic;
		sck      :  out std_logic;
		tx       :  out std_logic
			);
			
END ENTITY;

ARCHITECTURE behavior OF ECG IS
COMPONENT UART IS
	PORT(
		data : in std_logic_vector(7 downto 0);
		strt : in std_logic;
		sclk : in std_logic;
		rst : in std_logic;
		done : out std_logic;
		tx : out std_logic
			);
			
END COMPONENT;

COMPONENT Trans_FSM IS
	PORT(
		doneADC, sclk, rst : in std_logic;
		strtUART : out std_logic
		);
			
END COMPONENT;

COMPONENT SPI IS 
	GENERIC(n : integer:= 12);
	PORT(
			clk	:	in std_logic;
			rst	:	in std_logic;
			datain	:	out std_logic;
			dataout	:	in std_logic;
			ADCoutput : out std_logic_vector(n-1 downto 0);
			cs	:	out std_logic;
			sclk	:	out std_logic;
			done	:	out std_logic;
			rdy	:	out std_logic
			);
END COMPONENT;
Component Comparator is
Generic (n : integer:=25);
	PORT(
		In_value : in std_logic_vector(n-1 downto 0);
		Ref	 : in std_logic_vector(n-1 downto 0);
		Comp_out : out std_logic
		
		  );
End Component;

Component counter is
GENERIC(n : integer:=7);
	PORT(
		clk : in std_logic;
		rst : in std_logic;
		EN : in std_logic;
		cnt: out std_logic_vector(n-1 downto 0)
		);	

End component;

SIGNAL sclk, doneADC, strtUART : std_logic;
SIGNAL dataOutput : std_logic_vector(11 downto 0);
signal cntr_out3 : std_logic_vector(19 downto 0);
signal comp_out3 : std_logic;
signal cntr_rst3 : std_logic;
BEGIN
UART0 : UART PORT MAP(data => dataUART , strt => strtUART, sclk => clk, rst => rst, tx => tx);
SPI0 : SPI GENERIC MAP(12) PORT MAP(clk => clk, rst => rst, datain => datain, dataout => dataout, ADCoutput => dataOutput, cs => convst, sclk => sclk, done => doneADC);
--Trans_FSM0 : Trans_FSM PORT MAP(doneADC => doneADC, sclk => clk, rst => rst, strtUART => strtUART);

ComparatorStr : Comparator generic map(20) port map(     Ref       =>"01110100001001000000", 
                                                          In_value => cntr_out3,  
                                                         Comp_out     => comp_out3);
																			cntr_rst3 <= rst or strtUART;
                                                                                                                                                                                  
counterStr : counter generic map(20) port map(
                                         clk              => clk,
                                         rst              => cntr_rst3,
                                         EN               => '1',
                                         cnt              => cntr_out3);
                                                                                                                                                                    
PROCESS(rst, clk)
begin
              if rst = '1' then
                           strtUART<= '0';
              elsif rising_edge(clk) then
                           strtUART<= comp_out3;
              end if;
END PROCESS;
END ARCHITECTURE;





