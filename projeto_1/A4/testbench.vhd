library IEEE;
use IEEE.numeric_bit.all;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is
    
-- DUT component
component ram is
	generic (
    	addressSize : natural := 5;
      wordSize : natural := 8
    );
    port (
    	ck, wr : in bit ;
      addr : in bit_vector (addressSize - 1 downto 0);
      data_i : in bit_vector (wordSize - 1 downto 0);
      data_o : out bit_vector (wordSize - 1 downto 0)
    );
end component;

constant addressSize : natural := 5;
constant wordSize : natural:= 8;
constant datFileName : string := "conteudo_rom_ativ_02_carga.dat";

signal wr: bit;
signal ende: bit_vector (addressSize - 1 downto 0);
signal data_in, data_out: bit_vector (wordSize - 1 downto 0);


constant clockPeriod : time := 2 ns; -- clock period
signal keep_simulating: bit := '0'; -- interrompe simulação 
signal clk_in: bit; -- se construção alternativa do clock

begin
	clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  -- Connect DUT
  DUT: ram generic map(addressSize, wordSize)
           port map(clk_in, wr, ende, data_in, data_out);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    keep_simulating <= '1';
    
    ende <= "00000";
    data_in <= "01010101";
    wr <= '1';
    wait for 2 ns;
    wr <= '0';
    data_in <= "00000000";
    wait for 2 ns;
    
    assert(data_out ="01010101") report "Fail 0+0" severity error;
    
	keep_simulating <= '0';
    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;
