library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

	component rom_arquivo is
port (
    addr: in bit_vector (4 downto 0);
    data: out bit_vector(7 downto 0)
    );
end component;

-- DUT component

signal ende: bit_vector (4 downto 0);
signal saida: bit_vector (7 downto 0);


begin
  -- Connect DUT
  DUT: rom_arquivo port map(ende, saida);
  
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

