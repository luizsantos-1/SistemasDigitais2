library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

signal reg2loc_o, uncondBranch_o, branch_o, memRead_o, memToReg_o, memWrite_o, aluSrc_o, regWrite_o: bit;
signal aluOp_o: bit_vector(1 downto 0);
signal opcode_in: bit_vector(10 downto 0);

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

begin
  -- Connect DUT
  DUT: controlunit port map (reg2loc_o, uncondBranch_o, branch_o, memRead_o, memToReg_o, aluOp_o ,memWrite_o, aluSrc_o, regWrite_o, opcode_in);
  
  process
  begin
  
  	assert false report "Test start." severity note;
code 
    
    
    
    wait for 2 ns;
    
    assert(false) report "Fail 0+0" severity error;
   

    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;