module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;

//Main function
reg		[32-1:0] ALU_out;
reg				 ALU_overflow;

assign zero = (result==0);
assign result = ALU_out;
assign overflow = ALU_overflow;

always @(ALU_operation_i, aluSrc1, aluSrc2) begin
	case (ALU_operation_i)
		4'b0000: ALU_out <= aluSrc1 & aluSrc2; // AND
		4'b0001: ALU_out <= aluSrc1 | aluSrc2; // OR
		4'b0010: ALU_out <= aluSrc1 + aluSrc2; // ADD
		4'b0110: ALU_out <= aluSrc1 - aluSrc2; // SUB
		4'b0111: ALU_out <= $signed(aluSrc1) < $signed(aluSrc2); // SLT
		4'b1100: ALU_out <= ~(aluSrc1 | aluSrc2 ); // NOR
		4'b0101: ALU_out <= aluSrc2<<aluSrc1; // SLLV
		4'b1000: ALU_out <= aluSrc2>>aluSrc1; // SRLV
		default: ALU_out <= 0; 
	endcase
end

always @(ALU_operation_i, aluSrc1, aluSrc2) begin
	if (ALU_operation_i==4'b0010) begin // ADD
		if (aluSrc1[31]==aluSrc2[31])
		ALU_overflow <= ((aluSrc1[31]==aluSrc2[31]) && (ALU_out[31]!=aluSrc1[31])) ? 1'b1 : 1'b0;
	end
	else if (ALU_operation_i==4'b0110) begin // SUB
		if (aluSrc1[31] && !aluSrc2[31] && !ALU_out[31]) begin
			ALU_overflow <= 1'b1;
		end else if (!aluSrc1[31] && aluSrc2[31] && ALU_out[31]) begin
			ALU_overflow <= 1'b1;
		end else begin
			ALU_overflow <= 1'b0;
		end
	end
end

endmodule
