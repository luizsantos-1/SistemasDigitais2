library IEEE;
use IEEE.numeric_bit.all;

entity alu is generic (
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
end entity;

--ARRUMAR O OVERFLOW DO ALU1BIT??????????

architecture alu_arch of alu is 
component alu1bit is 
	port (
    		a,b,less,cin: in bit;
            result, cout, set, overflow: out bit;
            ainvert, binvert: in bit;
            operation: in bit_vector(1 downto 0)
            );
end component;
signal carry : bit_vector(size - 1 downto 0);
signal less_final: bit;
signal set_vec, compare: bit_vector(size-1 downto 0);

signal overflow_ignore: bit_vector(size - 1 downto 0);

signal inv_detec: bit;
signal op: bit_vector(1 downto 0);

begin
inv_detec <= S(3) or S(2);
op <= S(1) & S(0);

alu1bit0: alu1bit port map (A(0), B(0), set_vec(size - 1),inv_detec, F(0), carry(0), set_vec(0), overflow_ignore(0), S(3), S(2), op);

g1: for i in 1 to size - 2 generate 
    	alu1biti: alu1bit  port map (A(i), B(i), '0',carry(i-1), F(i), carry(i), set_vec(i), overflow_ignore(i), S(3), S(2), op);
end generate g1;

alu1bitfinal: alu1bit port map (A(size -1), B(size -1), '0',carry(size - 2), F(size -1), Co, set_vec(size - 1), Ov, S(3), S(2), op);

compare <= (others => '0');

Z <= '1' when (set_vec = compare) else
	 '0';

end architecture;

 