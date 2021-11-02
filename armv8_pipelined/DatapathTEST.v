//TESTBENCH 
module datapathTest(); 
	reg clock = 0; 
	
	
	//CPU aansturen met klok
	datapath dp(.clock(clock)); 
	
	always 
		begin 
		#10 
			clock = ~clock; 
		end
	
	initial 
		begin 
		#0
		$readmemb("C:/Users/32474/Documents/IIW/3BA/Computer architectuur/armv8_pipelined/memory/instructions.bin", dp.IF.IM.memory);
		$readmemb("C:/Users/32474/Documents/IIW/3BA/Computer architectuur/armv8_pipelined/memory/datamem.bin", dp.MEM.dataMem.memory);
		$readmemb("C:/Users/32474/Documents/IIW/3BA/Computer architectuur/armv8_pipelined/memory/registers.bin", dp.ID.registers.memory);
		end
		
		
endmodule
