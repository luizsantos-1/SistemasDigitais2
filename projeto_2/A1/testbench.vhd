library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is
    
-- DUT component

component reg is 
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
    
end component;



constant wordSize : natural:= 5;


signal reset_in: bit;
signal load_in: bit;
signal d_in: bit_vector (wordSize - 1 downto 0);
signal q_out: bit_vector (wordSize - 1 downto 0);


constant clockPeriod : time := 2 ns; -- clock period
signal keep_simulating: bit := '0'; -- interrompe simulação 
signal clk_in: bit; -- se construção alternativa do clock

begin
	clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  -- Connect DUT
  DUT: reg generic map(wordSize)
           port map(clk_in, reset_in, load_in, d_in, q_out);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    keep_simulating <= '1';
    
	reset_in <= '0';
	load_in <= '1';
 	d_in <= "11111";
    
    wait for 4 ns;
    
    assert(q_out = "11111") report "Fail 0+0" severity error;
    
	keep_simulating <= '0';
    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;
