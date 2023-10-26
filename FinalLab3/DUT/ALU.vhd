library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

----------------------------------------------------------------------	
entity ALU is 
	generic (n : integer := 8;
			k: integer := 4 );
	port (	x,y 	: in  std_logic_vector (n-1 downto 0);
			s 		: out std_logic_vector (n-1 downto 0);
			Cflag,Zflag,Nflag	: out std_logic;
			ALUFN	: in  std_logic_vector (3 downto 0) );
end ALU;

architecture dfl of ALU is 
	component FA is 
		port (xi,yi,cin: in std_logic; s,cout: out std_logic);
	end component;
	signal regC,Xin,regS,yin,Res,zeros 		: std_logic_vector(n-1 downto 0);
	signal Cary:  std_logic;
	
begin
	with ALUFN select
		Xin  <= 	x when "0000",
				not x when "0001",
				not x when "0100",
				(others => '0') when others;
						-- x is xored with the ALUFN(0) bit for add/sub mode and zero otherwise
		with ALUFN select
		yin  <= 	y when "0000",
					y when "0001",
				(0 => '1' , others => '0') when "0010",
				(others => '0') when others;
		
	first:	FA port map(
		xi   	=> Xin(0),
		yi   	=> yin(0),
		s  	=> regS(0),
		cin  	=> ALUFN(0),
		cout 	=> regC(0)
	);
	
	rest: for i in 1 to n-1 generate
		chain : FA port map (									--chaining: the other FA together	
			xi   	=> Xin(i),
			yi   	=> yin(i),
			s	=> regS(i),
			cin  	=> regC(i-1),
			cout 	=> regC(i)
		);
	end generate;

  process (X, Y)  
    variable temp: std_logic_vector(n - 1 downto 0);
	variable amount : integer ;
	variable carry: std_logic := '0';	
	begin
    temp := Y;
	amount := 0;

	 -- Convert input vector to shift amount
    for i in 0 to k - 1 loop
      if X(i) = '1' then
        amount := amount + 2 ** i;
      end if;
    end loop;
   

    for i in 0 to amount - 1 loop
		carry := temp(n - 1);
        temp(n - 1 downto 1) := temp(n - 2 downto 0);
        temp(0) := '0';
    end loop;

    

    Res <= temp;
	Cary <= carry;

  end process;

	zeros <= (others => '0') ;
	Cflag <= regC(n-1) when ((ALUFN = "0000") or (ALUFN = "0001"))  else cary when ALUFN ="0011" else  '0' ;
	Zflag	<= '1' when regS = zeros and ((ALUFN = "0000") or (ALUFN = "0001"))  else '1' when ((ALUFN = "0011") and Res = zeros) else '0' ;
	Nflag 		<= regS(n-1) when ((ALUFN = "0000") or (ALUFN = "0001"))  else Res(n-1) when ALUFN ="0011" else  '0' ;
	s    <= regS	 when ((ALUFN = "0000") or (ALUFN = "0001"))  else Res when ALUFN ="0011"  else (others => '0');	 
			
end dfl;