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
        data_i : in bit vector (wordSize - 1 downto 0);
        data_o : out bit_vector (wordSize - 1 downto 0)
    );
    
end ram;

architecture ram_arch of ram is 
	-- declaracoes 
    constant MEM_DEPTH : integer := 2**addressSize;
	type mem_type is array (0 to MEM_DEPTH - 1) of bit_vector(wordSize - 1 downto 0);
    
    
begin 

    data <= memoria(to_integer(unsigned(addr))); 
    		
end rom_arquivo_arch;

entity regFile is 
	generic (
    	regSize: natural: = 8;
        addressSize : natural := 5 
    );
    port(
        reset, clock, EN: in bit;
        D: in bit_vector (regSize - 1 downto 0);
        Q: out bit_vector(regSIze- 1 downto 0);
end regFile;

architecture behavior of regFile is

type mem_type is array (0 to 2**addressSize - 1) of bit_vector(wordSize - 1 downto 0);
signal mem: mem_type;

begin
  process (reset, clock) 
  	begin
      if reset='0' 
      	then Q <= '0';
      elsif clock'EVENT and clock='1' and EN='1' 
      	then Q <= D;
      end if;
  end process;
  
Q <= mem
  
end behavior;
