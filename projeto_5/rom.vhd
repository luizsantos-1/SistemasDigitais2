-------
-- PCS-3225 - Sistemas Digitais II
-- Modelo de uma ROM assíncrona em VHDL com inicialização em vetor constante.
-- Contem como exemplo o programa MDC. 
--
-- Author: Prof. Sergio R. M. Canovas
-- Modificado por: Prof. Edson S. Gomi
-- Date: 16-Nov-2020
-------

library ieee;
use ieee.numeric_bit.all;

entity rom is
   port (
      -- 4 bits de endereço:
      addr: in bit_vector(3 downto 0);
      -- 32 bits de tamanho de palavra de dados:
      data: out bit_vector(31 downto 0)
   );
end rom;

architecture rom_arch of rom is
  type mem_tipo is array (0 to 15) of bit_vector(31 downto 0);
  constant mem: mem_tipo :=
    (1 => "11111000010000000000001111100001", 
     2 => "11111000010000001000001111100010",
     3 => "11111000010000010000001111100011",
     4 => "11001011000000110000000001000100",
     5 => "10110100000000000000000011100100",
     6 => "10001010000000010000000010000101",
     7 => "10110100000000000000000001100101", 
     8 => "11001011000000100000000001100011",
     9 => "00010111111111111111111111111011",
     10 => "11001011000000110000000001000010",
     11 => "00010111111111111111111111111001",
     12 => "11111000000000001000001111100010");
  
begin
   data <= mem(to_integer(unsigned(addr)));
end rom_arch;
