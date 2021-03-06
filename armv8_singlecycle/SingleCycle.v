//CPU Single Cycle 
module SingleCycle(clock); 
	input clock; 
	//wires voor control signaal 
	wire Reg2Loc; 
	wire RegWrite; 
	wire MemRead; 
	wire MemWrite; 
	wire Branch; 
	wire MemtoReg; 
	wire AluSrc; 
	wire UnCondBranch; 
	wire controlPCnext; 
	wire branching; 	
	wire ALUzero; 
	wire [3:0] ALUop; 

	wire [63:0] PC; 
	wire [63:0] PCbranch;
	wire [63:0] DataAddress; 
	wire [31:0] instruction; 
	wire [63:0] RegData1; 
	wire [63:0] RegData2; 
	wire [63:0] signExtended; 
	wire [63:0] ALUresult; 
	wire [63:0] DataMemWrite; 
	wire [63:0] DataMemRead; 
	wire [63:0] writeBack; 

	//AND en OR poort voor branching en PC
	assign branching = Branch & ALUzero; 
	assign controlPCnext = UnCondBranch | branching; 	

	//verschillende fases linken
	instructionFetch IF(.clock(clock), .PCbranch(PCbranch), .PC(PC), .instruction(instruction), .controlPCnext(controlPCnext)); 
	instructionDecoder ID(.clock(clock), .instruction(instruction), .controlRegWrite(RegWrite), .controlReg2Loc(Reg2Loc), .signExtendOut(signExtended), .readData1(RegData1), .readData2(RegData2), .writeData(writeBack));
	execute EX(.signExtended(signExtended), .readData1(RegData1), .readData2(RegData2), .PC(PC), .PCbranch(PCbranch), .ALUzero(ALUzero), .ALUresult(ALUresult), .writeData(writeBack), .control_ALUsrc(AluSrc), .ALUoperation(ALUop)); 
	memoryAccess MEM(.clock(clock), .ALUresult(ALUresult), .dataMemWrite(DataMemWrite), .dataMemRead(DataMemRead), .controlMemWrite(MemWrite), .controlMemRead(MemRead), .dataAddress(DataAddress)); 
	writeBack WB(.dataMemRead(DataMemRead), .dataAddress(DataAddress), .controlMemToReg(MemtoReg), .writeBack(writeBack)); 
	control control(.clock(clock), .instruction(instruction), .Reg2Loc(Reg2Loc), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(AluSrc), .RegWrite(RegWrite), .operation(ALUop)); 

endmodule


	
	

