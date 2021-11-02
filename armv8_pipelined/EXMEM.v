module EXMEM(clock, ALUzeroIn, ALUzeroOut, ALUresultIn, ALUresultOut, writeDataIn, writeDataOut, writeRegIn, writeRegOut, 
		RegWriteIn, MemReadIn, MemWriteIn, MemToRegIn, 
		RegWriteOut, MemReadOut, MemWriteOut, MemToRegOut, 
		RdEX, RdMEM); 
	input clock; 
	input ALUzeroIn; 
	input [63:0] ALUresultIn; 
	input [63:0] writeDataIn; 
	input [4:0] writeRegIn; 
	input RegWriteIn, MemReadIn, MemWriteIn, MemToRegIn; 
	input [4:0] RdEX; 
	
	output reg ALUzeroOut; 
	output reg[63:0] ALUresultOut; 
	output reg[63:0] writeDataOut; 
	output reg[4:0] writeRegOut; 
	output reg RegWriteOut, MemReadOut, MemWriteOut,MemToRegOut; 
	output reg[4:0] RdMEM; 
	
	initial begin 
		ALUzeroOut = 1'b0; 
		ALUresultOut = 64'b0; 
		writeDataOut = 64'b0; 
		writeRegOut = 5'b0; 
		RegWriteOut = 1'b0;
		MemReadOut  = 1'b0;
		MemWriteOut  = 1'b0;
		MemToRegOut  = 1'b0;
		RdMEM  = 5'b0;
	end 

	always @(negedge clock) begin
		ALUzeroOut <= ALUzeroIn; 
		ALUresultOut <= ALUresultIn; 
		writeDataOut <= writeDataIn; 
		writeRegOut <= writeRegIn; 
		RegWriteOut <= RegWriteIn; 
		MemReadOut <= MemReadIn; 
		MemWriteOut <= MemWriteIn; 
		MemToRegOut <= MemToRegIn; 
		RdMEM <= RdEX; 
	end 
endmodule
