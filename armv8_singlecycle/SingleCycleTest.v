//TESTBENCH 
module CPUtest(); 
	reg clock = 0; 
	
	//CPU aansturen met klok
	SingleCycle singleCycle(.clock(clock)); 
	
	always 
		begin 
		#10 
			clock = !clock; 
		end
	
	initial 
		begin 
		$readmemb("C:\Users\32474\Documents\IIW\3BA\Computer architectuur\SingleCycle\Memory\instructions.bin", singleCycle.IF.IM.memory);
		$readmemb("C:\Users\32474\Documents\IIW\3BA\Computer architectuur\SingleCycle\Memory\datamem.bin", singleCycle.MEM.dataMem.memory);
		$readmemb("C:\Users\32474\Documents\IIW\3BA\Computer architectuur\SingleCycle\Memory\registers.bin", singleCycle.ID.registers.memory);
		end
endmodule
			