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