DUT: 
1. top:
	inputs: rst- reset ,
			clk- clock
			ProgMemTBDataIn,DataMemTBDataIn,ProgMemTBWren,DataMemTBWren,ProgMemTbWAddr,DataMemTbRAddr,DataMemTbWAddr,TBactive
							
	outputs: DataMemDataOut- holds the last value of the DataOut after finnishing 	calculations. 
		
	internal signals: mov,st,ld,done_in,jnc,jc,jmp,sub,add,nop,Nflag,Zflag,Cflag,Cout, Cin, Ain, RFin, RFout,IRin,PCin,Imm1_in,Imm2_in,DoneProgram,Mem_wr, Mem_out, Mem_in,OPC,RFadder ,PCsel . 

2. Control:
		inputs: rst- reset ,
			clk- clock
			input - mov, donein, nop, jnc, jc ,jmp, sub, add, Nflag, Zflag, Cflag ,ld, st - that  arraived from dataPATH 
			one - indicates that the counter has reached one. 
		outputs : acording to FSM 
						Mem_wr, Mem_out, Mem_in, Cout, Cin, Ain, RFin				 
		RFout,IRin,PCin,Imm1_in, Imm2_in							 
		OPC 														
		RFadder ,PCsel												 
		done	
		internal signals:
			pr_state - holds the name of the present state 
			nx_state - holds the name of next state 
			state - new type for states 
		process: 
			 the FSM that decides whith signials arr outputed acordint to input and pr_state.
			 
3. Datapath:
	inputs: rst- reset ,
			clk- clock
			OPCin -  indicates to open the opc register 
			 OPC  -  input for alu  to decide sub/add  
			RFadder    -  adress RF mux signal 
			Bin   -  indicates to open the reg_b register  
			PCsel  -  PC next mux signal  
Cout, Cin, Ain, RFin, RFout,IRin,PCin,Imm1_in,Imm2_in,Mem_wr, Mem_out, Mem_in-all the buffer for the bus or RF OR DATAMEMORY OR ALU REGISTERS
		internal signals:
			signal DataMemDOut-OUTPUT FROM DATA-MEMORY 						
IR-INSTRUCTION REGISTER ,Reg_C-MASTER SLAVE REGISTER FOR ALU,ALU_C-ALU OUTPUT,Reg_A-REGISTER A OF ALU
 opc_ir-OPC OF INSTRUCTION FOR DECODER,ChosenRegAddr-ADRESS TO RF					
 Imm1_ext-ZERO EXPANDED TO IMM1							 
Imm2_ext-ZERO EXPANDED TO IMM2							
 BUS_Bidir-CONNECT TO THE BUS BIDIR FILE						
 ProgMemDOut,RregDataOUT,WregDataIN, DataMemDIn 
	DataMemWAddr, DataMemRAddr-ALL THIS SIGNAL FOR TB,
 DFF-MEMIN FLIP FLOP	



			
		process: 
			D_filp_flops: a FLIPFLPO that CONNECTED TO MEMIN TO MAKE 1 CYCLE DELAY WHEN WE NEED TO ACSSES DATA MEMORY 
			UPDATE REGISTER          : PC,REGISTER A,REGISTER C,INSTRUCTION REGISTER
			      
			
	
		 