module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signals
wire 	[32-1:0] 	pc_in_i;
wire 	[32-1:0] 	pc_out_o;
wire 	[32-1:0] 	four_sig;
wire 	[32-1:0] 	instr_o;

wire 	[5-1:0] 	RDaddr;
wire 	[32-1:0] 	RSdata;
wire 	[32-1:0] 	RTdata;

wire 	[4-1:0] 	ALU_operation_o;
wire 	[2-1:0] 	FURslt_o;

wire 	[32-1:0]	sign_extended;
wire 	[32-1:0]	zero_filled;

wire 	leftright;
wire 	[32-1:0]	shifter_result;

wire 	[32-1:0]	RDdata;

// ALU Signals
wire 	[32-1:0]	aluSrc1, aluSrc2;
wire 	[32-1:0]	result;
wire 	zero, overflow;

// Decoder Signals
wire RegDst;
wire RegWrite;
wire [3-1:0] ALUOp;
wire ALUSrc;

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
	    .sum_o(pc_in_i)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out_o),  
	    .instr_o(instr_o)    
	    );

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst),
        .data_o(RDaddr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(RDaddr) ,  
        .RDdata_i(RDdata)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst)   
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
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(RTdata),
        .data1_i(sign_extended),
        .select_i(ALUSrc),
        .data_o(aluSrc2)
        );	
		
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
		.shamt(instr_o[10:6]),
		.sftSrc(aluSrc2) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(result),
        .data1_i(shifter_result),
		.data2_i(zero_filled),
        .select_i(FURslt_o),
        .data_o(RDdata)
        );			

endmodule



