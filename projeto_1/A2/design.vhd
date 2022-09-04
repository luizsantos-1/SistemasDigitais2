entity rom_arquivo is 
	port (
    	addr: in bit_vector (4 downto 0);
        data: out bit_vector(7 downto 0)
    );
end rom_arquivo;


architecture rom_arquivo_arch of rom_arquivo is 
	-- declaracoes 
    type mem_rom is array (0 to 31) of bit_vector (7 downto 0);
    signal memoria: mem_rom := init_mem("conteudo_rom_ativ_02_carga.dat");  
begin 

    data <= memoria(to_integer(unsigned(addr))); 
    		
end rom_arquivo_arch;
