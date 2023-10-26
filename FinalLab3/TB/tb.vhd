library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;
---------------------------------------------------------
entity tb is
	constant Dwidth : integer:= 16 ;
	constant AwidthMem : integer:=6 ;
	constant AwidthRF : integer:=4 ;
	constant dept   : integer:=64;
	
end tb;
---------------------------------------------------------
architecture rtb of tb is
	signal  rst,ena,clk 	: std_logic;
	signal  done			: std_logic := '0';
	signal ProgMemTBDataIn,DataMemTBDataIn	: std_logic_vector(Dwidth-1 downto 0);
	signal DataMemDataOut :std_logic_vector(Dwidth-1 downto 0);
	 -----------------------------------
	signal ProgMemTBWren,DataMemTBWren  	 : std_logic;
	 --------------------------------------
	signal ProgMemTbWAddr,DataMemTbRAddr,DataMemTbWAddr	 : std_logic_vector(AwidthMem -1 downto 0);
	signal TBactive           : std_logic := '0'; 
	
	
	signal  doneProgMem,doneDataMem			: boolean :=false;
	signal doneDataMemRead					: boolean :=true;
	constant FileLocation_ProgMem					: string(1 to 70) :=
	"C:\Users\Noam\Desktop\CPU-LABS\myLAB3\myLAB3\Memory_files\ITCMinit.txt";
	constant FileLocation_DataMem					: string(1 to 70) :=
	"C:\Users\Noam\Desktop\CPU-LABS\myLAB3\myLAB3\Memory_files\DTCMinit.txt";
	constant FileLocation_Update_DataMem					: string(1 to 73) :=
	"C:\Users\Noam\Desktop\CPU-LABS\myLAB3\myLAB3\Memory_files\DTCMcontent.txt";
--------------------------------------------------------------------------------------------------
begin
	L0 : top generic map (Dwidth,AwidthMem,AwidthRF,dept)
	port map(
		rst,ena,clk,	
		done, 			 		
		-----------------------------------
		ProgMemTBDataIn,DataMemTBDataIn,	 
		DataMemDataOut,
		-----------------------------------
		ProgMemTBWren,DataMemTBWren,  	
		--------------------------------------
		ProgMemTbWAddr,DataMemTbRAddr,DataMemTbWAddr,	 
		TBactive         
	);

		
 --------- start of stimulus section ------------------	
 
 -------------------------------------------------------------------------------------------------------
			--Load the instraction from ITCMinit to Program Memory
-------------------------------------------------------------------------------------------------------	

LoadProgMem:process
		file infile_ProgMem : text open read_mode is FileLocation_ProgMem;
		variable 	L 					: line;		
		variable    linetomem			: std_logic_vector(Dwidth-1 downto 0);
		variable	good				: boolean;
		variable	TempRAddresses		: std_logic_vector(AwidthMem-1 downto 0) ; -- Awidth
	begin 
		--wait until rst = '0';
		doneProgMem <= false;
		TempRAddresses := (others => '0');
		
		while not endfile(infile_ProgMem) loop
			readline(infile_ProgMem,L); --read a line to L
-----------------------------------------------------------------------			
			hread(L,linetomem,good); --read to linetomem from L in hex
			next when not good;
	-----------------------------------
		    ProgMemTBWren <= '1';
			ProgMemTbWAddr <= TempRAddresses;
			ProgMemTBDataIn <= linetomem;
			wait until rising_edge(clk);
			TempRAddresses := TempRAddresses + '1';
		end loop ;
		ProgMemTBWren <= '0';
		doneProgMem <= true;
		file_close(infile_ProgMem);
		report "End of Load the instraction from ITCMinit to Program Memory" severity note;
		---------------------------------------------------------------------------------
		wait;
	end process;
-------------------------------------------------------------------------------------------------------
			--Load the data from DTCMinit to DATA Memory
-------------------------------------------------------------------------------------------------------	
	
LoadDataMem:process 
		file infile_DataMem : text open read_mode is FileLocation_DataMem;
		variable    linetomem			: std_logic_vector(Dwidth-1 downto 0);
		variable	good				: boolean;
		variable 	L 					: line;
		variable    TempWAddresses		: std_logic_vector(AwidthMem-1 downto 0) ;
	begin 
		doneDataMem <= false;
		TempWAddresses := (others => '0');
		while not endfile(infile_DataMem) loop
			readline(infile_DataMem,L); --read a line to L
			hread(L,linetomem,good); --read to linetomem from L in hex
			next when not good;
			DataMemTBWren <= '1';
			DataMemTbWAddr <= TempWAddresses;
			DataMemTBDataIn <= linetomem;
			wait until rising_edge(clk);
			TempWAddresses := TempWAddresses + '1';
		end loop ;
		DataMemTBWren <='0';
		doneDataMem <= true;
		file_close(infile_DataMem);
		report "End of Load the Data from DTCMinit to Data Memory" severity note;
		wait;
	end process;

-------------------------------------------------------------------------------------------------------
			--Write the data to DTCMcontent from CPU 
-------------------------------------------------------------------------------------------------------		
-------------------------------------------------------------------------------------------------------
			--Write the data to DTCMcontent from CPU 
-------------------------------------------------------------------------------------------------------		
UpdateDataMem:process
		file outfile_DataMem : text open write_mode is FileLocation_Update_DataMem;
		variable    linetomem			: std_logic_vector(Dwidth-1 downto 0);
		variable	good				: boolean;
		variable 	L 					: line;
		variable    TempRAddresses		: std_logic_vector(AwidthMem-1 downto 0) ;
		variable 	counter				: integer;
	begin 
	--wait until rst = '0';
		wait until done = '1';
		doneDataMemRead <= false;
		TempRAddresses := (others => '0');
		counter := 0;
		while counter < 28 loop
			DataMemTbRAddr <= TempRAddresses;
			wait until rising_edge(clk);
			hwrite(L,DataMemDataOut);  --write a line to L from DataMemDataOut
			writeline(outfile_DataMem,L);
			TempRAddresses := TempRAddresses +1;
			counter := counter + 1;
		end loop ;
		file_close(outfile_DataMem);
		report "End of Update the Data from CPU to Data Memory" severity note;
		

		wait;
	end process;




		rst <= '0' when doneProgMem and doneDataMem else '1';
        ena <= '1' when doneProgMem and doneDataMem  else '0';
		TBactive <= '1' when doneProgMem and doneDataMem and doneDataMemRead else '0';
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;


end architecture rtb;
