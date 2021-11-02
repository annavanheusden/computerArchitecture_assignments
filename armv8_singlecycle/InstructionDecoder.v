//INSTRUCTION DECODER
module instructionDecoder(clock, instruction, controlRegWrite, controlReg2Loc, signExtendOut, readData1, readData2, writeData); 
	input clock;
	input [31:0] instruction; 
	input [63:0] writeData; 
	input controlRegWrite, controlReg2Loc; 
	output [63:0] signExtendOut; 
	output[63:0] readData1; 
	output[63:0] readData2;
	wire [4:0] readRegister2; 

	registers registers(.clock(clock),.inputRead1(instruction[9:5]), .inputRead2(readRegister2), .inputWriteReg(instruction[4:0]), .inputWriteData(writeData), .outputData1(readData1), .outputData2(readData2),.controlRegWrite(controlRegWrite));
	signExtend signExtend(.in(instruction), .out(signExtendOut)); 
	muxDecoder muxReg2Loc(.in0(instruction[20:16]), .in1(instruction[4:0]), .control(controlReg2Loc), .out(readRegister2)); 
endmodule

//REGISTERS 
module registers(clock, inputRead1, inputRead2, inputWriteReg, inputWriteData, outputData1, outputData2, controlRegWrite); 
	input clock; 
	input[4:0] inputRead1; 
	input[4:0] inputRead2; 
	input[4:0] inputWriteReg; 
	input [63:0] inputWriteData; 
	input controlRegWrite; 
	output[63:0] outputData1;
	output[63:0] outputData2; 
	reg[63:0] memory [63:0]; 

	assign outputData1 = memory[inputRead1];
	assign outputData2 = memory[inputRead2];
	
	//innitialisatie van register file 
	integer i;
	initial begin
		for(i=0; i < 64; i = i + 1) begin	
			memory[i] = 0; 
		end 
	end 
	
	//bij rising edge: data wegschrijven 
	always @(posedge clock) begin
		if (controlRegWrite) begin	
			memory[inputWriteReg] = inputWriteData; 
		end 
	end
	
endmodule


//SIGNEXTEND 
module signExtend(in, out); 
	input [31:0] in; 
	output reg[63:0] out; 
	
	always @(in) begin
		//afhankelijk van welk type instructie: CBZ, CBNZ, B, D (LDUR/STUR)
		
		//B opcode van 31:26 => address van 25:0 
		if(in[31:26] == 6'b000101) begin
			//tekenbit wordt opgeschoven naar links 
			out[25:0] = in[25:0] ; 
			out[63:26] = {38{out[25]}};  

		//19-bit offset 
		//CBNZ 
		end else if (in[31:24] == 8'b10110101) begin
			out[18:0] = in[23:5]; 
			out[63:19] = {45{in[23]}};  
		end else if (in[31:24] == 8'b10110100) begin 	//CBZ 
			out[18:0] = in[23:5]; 
			out[63:19] = {45{in[23]}}; 
		end else begin
		//laatste optie: 9-bit offset  
			out[8:0] = in[20:12]; 
			out[63:9] = {55{in[20]}}; 
		end
	end
	
endmodule

//MUX REG2LOC 
module muxDecoder(in0,in1,control,out);

	input[4:0] in0; 
	input[4:0] in1;
	input control; 
	output reg[4:0] out; 
	
	always@(in0,in1,control, out) begin
		if(control == 0) begin
			out = in0; 
		end 
		else begin	
			out = in1; 
		end 
	end 
endmodule 
