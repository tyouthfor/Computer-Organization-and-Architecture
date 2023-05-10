`timescale 1ns / 1ps

//*********************************************************
//                模块名称：SHift_Left_2
//                模块功能：左移2位
//*********************************************************
module Shift_Left_2 #(parameter DATA_WIDTH = 32)(
    input [DATA_WIDTH - 1 : 0] x,
	
    output [DATA_WIDTH - 1 : 0] y
    );

    assign y = {x[DATA_WIDTH - 3 : 0], 2'b00};

endmodule
