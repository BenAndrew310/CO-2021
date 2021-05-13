module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
reg			[4-1:0] ALU_operation;
reg			[2-1:0] FURslt;

assign ALU_operation_o = ALU_operation;
assign FURslt_o = FURslt;

always @(funct_i, ALUOp_i) begin
	if (ALUOp_i==3'b010) begin
		case (funct_i)
			6'b010_011: ALU_operation <= 4'b0010; // ADD 	2
			6'b010_001: ALU_operation <= 4'b0110; // SUB 	6
			6'b010_100: ALU_operation <= 4'b0000; // AND 	0
			6'b010_110: ALU_operation <= 4'b0001; // OR 	1
			6'b010_101: ALU_operation <= 4'b1100; // NOR 	12
			6'b110_000: ALU_operation <= 4'b0111; // SLT 	7
			6'b000_000: ALU_operation <= 4'b0011; // SLL 	3
			6'b000_010: ALU_operation <= 4'b0100; // SRL 	4
			6'b000_110: ALU_operation <= 4'b0101; // SLLV 	5
			6'b000_100: ALU_operation <= 4'b1000; // SRLV 	8
		endcase
	end else if (ALUOp_i==3'b011) begin
		ALU_operation <= 4'b0010; // ADDI
	end
end

always @(funct_i, ALUOp_i) begin
	if (ALUOp_i==3'b010) begin
		if (funct_i==6'b000_000 || funct_i==6'b000_010) begin // SLL and SRL
			FURslt <= 2'b01;
		end else begin
			FURslt <= 2'b00;
		end
	end else if (ALUOp_i==3'b011) begin
		FURslt <= 2'b00; // ADDI
	end
end

endmodule     
