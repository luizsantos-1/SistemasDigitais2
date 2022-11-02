-- ja fiz 4 envios
library IEEE;
use IEEE.numeric_bit.all;
 
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
 