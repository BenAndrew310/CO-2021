module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/
  output wire w1, w2, w3, w4;
  wire aa, bb;
  assign aa = (invertA==1) ? ~a : a;
  assign bb = (invertB==1) ? ~b : b;
  and a1 (w1, aa, bb);
  or o1 (w2, aa, bb);
  Full_adder fa(.sum(w3), .carryOut(carryOut), .carryIn(carryIn), .input1(aa), .input2(bb));
  assign w4 = less;

  assign result = (operation==2'b00) ? w1 :
                  (operation==2'b01) ? w2 :
                  (operation==2'b10) ? w3 : w4;

  
endmodule