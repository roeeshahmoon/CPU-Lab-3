LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
-----------------------------------------------------------------------
entity Control is
		port(
		rst,ena,clk : in std_logic;
		mov, ld, st,shl, donein, jnc, jc ,jmp, sub, add, nop, Nflag, Zflag, Cflag: in std_logic;
		---------------------------------------------
		Mem_wr, Mem_out, Mem_in, Cout, Cin, Ain, RFin				 : out std_logic := '0';
		RFout,IRin,PCin,Imm1_in, Imm2_in							 : out std_logic := '0';
		OPC 														 : out std_logic_vector(3 downto 0);
		RFadder ,PCsel												 : out std_logic_vector(1 downto 0);
		done													 	 : out std_logic	
	);
end Control;
------------- complete the Control Unit Architecture code --------------
architecture arc_sys of Control is
	type state is(idle,fetch,decode,state_3,state_4,state_5,state_6,state_7,state_8,state_9,state_10,state_11,hold); 
	signal pr_state, nx_state : state := idle; 
begin

-----------------FSM section:------------------------------------------
process(rst,clk,ena)
begin
	if (rst ='1') then 
		nx_state <= idle;
		
	elsif (clk'event and clk='1') then 
		if (ena='1') then 
			case pr_state is 
				when idle => -- Tells the CPU not to operate until the memory is Ready to be read.
						nx_state <= fetch;

		
				when fetch => --Fetching the Next Instruction 
					nx_state	<= decode;
		
				when decode => --- decode is the state when datapath is decoding the instruction.
					if jc = '1' or jnc = '1' or jmp ='1' then 
						nx_state <= state_3;
			
					elsif	add = '1' or sub = '1' or nop = '1' or shl = '1' then
						nx_state	<= state_4;
				
					elsif ld = '1' or st = '1' then
						nx_state <=	state_5;
			
			
					else	
						nx_state <= state_6;
			
					end if;
		
				when state_3 =>  -- cycle 1 of j-type
					nx_state <= fetch;

				when state_4 => -- cycle1 of R-type
					nx_state <= state_7;
				
				when state_5 => -- cycle 1 of ls/st
					nx_state <= state_8;

				when state_6 => -- cycle 1 of mov/done
					nx_state <= fetch;
		
				when state_7 => -- cycle 2 of R-type
					nx_state <= state_9;

				when state_8 => -- cycle 2 of ld/st-type
					nx_state <= state_10;
		
				when state_9 => -- cycle 3 of R-type
					nx_state <= fetch;

				when state_10 => -- cycle 3 of ld/st
					nx_state <= state_11;
		
				when state_11 => -- cycle 4 of ld/st
					nx_state <= fetch;
					
				when hold => -- en 0 to 1
					nx_state <= fetch;
				
			end case;
			
		else
			nx_state <= hold;
		end if;
	
	end if;
	
	

end process;

	pr_state <= nx_state; --updating the state every clk rise
-----------------control section:------------------------------------------

	Mem_wr	<= '1'    when pr_state = state_11 and (st = '1')  else '0';
	Mem_out <= '1'    when pr_state = state_11 and (ld = '1')  else '0';
	Mem_in	<= '1'    when pr_state = state_10 and (st = '1')   else  '0';
	Cout	<= '1'    when pr_state = state_10 or  pr_state = state_9 else '0' ;
	Cin  	<= '1'    when pr_state = state_7  or  (pr_state = state_8) else '0' ;
	OPC		<= "0000" when ((pr_state = state_7) and (add = '1' or nop = '1' )) or (pr_state = state_11) or (pr_state = state_8) else "0001" when (pr_state = state_7 and sub = '1') else "0011" when pr_state = state_4 and shl ='1' else unaffected ;
	Ain		<= '1'    when ((pr_state = state_4) or (pr_state = state_5))   else '0';
	RFin	<= '1'	  when (((pr_state = state_6) and (mov = '1')) or (pr_state = state_9) or ((pr_state = state_11) and (ld = '1')))  else '0';
	RFout	<= '1'    when ((pr_state = state_4 ) or (pr_state = state_7) or (pr_state = state_5 ) or (pr_state = state_11 and st = '1')) else '0';
	RFadder <= "10"   when (pr_state = state_6  ) or (pr_state = state_9 and nop = '0' ) or (pr_state = state_11 )  else "01" when (pr_state = state_4 and nop = '0') or (pr_state = state_5) else	"00";
	IRin 	<= '1'    when  pr_state = fetch  else '0';
	PCin 	<= '1'    when pr_state = idle or (pr_state = state_3) or  (pr_state = state_6) or (pr_state = state_9) or (pr_state = state_11)  else '0';
	PCsel	<= "01"   when pr_state = state_3 and ((jmp = '1') or (jc='1' and Cflag ='1') or (jnc='1' and Cflag ='0'))  else "00" when pr_state = idle else "10" when (pr_state = state_3) or  (pr_state = state_4) or (pr_state = state_5) or (pr_state = state_6)  else "11" ;
	Imm1_in	<= '1'    when pr_state = state_6  else '0';
	Imm2_in	<= '1'    when pr_state = state_8 else '0';
	done	<= '1' when (donein = '1' and rst = '0') else '0';
end arc_sys;







