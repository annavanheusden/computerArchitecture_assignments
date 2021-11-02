//INSTRUCTION FETCH: 
module instructionFetch(clock, PCbranch, PC, instruction, controlPCnext); 
	input clock; 
	input [63:0] PCbranch; 
	input controlPCnext; 
	output [31:0] instruction; 
	output reg[63:0] PC;
 
	wire [63:0] PCadd; 
	wire[63:0] PCnext; 

	initial begin
		PC = 0; 
	end

	rom IM(.address(PC), .data_out(instruction)); 
	add PCADD(.a(PC), .b(64'd4), .out(PCadd));
	muxFetch muxPCnext(.in0(PCadd), .in1(PCbranch), .control(controlPCnext), .out(PCnext)); 

	always@(posedge clock) begin 
		PC<= PCnext; 
	end 
endmodule 

//INSTRUCTION MEMORY 
module rom(address, data_out);

	parameter words = 256; // default number of words
	parameter logwords = 9; // default max address bit (log2(words)+1)
	parameter size = 32; // default number of bits per instruction word
	parameter addr_size = 64; // default address size
	input [addr_size-1:0] address;
	output [size-1:0] data_out;
	reg [size-1:0] memory [0:words-1];
	wire [size-1:0] data_out;
	
	assign data_out = memory[address[logwords:2]];
	
	integer i;
	initial begin
		for (i = 0; i < 64
		; i = i + 1) begin
			memory[i] = 0;
		end
   	end

endmodule

//ADDER
module add(a,b,out);
	
	input [63:0] a; 
	input [63:0] b; 
	output [63:0] out;
	wire [63:0] out;
	
	assign out = a + b;
	
endmodule

//MULTIPLEXER 
module muxFetch(in0,in1,control,out);

	input[63:0] in0; 
	input[63:0] in1; 
	input control; 
	output reg[63:0] out; 
	
	always@(in0,in1,control, out) begin
		if(control == 0) begin
			out = in0; 
		end 
		else begin	
			out = in1; 
		end 
	end 

endmodule

