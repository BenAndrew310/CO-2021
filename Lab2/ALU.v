module ALU( result, zero, overflow, aluSrc1, aluSrc2, invertA, invertB, operation );
   
  output wire[31:0] result;
  output wire zero;
  output wire overflow;

  input wire[31:0] aluSrc1;
  input wire[31:0] aluSrc2;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  
  /*your code here*/
  inout wire [31:0] carryOut;
  wire set;

  ALU_1bit alu0(.result(result[0]),
                .carryOut(carryOut[0]),
                .a(aluSrc1[0]),
                .b(aluSrc2[0]),
                .invertA(invertA),
                .invertB(invertB),
                .operation(operation),
                .carryIn(1'b0),
                .less(set));
  ALU_1bit alu1(.result(result[1]),
                .carryOut(carryOut[1]),
                .a(aluSrc1[1]),
                .b(aluSrc2[1]),
                .invertA(invertA),
                .invertB(invertB),
                .operation(operation),
                .carryIn(carryOut[0]),
                .less(1'b0));
  ALU_1bit alu2(result[2],carryOut[2],aluSrc1[2],aluSrc2[2],invertA,invertB,operation,carryOut[1],1'b0);
  ALU_1bit alu3(result[3],carryOut[3],aluSrc1[3],aluSrc2[3],invertA,invertB,operation,carryOut[2],1'b0);
  ALU_1bit alu4(result[4],carryOut[4],aluSrc1[4],aluSrc2[4],invertA,invertB,operation,carryOut[3],1'b0);
  ALU_1bit alu5(result[5],carryOut[5],aluSrc1[5],aluSrc2[5],invertA,invertB,operation,carryOut[4],1'b0);
  ALU_1bit alu6(result[6],carryOut[6],aluSrc1[6],aluSrc2[6],invertA,invertB,operation,carryOut[5],1'b0);
  ALU_1bit alu7(result[7],carryOut[7],aluSrc1[7],aluSrc2[7],invertA,invertB,operation,carryOut[6],1'b0);
  ALU_1bit alu8(result[8],carryOut[8],aluSrc1[8],aluSrc2[8],invertA,invertB,operation,carryOut[7],1'b0);
  ALU_1bit alu9(result[9],carryOut[9],aluSrc1[9],aluSrc2[9],invertA,invertB,operation,carryOut[8],1'b0);
  ALU_1bit alu10(result[10],carryOut[10],aluSrc1[10],aluSrc2[10],invertA,invertB,operation,carryOut[9],1'b0);
  ALU_1bit alu11(result[11],carryOut[11],aluSrc1[11],aluSrc2[11],invertA,invertB,operation,carryOut[10],1'b0);
  ALU_1bit alu12(result[12],carryOut[12],aluSrc1[12],aluSrc2[12],invertA,invertB,operation,carryOut[11],1'b0);
  ALU_1bit alu13(result[13],carryOut[13],aluSrc1[13],aluSrc2[13],invertA,invertB,operation,carryOut[12],1'b0);
  ALU_1bit alu14(result[14],carryOut[14],aluSrc1[14],aluSrc2[14],invertA,invertB,operation,carryOut[13],1'b0);
  ALU_1bit alu15(result[15],carryOut[15],aluSrc1[15],aluSrc2[15],invertA,invertB,operation,carryOut[14],1'b0);
  ALU_1bit alu16(result[16],carryOut[16],aluSrc1[16],aluSrc2[16],invertA,invertB,operation,carryOut[15],1'b0);
  ALU_1bit alu17(result[17],carryOut[17],aluSrc1[17],aluSrc2[17],invertA,invertB,operation,carryOut[16],1'b0);
  ALU_1bit alu18(result[18],carryOut[18],aluSrc1[18],aluSrc2[18],invertA,invertB,operation,carryOut[17],1'b0);
  ALU_1bit alu19(result[19],carryOut[19],aluSrc1[19],aluSrc2[19],invertA,invertB,operation,carryOut[18],1'b0);
  ALU_1bit alu20(result[20],carryOut[20],aluSrc1[20],aluSrc2[20],invertA,invertB,operation,carryOut[19],1'b0);
  ALU_1bit alu21(result[21],carryOut[21],aluSrc1[21],aluSrc2[21],invertA,invertB,operation,carryOut[20],1'b0);
  ALU_1bit alu22(result[22],carryOut[22],aluSrc1[22],aluSrc2[22],invertA,invertB,operation,carryOut[21],1'b0);
  ALU_1bit alu23(result[23],carryOut[23],aluSrc1[23],aluSrc2[23],invertA,invertB,operation,carryOut[22],1'b0);
  ALU_1bit alu24(result[24],carryOut[24],aluSrc1[24],aluSrc2[24],invertA,invertB,operation,carryOut[23],1'b0);
  ALU_1bit alu25(result[25],carryOut[25],aluSrc1[25],aluSrc2[25],invertA,invertB,operation,carryOut[24],1'b0);
  ALU_1bit alu26(result[26],carryOut[26],aluSrc1[26],aluSrc2[26],invertA,invertB,operation,carryOut[25],1'b0);
  ALU_1bit alu27(result[27],carryOut[27],aluSrc1[27],aluSrc2[27],invertA,invertB,operation,carryOut[26],1'b0);
  ALU_1bit alu28(result[28],carryOut[28],aluSrc1[28],aluSrc2[28],invertA,invertB,operation,carryOut[27],1'b0);
  ALU_1bit alu29(result[29],carryOut[29],aluSrc1[29],aluSrc2[29],invertA,invertB,operation,carryOut[28],1'b0);
  ALU_1bit alu30(result[30],carryOut[30],aluSrc1[30],aluSrc2[30],invertA,invertB,operation,carryOut[29],1'b0);
  ALU_1bit alu31(result[31],carryOut[31],aluSrc1[31],aluSrc2[31],invertA,invertB,operation,carryOut[30],1'b0);
	
  assign set = (result[31]==1'b1) ? 1'b1 : 1'b0;
  assign overflow = (aluSrc1[31]==aluSrc2[31] && result[31]!=aluSrc1[31]) ? 1'b1 : 1'b0; //(carryOut[31]==1'b1) ? 1'b1 : 1'b0;
  assign zero = (result==0) ? 1'b1 : 1'b0;
    
endmodule