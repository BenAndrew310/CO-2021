module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signals
wire 	[32-1:0] 	pc_in_i;
wire 	[32-1:0] 	pc_out_o;
wire 	[32-1:0] 	four_sig;
wire 	[32-1:0] 	instr_o, pipeID_instr_o;

wire 	[5-1:0]		pipeEX_instr_2016;
wire 	[5-1:0]		pipeEX_instr_1511;
wire 	[5-1:0]		pipeEX_instr_1006;
wire 	[6-1:0]		pipeEX_instr_0500;

wire 	[5-1:0] 	RDaddr, pipeMEM_RDaddr, pipeWB_RDaddr;//RDaddr_j;
wire 	[32-1:0] 	RSdata, pipeEX_RSdata;
wire 	[32-1:0] 	RTdata, pipeEX_RTdata, pipeMEM_RTdata;

wire 	[4-1:0] 	ALU_operation_o;
wire 	[2-1:0] 	FURslt_o;

wire 	[32-1:0]	sign_extended, pipeEX_SE;
wire 	[32-1:0]	zero_filled, pipeEX_ZF;

wire 			leftright;
wire 	[32-1:0]	shifter_result;
wire 	[32-1:0]	RDdata, RDdata_j;

// wire 	[28-1:0]	jump_addr_28;
wire 	[32-1:0]	adder2_src2;
wire 	[32-1:0]	adder1_o, pipeID_adder1_o, pipeEX_adder1_o;
wire 	[32-1:0]	adder2_o, pipeMEM_adder2_o;

wire 			from_zero, pipeMEM_from_zero;
wire 			PCSrc;
// wire 	[32-1:0]	pcsrc_o;

// ALU Signals
wire 	[32-1:0]	aluSrc1, aluSrc2, final_aluSrc2;
wire 	[32-1:0]	result;
wire 			zero, overflow;

// Decoder Signals
wire 			RegDst, pipeEX_RegDst;
wire 			RegWrite, pipeEX_RegWrite, pipeMEM_RegWrite, pipeWB_RegWrite;
wire 	[3-1:0] 	ALUOp, pipeEX_ALUOp;
wire 			ALUSrc, pipeEX_ALUSrc;
wire 			Branch, pipeEX_Branch, pipeMEM_Branch;
wire 	[2-1:0]		BranchType, pipeEX_BranchType;
// wire 			Jump;
wire 			MemRead, pipeEX_MemRead, pipeMEM_MemRead;
wire 			MemWrite, pipeEX_MemWrite, pipeMEM_MemWrite;
wire 			MemtoReg, pipeEX_MemtoReg, pipeMEM_MemtoReg, pipeWB_MemtoReg;


// Data Memory Signals
wire 	[32-1:0] DM_addr_i, pipeMEM_DM_addr_i, pipeWB_DM_addr_i;
wire 	[32-1:0] DM_data_i;
wire 	[32-1:0] DM_data_o, pipeWB_DM_data_o;


assign four_sig = 33'd4;
assign aluSrc1 = pipeEX_RSdata;
assign leftright = (pipeEX_instr_0500==6'b000_000) ? 1'b1 : 1'b0;

//modules
Program_Counter PC(
        .clk_i(clk_i),      
	.rst_n(rst_n),     
	.pc_in_i(pc_in_i),   
	.pc_out_o(pc_out_o) 
	);

Adder Adder1(
        .src1_i(pc_out_o),     
	.src2_i(four_sig),
	.sum_o(adder1_o)    
	);



Instr_Memory IM(
        .pc_addr_i(pc_out_o),  
	.instr_o(instr_o)    
	);

PIPELINE_IFID pipe_ifid(
	.clk_i(clk_i),
	.rst_n(rst_n),
	.DATA_pc_i(adder1_o),
	.DATA_instr_i(instr_o),
	.DATA_pc_o(pipeID_adder1_o),
	.DATA_instr_o(pipeID_instr_o)
	);

// Shift_Left_Two #(.size_i(26), .size_o(28)) SL2_1(
// 	.data_i(instr_o[25:0]),
// 	.data_o(jump_addr_28)
// 	);

Mux2to1 #(.size(32)) PC_src(
	.data0_i(adder1_o),
        .data1_i(pipeMEM_adder2_o),
        .select_i(PCSrc),
        .data_o(pc_in_i)
        // .data_o(pcsrc_o)
	);

// Mux2to1 #(.size(32)) JumpSelect(
// 	.data1_i({adder1_o[31:28], jump_addr_28}),
// 	.data0_i(pcsrc_o),
// 	.select_i(Jump),
// 	.data_o(pc_in_i)
// 	);


// assign RDaddr_j = (pipeID_instr_o[31:26]==6'b000011) ? 5'b11111 : RDaddr; // reg[31]
// assign RDdata_j = (pipeID_instr_o[31:26]==6'b000011) ? adder1_o : RDdata; // set PC+4 to reg[31]

Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n) ,     
        .RSaddr_i(pipeID_instr_o[25:21]),  
        .RTaddr_i(pipeID_instr_o[20:16]),  
        .Wrtaddr_i(pipeWB_RDaddr),  
        .Wrtdata_i(RDdata), 
        .RegWrite_i(pipeWB_RegWrite),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata)
        );

Decoder Decoder(
        .instr_op_i(pipeID_instr_o[31:26]), 
	.RegWrite_o(RegWrite), 
	.ALUOp_o(ALUOp),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),
	.Branch_o(Branch),
	.branchType_o(BranchType),
	// .Jump_o(Jump),
	.MemRead_o(MemRead),
	.MemWrite_o(MemWrite),
	.MemtoReg_o(MemtoReg)   
	);

Sign_Extend SE(
        .data_i(pipeID_instr_o[15:0]),
        .data_o(sign_extended)
        );

Zero_Filled ZF(
        .data_i(pipeID_instr_o[15:0]),
        .data_o(zero_filled)
        );

PIPELINE_IDEX pipe_idex(
	.clk_i(clk_i),
	.rst_n(rst_n),
	.CTRL_ALUOp_i(ALUOp),
	.CTRL_ALUSrc_i(ALUSrc),
	.CTRL_RegWrite_i(RegWrite),
	.CTRL_RegDst_i(RegDst),
	.CTRL_Branch_i(Branch),
	.CTRL_BranchType_i(BranchType),
	.CTRL_MemRead_i(MemRead),
	.CTRL_MemWrite_i(MemWrite),
	.CTRL_MemtoReg_i(MemtoReg),
	.DATA_pc_i(pipeID_adder1_o),
	.DATA_ReadData1_i(RSdata),
	.DATA_ReadData2_i(RTdata),
	.DATA_SE_i(sign_extended),
	.DATA_ZF_i(zero_filled),
	.DATA_instr_2016_i(pipeID_instr_o[20:16]),
	.DATA_instr_1511_i(pipeID_instr_o[15:11]),
	.DATA_instr_0500_i(pipeID_instr_o[5:0]),
	.DATA_instr_1006_i(pipeID_instr_o[10:6]),
	.CTRL_ALUOp_o(pipeEX_ALUOp),
	.CTRL_ALUSrc_o(pipeEX_ALUSrc),
	.CTRL_RegWrite_o(pipeEX_RegWrite),
	.CTRL_RegDst_o(pipeEX_RegDst),
	.CTRL_Branch_o(pipeEX_Branch),
	.CTRL_BranchType_o(pipeEX_BranchType),
	.CTRL_MemRead_o(pipeEX_MemRead),
	.CTRL_MemWrite_o(pipeEX_MemWrite),
	.CTRL_MemtoReg_o(pipeEX_MemtoReg),
	.DATA_pc_o(pipeEX_adder1_o),
	.DATA_ReadData1_o(pipeEX_RSdata),
	.DATA_ReadData2_o(pipeEX_RTdata),
	.DATA_SE_o(pipeEX_SE),
	.DATA_ZF_o(pipeEX_ZF),
	.DATA_instr_2016_o(pipeEX_instr_2016),
	.DATA_instr_1511_o(pipeEX_instr_1511),
	.DATA_instr_0500_o(pipeEX_instr_0500),
	.DATA_instr_1006_o(pipeEX_instr_1006)
	);

Shift_Left_Two SL2_2(
	.data_i(pipeEX_SE),
	.data_o(adder2_src2)
	);

Adder Adder2(
	.src1_i(pipeEX_adder1_o),
	.src2_i(adder2_src2),
	.sum_o(adder2_o)
	);

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(pipeEX_instr_2016),
        .data1_i(pipeEX_instr_1511),
        .select_i(pipeEX_RegDst),
        .data_o(RDaddr)
        );

ALU_Ctrl AC(
        .funct_i(pipeEX_instr_0500),   
        .ALUOp_i(pipeEX_ALUOp),   
        .ALU_operation_o(ALU_operation_o),
	.FURslt_o(FURslt_o)
        );

	
Mux2to1 #(.size(32)) ALU_src2(
        .data0_i(pipeEX_RTdata),
        .data1_i(pipeEX_SE),
        .select_i(pipeEX_ALUSrc),
        .data_o(aluSrc2)
        );	

// assign final_aluSrc2 = (instr_o[31:26]==6'b001100 || instr_o[31:26]==6'b001101) ? {32{1'b0}} : aluSrc2;

ALU ALU(
	.aluSrc1(aluSrc1),
	.aluSrc2(aluSrc2),
	.ALU_operation_i(ALU_operation_o),
	.result(result),
	.zero(zero),
	.overflow(overflow)
	);
	
Shifter shifter( 
	.result(shifter_result), 
	.leftRight(leftright),
	.shamt(pipeEX_instr_1006),
	.sftSrc(aluSrc2) 
	);

Mux3to1 #(.size(32)) DM_Source(
        .data0_i(result),
        .data1_i(shifter_result),
	.data2_i(pipeEX_ZF),
        .select_i(FURslt_o),
        .data_o(DM_addr_i)
        );

assign from_zero = (pipeEX_BranchType==2'b00) ? zero :              // beq
		(pipeEX_BranchType==2'b01) ? ~zero :                // bne, bnez
		(pipeEX_BranchType==2'b10) ? result[31] :           // blt
		(pipeEX_BranchType==2'b11) ? (zero | ~result[31]) : // bgez
		1'b0;
		
PIPELINE_EXMEM pipe_exmem(
	.clk_i(clk_i),
	.rst_n(rst_n),
	.CTRL_MemRead_i(pipeEX_MemRead),
	.CTRL_MemWrite_i(pipeEX_MemWrite),
	.CTRL_MemtoReg_i(pipeEX_MemtoReg),
	.CTRL_RegWrite_i(pipeEX_RegWrite),
	.CTRL_Branch_i(pipeEX_Branch),
	.CTRL_zero_i(from_zero),
	.DATA_pc_i(adder2_o),
	.DATA_DM_ADDR_i(DM_addr_i),
	.DATA_DM_WriteData_i(pipeEX_RTdata),
	.DATA_RF_WriteReg_i(RDaddr),
	.CTRL_MemRead_o(pipeMEM_MemRead),
	.CTRL_MemWrite_o(pipeMEM_MemWrite),
	.CTRL_MemtoReg_o(pipeMEM_MemtoReg),
	.CTRL_RegWrite_o(pipeMEM_RegWrite),
	.CTRL_Branch_o(pipeMEM_Branch),
	.CTRL_zero_o(pipeMEM_from_zero),
	.DATA_pc_o(pipeMEM_adder2_o),
	.DATA_DM_ADDR_o(pipeMEM_DM_addr_i),
	.DATA_DM_WriteData_o(pipeMEM_RTdata),
	.DATA_RF_WriteReg_o(pipeMEM_RDaddr)
	);

assign PCSrc = (pipeMEM_Branch && pipeMEM_from_zero);
assign DM_data_i = pipeMEM_RTdata;

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(pipeMEM_DM_addr_i),
	.data_i(DM_data_i),
	.MemRead_i(pipeMEM_MemRead),
	.MemWrite_i(pipeMEM_MemWrite),
	.data_o(DM_data_o)
	);

PIPELINE_MEMWB pipe_memwb(
	.clk_i(clk_i),
	.rst_n(rst_n),
	.CTRL_RegWrite_i(pipeMEM_RegWrite),
	.CTRL_MemtoReg_i(pipeMEM_MemtoReg),
	.DATA_DM_ReadData_i(DM_data_o),
	.DATA_DM_ADDR_i(pipeMEM_DM_addr_i),
	.DATA_RF_WriteReg_i(pipeMEM_RDaddr),
	.CTRL_RegWrite_o(pipeWB_RegWrite),
	.CTRL_MemtoReg_o(pipeWB_MemtoReg),
	.DATA_DM_ReadData_o(pipeWB_DM_data_o),
	.DATA_DM_ADDR_o(pipeWB_DM_addr_i),
	.DATA_RF_WriteReg_o(pipeWB_RDaddr)
	);

Mux2to1 #(.size(32)) RDdata_Source(
	.data1_i(pipeWB_DM_data_o),
	.data0_i(pipeWB_DM_addr_i),
	.select_i(pipeWB_MemtoReg),
	.data_o(RDdata)
	);	

endmodule