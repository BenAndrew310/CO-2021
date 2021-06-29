module Shift_Left_Two(
	data_i,
	data_o
	);

parameter size_i = 32;
parameter size_o = 32;

// I/O ports
input		[size_i-1:0] data_i;
output		[size_o-1:0] data_o;

wire		data_i;
wire		data_o;

assign data_o = data_i << 2;

endmodule