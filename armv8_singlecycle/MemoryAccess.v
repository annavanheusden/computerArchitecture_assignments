//MEMORY ACCESS 
module memoryAccess(clock, ALUresult, dataMemWrite, dataMemRead, controlMemWrite, controlMemRead, dataAddress); 
	input clock; 
	input [63:0] ALUresult;
	input [63:0] dataMemWrite; 
	input controlMemWrite, controlMemRead; 
	output [63:0] dataMemRead; 
	output [63:0] dataAddress; 

	assign dataAddress = ALUresult; 

	dataMemory dataMem(.clock(clock), .inAddress(ALUresult), .inWriteData(dataMemWrite), .controlMemRead(controlMemRead), .controlMemWrite(controlMemWrite), .outReadData(dataMemRead)); 

endmodule

//DATAMEMORY
module dataMemory(clock, inAddress, inWriteData, controlMemRead, controlMemWrite, outReadData); 
	input clock; 
	input [63:0] inAddress; 
	input [63:0] inWriteData; 
	input controlMemRead,controlMemWrite; 
	output reg[63:0] outReadData; 
	
	reg[63:0] memory [63:0]; 
	
	//initialiasatie
	integer i; 
	initial begin 
		for(i = 0; i<64; i = i + 1) begin	
			memory[i] = 0; 
		end 
	end 
	
	//write of read 
	//als read is: in memory zoeken
	//als write is: wegschrijven in memory 
	always@(posedge clock )
	begin
		if(controlMemWrite == 1)
			begin memory[inAddress] <= inWriteData; 
		end 
	end 
	
	always@(controlMemRead or inAddress or controlMemWrite or inWriteData)
	begin 
		if(controlMemRead == 1) 
			begin outReadData<= memory[inAddress]; 
		end 
	end 
	
endmodule

