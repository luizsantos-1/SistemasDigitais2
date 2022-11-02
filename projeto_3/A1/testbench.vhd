library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

component alu1bit is 
	port (
    		a,b,less,cin: in bit;
            result, cout, set, overflow: out bit;
            ainvert, binvert: in bit;
            operation: in bit_vector(1 downto 0)
            );
end component;

-- DUT component

signal a_in, b_in, less_in, cin_in, ainvert_in, binvert_in, result_out, cout_out, set_out, overflow_out: bit;
signal operation_in: bit_vector (1 downto 0);


begin
  -- Connect DUT
  DUT: alu1bit port map(a_in, b_in, less_in, cin_in, result_out, cout_out, set_out, overflow_out, ainvert_in, binvert_in, operation_in);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    
    operation_in <= "01";
    a_in <= '0';
    b_in <= '1';
    less_in <= '0';
    cin_in  <= '0';
    ainvert_in <='0';
    binvert_in <='0';
    
   
    wait for 2 ns;
    assert(result_out = '1') report "erro1" severity error;
    assert(cout_out = '0' ) report "erro2" severity error;
    assert(set_out = '1' ) report "erro3" severity error;
    assert(overflow_out = '0') report "erro4" severity error;
    
    
    
    wait for 2 ns;
    
    assert(true) report "Fail 0+0" severity error;
   

    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;