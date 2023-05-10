`timescale 1ns / 1ps

//*********************************************************
//                ģ�����ƣ�SHift_Left_2
//                ģ�鹦�ܣ�����2λ
//*********************************************************
module Shift_Left_2 #(parameter DATA_WIDTH = 32)(
	input [DATA_WIDTH - 1 : 0] x,
	
	output [DATA_WIDTH - 1 : 0] y
    );

	assign y = {x[DATA_WIDTH - 3 : 0], 2'b00};

endmodule
