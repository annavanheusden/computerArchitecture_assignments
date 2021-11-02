//EXECUTE
module execute(signExtended, readData1, readData2, PC, PCbranch, ALUzero, ALUresult, writeData, control_ALUsrc, ALUoperation); 
	input[63:0] signExtended, readData1, readData2, PC;
	input[3:0] ALUoperation; 
	input control_ALUsrc; 
	output[63:0] PCbranch, ALUresult, writeData;
	output ALUzero; 
	wire[63:0] shifted, ALUin; 

	assign writeData = readData2; 

	shiftLeft2 shiftLeft(.inputInstr(signExtended), .outputInstr(shifted)); 
	add addPCbranch(.a(shifted), .b(PC), .out(PCbranch)); 
	mux muxALUsrc(.in0(readData2), .in1(signExtended), .control(control_ALUsrc), .out(ALUin)); 
	ALU alu(.a(readData1), .b(ALUin), .operation(ALUoperation), .out(ALUresult), .zero(ALUzero)); 
endmodule 

//SHIFT LEFT 2
module shiftLeft2(inputInstr, outputInstr); 
	input[63:0] inputInstr; 
	output reg[63:0] outputInstr; 
	
	always@(inputInstr) begin
		outputInstr = inputInstr <<2; 
	end 
endmodule

//ADDER voor PC 
module add(a,b,out);
	
	input [63:0] a, b;
	output [63:0] out;
	wire [63:0] out;
	
	assign out = a + b;
	
endmodule

//MUX
module mux(in0,in1,control,out);

	input[63:0] in0,in1;
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

//ALU 
module ALU(a, b, operation, out, zero);

	input [63:0] a, b;
	input [3:0] operation;
	output zero;
	output [63:0] out;
	reg [63:0] out;
	reg zero;

	always @(a or b or operation) begin
		case (operation) // see P&H page 271
			4'b0000 : out = a & b; // and
			4'b0001 : out = a | b; // or
			4'b0010 : out = a + b; // add
			4'b0110 : out = a - b; // subtract
			4'b0111 : out = b; // pass input b
			4'b1100 : out = !(a | b); // nor
			default : out = 0; // WARNING: Raise EXEPTION for default case!!!
		endcase
		zero = (out == 32'b0);
	end
endmodule
