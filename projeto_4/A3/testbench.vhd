library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

signal aluop_in: bit_vector(1 downto 0);
signal opcode_in: bit_vector(10 downto 0);
signal aluCtrl_out: bit_vector(3 downto 0);

component alucontrol is 
	port (
    	aluop: in bit_vector(1 downto 0);
        opcode: in bit_vector(10 downto 0);
        aluCtrl: out bit_vector(3 downto 0)
        );
end component;

begin
  -- Connect DUT
  DUT: alucontrol port map (aluop_in, opcode_in, aluCtrl_out);
  
  process
  begin
  
  	assert false report "Test start." severity note;
	aluop_in <= "00";
    opcode_in <= "00000000000";
    
    
    
    wait for 2 ns;
    
    assert(aluCtrl_out = "0010") report "Fail 0+0" severity error;
   

    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;