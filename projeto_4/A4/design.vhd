llibrary IEEE;
use IEEE.numeric_bit.all;

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
	type_r <= '1' (opcode = "10001011000") else
    		  '1' (opcode = "11001011000") else
              '1' (opcode = "10001010000") else
              '1' (opcode = "10101010000") else
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
                "10 "when (type_r = '1');
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
