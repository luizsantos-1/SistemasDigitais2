library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

component alu is generic (
 		size: natural := 10 --Bit size
);
port (
A,B: in bit_vector(size -1 downto 0); --inputs
F: out bit_vector(size -1 downto 0); --outputs
S: in bit_vector(3 downto 0); -- operation selection
Z: out bit; --zero flag
Ov: out bit; -- oveflow flag
Co: out bit -- carry out
);
end component;
--ARRUMAR O OVERF

-- DUT component

signal A_in, B_in, F_out: bit_vector(9 downto 0);
signal S_in: bit_vector (3 downto 0);
signal Z_out, Ov_out, Co_out: bit;


begin
  -- Connect DUT
  DUT: alu port map(A_in, B_in, F_out, S_in, Z_out, Ov_out, Co_out);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    
	A_in <= "0000000000";
    B_in <= "0000000000";
    S_in <= "0011";
   
    wait for 2 ns;
    assert(F_out = "0000000000") report "erro1" severity error;
    assert(Co_out = '0' ) report "erro2" severity error;
    
    assert(Ov_out = '0') report "erro4" severity error;
    
    
    
    wait for 2 ns;
    
    assert(true) report "Fail 0+0" severity error;
   

    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;