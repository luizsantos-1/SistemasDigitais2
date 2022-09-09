library IEEE;
use IEEE.numeric_bit.all;

entity ram is 
	generic (
    	addressSize : natural := 5;
        wordSize : natural := 8
    );
    port (
    	ck, wr : in bit ;
        addr : in bit_vector (addressSize - 1 downto 0);
        data_i : in bit_vector (wordSize - 1 downto 0);
        data_o : out bit_vector (wordSize - 1 downto 0)
    );
    
end ram;

architecture ram_arch of ram is 
	-- declaracoes 
    constant MEM_DEPTH : integer := 2**addressSize;
	type mem_type is array (0 to MEM_DEPTH - 1) of bit_vector(wordSize - 1 downto 0);
    
signal memoria: mem_type;
    
begin 
	process (ck) 
  	begin
      if ck'EVENT and ck='1' and wr='1' 
      	then memoria(to_integer(unsigned(addr))) <= data_i;
      end if;
  end process;
  
data_o <= memoria(to_integer(unsigned(addr)));  

end ram_arch;
  


