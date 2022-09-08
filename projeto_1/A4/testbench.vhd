library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

		constant addressSize : natural := 5;
        constant wordSize : natural:= 8;
        constant datFileName : string := "conteudo_rom_ativ_02_carga.dat";
    
-- DUT component
component rom_arquivo_generica is
	generic (
    	addressSize : natural := 5;
        wordSize : natural:= 8;
        datFileName : string := "conteudo_rom_ativ_02_carga.dat"
        );
	port (
    	addr: in bit_vector (addressSize - 1 downto 0);
        data: out bit_vector(wordSize - 1 downto 0)
    );
end component;


signal ende: bit_vector (addressSize - 1 downto 0);
signal saida: bit_vector (wordSize - 1 downto 0);


begin
  -- Connect DUT
  DUT: rom_arquivo_generica port map(ende, saida);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    
    ende <= "00000";
    wait for 2 ns;
    
    assert(saida ="00000000") report "Fail 0+0" severity error;
    
    ende <= "00101";
    wait for 2 ns;
    
    assert(saida ="01010101") report "Fail 0+0" severity error;
   

    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;

