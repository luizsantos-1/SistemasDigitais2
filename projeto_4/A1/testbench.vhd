library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

component signExtend is
port (
	i: in bit_vector(31 downto 0);
    o: out bit_vector(63 downto 0)
    );
end component;
signal i_in: bit_vector(31 downto 0);
signal o_out: bit_vector(63 downto 0);



begin

DUT: signExtend port map(i_in, o_out);


process
  begin
  
  	assert false report "Test start." severity note;
    
	i_in <= "11111000010000001111000000000000";

   
    wait for 2 ns;
    assert(o_out = "0000000000000000000000000000000000000000000000000000000000001111") report
"erro1" severity error;
    
        
	i_in <= "11111000010111110000000000000000";

    wait for 2 ns;
    assert(o_out = "1111111111111111111111111111111111111111111111111111111111110000") report "erro2" severity error;
    
    i_in <= "11111000000111110000000000000000";

    wait for 2 ns;
    assert(o_out = "1111111111111111111111111111111111111111111111111111111111110000") report "erro3" severity error;
    
    i_in <= "10110100111111111111111000011111";

    wait for 2 ns;
    assert(o_out = "1111111111111111111111111111111111111111111111111111111111110000") report "erro4" severity error;
 
    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;
