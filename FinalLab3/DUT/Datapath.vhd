LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;

-------------------------------------------------------------
entity Datapath is
	generic (
		Dwidth : integer:=16 ;
		AwidthMem  : integer:=6 ;
		AwidthRF : integer:=4 ;
		dept   : integer:=64
		);
	port(
		rst,clk : in std_logic; --check if we need rst
		mov,st,ld,shl,done_in,jnc,jc,jmp,sub,add,nop,Nflag,Zflag,Cflag	 			 : out std_logic; --status
		---------------------------------------------
		Cout, Cin, Ain, RFin, RFout,IRin,PCin,Imm1_in,Imm2_in,Mem_wr, Mem_out, Mem_in	 	 : in std_logic; --control
		OPC 														 						 : in std_logic_vector(Dwidth-13 downto 0);
		RFadder ,PCsel	 	 : in std_logic_vector(Dwidth-15 downto 0);
		-----------------------------------
		ProgMemTBDataIn,DataMemTBDataIn	 : in  std_logic_vector(Dwidth-1 downto 0);
		DataMemDataOut : out std_logic_vector(Dwidth-1 downto 0);
		-----------------------------------
		ProgMemTBWren,DataMemTBWren  	 : in std_logic;
		--------------------------------------
		ProgMemTbWAddr,DataMemTbRAddr,DataMemTbWAddr	 : in std_logic_vector(AwidthMem -1 downto 0);
		TBactive           : in std_logic
	);

end Datapath;

------------- complete the Datapath Unit Architecture code --------------
architecture arc_sys of Datapath is
signal DataMemDOut 						:  std_logic_vector(Dwidth-1 downto 0);
signal IR,Reg_C,ALU_C,Reg_A,zero        : std_logic_vector(Dwidth-1 downto 0):= (others => '0');
signal opc_ir,ChosenRegAddr					: std_logic_vector(AwidthRF-1 downto 0):= (others => '0');
signal Imm1_ext							: std_logic_vector(Dwidth-1 downto 0):= (others => '0');
signal Imm2_ext							: std_logic_vector(Dwidth-1 downto 0):= (others => '0');
signal BUS_Bidir						: std_logic_vector(Dwidth-1 downto 0):= (others => '0');
signal ProgMemDOut,RregDataOUT,WregDataIN, DataMemDIn : std_logic_vector(Dwidth-1 downto 0):= (others => '0');
signal	DataMemWAddr, DataMemRAddr, DFF	: std_logic_vector(AwidthMem-1 downto 0);


signal WregAddr,RregAddr: std_logic_vector(AwidthRF-1 downto 0):= (others => '0');
signal WregEn,rstena,Busdir,DataMemWren,Nflag_Internal,Zflag_Internal,Cflag_Internal	: std_logic := '0';
signal doneRam,doneRF,done	: boolean;
signal PC,PCNext,readAddrReg: std_logic_vector(AwidthMem -1 downto 0):= (others => '0');

begin
	--rstena <= '1' when rst = '1' and ena = '1' else '0';

	ProgramMemory	: ProgMem generic map (Dwidth, AwidthMem , dept)   port map(clk  ,ProgMemTBWren  ,ProgMemTBDataIn  ,ProgMemTbWAddr,PC,ProgMemDOut);
	DataMemory		: dataMem generic map (Dwidth, AwidthMem , dept)  port map(clk  ,DataMemWren  ,DataMemDIn  ,DataMemWAddr,DataMemRAddr,DataMemDOut);
	RegisterFile	: RF	  generic map (Dwidth, AwidthRF)  port map(clk,rst,RFin,BUS_Bidir,WregAddr,RregAddr,RregDataOUT);
	ALU_ports		: ALU	  generic map (Dwidth,4)	  port map(BUS_Bidir,Reg_A,ALU_C,Cflag_Internal,Zflag_Internal,Nflag_Internal,OPC);


	DataMemDataOut <= DataMemDOut ;
	--readAddrReg  <= BUS_Bidir(AwidthMem-1 downto 0) when (IR(Dwidth-1 downto Dwidth-4) = "1010") and Cout = '1' else unaffected;
	
					Imm1_ext	 <=  IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(Dwidth-9 downto 0);
					Imm2_ext	 <=  '0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&IR(Dwidth-13 downto 0);
PCUpdate:			PCNext		<=	(others => '0') 							when PCsel = "00"   else
									PC + 1										when PCsel = "10"   else
									PC + 1 +(IR(4)&IR(Dwidth-12 downto Dwidth-16))  	when PCsel = "01"  else unaffected;

						
						
Mux_DMWren:				
							DataMemWren <= DataMemTBWren when TBactive = '0'  else	Mem_wr;

						

Mux_DataMemDIn:			
							DataMemDIn <= DataMemTBDatain when TBactive = '0'  else BUS_Bidir;


D_filp_flops:			process(clk, Mem_in)
						begin
						if rising_edge(clk) then
							if Mem_in = '1' then
								DFF <= BUS_Bidir(AwidthMem-1 downto 0);
							else
								DFF <= DFF;
							end if;
						end if;
						end process;


Mux_DataMemWAddr:		
							DataMemWAddr <= DataMemTbWAddr when TBactive = '0'  else DFF;


							

Mux_DataMemRAddr:		
							DataMemRAddr <= DataMemTbRAddr when TBactive = '0'  else DFF;



UpdateRegs:			process (clk)
					begin
					if rising_edge(clk) then
PCUpdate:				if PCin = '1' then
							PC <= PCNext;
						end if;

regA:					if Ain = '1' then
							Reg_A <= BUS_Bidir;
						else
							Reg_A <= Reg_A;
						end if;
regC:					if Cin = '1' then
							Reg_C <= ALU_C;
						else
							Reg_C <= Reg_C;
						end if;

regIR:					if IRin = '1' then
							IR <= ProgMemDOut;
						else
							IR <= IR;
						end if;
					end if;
					end process;

Decoder:			opc_ir  <= IR(Dwidth-1 downto Dwidth-4);
					add  	<= '0' when rst ='1' else '1' when opc_ir = "0000" else '0';
					sub  	<= '0' when rst ='1' else '1' when opc_ir = "0001" else '0';
					nop  	<= '0' when rst ='1' else '1' when opc_ir = "0010" else '0';
					jmp  	<= '0' when rst ='1' else '1' when opc_ir = "0100" else '0';
					jc   	<= '0' when rst ='1' else '1' when opc_ir = "0101" else '0';
					jnc  	<= '0' when rst ='1' else '1' when opc_ir = "0110" else '0';
					mov  	<= '0' when rst ='1' else '1' when opc_ir = "1000" else '0';
					ld	    <= '0' when rst ='1' else '1' when opc_ir = "1001" else '0';
					ST		<= '0' when rst ='1' else '1' when opc_ir = "1010" else '0';
					done_in <= '0' when rst ='1' else '1' when opc_ir = "1011" else '0';
					shl  	<= '0' when rst ='1' else '1' when opc_ir = "0011" else '0';

regC_buffer:		BidirPin generic map(width => Dwidth) 	port map(Dout => Reg_C, en => Cout,Din => open, IOpin => BUS_Bidir);
Data_MemOut_buffer:	BidirPin generic map(width => Dwidth) 	port map(Dout => DataMemDOut, en => Mem_out,Din => open, IOpin => BUS_Bidir);
IR_Imm1_buffer:		BidirPin generic map(width => Dwidth) 	port map(Dout => Imm1_ext, en => Imm1_in, Din => open, IOpin => BUS_Bidir);
IR_Imm2_buffer:		BidirPin generic map(width => Dwidth) 	port map(Dout => Imm2_ext, en => Imm2_in, Din => open, IOpin => BUS_Bidir);
RF_OUT_buffer:		BidirPin generic map(width => Dwidth) 	port map(Dout => RregDataOUT, en => RFout, Din => open, IOpin => BUS_Bidir);


MUX_RFadderReg:			ChosenRegAddr <=IR(Dwidth-13 downto Dwidth-16) 	when RFadder = "00" else --R[rc] Addr
								IR(Dwidth-9 downto Dwidth-12)	when RFadder = "01" else --R[rb] Addr
								IR(Dwidth-5 downto Dwidth-8)	when RFadder = "10" else unaffected; --R[ra] Addr

AddressRF:			WregAddr  <=   (others => '0') when IR(Dwidth-1 downto Dwidth-4) = "0010" else   ChosenRegAddr; 
					RregAddr  <=   (others => '0') when IR(Dwidth-1 downto Dwidth-4) = "0010" else  ChosenRegAddr; 
										
					
					
FLAGS:				zero 		<= (others => '0');		
					Nflag 		<= '0' when rst ='1' else Nflag_Internal when ((  IR(Dwidth-1 downto Dwidth-4) = "0001") or (  IR(Dwidth-1 downto Dwidth-4) = "0000") or(  IR(Dwidth-1 downto Dwidth-4) = "0011") ) and  (cin = '1')  else unaffected ;
					Zflag  		<= '0' when rst ='1' else Zflag_Internal  when ((  IR(Dwidth-1 downto Dwidth-4) = "0001") or (  IR(Dwidth-1 downto Dwidth-4) = "0000") or(  IR(Dwidth-1 downto Dwidth-4) = "0011") ) and  (cin = '1')  else unaffected ;
					Cflag <= '0' when rst ='1' else Cflag_Internal  when ((  IR(Dwidth-1 downto Dwidth-4) = "0001") or (  IR(Dwidth-1 downto Dwidth-4) = "0000") or(  IR(Dwidth-1 downto Dwidth-4) = "0011") ) and  (cin = '1') else unaffected ;
					
end arc_sys;







