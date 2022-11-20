library IEEE;
use IEEE.numeric_bit.all;

library IEEE;
use IEEE.numeric_bit.all;

entity signExtend is 
port (
	i: in bit_vector(31 downto 0);
    o: out bit_vector(63 downto 0)
    );
end signExtend;

architecture sign_arch of signExtend is 

signal extend_d: bit_vector(54 downto 0);
signal extend_cbz: bit_vector(44 downto 0);
signal extend_b: bit_vector(37 downto 0);

begin 
extend_d <= (others => i(20));
extend_cbz <= (others => i(23));
extend_b <= (others => i(25));
          
          
          
o <= 	extend_d & i(20 downto 12)	when (i(31 downto 21) = "11111000010" ) else -- LDUR
		extend_d & i(20 downto 12) when (i(31 downto 21) = "11111000000" ) else -- STUR
        extend_cbz & i(23 downto 5)	when (i(31 downto 24) = "10110100" ) else --CBZ
        extend_b & i(25 downto 0)	when (i(31 downto 26) = "000101" );
	

end architecture;

