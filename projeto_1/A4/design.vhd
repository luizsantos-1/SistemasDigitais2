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
    
	component regFile is 
      generic (
          regSize: natural := 8;
          addressSize : natural := 5 
      );
      port(
          endereco: in bit_vector(addressSize - 1 downto 0);
          reset, clock, write: in bit;
          D: in bit_vector (regSize - 1 downto 0);
          Q: out bit_vector(regSIze- 1 downto 0));
	end component;
    
begin 
	banco: regFile generic map (wordSize, addressSize)
    			   port map (addr, '0', ck, wr, data_i, data_o);
                   

end ram_arch;

entity regFile is 
	generic (
    	regSize: natural  := 8;
        addressSize : natural := 5 
    );
    port(
    	endereco: in bit_vector(addressSize - 1 downto 0);
        reset, clock, write: in bit;
        D: in bit_vector (regSize - 1 downto 0);
        Q: out bit_vector(regSIze- 1 downto 0));
end regFile;

architecture behavior of regFile is

type mem_type is array (0 to 2**addressSize - 1) of bit_vector(regSize - 1 downto 0);
signal mem: mem_type;
signal posicao: integer;

--ESCRITA
begin
  process (reset, clock) 
  	begin
      if clock'EVENT and clock='1' and write='1' 
      	then mem(to_integer(unsigned(endereco))) <= D;
      end if;
  end process;
  
-- LEITURA
Q <= mem(to_integer(unsigned(endereco))); 
  
end behavior;

