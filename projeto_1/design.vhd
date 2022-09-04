library IEEE;
use IEEE.numeric_bit.all;

entity rom_simples is 
	port (
    	addr: in bit_vector (4 downto 0);
        data: out bit_vector(7 downto 0)
    );
end rom_simples;


architecture rom_simples_arch of rom_simples is 
	-- declaracoes 
    type mem_rom is array (0 to 255) of bit_vector (7 downto 0);
    signal mem_rom: memoria := ("00000000", "00000011", "11000000", "00001100", "00110000", "01010101", "10101010", "11111111",
                            "11100000", "11100111", "00000111", "00011000", "11000011", "00111100", "11110000", "00001111",
                            "11101101", "10001010", "00100100", "01010101", "01001100", "01000100", "01110011", "01011101",
                            "11100101", "01111001", "01010000", "01000011", "01010011", "10110000", "11011110", "00110001");  
begin 

    data <= memoria(to_integer(unsigned(addr))); 
    		
end rom_simples_arch;