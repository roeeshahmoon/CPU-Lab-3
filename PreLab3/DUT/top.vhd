LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;
-------------------------------------------------------------
entity top is
	generic (
		Dwidth : integer:=16 ;
		AwidthMem : integer:=6 ;
		AwidthRF : integer:=4 ;
		dept   : integer:=64
		); 
	port(
		rst,ena,clk 			: in std_logic;
		done 			 		: out std_logic;
		-----------------------------------
		ProgMemTBDataIn,DataMemTBDataIn	 : in  std_logic_vector(Dwidth-1 downto 0);
		DataMemDataOut : out std_logic_vector(Dwidth-1 downto 0);
		-----------------------------------
		ProgMemTBWren,DataMemTBWren  	 : in std_logic;
		--------------------------------------
		ProgMemTbWAddr,DataMemTbRAddr,DataMemTbWAddr	 : in std_logic_vector(AwidthMem -1 downto 0);
		TBactive           : in std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is

signal	mov,st,shl,ld,done_in,jnc,jc,jmp,sub,add,nop,Nflag,Zflag,Cflag,Cout, Cin, Ain, RFin, RFout,IRin,PCin,Imm1_in,Imm2_in,DoneProgram,Mem_wr, Mem_out, Mem_in		 : std_logic;
signal	OPC 														 : std_logic_vector(Dwidth-13 downto 0);
signal	RFadder ,PCsel												 : std_logic_vector(Dwidth-15 downto 0);
begin
	DataPath1		: Datapath 	generic map (Dwidth, AwidthMem,AwidthRF, dept)   port map(rst,clk,mov,st,shl,ld ,done_in, jnc, jc ,jmp, sub, add,nop, Nflag, Zflag,Cflag,
																			 Cout, Cin, Ain, RFin, RFout,IRin,PCin,Imm1_in,Imm2_in,Mem_wr, Mem_out, Mem_in,
																			  OPC,RFadder ,PCsel,ProgMemTBDataIn,DataMemTBDataIn,DataMemDataOut,
																			  ProgMemTBWren,DataMemTBWren,ProgMemTbWAddr,DataMemTbRAddr,DataMemTbWAddr,TBactive);
																			  
																			  
	ControlUnit		: Control 	port map(rst,ena,clk,mov,ld,st,shl,done_in,jnc,jc,jmp,sub,add,nop,Nflag,Zflag,Cflag,Mem_wr, Mem_out, Mem_in,
											Cout, Cin, Ain, RFin, RFout,IRin,PCin,Imm1_in,Imm2_in
											,OPC,RFadder ,PCsel,DoneProgram);
	Done 	<= 		DoneProgram;


end arc_sys;







