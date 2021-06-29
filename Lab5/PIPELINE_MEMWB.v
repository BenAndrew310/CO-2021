module PIPELINE_MEMWB(
	clk_i,
	rst_n,
	CTRL_RegWrite_i,
	CTRL_MemtoReg_i,
	DATA_DM_ReadData_i,
	DATA_DM_ADDR_i,
	DATA_RF_WriteReg_i,
	CTRL_RegWrite_o,
	CTRL_MemtoReg_o,
	DATA_DM_ReadData_o,
	DATA_DM_ADDR_o,
	DATA_RF_WriteReg_o
	);

input wire 				clk_i, rst_n;
input wire  			CTRL_RegWrite_i, CTRL_MemtoReg_i;
input wire 	[32-1:0]	DATA_DM_ReadData_i, DATA_DM_ADDR_i;
input wire 	[5-1:0]		DATA_RF_WriteReg_i;

output reg  			CTRL_RegWrite_o, CTRL_MemtoReg_o;
output reg 	[32-1:0]	DATA_DM_ReadData_o, DATA_DM_ADDR_o;
output reg 	[5-1:0]		DATA_RF_WriteReg_o;

always @(posedge clk_i or negedge rst_n) begin
	if (!rst_n) begin
		CTRL_RegWrite_o		<= 0;
		CTRL_MemtoReg_o		<= 0;

		DATA_DM_ReadData_o	<= 32'd0;
		DATA_DM_ADDR_o		<= 32'd0;
		DATA_RF_WriteReg_o	<= 5'd0;
	end else begin
		CTRL_RegWrite_o		<= CTRL_RegWrite_i;
		CTRL_MemtoReg_o		<= CTRL_MemtoReg_i;

		DATA_DM_ReadData_o	<= DATA_DM_ReadData_i;
		DATA_DM_ADDR_o		<= DATA_DM_ADDR_i;
		DATA_RF_WriteReg_o	<= DATA_RF_WriteReg_i;
	end
end

endmodule