module PIPELINE_EXMEM(
	clk_i,
	rst_n,
	CTRL_MemRead_i,
	CTRL_MemWrite_i,
	CTRL_MemtoReg_i,
	CTRL_RegWrite_i,
	CTRL_Branch_i,
	CTRL_zero_i,
	DATA_pc_i,
	DATA_DM_ADDR_i,
	DATA_DM_WriteData_i,
	DATA_RF_WriteReg_i,
	CTRL_MemRead_o,
	CTRL_MemWrite_o,
	CTRL_MemtoReg_o,
	CTRL_RegWrite_o,
	CTRL_Branch_o,
	CTRL_zero_o,
	DATA_pc_o,
	DATA_DM_ADDR_o,
	DATA_DM_WriteData_o,
	DATA_RF_WriteReg_o);

input wire 				clk_i, rst_n;
input wire 				CTRL_zero_i, CTRL_Branch_i;
input wire 				CTRL_MemRead_i, CTRL_MemWrite_i, CTRL_MemtoReg_i, CTRL_RegWrite_i;
input wire 	[32-1:0]	DATA_pc_i;
input wire 	[32-1:0]	DATA_DM_ADDR_i;
input wire 	[32-1:0]	DATA_DM_WriteData_i;
input wire 	[5-1:0]		DATA_RF_WriteReg_i;

output reg 				CTRL_zero_o, CTRL_Branch_o;
output reg 				CTRL_MemRead_o, CTRL_MemWrite_o, CTRL_MemtoReg_o, CTRL_RegWrite_o;
output reg 	[32-1:0]	DATA_pc_o;
output reg 	[32-1:0]	DATA_DM_ADDR_o;
output reg 	[32-1:0]	DATA_DM_WriteData_o;
output reg 	[5-1:0]		DATA_RF_WriteReg_o;

always @(posedge clk_i or negedge rst_n) begin
	if (!rst_n) begin
		CTRL_zero_o 		<= 0;
		CTRL_Branch_o 		<= 0;
		CTRL_MemRead_o		<= 0;
		CTRL_MemWrite_o		<= 0;
		CTRL_MemtoReg_o		<= 0;
		CTRL_RegWrite_o		<= 0;

		DATA_pc_o			<= 32'd0;
		DATA_DM_ADDR_o		<= 32'd0;
		DATA_DM_WriteData_o	<= 32'd0;
		DATA_RF_WriteReg_o	<= 5'd0;
	end else begin
		CTRL_zero_o 		<= CTRL_zero_i;
		CTRL_Branch_o 		<= CTRL_Branch_i;
		CTRL_MemRead_o		<= CTRL_MemRead_i;
		CTRL_MemWrite_o		<= CTRL_MemWrite_i;
		CTRL_MemtoReg_o		<= CTRL_MemtoReg_i;
		CTRL_RegWrite_o		<= CTRL_RegWrite_i;

		DATA_pc_o			<= DATA_pc_i;
		DATA_DM_ADDR_o		<= DATA_DM_ADDR_i;
		DATA_DM_WriteData_o	<= DATA_DM_WriteData_i;
		DATA_RF_WriteReg_o	<= DATA_RF_WriteReg_i;
	end
end

endmodule