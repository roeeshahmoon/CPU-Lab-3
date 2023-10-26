library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_control is
	constant n : integer := 8;
end tb_control;
---------------------------------------------------------
architecture rtb of tb_control is
	signal ena,rst,clk : std_logic;

	--signal DATAin : std_logic_vector(n-1 downto 0);
signal	mov, nop, jnc, jc ,jmp, sub, add, ld, st, Nflag, Zflag,Cflag,Mem_wr, Mem_out, Mem_in, Cout, Cin, Ain, RFin,RFout,IRin,PCin,done_in,DoneProgram, Imm1_in, Imm2_in	 : std_logic;
signal	OPC 														 : std_logic_vector(3 downto 0);
signal	RFadder ,PCsel												 : std_logic_vector(1 downto 0);
	
	
begin
ControlUnit	: Control 	port map(rst,ena,clk,mov,ld,st,done_in, jnc, jc ,jmp, sub, add, nop, Nflag, Zflag,Cflag,Mem_wr, Mem_out, Mem_in,
									     Cout, Cin, Ain, RFin, RFout,IRin,PCin,Imm1_in, Imm2_in,OPC,RFadder ,PCsel,DoneProgram);
	--------- start of stimulus section ------------------	
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		

		gen_rst : process
        begin
		  rst <='1','0' after 100 ns;
		  wait;
        end process;
		
		gen_input : process
		variable 	counter				: integer;
        begin
		counter := 0 ;
		wait until rst = '0' ;
		ena <='1';
		while counter < 5 loop
	      if counter = 0 then 
			ld <= '0';
			st <= '0';
			mov <= '0';
			jc <= '0';
			add <='0';
			jmp <= '0';
			Nflag <= '0';
			Cflag <= '0';
			Zflag <= '0';
			sub <= '0';
			nop <= '0';
			jnc <= '0';
			Done_In <= '0';
		elsif counter = 1 then
			ld <= '0';
			st <= '1';
			mov <= '0';
			jc <= '0';
			add <='0';
			jmp <= '0';
			Nflag <= '0';
			Cflag <= '0';
			Zflag <= '0';
			sub <= '0';
			nop <= '0';
			jnc <= '0';
			Done_In <= '0';

		elsif counter = 2 then
			ld <= '1';
			st <= '0';
			mov <= '0';
			jc <= '0';
			add <='0';
			jmp <= '0';
			Nflag <= '0';
			Cflag <= '0';
			Zflag <= '0';
			sub <= '0';
			nop <= '0';
			jnc <= '0';
			Done_In <= '0';

		elsif counter = 3 then
			ld <= '0';
			st <= '0';
			mov <= '1';
			jc <= '0';
			add <='0';
			jmp <= '0';
			Nflag <= '0';
			Cflag <= '0';
			Zflag <= '0';
			sub <= '0';
			nop <= '0';
			jnc <= '0';
			Done_In <= '0';

		elsif counter = 4 then
			ld <= '0';
			st <= '0';
			mov <= '0';
			jc <= '0';
			add <='0';
			jmp <= '0';
			Nflag <= '0';
			Cflag <= '0';
			Zflag <= '0';
			sub <= '0';
			nop <= '0';
			jnc <= '0';
			Done_In <= '1';
		  

		end if;
		wait until rising_edge(IRin); --to chek all state i wait untill command finish
		counter := counter + 1;
	end loop ;
	ena <= '0';
	wait;
    end process;
		
		
		
end architecture rtb;
