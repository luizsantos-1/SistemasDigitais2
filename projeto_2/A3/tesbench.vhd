library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is
    
-- DUT component

signal reset_in: bit;
signal instruction_in: bit_vector (15 downto 0);
signal overflow_out: bit;
signal q_out: bit_vector (15 downto 0);
signal end1, end2: bit_vector(4 downto 0);

component calc is 
  port (
    clock: in bit;
    reset: in bit;
    instruction: in bit_vector (15 downto 0);
    overflow: out bit;
    q1: out bit_vector(15 downto 0));
end component;

constant clockPeriod : time := 2 ns; -- clock period
signal keep_simulating: bit := '0'; -- interrompe simulação 
signal clk_in: bit; -- se construção alternativa do clock

begin
	clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  -- Connect DUT
  
  DUT: calc port map(clk_in, reset_in, instruction_in, overflow_out, q_out);
  
  end1 <= "00000";
  end2 <= "00001";
  
  
  process
  begin
  
    assert false report "Test start." severity note;
    keep_simulating <= '1';
	reset_in <= '0';
    
  
  	instruction_in <= "0000001111100000";-- soma zero com zero e poe no primeiro registrador
    wait for 2 ns;
    instruction_in <= "1111110000000000"; -- soma o primeiro registrador com zero e poe o conteudo no primeiro e na saida
    wait for 2 ns;
    assert (q_out = "0000000000000000") report "Fail teste 1" severity error;
    
  	instruction_in <= "0000001111100001";-- soma zero com zero e poe no segundo registrador
    wait for 2 ns;
    instruction_in <= "1111110000100000"; -- soma o segundo registrador com zero e poe o conteudo no segundo e na saida
    wait for 2 ns;
    assert (q_out = "0000000000000000") report "Fail teste 2" severity error;
    
    instruction_in <= "0011110000000000";
    
    wait for 2 ns;
    
    assert (q_out = "0000000000001111") report "Fail teste 3" severity error;
    
 
    
	keep_simulating <= '0';
    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;
