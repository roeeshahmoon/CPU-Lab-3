LIBRARY ieee;
USE ieee.std_logic_1164.all;

package aux_package is
-----------------------------------------------------------------
component top is
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
		TBactive            : in std_logic
	);
end component;
-------------------------------------------------------------
component Control is
	port(
		rst,ena,clk : in std_logic;
		mov, ld, st,shl, donein, jnc, jc ,jmp, sub, add, nop, Nflag, Zflag, Cflag		 : in std_logic;
		---------------------------------------------
		Mem_wr, Mem_out, Mem_in, Cout, Cin, Ain, RFin				 : out std_logic := '0';
		RFout,IRin,PCin,Imm1_in, Imm2_in							 : out std_logic := '0';
		OPC 														 : out std_logic_vector(3 downto 0);
		RFadder ,PCsel												 : out std_logic_vector(1 downto 0);
		done													 	: out std_logic	
	
	);
end component;

----------------------------------------------------------------------	
component Datapath is
	generic (
		Dwidth : integer:=16 ;
		AwidthMem  : integer:=6 ;
		AwidthRF : integer:=4 ;
		dept   : integer:=64
		);
	port(
		rst,clk : in std_logic; --check if we need rst
		mov,st,shl,ld,done_in,jnc,jc,jmp,sub,add,nop,Nflag,Zflag,Cflag	 			 : out std_logic; --status
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

end component;



----------------------------------------------------------------------	

component ALU is
	generic (n : integer := 8;
			k: integer := 3 );
	port (	x,y 	: in  std_logic_vector (n-1 downto 0);
			s 		: out std_logic_vector (n-1 downto 0);
			Cflag,Zflag,Nflag	: out std_logic;
			ALUFN	: in  std_logic_vector (3 downto 0) );
end component;



component BidirPin is
	generic( width: integer:=16 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end component; 
  
--------------------------------------------------------------
component ProgMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr:	in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
);
end component;
-------------
component dataMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr:	in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
);
end component;
--------------------------------------------------------------
--------------------------------------------------------------
component RF is
generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
port(	clk,rst,WregEn: in std_logic;	
		WregData:	in std_logic_vector(Dwidth-1 downto 0);
		WregAddr,RregAddr:	in std_logic_vector(Awidth-1 downto 0);
		RregData: 	out std_logic_vector(Dwidth-1 downto 0)
);
end component;
--------------------------------------------------------------  
end aux_package;

