module datapath(clock) ;
	input clock; 
	//wires voor control signaal van control naar IDEX
	wire RegWriteControlIDEX; 
	wire MemReadControlIDEX; 
	wire MemWriteControlIDEX; 
	wire BranchControlIDEX; 
	wire MemtoRegControlIDEX; 
	wire AluSrcControlIDEX; 
	wire UnCondBranchControlIDEX; 
	wire [3:0] ALUopControlIDEX; 
	//wires voor controlsignaal van IDEX naar EXMEM
	wire RegWriteIDEX_EXMEM; 
	wire MemReadIDEX_EXMEM; 
	wire MemWriteIDEX_EXMEM; 
	wire MemtoRegIDEX_EXMEM; 
	wire AluSrcIDEX_EX; 
	wire [3:0] ALUopIDEX_EX; 
	wire [4:0] writeRegIDEX_EXMEM; 
	//wires voor controlsignaal van EXMEM naar MEM(WB)
	wire RegWriteEXMEM_MEMWB; 
	wire MemtoRegEXMEM_MEMWB;  
	wire [4:0] writeRegEXMEM_MEMWB; 
	//MemToReg en RegWrite en writeReg wires van MEMWB pipeline register naar WB en ID 
	wire MemtoRegMEMWB_WB; 
	wire RegWriteMEMWB_ID; 
	wire [4:0] writeRegMEMWB_ID; 

	
	wire [31:0] instructionIF_IFID; 
	wire [31:0] instructionIFID_ID; 
	
	wire [63:0] PC_IF_IFID;
	wire [63:0] PC_IFID_IDEX; 
	wire PCSrc_MEM_IF; 
	
	wire [63:0] RegData1;
	wire [63:0] RegData1IDEX;
	wire [63:0] RegData2;
	wire [63:0] RegData2IDEX;
	wire [63:0] signExtended; 
	wire [63:0] signExtendedIDEX; 
	wire [63:0] ALUresult; 
	wire [63:0] ALUresultEXMEM;
	wire [63:0] DataMemWrite; 
	wire [63:0] DataMemWriteEXMEM;
	wire [63:0] DataMemRead; 
	wire [63:0] DataMemReadMEMWB;
	wire [63:0] DataAddress; 
	wire [63:0] DataAddressMEMWB;
	wire [63:0] writeBack; 
	wire ALUzeroEX_EXMEM; 
	wire ALUzeroEXMEM_MEM; 

	wire [63:0] addEXMEM_ID; 
	
	//FORWARDING
	wire [4:0] rmEX; 
	wire [4:0] rnEX; 
	wire [4:0] rdEX; 
	wire [4:0] rdMEM;
	wire [4:0] rdWB; 
	wire [1:0] forwardA; 
	wire [1:0] forwardB; 
	
	//HAZARD DETECTION 
	wire [4:0] rmID; 
	assign rmID = instructionIFID_ID[20:16]; 
	wire [4:0] rnID; 
	assign rnID = instructionIFID_ID[9:5]; 
	wire IFIDwrite; 
	wire PCwrite; 
	wire muxSelectHDU; 
	
	//CONTROL HAZARD
	wire flush;
	
	wire zeroOut; 
	
	assign zeroBranch = zeroOut & BranchControlIDEX; 
	assign PCSrc_MEM_IF = zeroBranch || UnCondBranchControlIDEX; 
	

	//verschillende fases linken
	instructionFetch IF(.clock(clock),
				.PCbranch(addEXMEM_ID),
				.PC(PC_IF_IFID), 
				.instruction(instructionIF_IFID), 
				.controlPCnext(PCSrc_MEM_IF),
				.PCwrite(PCwrite)); 

	IFID IFID(.clock(clock),
		.PCin(PC_IF_IFID), 
		.PCout(PC_IFID_IDEX), 
		.instructIn(instructionIF_IFID), 
		.instructOut(instructionIFID_ID),
		.IFIDwrite(IFIDwrite),
		.flush(flush));

	instructionDecoder ID(.clock(clock), 
		.instruction(instructionIFID_ID), 
		.controlRegWrite(RegWriteMEMWB_ID), 
		.signExtendOut(signExtended), 
		.readData1(RegData1), 
		.readData2(RegData2), 
		.writeData(writeBack), 
		.writeRegIN(writeRegMEMWB_ID),
		.zeroOut(zeroOut), 
		.PC(PC_IFID_IDEX),
		.PCbranch(addEXMEM_ID)); 

	IDEX IDEX(.clock(clock), 
		.readData1In(RegData1),
		.readData1Out(RegData1IDEX),
		.readData2In(RegData2), 
		.readData2Out(RegData2IDEX), 
		.signExtendIn(signExtended), 
		.signExtendOut(signExtendedIDEX), 
		.writeRegIn(instructionIFID_ID[4:0]), 
		.writeRegOut(writeRegIDEX_EXMEM),
		.RegWriteIn(RegWriteControlIDEX), 
		.MemReadIn(MemReadControlIDEX),
		.MemToRegIn(MemtoRegControlIDEX), 
		.MemWriteIn(MemWriteControlIDEX),
		.AluSrcIn(AluSrcControlIDEX),
		.ALUOpIn(ALUopControlIDEX),
		.RegWriteOut(RegWriteIDEX_EXMEM), 
		.MemReadOut(MemReadIDEX_EXMEM), 
		.MemToRegOut(MemtoRegIDEX_EXMEM), 
		.MemWriteOut(MemWriteIDEX_EXMEM), 
		.AluSrcOut(AluSrcIDEX_EX), 
		.ALUOpOut(ALUopIDEX_EX),
		.instruct(instructionIFID_ID),
		.Rn(rnEX),
		.Rm(rmEX), 
		.Rd(rdEX)); 

	execute EX(.signExtended(signExtendedIDEX), 
		.readData1(RegData1IDEX), 
		.readData2(RegData2IDEX), 
		.ALUzero(ALUzeroEX_EXMEM), 
		.ALUresult(ALUresult), 
		.writeData(DataMemWrite), 
		.control_ALUsrc(AluSrcIDEX_EX), 
		.ALUoperation(ALUopIDEX_EX), 
		.forwardA(forwardA), 
		.forwardB(forwardB), 
		.writeBack(writeBack));

	EXMEM EXMEM(.clock(clock), 
		.ALUzeroIn(ALUzeroEX_EXMEM), 
		.ALUzeroOut(ALUzeroEXMEM_MEM), 
		.ALUresultIn(ALUresult), 
		.ALUresultOut(ALUresultEXMEM), 
		.writeDataIn(DataMemWrite), 
		.writeDataOut(DataMemWriteEXMEM), 
		.writeRegIn(writeRegIDEX_EXMEM), 
		.writeRegOut(writeRegEXMEM_MEMWB), 
		.RegWriteIn(RegWriteIDEX_EXMEM), 
		.MemReadIn(MemReadIDEX_EXMEM), 
		.MemWriteIn(MemWriteIDEX_EXMEM), 
		.MemToRegIn(MemtoRegIDEX_EXMEM), 
		.RegWriteOut(RegWriteEXMEM_MEMWB), 
		.MemReadOut(MemReadEXMEM_MEMWB), 
		.MemWriteOut(MemWriteEXMEM_MEMWB), 
		.MemToRegOut(MemtoRegEXMEM_MEMWB),
		.RdEX(rdEX), 
		.RdMEM(rdMEM)); 
 
	memoryAccess MEM(.clock(clock), 
		.ALUresult(ALUresultEXMEM), 
		.dataMemWrite(DataMemWriteEXMEM), 
		.dataMemRead(DataMemRead), 
		.controlMemWrite(MemWriteEXMEM_MEMWB), 
		.controlMemRead(MemReadEXMEM_MEMWB), 
		.dataAddress(DataAddress)); 

	MEMWB MEMWB (.clock(clock), 
		.dataMemReadIn(DataMemRead), 
		.dataMemReadOut(DataMemReadMEMWB), 
		.dataAddressIn(DataAddress), 
		.dataAddressOut(DataAddressMEMWB), 
		.writeRegIn(writeRegEXMEM_MEMWB), 
		.writeRegOut(writeRegMEMWB_ID), 
		.MemToRegIn(MemtoRegEXMEM_MEMWB), 
		.RegWriteIn(RegWriteEXMEM_MEMWB), 
		.MemToRegOut(MemtoRegMEMWB_WB), 
		.RegWriteOut(RegWriteMEMWB_ID),
		.RdMEM(rdMEM), 
		.RdWB(rdWB)); 

	writeBack WB(.dataMemRead(DataMemReadMEMWB), 
		.dataAddress(DataAddressMEMWB), 
		.controlMemToReg(MemtoRegMEMWB_WB), 
		.writeBack(writeBack)); 

	control control(.instruction(instructionIFID_ID), 
		.Branch(BranchControlIDEX), 
		.MemRead(MemReadControlIDEX), 
		.MemtoReg(MemtoRegControlIDEX), 
		.MemWrite(MemWriteControlIDEX), 
		.ALUSrc(AluSrcControlIDEX), 
		.RegWrite(RegWriteControlIDEX), 
		.UnCondBranch(UnCondBranchControlIDEX),
		.operation(ALUopControlIDEX), 
		.select(muxSelectHDU),
		.flush(flush)); 

	forwardingUnit FU(.rnEX(rnEX), 
		.rmEX(rmEX), 
		.rdMEM(rdMEM), 
		.rdWB(rdWB), 
		.regWriteMEM(RegWriteEXMEM_MEMWB),
		.regWriteWB(RegWriteMEMWB_ID), 
		.forwardA(forwardA), 
		.forwardB(forwardB)); 
		
	hazardDetectionUnit HZU(.IFIDregisterRn(rnID),
		.IFIDregisterRm(rmID),
		.IDEXregisterRd(rdEX),
		.IDEXMemRead(MemReadIDEX_EXMEM), 
		.PCwrite(PCwrite),
		.IFIDwrite(IFIDwrite), 
		.muxSelect(muxSelectHDU));
		

endmodule




























