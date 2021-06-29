module PIPELINE_IDEX( 
	clk_i,
	rst_n,
	CTRL_ALUOp_i,
	CTRL_ALUSrc_i,
	CTRL_RegWrite_i,
	CTRL_RegDst_i,
	CTRL_Branch_i,
	CTRL_BranchType_i,
	CTRL_MemRead_i,
	CTRL_MemWrite_i,
	CTRL_MemtoReg_i,
	DATA_pc_i,
	DATA_ReadData1_i,
	DATA_ReadData2_i,
	DATA_SE_i,
	DATA_ZF_i,
	DATA_instr_2016_i,
	DATA_instr_1511_i,
	DATA_instr_0500_i,
	DATA_instr_1006_i,
	CTRL_ALUOp_o,
	CTRL_ALUSrc_o,
	CTRL_RegWrite_o,
	CTRL_RegDst_o,
	CTRL_Branch_o,
	CTRL_BranchType_o,
	CTRL_MemRead_o,
	CTRL_MemWrite_o,
	CTRL_MemtoReg_o,
	DATA_pc_o,
	DATA_ReadData1_o,
	DATA_ReadData2_o,
	DATA_SE_o,
	DATA_ZF_o,
	DATA_instr_2016_o,
	DATA_instr_1511_o,
	DATA_instr_0500_o,
	DATA_instr_1006_o);

input wire 				clk_i, rst_n;

input wire 	[3-1:0]		CTRL_ALUOp_i;
input wire 				CTRL_ALUSrc_i, CTRL_RegDst_i, CTRL_RegWrite_i;
input wire 				CTRL_MemRead_i, CTRL_MemWrite_i, CTRL_MemtoReg_i;
input wire 				CTRL_Branch_i;
input wire 	[2-1:0]		CTRL_BranchType_i;

input wire 	[32-1:0]	DATA_pc_i, DATA_ReadData1_i, DATA_ReadData2_i;
input wire 	[32-1:0]	DATA_SE_i, DATA_ZF_i;
input wire 	[5-1:0]		DATA_instr_2016_i, DATA_instr_1511_i, DATA_instr_1006_i;
input wire 	[6-1:0]		DATA_instr_0500_i;

output reg 	[3-1:0]		CTRL_ALUOp_o;
output reg 				CTRL_ALUSrc_o, CTRL_RegDst_o, CTRL_RegWrite_o;
output reg 				CTRL_MemRead_o, CTRL_MemWrite_o, CTRL_MemtoReg_o;
output reg 				CTRL_Branch_o;
output reg 	[2-1:0]		CTRL_BranchType_o;

output reg 	[32-1:0]	DATA_pc_o, DATA_ReadData1_o, DATA_ReadData2_o;
output reg 	[32-1:0]	DATA_SE_o, DATA_ZF_o;
output reg 	[5-1:0]		DATA_instr_2016_o, DATA_instr_1006_o, DATA_instr_1511_o;
output reg 	[6-1:0]		DATA_instr_0500_o;

always @(posedge clk_i or negedge rst_n) begin
	if (!rst_n) begin
		CTRL_ALUOp_o 		<= 3'd0;
		CTRL_ALUSrc_o 		<= 0;
		CTRL_RegDst_o		<= 0;
		CTRL_RegWrite_o		<= 0;
		CTRL_MemRead_o		<= 0;
		CTRL_MemWrite_o 	<= 0;
		CTRL_MemtoReg_o 	<= 0;
		CTRL_Branch_o 		<= 0;
		CTRL_BranchType_o 	<= 2'd0;

		DATA_pc_o			<= 32'd0;
		DATA_ReadData1_o 	<= 32'd0;
		DATA_ReadData2_o 	<= 32'd0;
		DATA_SE_o			<= 32'd0;
		DATA_ZF_o			<= 32'd0;
		DATA_instr_2016_o	<= 5'd0;
		DATA_instr_1511_o 	<= 5'd0;
		DATA_instr_1006_o 	<= 5'd0;
		DATA_instr_0500_o	<= 6'd0;
	end else begin
		CTRL_ALUOp_o 		<= CTRL_ALUOp_i;
		CTRL_ALUSrc_o 		<= CTRL_ALUSrc_i;
		CTRL_RegDst_o		<= CTRL_RegDst_i;
		CTRL_RegWrite_o		<= CTRL_RegWrite_i;
		CTRL_MemRead_o		<= CTRL_MemRead_i;
		CTRL_MemWrite_o 	<= CTRL_MemWrite_i;
		CTRL_MemtoReg_o 	<= CTRL_MemtoReg_i;
		CTRL_Branch_o 		<= CTRL_Branch_i;
		CTRL_BranchType_o 	<= CTRL_BranchType_i;

		DATA_pc_o			<= DATA_pc_i;
		DATA_ReadData1_o 	<= DATA_ReadData1_i;
		DATA_ReadData2_o 	<= DATA_ReadData2_i;
		DATA_SE_o			<= DATA_SE_i;
		DATA_ZF_o			<= DATA_ZF_i;
		DATA_instr_2016_o	<= DATA_instr_2016_i;
		DATA_instr_1511_o 	<= DATA_instr_1511_i;
		DATA_instr_0500_o	<= DATA_instr_0500_i;
		DATA_instr_1006_o 	<= DATA_instr_1006_i;
	end
end


endmodule