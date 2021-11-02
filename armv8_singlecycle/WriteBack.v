//WRITE BACK 
module writeBack( dataMemRead, dataAddress, controlMemToReg, writeBack); 
	input[63:0] dataMemRead; 
	input [63:0]dataAddress; 
	input controlMemToReg; 
	output [63:0] writeBack; 
	
	muxWb muxWriteBack(.in0(dataAddress), .in1(dataMemRead), .control(controlMemToReg), .out(writeBack)); 
endmodule 

//MUX 
module muxWb(in0,in1,control,out);

	input[63:0] in0; 
	input [63:0] in1; 
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
