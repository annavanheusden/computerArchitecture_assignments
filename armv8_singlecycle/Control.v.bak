//CONTROL 
module control(clock, instruction, Reg2Loc, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, operation); 
	input clock; 
	input [63:0] instruction; 
	output Reg2Loc, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite; 
	output [3:0] operation; 
	wire [3:0] ALUOp; 

	aluControl ALUC(.aluOp(ALUOp), .instr(instruction), .operation(operation)); 
	control(.clock(clock), .instruction(instruction), .reg2loc(Reg2Loc), .branch(Branch), .memRead(MemRead), .memToReg(MemToReg), .ALUOp(ALUOp), .memWrite(MemWrite), .ALUSrc(ALUSrc), .regWrite(RegWrite));  
endmodule 

//ALU CONTROL
module aluControl(aluOp, instr, operation); 
	input[1:0] aluOp; 
	input[31:0] instr;  
	output reg[3:0] operation; 


	reg [10:0] opc; 
	integer i; 
	initial begin
		for(i = 0; i< 11; i = i+1) begin 
			opc[i] = instr [21 + i ]; 
		end
	end
	
	always@(aluOp or opc) begin 
		//LDUR en STUR 
		if(aluOp == 0)
			operation = 4'b0010; 
		// CBZ
		else if (aluOp == 1)
			operation = 4'b0111; 
			
		//R-type instruction 
		else if(aluOp == 2) 
			//als [30]=1 => 0110 sub
			if(opc[9] == 1 )
				operation = 4'b0110; 
				
			//als [29] =1 => 0001 or
			else if(opc[8] == 1)
				operation = 4'b0001; 

			//als [24]=0 => 0000 and 
			else if(opc[3] == 0 )
				operation = 4'b0000;
			
			//anders => 0010 add 
			else 
				operation = 4'b0010; 
	end 
	
endmodule 


//MAIN CONTROL UNIT
module control(clock, instruction, reg2loc,branch,memRead,memToReg,ALUOp, memWrite,ALUSrc, regWrite); 
	input clock;
	input[31:0] instruction;
	output reg reg2loc, branch, memRead,memToReg,memWrite,ALUSrc,regWrite; 
	output reg [1:0] ALUOp; 
	
	reg[10:0] control; 

	//initialisatie bij begin 
	integer i;
	initial begin 
		for ( i = 0; i < 11 ; i = i + 1) begin
			control[i] = 1'b0; 
		end 

		control[8] = reg2loc; 
		control[7] = ALUSrc; 
		control[6] = memToReg; 
		control[5] = regWrite; 
		control[4] = memRead; 
		control[3] = memWrite; 
		control[2] = branch; 
		control[1:0] = ALUOp;
	end 

	//aan de hand van [31:21] 
	reg [10:0] instr11; 
	reg[7:0] instr8; 
	reg[5:0] instr6; 
	
	
	//parameters maken van de 4 verschillende opties van control output 
	parameter R_Format_Control = 9'b000100010; 
	parameter LDUR_Control = 9'b011110000; 
	parameter STUR_Control = 9'b110001000; 
	parameter CBZ_Control = 9'b100000101; 
	//parameter CBNZ_Control = 9'b1000100001; 
	parameter B_Control = 9'b0000000101; 
	
	
	//parameters van instruction met 6 bits (B)
	parameter B_instr = 6'b000101;
	
	//parameters van instruction met 8 bits (CBZ en CBNZ) 
	parameter CBZ_instr = 8'b10110100;
	parameter CBNZ_instr = 8'b10110101;
	
	//parameters van instruction met 11 bits (LDUR en STUR en ook andere R) 
	parameter LDUR_instr = 11'b11111000010; 
	parameter STUR_instr = 11'b11111000000; 

	
	//nu gaan we kijken welk type instruction het is en aan de hand daarvan de output doorgeven
	//VERSCHILLENDE TYPES: R-format, LDUR, STUR, CBZ 
	always@(posedge clock, instruction) begin
		instr11 = instruction[31:21]; 
		instr8 = instruction[31:24]; 
		if(instr6 == instruction[31:26])
			control = B_Control; 
		else if(instr8 == CBZ_instr ) 	
			control = CBZ_Control; 
		else if(instr11 == LDUR_instr) 
			control = LDUR_Control; 
		else if(instr11 == STUR_instr)
			control = STUR_Control; 
		else 
			control = R_Format_Control; 
	end
	
endmodule
	
		
	