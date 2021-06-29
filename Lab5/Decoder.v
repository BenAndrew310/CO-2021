module Decoder(
	instr_op_i,
	RegWrite_o,
	ALUOp_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	branchType_o,
	// Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o,
	);

//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
output			Branch_o;
output	[2-1:0] branchType_o;
// output			Jump_o;
output			MemRead_o;
output			MemWrite_o;
output			MemtoReg_o;

//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;

wire			Branch_o;
wire 	[2-1:0] branchType_o;
// wire			Jump_o;
wire			MemRead_o;
wire			MemWrite_o;
wire			MemtoReg_o;

//Main function
parameter r_format = 6'b000000, lw = 6'b101100, sw = 6'b101101, 
		beq = 6'b001010, bne = 6'b001011, addi = 6'b001000, 
		// j = 6'b000010, jal = 6'b000011, jr = 6'b000000,
		blt = 6'b001110, bnez = 6'b001100, bgez = 6'b001101;

assign ALUOp_o = (instr_op_i==lw || instr_op_i==sw) ? 3'b000 : // lw, sw
				(instr_op_i==beq || instr_op_i==bgez) ? 3'b001 :  // beq
				(instr_op_i==bne || instr_op_i==bnez || instr_op_i==blt) ? 3'b110 :  // bne
				(instr_op_i==addi) ? 3'b100 : // addi
				3'b010;                       // R-format
assign ALUSrc_o = (instr_op_i==addi || instr_op_i==lw || instr_op_i==sw); // 1 for addi, lw, sw
assign RegWrite_o = (instr_op_i==beq || instr_op_i==bgez || instr_op_i==bne || instr_op_i==bnez || instr_op_i==blt || instr_op_i==sw) ? 1'b0 : 1'b1; // 0 for beq, bne, sw
assign RegDst_o = (instr_op_i==r_format); //(instr_op_i==addi || instr_op_i==lw) ? 1'b0 : 1'b1; // 0 for addi, lw
assign Branch_o = (instr_op_i==beq || instr_op_i==bne || instr_op_i==blt || instr_op_i==bnez || instr_op_i==bgez); // 1 for beq, bne
assign branchType_o = (instr_op_i==beq) ? 2'b00 : 
						(instr_op_i==bne || instr_op_i==bnez) ? 2'b01 :
						(instr_op_i==blt) ? 2'b10 : 2'b11;


// assign Jump_o = (instr_op_i==j || instr_op_i==jal); // 1 for j
assign MemRead_o = (instr_op_i==lw); // 1 for lw
assign MemWrite_o = (instr_op_i==sw); // 1 for sw
assign MemtoReg_o = (instr_op_i==lw); // 1 for lw

endmodule
   