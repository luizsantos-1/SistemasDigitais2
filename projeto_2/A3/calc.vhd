library IEEE;
use IEEE.numeric_bit.all;

entity reg is 
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
    
end reg;

architecture reg_arch of reg is 

    
begin 
	process (clock, reset) 
  	begin
      if reset = '1' then 
      	q <= (others => '0');
      elsif clock = '1' and clock'event and load = '1' then 
      	q <= d;
        
      end if;
  end process;
  
 

end reg_arch;


library IEEE;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;
use IEEE.numeric_bit.all;


entity regfile is 


	generic (
    	regn: natural := 32;
        wordSize : natural := 64
    );
    port (
    	clock: in bit ;
        reset: in bit;
        regWrite: in bit;
        rr1, rr2, wr: in bit_vector (natural(ceil(log2(real(regn))))-1 downto 0);
        d: in bit_vector (wordSize - 1 downto 0);
        q1, q2: out bit_vector (wordSize - 1 downto 0)
    );
    
end regfile;

architecture regfile_arch of regfile is 

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

type in_out is array (0 to regn - 2) of bit_vector(wordSize - 1 downto 0);

signal load_vector: bit_vector(regn - 1 downto 0);

signal in_vector: in_out;
signal out_vector: in_out;


begin 

	g1: for i in 0 to regn - 2 generate 
    	regi: reg generic map (wordSize) port map (clock, reset, load_vector(i), in_vector(i), out_vector(i));
    end generate g1;
    
      			
	q1 <= "0000000000000000" when (to_integer(unsigned(rr1)) = regn - 1) else 
           out_vector(to_integer(unsigned(rr1)));
    q2 <= "0000000000000000" when (to_integer(unsigned(rr2)) = regn - 1) else
            out_vector(to_integer(unsigned(rr2)));
    in_vector(to_integer(unsigned(wr))) <= d;
    
    load_vector(to_integer(unsigned(wr))) <= regWrite;
    

end regfile_arch;

entity somador_1 is port(
  	A, B, carry_in: in bit ; 
	carry_out, S: out bit); 
end somador_1;

architecture somador_1_arch of somador_1 is 

    begin 
        S <= A xor B xor carry_in;
        carry_out <= ((A xor B) and carry_in) or (A and B); 

end somador_1_arch;

entity somador_16 is port(
  	entrada1, entrada2: in bit_vector(15 downto 0); 
	saida: out bit_vector(15 downto 0);
	overflow: out bit); 
end somador_16;

architecture somador_16_arch of somador_16 is 

    signal carry_out_vec: bit_vector(15 downto 0);

    component somador_1 is port (
		A, B, carry_in: in bit; 
		carry_out, S: out bit); 
    end component;

    begin 
    
        B0: somador_1 port map (entrada1(0), entrada2(0), '0' , carry_out_vec(0), saida(0)); 
        B1: somador_1 port map (entrada1(1), entrada2(1), carry_out_vec(0), carry_out_vec(1), saida(1)); 
        B2: somador_1 port map (entrada1(2), entrada2(2), carry_out_vec(1), carry_out_vec(2), saida(2)); 
        B3: somador_1 port map (entrada1(3), entrada2(3), carry_out_vec(2), carry_out_vec(3), saida(3)); 
        B4: somador_1 port map (entrada1(4), entrada2(4), carry_out_vec(3), carry_out_vec(4), saida(4)); 
        B5: somador_1 port map (entrada1(5), entrada2(5), carry_out_vec(4), carry_out_vec(5), saida(5)); 
        B6: somador_1 port map (entrada1(6), entrada2(6), carry_out_vec(5), carry_out_vec(6), saida(6)); 
        B7: somador_1 port map (entrada1(7), entrada2(7), carry_out_vec(6), carry_out_vec(7), saida(7)); 
        B8: somador_1 port map (entrada1(8), entrada2(8), carry_out_vec(7), carry_out_vec(8), saida(8)); 
        B9: somador_1 port map (entrada1(9), entrada2(9), carry_out_vec(8), carry_out_vec(9), saida(9)); 
        B10: somador_1 port map (entrada1(10), entrada2(10), carry_out_vec(9), carry_out_vec(10), saida(10));  
        B11: somador_1 port map (entrada1(11), entrada2(11), carry_out_vec(10), carry_out_vec(11), saida(11)); 
        B12: somador_1 port map (entrada1(12), entrada2(12), carry_out_vec(11), carry_out_vec(12), saida(12)); 
        B13: somador_1 port map (entrada1(13), entrada2(13), carry_out_vec(12), carry_out_vec(13), saida(13));
        B14: somador_1 port map (entrada1(14), entrada2(14), carry_out_vec(13), carry_out_vec(14), saida(14)); 
        B15: somador_1 port map (entrada1(15), entrada2(15), carry_out_vec(14), carry_out_vec(15), saida(15)); 

    overflow <= carry_out_vec(15);
    
end somador_16_arch;

library IEEE;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity calc is 
		port (
        		clock: in bit;
                reset: in bit;
                instruction: in bit_vector (15 downto 0);
                overflow: out bit;
                q1: out bit_vector(15 downto 0));
end calc;


architecture calc_arch of calc is 

  component regfile is 
  
	  generic (
          regn: natural := 32;
          wordSize : natural := 64
      );
      port (
          clock: in bit ;
          reset: in bit;
          regWrite: in bit;
          rr1, rr2, wr: in bit_vector (natural(ceil(log2(real(regn))))-1 downto 0);
          d: in bit_vector (wordSize - 1 downto 0);
          q1, q2: out bit_vector (wordSize - 1 downto 0)
      );

  end component;
  
	component somador_16 is port(
		entrada1, entrada2: in bit_vector(15 downto 0); 
		saida: out bit_vector(15 downto 0);
		overflow: out bit); 
	end component;
  
  signal regWrite_in: bit;
  
  signal out1_reg, out2_reg: bit_vector(15 downto 0);
  signal in1_soma, in2_soma, out_soma: bit_vector(15 downto 0);

begin 

banco: regfile generic map (32, 16) port map (clock, reset, regWrite_in, instruction(14 downto 10), instruction(9 downto 5), instruction (4 downto 0), out_soma, out2_reg, out1_reg);

somador: somador_16 port map(in2_soma, in1_soma, out_soma,overflow);

in2_soma <= out2_reg when (instruction(15) = '1') else 
			"00000000000" & instruction(14 downto 10)  when (instruction(14) = '0') else
            "11111111111" & instruction(14 downto 10) when (instruction(14) = '1');
            
in1_soma <= out1_reg; 
q1 <= out1_reg;

regWrite_in <= '1';--um problema esta aqui

end calc_arch;

