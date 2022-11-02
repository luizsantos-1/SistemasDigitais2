library IEEE;
use IEEE.numeric_bit.all;

entity fulladder is
  port (
    a, b, cin: in bit;
    s, cout: out bit
  );
 end entity;
-------------------------------------------------------
architecture structural of fulladder is
  signal axorb: bit;
begin
  axorb <= a xor b;
  s <= axorb xor cin;
  cout <= (axorb and cin) or (a and b);
 end architecture;
 
entity alu1bit is 
	port (
    		a,b,less,cin: in bit;
            result, cout, set, overflow: out bit;
            ainvert, binvert: in bit;
            operation: in bit_vector(1 downto 0)
            );
end entity;

architecture alu1bit_arch of alu1bit is
	component fulladder is
      port (
        a, b, cin: in bit;
        s, cout: out bit
      );
 end component;
  signal s_soma, s_and, s_or, s_slt, a_processado, b_processado, carry_out : bit;
  
begin
    a_processado <= a xor ainvert;
    b_processado <= b xor binvert;

	s_and <= a_processado and b_processado;
    s_or <= a_processado or b_processado;

	somador: fulladder port map (a_processado, b_processado,cin,s_soma, carry_out);
  set <= s_soma;
  cout <= carry_out;
  overflow <= (a_processado and b_processado and (not s_soma)) or ((not a_processado) and (not b_processado) and s_soma);

  result <= s_soma when ( operation = "10") else
            s_or when ( operation = "01") else
    		s_and when (operation = "00") else
            less when (operation = "11");

 end architecture;
 
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
inv_detec <= S(0) or S(1);
op <= S(2) & S(3);

alu1bit0: alu1bit port map (A(0), B(0), set_vec(size - 1),inv_detec, F(0), carry(0), set_vec(0), overflow_ignore(0), S(0), S(1), op);

g1: for i in 1 to size - 2 generate 
    	alu1biti: alu1bit  port map (A(i), B(i), '0',carry(i-1), F(i), carry(i), set_vec(i), overflow_ignore(i), S(0), S(1), op);
end generate g1;

alu1bitfinal: alu1bit port map (A(size -1), B(size -1), '0',carry(size - 2), F(size -1), Co, set_vec(size - 1), Ov, S(0), S(1), op);

compare <= (others => '0');

Z <= '1' when (set_vec = compare) else
	 '0';

end architecture;


