library IEEE;
use IEEE.numeric_bit.all;

entity reg is 
	generic (
        wordSize : natural := 4
    );
    port (
    	clock: in bit ;
        reset: in bit;
        load: in bit;
        d: in bit_vector (wordSize - 1 downto 0);
        q: out bit_vector (wordSize - 1 downto 0)
    );
    
end reg;

architecture reg_arch of reg is 

    
begin 
	process (clock, reset) 
  	begin
      if reset = '1' then 
      	q <= (others => '0');
      elsif clock = '1' and clock'event and load = '1' then 
      	q <= d;
        
      end if;
  end process;
  
 

end reg_arch;


library IEEE;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;
use IEEE.numeric_bit.all;


entity regfile is 


	generic (
    	regn: natural := 32;
        wordSize : natural := 64
    );
    port (
    	clock: in bit ;
        reset: in bit;
        regWrite: in bit;
        rr1, rr2, wr: in bit_vector (natural(ceil(log2(real(regn))))-1 downto 0);
        d: in bit_vector (wordSize - 1 downto 0);
        q1, q2: out bit_vector (wordSize - 1 downto 0)
    );
    
end regfile;

architecture regfile_arch of regfile is 

	component reg is 
      generic (
          wordSize : natural := 4
      );
      port (
          clock: in bit ;
          reset: in bit;
          load: in bit;
          d: in bit_vector (wordSize - 1 downto 0);
          q: out bit_vector (wordSize - 1 downto 0)
      );
end component;

type in_out is array (0 to regn - 2) of bit_vector(wordSize - 1 downto 0);

signal load_vector: bit_vector(regn - 1 downto 0);

signal in_vector: in_out;
signal out_vector: in_out;


begin 

	g1: for i in 0 to regn - 2 generate 
    	regi: reg generic map (wordSize) port map (clock, reset, load_vector(i), in_vector(i), out_vector(i));
    end generate g1;
    
      			
	q1 <= "0000000000000000" when (to_integer(unsigned(rr1)) = regn - 1) else 
           out_vector(to_integer(unsigned(rr1)));
    q2 <= "0000000000000000" when (to_integer(unsigned(rr2)) = regn - 1) else
            out_vector(to_integer(unsigned(rr2)));
    in_vector(to_integer(unsigned(wr))) <= d;
    load_vector(to_integer(unsigned(wr))) <= regWrite; 
  
 

end regfile_arch;