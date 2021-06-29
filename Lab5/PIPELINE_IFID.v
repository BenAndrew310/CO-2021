module PIPELINE_IFID(
	clk_i, 
	rst_n, 
	DATA_pc_i,
	DATA_instr_i,
	DATA_pc_o,
	DATA_instr_o
	);

input				clk_i, rst_n;
input 	[32-1:0]	DATA_instr_i;
input	[32-1:0]	DATA_pc_i;
output 	[32-1:0]	DATA_instr_o;
output 	[32-1:0]	DATA_pc_o;

wire 				clk_i, rst_n;
wire				DATA_instr_i;
wire				DATA_pc_i;
reg 				DATA_instr_o;
reg 				DATA_pc_o;


always @(posedge clk_i or negedge rst_n) begin
	if (!rst_n) begin
		DATA_instr_o 	<= 32'd0;
		DATA_pc_o 		<= 32'd0;
	end else begin
		DATA_instr_o 	<= DATA_instr_i;
		DATA_pc_o 		<= DATA_pc_i;
	end
end

endmodule