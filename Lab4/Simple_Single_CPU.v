module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signals
wire 	[32-1:0] 	pc_in_i;
wire 	[32-1:0] 	pc_out_o;
wire 	[32-1:0] 	four_sig;
wire 	[32-1:0] 	instr_o;

wire 	[5-1:0] 	RDaddr, RDaddr_j;
wire 	[32-1:0] 	RSdata;
wire 	[32-1:0] 	RTdata;

wire 	[4-1:0] 	ALU_operation_o;
wire 	[2-1:0] 	FURslt_o;

wire 	[32-1:0]	sign_extended;
wire 	[32-1:0]	zero_filled;

wire 			leftright;
wire 	[32-1:0]	shifter_result;
wire 	[32-1:0]	RDdata, RDdata_j;

wire 	[28-1:0]	jump_addr_28;
wire 	[32-1:0]	adder2_src2;
wire 	[32-1:0]	adder1_o;
wire 	[32-1:0]	adder2_o;

wire 			from_zero;
wire 			PCSrc;
wire 	[32-1:0]	pcsrc_o;

// ALU Signals
wire 	[32-1:0]	aluSrc1, aluSrc2, final_aluSrc2;
wire 	[32-1:0]	result;
wire 			zero, overflow;

// Decoder Signals
wire 			RegDst;
wire 			RegWrite;
wire 	[3-1:0] 	ALUOp;
wire 			ALUSrc;
wire 			Branch;
wire 	[2-1:0]		BranchType;
wire 			Jump;
wire 			MemRead;
wire 			MemWrite;
wire 			MemtoReg;


// Data Memory Signals
wire 	[32-1:0] DM_addr_i;
wire 	[32-1:0] DM_data_i;
wire 	[32-1:0] DM_data_o;


assign four_sig = 33'd4;
assign aluSrc1 = RSdata;
assign leftright = (instr_o[5:0]==6'b000_000) ? 1'b1 : 1'b0;

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

Adder Adder2(
	.src1_i(adder1_o),
	.src2_i(adder2_src2),
	.sum_o(adder2_o)
	);

Instr_Memory IM(
        .pc_addr_i(pc_out_o),  
	.instr_o(instr_o)    
	);

Shift_Left_Two #(.size_i(26), .size_o(28)) SL2_1(
	.data_i(instr_o[25:0]),
	.data_o(jump_addr_28)
	);

Shift_Left_Two SL2_2(
	.data_i(sign_extended),
	.data_o(adder2_src2)
	);

assign PCSrc = (Branch && from_zero);
assign from_zero = (BranchType==2'b00) ? zero :              // beq
		(BranchType==2'b01) ? ~zero :                // bne, bnez
		(BranchType==2'b10) ? result[31] :           // blt
		(BranchType==2'b11) ? (zero | ~result[31]) : // bgez
		1'b0;

Mux2to1 #(.size(32)) PC_src(
	.data0_i(adder1_o),
        .data1_i(adder2_o),
        .select_i(PCSrc),
        .data_o(pcsrc_o)
	);

Mux2to1 #(.size(32)) JumpSelect(
	.data1_i({adder1_o[31:28], jump_addr_28}),
	.data0_i(pcsrc_o),
	.select_i(Jump),
	.data_o(pc_in_i)
	);

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst),
        .data_o(RDaddr)
        );	

assign RDaddr_j = (instr_o[31:26]==6'b000011) ? 5'b11111 : RDaddr; // reg[31]
assign RDdata_j = (instr_o[31:26]==6'b000011) ? adder1_o : RDdata; // set PC+4 to reg[31]
	
Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n) ,     
        .RSaddr_i(instr_o[25:21]),  
        .RTaddr_i(instr_o[20:16]),  
        .RDaddr_i(RDaddr_j),  
        .RDdata_i(RDdata_j), 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata)
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	.RegWrite_o(RegWrite), 
	.ALUOp_o(ALUOp),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),
	.Branch_o(Branch),
	.branchType_o(BranchType),
	.Jump_o(Jump),
	.MemRead_o(MemRead),
	.MemWrite_o(MemWrite),
	.MemtoReg_o(MemtoReg)   
	);

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALU_operation_o(ALU_operation_o),
	.FURslt_o(FURslt_o)
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(sign_extended)
        );

Zero_Filled ZF(
        .data_i(instr_o[15:0]),
        .data_o(zero_filled)
        );
		
Mux2to1 #(.size(32)) ALU_src2(
        .data0_i(RTdata),
        .data1_i(sign_extended),
        .select_i(ALUSrc),
        .data_o(aluSrc2)
        );	

assign final_aluSrc2 = (instr_o[31:26]==6'b001100 || instr_o[31:26]==6'b001101) ? {32{1'b0}} : aluSrc2;
	
ALU ALU(
	.aluSrc1(aluSrc1),
	.aluSrc2(final_aluSrc2),
	.ALU_operation_i(ALU_operation_o),
	.result(result),
	.zero(zero),
	.overflow(overflow)
	);
		
Shifter shifter( 
	.result(shifter_result), 
	.leftRight(leftright),
	.shamt(instr_o[10:6]),
	.sftSrc(aluSrc2) 
	);

	
Mux3to1 #(.size(32)) DM_Source(
        .data0_i(result),
        .data1_i(shifter_result),
	.data2_i(zero_filled),
        .select_i(FURslt_o),
        .data_o(DM_addr_i)
        );

assign DM_data_i = RTdata;

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(DM_addr_i),
	.data_i(DM_data_i),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(DM_data_o)
	);

Mux2to1 #(.size(32)) RDdata_Source(
	.data1_i(DM_data_o),
	.data0_i(DM_addr_i),
	.select_i(MemtoReg),
	.data_o(RDdata)
	);	

endmodule



