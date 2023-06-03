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

entity Shiftleft2 is
    port(
        entrada: in bit_vector(63 downto 0);
        clock: in bit;
        saida: out bit_vector(63 downto 0)
    );
end entity Shiftleft2;

architecture Shiftleft2_arc of Shiftleft2 is
    begin
        process (clock) is
            begin

            if clock = '1' and clock'event then 
                saida <= entrada(61 downto 0) & "00";
            end if;

        end process;
end architecture Shiftleft2_arc;

entity datapath is
	port( 
    --Common
    clock: in bit;
    reset: in bit;
    --From ControlUnit
    reg2loc: in bit;
    pcsrc: in bit;
    memToReg: in bit;
    aluCtrl: in bit_vector(3 downto 0);
    aluSrc: in bit;
    regWrite:in bit;
    --To Control Unit
    opcode: out bit_vector(10 downto 0);
    zero: out bit;
    --IM Interface
    imAddr: out bit_vecto(63 downto 0);
    imOut: out bit_vector(31 downto 0);
    --DM Interface
    dmAddr: out bit_vecto(63 downto 0);
    dmIn: out bit_vecto(63 downto 0);
    dmOut: out bit_vecto(63 downto 0)
    );
end entity;

architecture datapath_arch of datapath is 
    component Shiftleft2 is
        port(
            entrada: in bit_vector(63 downto 0);
            clock: in bit;
            saida: out bit_vector(63 downto 0)
        );
    end component;

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

    component signExtend is 
    port (
        i: in bit_vector(31 downto 0);
        o: out bit_vector(63 downto 0)
        );
    end component;

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

    signal regPCin, regPCout, pc4 ,pc4_signed : bit_vector(63 downto 0);

    signal ende1_in, ende2_in, write_in : bit_vector(4 downto 0);
    signal data_in : bit_vector(63 downto 0);
    signal data_out1, data_out2 : bit_vector(63 downto 0);

    signal extended : bit_vector(63 downto 0);

    signal alu1_in, alu1_out : bit_vector(63 downto 0);

    signal pc4 : bit_vector(63 downto 0);

    signal extended_and_shifted : bit_vector(63 downto 0);

begin
    

    pc: reg generic map(64) port map(clock, reset, '1', regPCin, regPCout);

    banco: regfile generic map(32, 64) port map(clock, reset, regWrite, ende1_in, ende2_in, write_in, data_in, data_out1, data_out2);
    
    extend: signExtend port map(imOut, extended);

    alu1: alu generic map(64) port map(data_out1, alu1_in, alu1_out, aluCtrl, zero, open, open);

    alu2: alu generic map(64) port map(regPCout, "0000000000000000000000000000000000000000000000000000000000000100", pc4, "0010", open, open, open);
    
    shifter: Shiftleft2 port map(extended, clock, extended_and_shifted);

    alu3: alu generic map(64) port map(regPCout, extended_and_shifted, pc4_signed, "0010", open, open, open);

    regPCin <= pc4_signed when (pcsrc = '1') else
               pc4;

    alu1_in <= extented when (aluSrc = '1') else
               data_out2;
               
    opcode <= imOut(31 downto 21);

    imAddr <= regPCout;

    dmAddr <= alu1_out;

    dmIn <= data_out2;

    ende1_in <= imOut(9 downto 5);

    ende2_in <= imOut(4 downto 0) when (reg2loc = '1') else
                imOut(20 downto 16);

    write_in <= imOut(4 downto 0);

    data_in <= dmOut when (dmOut = '1') else
                     alu1_out;


end datapath_arch;

entity controlunit is 
	port (
--To Datapath
		reg2loc : out bit; 
		uncondBranch : out bit;
		branch: out bit;
      	memRead: out bit ;
      	memToReg: out bit ;
      	aluOp: out bit_vector(1 downto 0); 
        memWrite: out bit;
      	aluSrc : out bit ;
      	regWrite : out bit ; 
      --From Datapath
      	opcode : in bit_vector (10 downto 0)
      	);
		
end entity;

architecture controlunit_arch of controlunit is 
	signal ldur: bit;
    signal type_r: bit;
begin
	type_r <= '1' when (opcode = "10001011000") else
    		  '1' when (opcode = "11001011000") else
              '1' when (opcode = "10001010000") else
              '1' when (opcode = "10101010000") else
              '0';
    			

	reg2loc <=  '1' when (opcode = "11111000010") else 
    			'1' when (opcode = "11111000000") else 
                '1' when (opcode = "00010110100") else
                '0' when (opcode = "00000000101") else
                '0' when (type_r = '1');
    
	uncondBranch <= '0' when (opcode = "11111000010") else
    			'0' when (opcode = "11111000000") else 
                '1' when (opcode = "00010110100") else
                '1' when (opcode = "00000000101") else
                '0' when (type_r = '1');
                
    branch <= '0' when (opcode = "11111000010") else
    			'0' when (opcode = "11111000000") else 
                '1' when (opcode = "00010110100") else
                '0' when (opcode = "00000000101") else
                '0' when (type_r = '1');
    memRead <=  '1' when (opcode = "11111000010") else
    			'0' when (opcode = "11111000000") else 
                '0' when (opcode = "00010110100") else
                '0' when (opcode = "00000000101") else
                '0' when (type_r = '1');
    memToReg <=  '1' when (opcode = "11111000010") else
    			'0' when (opcode = "11111000000") else 
                '0' when (opcode = "00010110100") else
                '0' when (opcode = "00000000101") else
                '0' when (type_r = '1');
    aluOp <=  "00" when (opcode = "11111000010") else
    			"00" when (opcode = "11111000000") else 
                "11" when (opcode = "00010110100") else
                "00" when (opcode = "00000000101") else
                "10"when (type_r = '1');
    memWrite <=  '0' when (opcode = "11111000010") else
    			'1' when (opcode = "11111000000") else 
                '0' when (opcode = "00010110100") else
                '0' when (opcode = "00000000101") else
                '0' when (type_r = '1');
    aluSrc <=  '1' when (opcode = "11111000010") else
    			'0' when (opcode = "11111000000") else 
                '0'when (opcode = "00010110100") else
                '0' when (opcode = "00000000101") else
                '0' when (type_r = '1');
    regWrite <=  '1' when (opcode = "11111000010") else
    			'0' when (opcode = "11111000000") else 
                '0' when (opcode = "00010110100") else
                '1' when (opcode = "00000000101") else
                '1' when (type_r = '1');
    
end architecture;

entity alucontrol is 
	port (
    	aluop: in bit_vector(1 downto 0);
        opcode: in bit_vector(10 downto 0);
        aluCtrl: out bit_vector(3 downto 0)
        );
end entity;

architecture alucontrol_arch of alucontrol is

signal r_type: bit_vector(3 downto 0);

begin

r_type <= "0010" when (opcode = "10001011000") else
		  "0110" when (opcode = "11001011000") else 
          "0000" when (opcode = "10001010000") else 
          "0001" when (opcode = "10101010000");

aluCtrl <= "0010" when (aluop = "00") else
		   "0111" when (aluop = "01") else
           r_type when (aluop = "10");

end alucontrol_arch;

entity polilegsc is
port(
    clock, reset : in bit;
    -- Data Memory
    dmem_addr: out bit_vector(63 downto 0);
    dmem_dati: out bit_vector(63 downto 0);
    dmem_dato: in  bit_vector(63 downto 0);
    dmem_we: out bit;
    -- Instruction Memory
    imem_addr: out bit_vector(63 downto 0);
    imem_data: in  bit_vector(31 downto 0)
);
end entity polilegsc;

architecture polilegsc_arch of polilegsc is 

component datapath is
	port( 
    --Common
    clock: in bit;
    reset: in bit;
    --From ControlUnit
    reg2loc: in bit;
    pcsrc: in bit;
    memToReg: in bit;
    aluCtrl: in bit_vector(3 downto 0);
    aluSrc: in bit;
    regWrite:in bit;
    --To Control Unit
    opcode: out bit_vector(10 downto 0);
    zero: out bit;
    --IM Interface
    imAddr: out bit_vecto(63 downto 0);
    imOut: out bit_vector(31 downto 0);
    --DM Interface
    dmAddr: out bit_vecto(63 downto 0);
    dmIn: out bit_vecto(63 downto 0);
    dmOut: out bit_vecto(63 downto 0)
    );
end component;

component alucontrol is 
	port (
    	aluop: in bit_vector(1 downto 0);
        opcode: in bit_vector(10 downto 0);
        aluCtrl: out bit_vector(3 downto 0)
        );
end component;

component controlunit is 
	port (
--To Datapath
		reg2loc : out bit; 
		uncondBranch : out bit;
		branch: out bit;
      	memRead: out bit ;
      	memToReg: out bit ;
      	aluOp: out bit_vector(1 downto 0); 
        memWrite: out bit;
      	aluSrc : out bit ;
      	regWrite : out bit ; 
      --From Datapath
      	opcode : in bit_vector (10 downto 0)
      	);
		
end component;

signal reg2loc, uncondBranch, branch: bit;
signal aluOp : bit_vector(1 downto 0);
signal pcsrc, zero : bit;
signal opcode : bit_vector(10 downto 0);
signal aluCtrl : bit_vector(3 downto 0);
signal memRead, memToReg, aluSrc, regWrite: bit;

begin
aluctrl: alucontrol port map (aluOp, opcode, aluCtrl);

fluxo_dados: datapath port map  (clock, reset, reg2loc, pcsrc, memToReg, aluCtrl, aluSrc, regWrite, opcode, zero, imem_addr, imem_data, dmem_addr, dmem_dati, dmem_dato);

unidade_de_controle: controlunit port map  (reg2loc, uncondBranch, branch, memRead, memToReg, aluOp, dmem_we, aluSrc, regWrite, opcode);

pcsrc <= uncondBranch or (branch and zero);

-- Instruction Memory
end polilegsc_arch;

